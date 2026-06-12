local fs = require("@lune/fs")
local luau = require("@lune/luau")
local serde = require("@lune/serde")

type MetadataKind = fs.MetadataKind

type object = {
	Children: {object},
	ClassName: string,
	ID: string,
	IsLinkedChild: boolean,
	Name: string,
	Properties: {
		[string]: any,
	}
}

type world_data = {
	FileType: number,
	NonInstanceObjects: {},
	Objects: {object},
	Version: string, -- SemVer
}

type code_file_meta_data = {
	id: string,
}

local function is_Luau(path: string): ()
	return string.sub(path, -5, -1) == ".luau"
end

local function find_code_file(link_id: string): string?
	local path_queue = {"./build"}
	local path_queue_index = 0
	while true do
		path_queue_index += 1
		local path = path_queue[path_queue_index]
		if path == nil then
			break
		end

		local kind: MetadataKind? = fs.metadata(path).kind
		if kind == "file" then
			if is_Luau(path) == false then
				continue
			end

			local path_meta = path .. ".meta"
			local meta_data_JSON = fs.readFile(path_meta)
			local meta_data: code_file_meta_data = serde.decode("json", meta_data_JSON)
			local this_link_id = meta_data.id
			if this_link_id == link_id then
				return path
			end
		elseif kind == "dir" then
			local children = fs.readDir(path)
			for _, child in children do
				table.insert(path_queue, path .. "/" .. child)
			end
		else
			print(`Error: Kind "{kind}" is not supported.`)
		end
	end

	return nil
end

local function create_environment(): {[string]: any}
	local environment = {}

	return environment
end

local function execute_script(object: object): ()
	local linked_script_id: string = object.Properties.LinkedScript
	local path = find_code_file(linked_script_id)
	if path == nil then
		print(`Error: Failed to find filesystem path of code file with link id "{linked_script_id}".`)
		return
	end

	print("path:", path)

	local enviroment = create_environment()

	local content = fs.readFile(path)
	local bytecode = luau.compile(content)
	local chunk = luau.load(bytecode, {
		debugName = `server script "{object.Name}"`,
		environment = enviroment,
	})
	chunk()
end

local function create_mock(): ()
	local world_file_Zstandard = fs.readFile("./main.poly")
	local world_file_JSON = serde.decompress("zstd", world_file_Zstandard)
	local world_data: world_data = serde.decode("json", world_file_JSON)

	if world_data.Version ~= "2.0.15" then
		print(`Warning: Version {world_data.Version} is not supported. I will try anyway.`)
	end

	local object_queue = table.clone(world_data.Objects)
	local object_queue_index = 0
	while true do
		object_queue_index += 1
		local object = object_queue[object_queue_index] :: object?
		if object == nil then
			break
		end

		if object.ClassName == "ServerScript" then
			execute_script(object)
		end

		local children = object.Children
		table.move(children, 1, #children, #object_queue + 1, object_queue)
	end
end

create_mock()
