local entity = require("../shared/entity")

local function on_player_added(player: Player): ()
	entity.create({
		player = player,
	})
end

Players.PlayerAdded:Connect(on_player_added)

for _, player in Players:GetPlayers() do
	on_player_added(player)
end
