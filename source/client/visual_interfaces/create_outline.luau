local colour = Color.New(0.5, 0.5, 1, 1)

local function create_outline(dynamic: Dynamic): Model
	local model = Model.New()

	local position = dynamic.Position
	-- Rotation is not used yet.
	local size = dynamic.Size
	local size_half = size / 2

	-- A rectangular prism has 12 edges...
	-- I suppose that this can be automated, but it would probably be quite confusing to read. When one reads through the following explicit instructions, one will quickly realise the pattern.

	local part_left_down = Part.New()
	part_left_down.CanCollide = false
	part_left_down.Color = colour
	part_left_down.Position = position + Vector3.New(-size_half.X, -size_half.Y, 0)
	part_left_down.Size = Vector3.New(1, 1, size.Z)
	part_left_down.Parent = model

	local part_left_up = Part.New()
	part_left_up.CanCollide = false
	part_left_up.Color = colour
	part_left_up.Position = position + Vector3.New(-size_half.X, size_half.Y, 0)
	part_left_up.Size = Vector3.New(1, 1, size.Z)
	part_left_up.Parent = model

	local part_left_back = Part.New()
	part_left_back.CanCollide = false
	part_left_back.Color = colour
	part_left_back.Position = position + Vector3.New(-size_half.X, 0, -size_half.Z)
	part_left_back.Size = Vector3.New(1, size.Y, 1)
	part_left_back.Parent = model

	local part_left_forward = Part.New()
	part_left_forward.CanCollide = false
	part_left_forward.Color = colour
	part_left_forward.Position = position + Vector3.New(-size_half.X, 0, size_half.Z)
	part_left_forward.Size = Vector3.New(1, size.Y, 1)
	part_left_forward.Parent = model

	local part_right_down = Part.New()
	part_right_down.CanCollide = false
	part_right_down.Color = colour
	part_right_down.Position = position + Vector3.New(size_half.X, -size_half.Y, 0)
	part_right_down.Size = Vector3.New(1, 1, size.Z)
	part_right_down.Parent = model

	local part_right_up = Part.New()
	part_right_up.CanCollide = false
	part_right_up.Color = colour
	part_right_up.Position = position + Vector3.New(size_half.X, size_half.Y, 0)
	part_right_up.Size = Vector3.New(1, 1, size.Z)
	part_right_up.Parent = model

	local part_right_back = Part.New()
	part_right_back.CanCollide = false
	part_right_back.Color = colour
	part_right_back.Position = position + Vector3.New(size_half.X, 0, -size_half.Z)
	part_right_back.Size = Vector3.New(1, size.Y, 1)
	part_right_back.Parent = model

	local part_right_forward = Part.New()
	part_right_forward.CanCollide = false
	part_right_forward.Color = colour
	part_right_forward.Position = position + Vector3.New(size_half.X, 0, size_half.Z)
	part_right_forward.Size = Vector3.New(1, size.Y, 1)
	part_right_forward.Parent = model

	local part_down_back = Part.New()
	part_down_back.CanCollide = false
	part_down_back.Color = colour
	part_down_back.Position = position + Vector3.New(0, -size_half.Y, -size_half.Z)
	part_down_back.Size = Vector3.New(size.X, 1, 1)
	part_down_back.Parent = model

	local part_down_forward = Part.New()
	part_down_forward.CanCollide = false
	part_down_forward.Color = colour
	part_down_forward.Position = position + Vector3.New(0, -size_half.Y, size_half.Z)
	part_down_forward.Size = Vector3.New(size.X, 1, 1)
	part_down_forward.Parent = model

	local part_up_back = Part.New()
	part_up_back.CanCollide = false
	part_up_back.Color = colour
	part_up_back.Position = position + Vector3.New(0, size_half.Y, -size_half.Z)
	part_up_back.Size = Vector3.New(size.X, 1, 1)
	part_up_back.Parent = model

	local part_up_forward = Part.New()
	part_up_forward.CanCollide = false
	part_up_forward.Color = colour
	part_up_forward.Position = position + Vector3.New(0, size_half.Y, size_half.Z)
	part_up_forward.Size = Vector3.New(size.X, 1, 1)
	part_up_forward.Parent = model

	return model
end

return create_outline
