local lobby = Environment:FindChild("lobby")
local maps_folder = ServerHidden:FindChild("maps")

type base = {
	goal: Part,
	spawn_part: Part,
}

type map = {
	bases: {base},
	container: Model,
}

local current_map: map?

-- example: base_1
local pattern_base_name = "base_(%d+)"

local function table_unpack_full<T>(t: {n: number, [number]: T}): ...T
	return table.unpack(t, 1, t.n)
end

local function delay<A...>(delay_time: number, fun: (A...) -> (), ...: A...): ()
	local arguments: {n: number, [number]: any} = table.pack(...)
	local function caller(): ()
		wait(delay_time)
		fun(table_unpack_full(arguments))
	end
	spawn(caller)
end

local function get_map_from_container(map_container_maybe: Instance): map?
	local bases: {base} = {}

	if map_container_maybe:IsA("Model") == false then
		print("Map container is not a model.")
		return nil
	end

	local map_container: Model = map_container_maybe :: any

	for _, child in map_container_maybe:GetChildren() do
		if child:IsA("Folder") == false then
			continue
		end

		local id_string: string? = string.match(child.Name, pattern_base_name)
		if id_string == nil then
			continue
		end

		local id = tonumber(id_string, 10)
		if id == nil then
			print("Something string occured. Id string was not able to be converted into a number.")
			continue
		end

		local goal_maybe: Instance? = child:FindChild("goal")

		if goal_maybe == nil then
			print("Goal was not found.")
			continue
		end

		if goal_maybe:IsA("Part") == false then
			print("Goal is not a part.")
			continue
		end

		local goal: Part = goal_maybe :: any

		local spawn_part_maybe: Instance? = child:FindChild("spawn")

		if spawn_part_maybe == nil then
			print("Spawn-part was not found.")
			continue
		end

		if spawn_part_maybe:IsA("Part") == false then
			print("Spawn-part is not a part.")
			continue
		end

		local spawn_part: Part = spawn_part_maybe :: any

		local base: base = {
			goal = goal,
			spawn_part = spawn_part,
		}

		table.insert(bases, base)
	end

	local map: map = {
		bases = bases,
		container = map_container,
	}

	return map
end

local map_containers: {Instance} = maps_folder:GetChildren()

local function pick_random_map(): map?
	if #map_containers == 0 then
		print("No maps were found.")
		return nil
	end

	local map_container = map_containers[math.random(1, #map_containers)]
	local container_clone: Model = map_container:Clone() :: any
	local map = get_map_from_container(container_clone)
	if map == nil then
		print(`Failed to get map from container for map "{map_container.Name}".`)
	end

	return map
end

local game_end
local function process_score(map: map): ()
	-- ~ Investigate: It seems that it is possible for the game to end before it quite begins, visually resulting in both the lobby and map being present simultaneously.
	game_end()
end

local function setup_map(map: map): ()
	for _, base in map.bases do
		local function on_touched(toucher_maybe: Physical): ()
			if not toucher_maybe:IsA("Player") then
				return
			end

			process_score(map)
		end
		
		base.goal.Touched:Connect(on_touched)
	end
end

local function game_start(): ()
	local random_map = pick_random_map()
	if random_map == nil then
		print("Failed to pick a random map.")
		return
	end
	
	local map = random_map
	current_map = map
	setup_map(map)

	map.container.Parent = Environment
	-- Must be Hidden and not ServerHidden for map to be hidden on client. I assume ServerHidden works on the server.
	lobby.Parent = Hidden
end

game_end = function(): ()
	if current_map == nil then
		print("Can not stop because `current_map` was not found.")
		return
	end
	local map = current_map
	current_map = nil

	lobby.Parent = Environment
	map.container:Destroy()

	delay(5, game_start)
end

game_start()
