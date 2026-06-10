-- ~ Polytoria link id: 84066fca-026b-4c4e-9173-b0f47f47d3c1

local entity_mod = require("../shared/entity")
local event_game_state: NetworkEvent = Hidden:FindChild("game_state") :: any
local lobby = Environment:FindChild("lobby")
local maps_folder = ServerHidden:FindChild("maps")
local team_mod = require("../shared/team")

type entity = entity_mod.entity
type team = team_mod.team

type map = {
	container: Model,
	teams: {team},
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
	local teams: {team} = {}

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

		local team: team = team_mod.create({
			goal = goal,
			spawn_part = spawn_part,
		})

		table.insert(teams, team)
	end

	local map: map = {
		container = map_container,
		teams = teams,
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

local function reset_positions(map: map): ()
	for _, team in map.teams do
		local position = team.spawn_part.Position
		local rotation = team.spawn_part.Rotation

		for _, entity in team.members do
			if entity.player ~= nil then
				entity.player.Position = position
				entity.player.Rotation = rotation
			end
		end
	end
end

local game_end
local function process_score(map: map, entity: entity, team: team): ()
	team.points += 1

	-- ~ Investigate: It seems that it is possible for the game to end before it quite begins, visually resulting in both the lobby and map being present simultaneously.

	if team.points >= 5 then
		print(`Team with id {team.id} wins!`)
		game_end()
	else
		print(`Team with id {team.id} has {team.points} points.`)
		reset_positions(map)
	end
end

local function setup_map(map: map): ()
	for _, team in map.teams do
		local function on_touched(toucher_maybe: Physical): ()
			if not toucher_maybe:IsA("Player") then
				return
			end

			local player: Player = toucher_maybe :: any

			local entity = entity_mod.find_by_player(player)

			if entity == nil then
				print("Error: There is no entity with this player.")
				return
			end

			if entity.team_id == nil then
				return
			end

			if entity.team_id == team.id then
				return
			end

			process_score(map, entity, team)
		end
		
		team.goal.Touched:Connect(on_touched)
	end
end

local function add_entity_to_team(team: team, entity: entity): ()
	table.insert(team.members, entity)
	entity.team_id = team.id
end

local function setup_entities(map: map): ()
	local teams_size = #map.teams

	for entity_index, entity in entity_mod.all_entities do
		local team_index = (entity_index - 1) % teams_size + 1
		local team = map.teams[team_index]
		add_entity_to_team(team, entity)
	end
end

local function get_smallest_team(map: map): team
	local smallest_size = math.huge
	local smallest_teams = {}
	for _, this_team in map.teams do
		local this_size = #this_team.members
		if this_size < smallest_size then
			smallest_size = this_size
			table.clear(smallest_teams)
			table.insert(smallest_teams, this_team)
		elseif this_size == smallest_size then
			table.insert(smallest_teams, this_team)
		end
	end
	local random_smallest = smallest_teams[math.random(1, #smallest_teams)]
	return random_smallest
end

local function setup_new_entity(map: map, entity: entity): ()
	local team = get_smallest_team(map)
	add_entity_to_team(team, entity)
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
	setup_entities(map)

	map.container.Parent = Environment
	-- Must be Hidden and not ServerHidden for map to be hidden on client. I assume ServerHidden works on the server.
	lobby.Parent = Hidden

	local message = NetMessage.New()
	message:AddBool("did_start", true)
	event_game_state:InvokeClients(message)
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

	for _, team in map.teams do
		team_mod.destroy(team)
	end

	local message = NetMessage.New()
	message:AddBool("did_start", false)
	event_game_state:InvokeClients(message)

	delay(5, game_start)
end

game_start()

local function on_player_added(player: Player): ()
	-- ~ Todo: Replace this with an `on_entity_added` signal. This will require a Polytoria signal module.

	if current_map ~= nil then
		-- Wait a bit for the entity to be created.
		wait(0.2)

		local entity = entity_mod.find_by_player(player)
		
		if entity == nil then
			print("Error: No entity was found with this player.")
			return
		end

		setup_new_entity(current_map, entity)
	end
end

Players.PlayerAdded:Connect(on_player_added)

