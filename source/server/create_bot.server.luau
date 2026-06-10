-- ~ Polytoria link id: f6a3535d-6327-4c8f-89fb-318b05cca0cc

local entity = require("../shared/entity")
local event_create_bot: NetworkEvent = Hidden:FindChild("create_bot") :: any

local function on_invoked_create_bot(_, messsage: NetMessage): ()
	local bot = NPC.New()
	local character = PolytorianModel.New()
	character.Position = Vector3.New(0, 9, 0)
	character.Parent = bot
	entity.create({
		NPC_object = bot,
	})
	bot.Parent = Environment
end

event_create_bot.InvokedServer:Connect(on_invoked_create_bot)
