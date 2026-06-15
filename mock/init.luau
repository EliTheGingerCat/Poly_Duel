local fs = require("@lune/fs")
local luau = require("@lune/luau")
local serde = require("@lune/serde")

local datamodel = require("@self/datamodel")
local create_environment = require("@self/create_environment")
local file_tools = require("@self/file_tools")
local instance_mod = require("@self/classes/instance")
local script_mod = require("@self/classes/script")

type instance = instance_mod.instance
type script = script_mod.script

type MetadataKind = fs.MetadataKind

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

local function execute_script(world: instance, script: script): any
	local linked_script_id: string = script.LinkedScript.LinkedId
	local path = find_code_file(linked_script_id)
	if path == nil then
		print(`Error: Failed to find filesystem path of code file with link id "{linked_script_id}".`)
		return
	end

	local enviroment = create_environment(world, script, execute_script)

	local content = fs.readFile(path)
	local bytecode = luau.compile(content)
	local chunk = luau.load(bytecode, {
		debugName = `server script "{script.Name}"`,
		environment = enviroment,
	})
	local result = chunk()
	return result
end

local function create_mock(path: string): ()
	local file_data = file_tools.read_world_file(path)

	if file_data.FileType ~= 0 then
		print("Error: This file is not a world.")
		return
	end

	local world = datamodel.from_file_data(file_data)
	if world == nil then
		return
	end

	local instance_queue = {world}
	local instance_queue_index = 0
	while true do
		instance_queue_index += 1
		local instance = instance_queue[instance_queue_index] :: instance?
		if instance == nil then
			break
		end

		if instance:IsA("ServerScript") then
			local script: script = instance :: any
			execute_script(world, script)
		end

		if instance:IsA("ClientScript") then
			-- ~ Todo.
			print("Error: Todo.")
		end

		local children = instance:GetChildren()
		table.move(children, 1, #children, #instance_queue + 1, instance_queue)
	end
end

create_mock("./main.poly")
