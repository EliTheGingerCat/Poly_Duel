-- ~ Polytoria link id: 8b60fd8e-cc35-43bd-aa23-d164af468ae6

local event_attack_melee: NetworkEvent = Hidden:FindChild("attack_melee") :: any

local damage = 10

local function on_invoked_attack_melee(_, message: NetMessage): ()
	local instance = message:GetInstance("NPC")

	if instance:IsA("NPC") == false then
		print("Not an NPC.")
		return
	end

	local bot_NPC: NPC = instance :: any

	bot_NPC.Health -= damage
end

event_attack_melee.InvokedServer:Connect(on_invoked_attack_melee)
