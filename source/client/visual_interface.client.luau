local event_create_bot: NetworkEvent = Hidden:FindChild("create_bot") :: any
local event_game_state: NetworkEvent = Hidden:FindChild("game_state") :: any

type destroy = () -> ()

-- example: 01:34:67 <-- 6-7 joke
-- However, although the format supports it, real time values can not have >= 60 seconds.
local format_time = "%02d:%02d:%02d"

local function create_create_bot(): destroy
	local interface = GUI.New()

	local create_bot = UIButton.New()
	create_bot.PositionRelative = Vector2.New(0.1, 0.8)
	create_bot.SizeRelative = Vector2.New(0.1, 0.01)
	create_bot.Text = "create a bot"
	create_bot.Parent = interface

	local function on_clicked_create_bot(): ()
		local message = NetMessage.New()
		event_create_bot:InvokeServer(message)
	end

	create_bot.Clicked:Connect(on_clicked_create_bot)

	local function destroy(): ()
		interface:Destroy()
	end

	interface.Parent = PlayerGUI

	return destroy
end

local game_state_text = {
	[true] = "game",
	[false] = "intermission"
}

local function create_game_state(): destroy
	local is_destroyed = false
	local game_is_ongoing = false
	local time_start = os.time()

	local interface = GUI.New()

	local text = UILabel.New()
	text.PositionRelative = Vector2.New(0.5, 0.1)
	text.SizeRelative = Vector2.New(0.3, 0.01)
	text.Text = game_state_text[game_is_ongoing]
	text.Parent = interface

	local function on_invoked_game_state(message: NetMessage): ()
		local did_start = message:GetBool("did_start")
		game_is_ongoing = did_start
		time_start = os.time()
	end

	event_game_state.InvokedClient:Connect(on_invoked_game_state)

	local function timer(): ()
		while true do
			if is_destroyed == true then
				return
			end

			local time_now = os.time()
			local time_elapsed = time_now - time_start
			
			local seconds = time_elapsed % 60

			local time_elapsed_for_minutes = time_elapsed - seconds
			local minutes = time_elapsed_for_minutes / 60

			local time_elapsed_for_hours = time_elapsed_for_minutes - minutes
			local hours = time_elapsed_for_hours / 60

			local time_formatted = string.format(format_time, hours, minutes, seconds)
			text.Text = game_state_text[game_is_ongoing] .. " " .. time_formatted

			wait()
		end
	end

	spawn(timer)

	local function destroy(): ()
		is_destroyed = true
		interface:Destroy()
	end

	interface.Parent = PlayerGUI

	return destroy
end

create_create_bot()
create_game_state()
