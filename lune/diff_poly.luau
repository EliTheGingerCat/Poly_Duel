--> Output the diff of `main.poly`.

local fs = require("@lune/fs")
local process = require("@lune/process")
local serde = require("@lune/serde")

local result_Git_show = process.exec("git", {"show", "HEAD~1:./main.poly"})

if result_Git_show.ok == false then
	print(`Error: \`git show\` failed. \`stderr\`: {result_Git_show.stderr}`)
	return
end

local path_directory = "./temporary_diff_poly_file"
fs.writeDir(path_directory)

local data_previous_Zstandard = result_Git_show.stdout
local data_previous_JSON = serde.decompress("zstd", data_previous_Zstandard)
local path_previous = path_directory .. "/previous.json"
fs.writeFile(path_previous, data_previous_JSON)

local data_current_Zstandard = fs.readFile("./main.poly")
local data_current_JSON = serde.decompress("zstd", data_current_Zstandard)
local path_current = path_directory .. "/current.json"
fs.writeFile(path_current, data_current_JSON)

local path_output = "./poly_file_changes.patch"
local result_Git_diff = process.exec("git", {"diff", "--no-index", `--output={path_output}`, path_previous, path_current})
print(`Please remember to not commit the patch file ("{path_output}").`)

fs.removeDir(path_directory)

if result_Git_diff.ok == false then
	print(`Error: \`git diff\` failed. \`stderr\`: {result_Git_diff.stderr}`)
	return
end
