-- ~ Polytoria link id: 3d9e90c6-e0a1-4c77-b69c-f34ac276478a

local entity_mod = require("./entity")

type entity = entity_mod.entity

export type team = {
	id: number,
	goal: Part,
	members: {entity},
	points: number,
	spawn_part: Part,
}

local team_id = 0

type team_creation_options = {
	goal: Part,
	spawn_part: Part,
}

local function team_create(options: team_creation_options): team
	team_id += 1

	local team: team = {
		id = team_id,
		goal = options.goal,
		members = {},
		points = 0,
		spawn_part = options.spawn_part,
	}

	return team
end

local function team_destroy(team: team): ()
	table.clear(team)

	local husk: any = team
	husk["what"] = "Destroyed object. Was formerly a team."
end

local team_mod = {
	create = team_create,
	destroy = team_destroy,
}

return team_mod
