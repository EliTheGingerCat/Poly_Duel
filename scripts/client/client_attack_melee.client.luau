local event_attack_melee: NetworkEvent = Hidden:FindChild("attack_melee") :: any

local local_player = Players.LocalPlayer
local input_use_tool = Input:GetButton("use_tool")

local melee_range = 10

local function on_activated(): ()
	local origin = local_player.Position
	local mouse_position = Input:GetMouseWorldPosition()
	local direction = mouse_position - origin
	local result: RayResult? = Environment:Raycast(origin, direction)

	if result == nil then
		print("Nothing found.")
		return
	end

	if result.Distance > melee_range then
		print("Too far.")
		return
	end

	local result_instance = result.Instance
	
	if not result_instance:IsA("NPC") then
		print("Not an NPC.")
		return
	end

	local bot_NPC: NPC = result_instance :: any

	local network_message = NetMessage.New()
	network_message:AddInstance("NPC", bot_NPC)
	event_attack_melee:InvokeServer(network_message)
end

input_use_tool.Pressed:Connect(on_activated)
