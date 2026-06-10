-- ~ Polytoria link id: eea94b1f-00fe-45a9-96cb-8ffac97d9a3e

type require = (path: string) -> any

local require_native = require

local function get_module(script_caller: ModuleScript, path_require: string): ModuleScript?
	local parts = string.split(path_require, "/")

	local part_1 = parts[1]
	local start: Instance
	if part_1 == "." then
		start = script_caller.Parent
	elseif part_1 == ".." then
		local parent = script_caller.Parent
		local parent_2 = parent.Parent :: Instance?
		if parent_2 == nil then
			print(`Error: "{parent.Name}" has no parent.`)
			return nil
		end
		start = parent_2
	elseif part_1 == "" then
		-- "/..."
		start = world
	else
		print("Error: Must start with \".\" or \"..\".")
		return nil
	end

	local current = start
	for index = 2, #parts do
		local part = parts[index]
		if part == "." then
			continue
		elseif part == ".." then
			local parent = current.Parent :: Instance?
			if parent == nil then
				print(`Error: "{current.Name}" has no parent.`)
				return nil
			end
			current = parent
		elseif part == "" then
			-- "...//..."
			print("Error: \"//\" is not supported.")
			return nil
		else
			local child = current:FindChild(part) :: Instance?
			if child == nil then
				print(`Error: No child of "{current.Name}" was found with name "{part}".`)
				return nil
			end
			current = child
		end
	end

	if current:IsA("ModuleScript") == false then
		print(`Error: "{current.Name}" is not a module-script.`)
		return nil
	end

	local current_module_script: ModuleScript = current :: any

	return current_module_script
end

local function require_generator(script_caller: ModuleScript): require
	local function require(path: string): any
		local module = get_module(script_caller, path)
		if module == nil then
			-- The caller does not expect require to fail to require. Thus, execution must be halted.
			error(`Failed to find module from path "{path}".`)
		end

		return require_native(module)
	end

	return require
end

return require_generator
