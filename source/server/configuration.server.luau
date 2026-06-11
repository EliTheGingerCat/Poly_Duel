-- ~ Polytoria link id: 44eccd1e-11c9-4b16-a7e8-109d0889f042

local respawn_time = 0.1

PlayerDefaults.RespawnTime = respawn_time

for _, player in Players:GetPlayers() do
	player.RespawnTime = respawn_time
end
