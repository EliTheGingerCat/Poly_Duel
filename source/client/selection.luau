local signal = require("../shared/signal")

type signal<T...> = signal.signal<T...>

-- ~ Todo: Maybe use a set. (`{[Instance]: boolean}`.)
local current_selection: {Instance} = {}

local when_added_to_selection = signal.create() :: signal<Instance>
local when_removed_from_selection = signal.create() :: signal<Instance>

-- Unused.
--[=[
	@return -- Must not be mutated.
]=]
local function get_selection(): {Instance}
	return current_selection
end

--[=[
	@return --- The index, to be used with `remove_from_selection`.
]=]
local function add_to_selection(instance: Instance): number
	local index = #current_selection + 1
	current_selection[index] = instance
	signal.fire(when_added_to_selection, instance)
	return index
end

local function find_in_selection(instance: Instance): number?
	local index = table.find(current_selection, instance)
	return index
end

--[=[
	@param index --- Instance index in selection. This is provided by `add_to_selection`.
]=]
local function remove_from_selection(index: number): ()
	local instance = table.remove(current_selection, index)
	if instance == nil then
		print(`Error: No instance was found at index {index}.`)
		return
	end
	signal.fire(when_removed_from_selection, instance)
end

local selection = {
	add = add_to_selection,
	find = find_in_selection,
	get = get_selection,
	remove = remove_from_selection,
	when_added = when_added_to_selection,
	when_removed = when_removed_from_selection,
}

return selection
