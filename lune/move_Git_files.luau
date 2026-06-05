--> Bulk-move files using Git.

local fs = require("@lune/fs")
local process = require("@lune/process")

local function move_file(from: string, to: string): ()
	process.exec("git", {"mv", from, to}, {
		stdio = "forward",
	})
end

local argument_from = process.args[1]
local argument_to = process.args[2]

if argument_from == nil then
	print("Argument #1 is missing.")
	return
end

if argument_to == nil then
	print("Argument #2 is missing.")
	return
end

local queue = {"."}
local queue_index = 0

while true do
	queue_index += 1
	local queue_item = queue[queue_index]
	if queue_item == nil then
		break
	end

	-- "full" means relative to the project root.
	local full_path_from = argument_from .. "/" .. queue_item
	local full_path_to = argument_to .. "/" .. queue_item

	local kind = fs.metadata(full_path_from).kind
	if kind == "file" then
		move_file(full_path_from, full_path_to)
	elseif kind == "dir" then
		fs.writeDir(full_path_to)
		for _, child in fs.readDir(full_path_from) do
			table.insert(queue, queue_item .. "/" .. child)
		end
	else
		print(`Kind "{kind}" is not supported.`)
	end
end
