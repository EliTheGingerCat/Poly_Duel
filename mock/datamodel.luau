local file_tools = require("./file_tools")
local instance_mod = require("./classes/instance")
local script_mod = require("./classes/script")

type instance = instance_mod.instance
type file_data = file_tools.file_data
type object = file_tools.object

local function form_object(object_data: object): instance
	local object_instance = instance_mod.New()
	object_instance.ClassName = object_data.ClassName
	-- ~ Investigate: `ObjectId` is different on the client.
	object_instance.ObjectId = object_data.ID
	object_instance.Name = object_data.Name

	for name, value in object_data.Properties do
		-- It seems that all objects have tags but I am not completely sure.
		if name == "Tags" then
			instance_mod.set_tags(object_instance, object_data.Properties.Tags)
		else
			object_instance[name] = value
		end
	end

	for _, child_data in object_data.Children do
		local child_instance = form_object(child_data)
		child_instance.Parent = object_instance
	end

	-- `LinkedModel` and `IsLinkedChild` remain unused.

	-- ~ Todo: Add `IsA`.
	if object_instance.ClassName == "ServerScript" or object_instance.ClassName == "ClientScript" or object_instance.ClassName == "ModuleScript" then
		script_mod.fix_general_instance(object_instance)
	end

	return object_instance
end

local function from_file_data(file_data: file_data): instance?
	if #file_data.Objects ~= 1 then
		print(`Warning: I do not know what to do since \`Objects\` does not contain exactly 1 object. Instead, it contains {#file_data.Objects} objects. I will halt.`)
		return
	end

	local root_data = file_data.Objects[1]
	local root_instance = form_object(root_data)
	return root_instance
end

local datamodel = {
	from_file_data = from_file_data,
}

return datamodel
