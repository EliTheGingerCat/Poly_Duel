local fs = require("@lune/fs")
local serde = require("@lune/serde")

export type object = {
	Children: {object},
	ClassName: string,
	ID: string,
	IsLinkedChild: boolean,
	LinkedModel: string?,
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

local function write_JSON_data(path: string, JSON_data: string): ()
	local Zstandard_data = serde.compress("zstd", JSON_data)
	fs.writeFile(path, Zstandard_data)
end

--[=[
	Unused.
]=]
local function write_Polytoria_data(path: string, Polytoria_data: file_data): ()
	local JSON_data = serde.encode("json", Polytoria_data, true)
	write_JSON_data(path, JSON_data)
end

local file_tools = {
	read_world_file = read_world_file,
	write_JSON_data = write_JSON_data,
	write_Polytoria_data = write_Polytoria_data,
}

return file_tools
