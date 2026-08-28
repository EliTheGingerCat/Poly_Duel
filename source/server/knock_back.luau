-- dimension 1-dimension 3 plane strength
-- some might say "horizontal", though it is also distal (z-dimension)
-- I am overcomplicating
--local d1_d3_strength = 100

local pitch_minimum = math.pi / 8
local d2_maximum_strength = 50
--local wait_time = 0.2

--[[
type pending_item = {
	time_end: number,
	target: Physical,
	velocity: Vector3,
}

local pending_knock_back: {pending_item} = {}
local to_remove: {number} = {}]]

local function knock_back(attacker: Dynamic, target: Physical): ()
	local displacement = target.Position - attacker.Position
	local direction = displacement.Normalized
	--local direction_d1_d3 = Vector3.New(direction.X, 0, direction.Z)
	--local knock_back_d1_d3 = direction_d1_d3 * d1_d3_strength

	--[[
	Eli:

	Admittedly, I searched this up.

	<https://stackoverflow.com/questions/2782647/how-to-get-yaw-pitch-and-roll-from-a-3d-vector>

	However, I think that I understand:

	Imagine the vertical y-dimension circle around the direction vector. There is a triangle. (I suppose that circles and triangles are bound together, forever.) The hypotenuse is the length of the direction vector. The distance from the end of the direction vector to the x-z plane forms another leg of the triangle. (The last leg is the x-z distance to where the direction tip would be projected onto the x-z plane.) Thus:

	sin(theta) = opposite / hypotenuse
	sin(pitch) = direction.y / 1
	sin(pitch) = direction.y
	pitch = arcsin(direction.y)
	]]
	local pitch_real = math.asin(direction.Y)
	local pitch_clamped = math.max(pitch_real, pitch_minimum)
	local knock_back_d2_scalar = math.map(pitch_clamped, 0, math.pi / 2, 0, d2_maximum_strength)
	local knock_back_d2 = Vector3.New(0, knock_back_d2_scalar, 0)
	target.Velocity += knock_back_d2

	--[[
	local pending_item: pending_item = {
		target = target,
		velocity = knock_back_d1_d3,
		time_end = os.clock() + wait_time,
	}
	table.insert(pending_knock_back, pending_item)]]
end

--[[
local function when_updated(): ()
	local time_now = os.clock()
	for index, item in pending_knock_back do
		if time_now >= item.time_end then
			table.insert(to_remove, index)
			print("applying velocity:", item.velocity)
			item.target.Velocity += item.velocity
			print("velocity:", item.target.Velocity)
		end
	end

	for _, index in to_remove do
		table.remove(pending_knock_back, index)
	end

	table.clear(to_remove)
end
Hooks.Updated:Connect(when_updated)]]

return knock_back
