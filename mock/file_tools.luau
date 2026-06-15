local fs = require("@lune/fs")
local serde = require("@lune/serde")

export type object = {
	Children: {object},
	ClassName: string,
	ID: string,
	IsLinkedChild: boolean,
	Name: string,
	Properties: {
		[string]: any,
	}
}

export type file_data = {
	FileType: number,
	NonInstanceObjects: {},
	Objects: {object},
	Version: string, -- SemVer
}

-- file type 0: world
-- file type 1: model

local function read_world_file(path: string): file_data
	local data_Zstandard = fs.readFile(path)
	local data_JSON = serde.decompress("zstd", data_Zstandard)
	local world_data = serde.decode("json", data_JSON)
	return world_data
end

-- ~ Unused.
local function write_world_file(world_data: file_data, path: string): ()
	local data_JSON = serde.encode("json", world_data, false)
	local data_Zstandard = serde.compress("zstd", data_JSON)
	fs.writeFile(path, data_Zstandard)
end

local file_tools = {
	read_world_file = read_world_file,
	write_world_file = write_world_file,
}

return file_tools
