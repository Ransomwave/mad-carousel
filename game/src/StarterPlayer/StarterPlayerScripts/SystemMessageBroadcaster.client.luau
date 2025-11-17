local StarterGui = game:GetService("StarterGui")
local TextChatService = game:GetService("TextChatService")
local systemChannel = TextChatService:WaitForChild("TextChannels"):WaitForChild("RBXSystem")

local messages = {
	"Tip: Press 'F' to push!",
	"Tip: Buy Gear from the shop!",
	"Tip: Use your Cash to buy Gear from the shop!",
	"Tip: On console, press 'X' to push!",
	"Join the Roblox group for in-game rewards!",
	"Don't forget to favorite and like the game! 👍",
}

local MIN_INTERVAL = 60
local MAX_INTERVAL = 200

task.spawn(function()
	while true do
		-- Pick a random message
		local message = messages[math.random(1, #messages)]

		---- Send the system chat message
		--StarterGui:SetCore("ChatMakeSystemMessage", {
		--	Text = "[System]: " .. message,
		--	Color = Color3.fromRGB(255, 255, 0),
		--	Font = Enum.Font.SourceSansBold,
		--	FontSize = Enum.FontSize.Size24,
		--})

		systemChannel:DisplaySystemMessage(`<font color="rgb(255,255,0)" face="Montserrat" size="20"><b>{message}</b></font>`)

		task.wait(math.random(MIN_INTERVAL, MAX_INTERVAL))
	end
end)
