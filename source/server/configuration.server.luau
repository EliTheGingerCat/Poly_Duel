local respawn_time = 0.1

PlayerDefaults.RespawnTime = respawn_time

for _, player in Players:GetPlayers() do
	player.RespawnTime = respawn_time
end
