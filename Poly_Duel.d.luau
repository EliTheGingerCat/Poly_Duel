declare class Poly_Duel_entity
	id: number
	team_id: number?
end

declare class Poly_Duel_module_entity
	create: () -> Poly_Duel_entity
end
