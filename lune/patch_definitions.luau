--> Apply patches to the Polytoria definitions file.

local fs = require("@lune/fs")
local process = require("@lune/process")

local path_Polytoria_definitions = "./.poly/luau/def.d.luau"
local pattern_symbols = {"$", "%", "^", "*", "(", ")", ".", "[", "]", "+", "-", "?"}

local replacements = {
	{
		name = "global require",
		from = [[declare function require(moduleScript: (ModuleScript)): any

]],
		to = [[]],
	},
	{
		name = "global pcall",
		from = [[declare function pcall(f: (...any) -> (boolean, any))

]],
		to = [[]],
	},
	{
		name = "global Camera object",
		from = [[declare Camera: Camera

]],
		to = [[]],
	},
	{
		name = "global Camera library",
		from = [[declare Camera: {
New: (NetworkedObject?) -> (Camera),
}]],
		to = [[declare Camera: Camera & {
New: (NetworkedObject?) -> (Camera),
}]]
	},
	{
		name = "object Vector3 subtract",
		from = [[	function __sub(self, a: Vector3, b: Vector3): Vector3
	function __sub(self, a: Vector3, q: Quaternion): Vector3]],
		to = [[__sub: ((a: Vector3, b: Vector3) -> Vector3) & ((a: Vector3, q: Quaternion) -> Vector3)]],
	},
	{
		name = "library `Vector3.New`",
		from = [[New: () -> (Vector3),
New: (number) -> (Vector3),
New: (number, number) -> (Vector3),
New: (number, number, number) -> (Vector3),
New: (Vector2) -> (Vector3),]],
		to = [[New: (() -> (Vector3)) & ((number) -> (Vector3)) & ((number, number) -> (Vector3)) & ((number, number, number) -> (Vector3)) & ((Vector2) -> (Vector3)),]],
	}
}

local function sanitise_pattern(pattern: string): string
	for _, symbol in pattern_symbols do
		pattern = string.gsub(pattern, "%" .. symbol, "%%" .. symbol)
	end
	return pattern
end

local function normalise_line_ending(str: string): string
	local result = string.gsub(str, "\r\n", "\n")
	return result
end

if fs.metadata(path_Polytoria_definitions).exists == false then
	print("Error: Definition file was not found.")
	return
end

local content = fs.readFile(path_Polytoria_definitions)

-- Eli: This took about 30 minutes to figure out :3 .
if process.os == "windows" then
	content = normalise_line_ending(content)
end

for _, replacement in replacements do
	local content_new, amount_substitutions = string.gsub(content, sanitise_pattern(replacement.from), replacement.to)
	content = content_new
	if amount_substitutions ~= 1 then
		print(`Warning: This is strange: "{replacement.name}" caused {amount_substitutions} substitutions.`)
	end
end

fs.writeFile(path_Polytoria_definitions, content)
