export type instance = {
	-- NetworkedObject
	ClassName: string,
	ObjectId: string,
	Name: string,

	FindChild: (self: instance, name: string) -> instance?,
	GetChildren: (self: instance) -> {instance},
	Parent: instance?,
}

-- There is no userdata type. Though, `type` can output "userdata". I am using `nil` so that the type checker warns me against using the regular `instance` variable in the metamethods. It is not really nil; it is userdata. Thus, this is *almost* true. Closer to truth, at least.
type instance_almost_true = nil

type instance_internal = instance & {
	children: {instance_internal},
	reference: instance_almost_true,
	tags: {string},
}

local all_internal_instances: {[instance | nil]: instance_internal} = {}

local function get_internal(instance: instance | nil): instance_internal
	local instance_internal = all_internal_instances[instance]
	return instance_internal
end

local function get_pretense(instance_internal: instance_internal): instance
	local instance: instance = instance_internal.reference :: any
	return instance
end

-- ~ Todo: If metatables must be used, then maybe use them for regular methods.
local function when_index(instance: instance_almost_true, index: any): any
	local instance_internal = get_internal(instance)
	local value = instance_internal[index]
	return value
end

--- @return -- Whether to halt.
local function when_parent_will_change(instance_internal: instance_internal, new_parent_true: any): boolean
	if new_parent_true == nil then
		local parent = instance_internal.Parent
		if parent == nil then
			print(`Error: It seems that \`instance\`, {instance_internal}, does not have a parent.`)
			return false
		end
		
		local parent_internal = get_internal(parent)
		local index = table.find(parent_internal.children, instance_internal)
		if index == nil then
			print(`Error: \`instance\`, {instance_internal}, was not found in \`children\` of parent, {parent_internal}.`)
			return false
		end
		
		table.remove(parent_internal.children, index)
	else
		local parent_internal: instance_internal? = get_internal(new_parent_true)
		if parent_internal == nil then
			print(`Error: I refuse to set the parent of \`instance\`, {instance_internal}, to \`value\`, {new_parent_true}, because \`value\` is not an instance.`)
			return true
		end

		table.insert(parent_internal.children, instance_internal)
	end

	return false
end

local function when_new_index(instance: instance_almost_true, index: any, value: any): ()
	local instance_internal = get_internal(instance)

	if index == "Parent" then
		local do_halt = when_parent_will_change(instance_internal, value)
		if do_halt == true then
			return
		end
	end

	instance_internal[index] = value
end

local function when_to_string(instance: instance): string
	return `{instance.ClassName} "{instance.Name}"`
end

local instance_metatable = {
	__index = when_index,
	__newindex = when_new_index,
	__tostring = when_to_string,
}

local function table_overwrite(original: {[any]: any}, replacement: {[any]: any}): ()
	for index, value in replacement do
		original[index] = value
	end
end

local function find_child(self: instance, name: string): instance?
	local self_internal = get_internal(self)

	for _, child in self_internal.children do
		if child.Name == name then
			return get_pretense(child)
		end
	end

	return nil
end

local function get_children(self: instance): {instance}
	local self_internal = get_internal(self)

	local children_references: {instance} = table.create(#self_internal.children)
	for _, child in self_internal.children do
		table.insert(children_references, get_pretense(child))
	end
	return children_references
end

local function set_tags(instance: instance, tags: {string}): ()
	local instance_internal = get_internal(instance)
	instance_internal.tags = tags
end

local function instance_new(): instance
	local instance_internal: instance_internal = {
		-- NetworkedObject
		ClassName = "Instance",
		ObjectId = "",
		Name = "instance",

		FindChild = find_child,
		GetChildren = get_children,
		Parent = nil,

		-- internal
		children = {},
		tags = {},
	}

	local instance_true = newproxy(true)
	all_internal_instances[instance_true] = instance_internal
	instance_internal.reference = instance_true
	
	local metatable = getmetatable(instance_true)
	table_overwrite(metatable, instance_metatable)

	return instance_true
end

local instance_mod = {
	New = instance_new,

	-- for internal stuff
	set_tags = set_tags,
}

return instance_mod
