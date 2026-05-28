type entity = {
	id: number,
	team_id: number?,
}

local entity_id = 0

local function entity_create(): entity
	entity_id += 1
	
	local entity: entity = {
		id = entity_id,
		team_id = nil,
	}
	
	return entity
end

local entity_mod = {
	create = entity_create,
}

return entity_mod
