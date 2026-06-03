local entity = require(script.Parent:FindChild("entity")) :: Poly_Duel_module_entity

local function on_player_added(player: Player): ()
	entity.create({
		player = player,
	})
end

Players.PlayerAdded:Connect(on_player_added)
