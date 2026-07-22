local signal_mod = require("./signal")

type signal<T...> = signal_mod.signal<T...>

export type entity = {
	id: number,
	NPC_object: NPC?,
	player: Player?,
	team_id: number?,
}

local all_entities: {entity} = {}
local entity_id = 0
local signal_entity_added = signal_mod.create() :: signal<entity>

type entity_creation_options = {
	NPC_object: NPC?,
	player: Player?,
}

local function entity_create(options: entity_creation_options): entity
	if options.NPC_object == nil and options.player == nil then
		print("Error: Entity must be either a player or a bot.")
		return nil :: any
	end
	
	entity_id += 1
	
	local entity: entity = {
		id = entity_id,
		NPC_object = options.NPC_object or nil,
		player = options.player or nil,
		team_id = nil,
	}

	table.insert(all_entities, entity)

	signal_mod.fire(signal_entity_added, entity)
	
	return entity
end

local function find_by_player(player: Player): entity?
	for _, entity in all_entities do
		if entity.player == player then
			return entity
		end
	end

	-- This is not good.
	return nil
end

local entity_mod = {
	all_entities = all_entities,
	create = entity_create,
	find_by_player = find_by_player,
	signal_entity_added = signal_entity_added,
}

return entity_mod
