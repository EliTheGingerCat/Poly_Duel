local entity = require(script.Parent:FindChild("entity"))

local function on_player_added(player: Player): ()
	entity.create()
end

Players.PlayerAdded:Connect(on_player_added)
