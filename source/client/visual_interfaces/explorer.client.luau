type destroy = () -> ()

local d1_length = 200
local depth_indent = 50
local row_height = 30
local row_padding = 10
local row_space = row_height + row_padding

local colours = {
	grey = Color.New(0.8, 0.8, 0.8, 1),
	transparent = Color.New(0, 0, 0, 0),
	white = Color.New(1, 1, 1, 1),
}

type title_bar_properties = {
	when_mouse_down_on_up: () -> (),
}

local function create_title_bar(properties: title_bar_properties): UIView
	local container = UIView.New()
	container.BorderWidth = 1
	container.Color = colours.transparent
	container.Name = "title bar"
	container.PivotPoint = Vector2.New(0.5, 0)
	container.PositionRelative = Vector2.New(0.5, 0)
	container.SizeOffset = Vector2.Zero
	container.SizeRelative = Vector2.New(1, 0.1)

	local title = UILabel.New()
	title.Color = colours.transparent
	title.PivotPoint = Vector2.New(0, 0.5)
	title.PositionRelative = Vector2.New(0, 0.5)
	title.SizeOffset = Vector2.Zero
	title.SizeRelative = Vector2.New(0.8, 1)
	title.Text = "explorer"
	title.Parent = container

	local up_button = UIButton.New()
	up_button.Color = colours.transparent
	up_button.PivotPoint = Vector2.New(1, 0)
	up_button.PositionOffset = Vector2.Zero
	up_button.PositionRelative = Vector2.New(0.9, 0)
	up_button.SizeOffset = Vector2.New(100, 25)
	up_button.Text = "go up"
	up_button.Parent = container

	up_button.MouseDown:Connect(properties.when_mouse_down_on_up)

	return container
end

type explorer_item_properties = {
	colour: Color,
	corresponding_instance: Instance,
	parent: Instance,
	position_offset: Vector2,
}

type explorer_item_result = {
	connection: PTSignalConnection,
	label: UILabel,
}

local function create_explorer_item(properties: explorer_item_properties): explorer_item_result
	local instance = properties.corresponding_instance
	local instance_name = instance.Name

	local label = UILabel.New()
	label.BorderWidth = 1
	label.Color = properties.colour
	label.Name = instance_name
	label.PivotPoint = Vector2.Zero
	label.PositionOffset = properties.position_offset
	label.PositionRelative = Vector2.Zero
	label.SizeOffset = Vector2.New(d1_length, row_height)
	label.Text = instance_name
	label.Parent = properties.parent

	local function when_property_changed(property_name: string): ()
		if property_name == "Name" then
			local name_new = instance.Name
			label.Name = name_new
			label.Text = name_new
		end
	end

	local connection_property_changed = instance.PropertyChanged:Connect(when_property_changed)

	local result = {
		connection = connection_property_changed,
		label = label,
	}

	return result
end

type information_notice_properties = {
	text: string,
}

local function create_information_notice(properties: information_notice_properties): UILabel
	local label = UILabel.New()
	label.Color = colours.transparent
	label.SizeOffset = Vector2.Zero
	label.SizeRelative = Vector2.New(1, 1)
	label.Text = properties.text
	return label
end

local function sort_instances_by_name(a: Instance, b: Instance): boolean
	return a.Name < b.Name
end

local function create_explorer(): destroy
	local interface = GUI.New()
	interface.Name = "explorer"

	local explorer_container = UIView.New()
	explorer_container.BorderWidth = 1
	explorer_container.Color = colours.white
	explorer_container.PositionRelative = Vector2.New(0.15, 0.3)
	explorer_container.SizeOffset = Vector2.Zero
	explorer_container.SizeRelative = Vector2.New(0.2, 0.5)
	explorer_container.Parent = interface

	-- title bar is below

	local scroll = UIScrollView.New()
	scroll.ClipDescendants = true
	scroll.Name = "instance menu"
	scroll.PivotPoint = Vector2.New(0.5, 0)
	scroll.PositionRelative = Vector2.New(0.5, 0.1)
	scroll.SizeOffset = Vector2.Zero
	scroll.SizeRelative = Vector2.New(1, 0.9)
	scroll.Parent = explorer_container

	-- For some reason, it seems that it is necessary to hold everything in a view in order for scrolling to work.
	local scroll_view = UIView.New()
	scroll_view.Color = colours.transparent
	scroll_view.Name = "instance menu container"
	scroll_view.Parent = scroll

	local function when_scroll_absolute_size_changed(): ()
		local size_offset_minimum_d1 = 2 * depth_indent + d1_length
		local size_absolute_scroll_d1 = scroll.AbsoluteSize.X
		-- The size must be at least `size_minimum_d1_offset`, but if that size is always used, it will usually be smaller than the scroll window.
		local size_offset_d1 = math.max(size_offset_minimum_d1, size_absolute_scroll_d1)
		local size_offset_d2 = scroll_view.SizeOffset.Y
		scroll_view.SizeOffset = Vector2.New(size_offset_d1, size_offset_d2)
	end

	local function when_scroll_property_changed(property_name: string): ()
		if property_name == "AbsoluteSize" then
			when_scroll_absolute_size_changed()
		end
	end

	scroll.PropertyChanged:Connect(when_scroll_property_changed)

	local root_current: Instance

	local cleanup_connections: {PTSignalConnection} = {}

	local function cleanup(): ()
		for _, connection in cleanup_connections do
			connection:Disconnect()
		end
		table.clear(cleanup_connections)
	end

	local function load(root: Instance): ()
		cleanup()

		root_current = root

		-- ~ Investigate: For unknown reasons,  that `scroll_view` is a child of itself.
		if root == scroll_view :: Instance then
			-- ~ Todo: Display this notice in the title bar rather than in the scroll menu.
			local label = create_information_notice({
				text = "Sorry: For unknown reasons, explorer does not work with the instance menu container.",
			})
			label.Parent = scroll_view
			return
		end

		for _, child in scroll_view:GetChildren() do
			child:Destroy()
		end

		local result = create_explorer_item({
			colour = colours.white,
			corresponding_instance = root,
			parent = scroll_view,
			position_offset = Vector2.Zero,
		})

		table.insert(cleanup_connections, result.connection)

		local root_children = root:GetChildren()
		table.sort(root_children, sort_instances_by_name)
		for index, child in root_children do
			local item_order = index + 1
			local is_even = item_order % 2 == 0
			local colour = if is_even == true then colours.grey else colours.white

			local child_result = create_explorer_item({
				colour = colour,
				corresponding_instance = child,
				parent = scroll_view,
				position_offset = Vector2.New(depth_indent, index * row_space),
			})

			table.insert(cleanup_connections, child_result.connection)

			local item = child_result.label

			local function on_mouse_down_on_item(): ()
				load(child)
			end
			
			item.MouseDown:Connect(on_mouse_down_on_item)
		end

		local size_offset_d1 = scroll_view.SizeOffset.X
		local amount_total_children = #root_children + 1
		local size_offset_d2 = amount_total_children * row_space
		scroll_view.SizeOffset = Vector2.New(size_offset_d1, size_offset_d2)
		when_scroll_absolute_size_changed()

		-- ~ Todo: Make this more efficient by simply adding the child. This would also require reordering.
		local function when_child_added(): ()
			-- Keep in mind that `ChildAdded` passes the added child to the callback, but here, `load` must actually reuse `root`. Thus, it is incorrect to do `ChildAdded:Connect(load)`. I made this mistake :3 . I also made this mistake with `ChildRemoved`.
			load(root)
		end

		local connection_child_added = root.ChildAdded:Connect(when_child_added)
		table.insert(cleanup_connections, connection_child_added)

		-- ~ Todo: Make this more efficient by simply removing the child. This would require saving the connections between each label and its corresponding instance.
		local function when_child_removed(): ()
			load(root)
		end

		local connection_child_removed = root.ChildRemoved:Connect(when_child_removed)
		table.insert(cleanup_connections, connection_child_removed)
	end

	local function when_mouse_down_on_up(): ()
		local parent = root_current.Parent :: Instance?
		if parent == nil then
			print(`Error: "{root_current}"'s parent was missing.`)
			return
		end

		load(parent)
	end

	local title_bar = create_title_bar({
		when_mouse_down_on_up = when_mouse_down_on_up,
	})
	title_bar.Parent = explorer_container

	load(world)

	local function destroy(): ()
		interface:Destroy()
	end

	interface.Parent = PlayerGUI

	return destroy
end

create_explorer()
