local create_outline = require("./create_outline")
local selection = require("../selection")
local signal = require("../../shared/signal")

local outlines: {[Instance]: Model} = {}

local function when_selection_added(instance: Instance): ()
	if instance:IsA("Dynamic") == false then
		return
	end

	local dynamic: any = instance :: Dynamic

	local outline = create_outline(dynamic)
	outlines[instance] = outline
	outline.Parent = Environment
end

signal.connect(selection.when_added, when_selection_added)

local function when_selection_removed(instance: Instance): ()
	local outline: Model? = outlines[instance]
	if outline == nil then
		if instance:IsA("Dynamic") == true then
			print(`Error: Instance {instance} is missing an outline.`)
		end
		return
	end
	outlines[instance] = nil

	outline:Destroy()
end

signal.connect(selection.when_removed, when_selection_removed)
