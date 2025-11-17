local TextChatService = game:GetService("TextChatService")
local Player = game:GetService("Players")

TextChatService.OnIncomingMessage = function(msg)
	local props = Instance.new("TextChatMessageProperties")

	if msg.TextSource then
		local plr = Player:GetPlayerByUserId(msg.TextSource.UserId)

		--while plr:GetAttribute("VIP")==nil do task.wait() end
		--if plr:GetAttribute("VIP")==true then
		--	props.PrefixText = `<font color="rgb(255,255,0)">[👑VIP]</font> {msg.PrefixText}`
		--end
		
		if plr:GetAttribute("BetaPlayer") == true then
			print(`BetaPlayer is true`)
			props.PrefixText = `<font color="rgb(153,255,102)">[Beta Player]</font> {msg.PrefixText}`
		end

		if plr.Name == "Ransomwavee" then
			props.PrefixText = `<font color="rgb(255,0,0)">[DEV]</font> {msg.PrefixText}`
		end
	end

	return props
end