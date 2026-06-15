local instance_mod = require("./classes/instance")
local script_mod = require("./classes/script")

type instance = instance_mod.instance
type script = script_mod.script

type execute_script = (world: instance, script: script) -> any
type require_instance = (module: script) -> any

type require_object = {
	result: any,
}

type environment = {
	require: require_instance,
	ScriptService: instance,
	world: instance,
}

local require_data: {[instance]: require_object} = {}

local function find_service(world: instance, name: string): instance
	-- Even if the result is nil, lie to the type-checker, since the environment should be created anyway.

	local service = world:FindChild(name)
	if service == nil then
		print(`Error: {name} was not found.`)
		return nil :: any
	end

	if service.ClassName ~= name then
		print(`Error: {name}'s class-name should be "{name}", but it is instead "{service.ClassName}".`)
		return nil :: any
	end

	return service
end

-- `execute_script` is needed because of cyclic dependency. But even if it was not cyclic, I quite want all the environment setup to be in 1 single file.
local function generate_require_instance(world: instance, execute_script: execute_script): require_instance
	local function require(module: script): any
		if module.ClassName ~= "ModuleScript" then
			print(`Error: The given instance is not a module script. Its class-name is "{module.ClassName}".`)
			return nil
		end

		local object: require_object? = require_data[module]
		if object == nil then
			local result = execute_script(world, module)
			require_data[module] = {
				result = result,
			}
			return result
		else
			return object.result
		end
	end

	return require
end

local function create_environment(world: instance, execute_script: execute_script): environment
	local ScriptService = find_service(world, "ScriptService")

	local require_instance = generate_require_instance(world, execute_script)

	local environment = {
		require = require_instance,
		ScriptService = ScriptService,
		world = world,
	}

	return environment
end

return create_environment
