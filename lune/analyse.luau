--> Analyse the code using Luau Language Server.

local fs = require("@lune/fs")
local process = require("@lune/process")

local do_output_to_file = false
local do_all = false
local directories: {string} = {}
for _, argument in process.args do
	if argument == "--all" then
		do_all = true
	elseif argument == "--output" then
		do_output_to_file = true
	else
		table.insert(directories, argument)
	end
end

if do_all == true then
	directories = {"./lune", "./miscellaneous", "./mock", "./source"}
end

local analyse_arguments = {"analyze", "--settings", "./.vscode/settings.json"}
table.move(directories, 1, #directories, #analyse_arguments + 1, analyse_arguments)

if do_output_to_file == true then
	local result = process.exec("luau_lsp", analyse_arguments)
	local error_output = result.stderr

	local file_path = "./code_errors.txt"
	print(`Please remember that \`{file_path}\` should not be committed.`)
	fs.writeFile(file_path, error_output)
else
	process.exec("luau_lsp", analyse_arguments, {
		stdio = "forward",
	})
end
