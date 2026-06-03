declare class Poly_Duel_entity
	id: number
	NPC_object: NPC?
	Player: Player?
	team_id: number?
end

type entity = Poly_Duel_entity

declare class Poly_Duel_module_entity
	all_entities: {entity}
	create: (
		options: {
			NPC_object: NPC?,
			player: Player?,
		}
	) -> entity
	find_by_player: (player: Player) -> entity?
end

declare class Poly_Duel_team
	id: number
	goal: Part
	members: {entity}
	points: number
	spawn_part: Part
end

type team = Poly_Duel_team

type team_creation_options = {
	goal: Part,
	spawn_part: Part,
}

declare class Poly_Duel_module_team
	create: (
		options: {
			goal: Part,
			spawn_part: Part,
		}
	) -> team
	destroy: (team: team) -> ()
end
