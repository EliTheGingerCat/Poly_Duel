local entity = require(ScriptService:FindChild("entity") :: any) :: Poly_Duel_module_entity
local event_create_bot: NetworkEvent = Hidden:FindChild("create_bot") :: any

local function create_character(): Model
	local character = Model.New()

	local part = Part.New()
	part.Anchored = false

	part.Parent = character

	return character
end

local function on_invoked_create_bot(_, messsage: NetMessage): ()
	local bot = NPC.New()
	local character = PolytorianModel.New()
	character.Position = Vector3.New(0, 9, 0)
	character.Parent = bot
	bot.Parent = Environment
end

event_create_bot.InvokedServer:Connect(on_invoked_create_bot)
