local event_create_bot: NetworkEvent = Hidden:FindChild("create_bot") :: any

local interface = GUI.New()

local create_bot = UIButton.New()
create_bot.Parent = interface

interface.Parent = PlayerGUI

local function on_clicked_create_bot(): ()
	local message = NetMessage.New()
	event_create_bot:InvokeServer(message)
end

create_bot.Clicked:Connect(on_clicked_create_bot)
