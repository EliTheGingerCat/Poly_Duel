-- ~ Polytoria link id: f398ee4e-c717-46b4-82b8-1ec64cdb5100

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
