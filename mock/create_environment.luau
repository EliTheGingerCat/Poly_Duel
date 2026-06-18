local instance_mod = require("./classes/instance")
local script_mod = require("./classes/script")
local template_datamodel = require("./template_datamodel")

type instance = instance_mod.instance
type script = script_mod.script

type execute_script = (world: instance, script: script) -> any
type require_instance = (module: script) -> any

type require_object = {
	result: any,
}

-- It might be nice to individually add services to the environment table in the future, so that scripts using the mock can access the default environment with intellisense.
type environment = {
	Camera: instance,
	require: require_instance,
	script: script,
	world: instance,
	[string]: any,
}

local require_data: {[instance]: require_object} = {}

local function find_service(world: instance, name: string, class_name: string): instance
	-- Even if the result is nil, lie to the type-checker, since the environment should be created anyway.

	local service = world:FindChild(name)
	if service == nil then
		print(`Error: {name} was not found.`)
		return nil :: any
	end

	if service.ClassName ~= class_name then
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

local function create_environment(world: instance, script: script, execute_script: execute_script): environment
	local Camera: instance
	local Environment = find_service(world, "Environment", "Environment")
	if Environment ~= nil then
		local camera_maybe = Environment:FindChild("Camera")
		if camera_maybe ~= nil then
			Camera = camera_maybe
		end
	end

	local require_instance = generate_require_instance(world, execute_script)

	local environment = {
		Camera = Camera,
		-- Environment is not placed in here now because it will be automatically placed in by the loop below.
		require = require_instance,
		script = script,
		world = world,
	}

	for _, service in template_datamodel.children do
		if service.declared == false then
			continue
		end

		if service.Polytoria_Creator == true then
			-- ~ Todo: Add an option for Polytoria Creator.
			continue
		end

		environment[service.name] = find_service(world, service.name, service.class_name)
	end

	return environment
end

return create_environment
