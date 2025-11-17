local Player = game.Players.LocalPlayer
local SocialService = game:GetService("SocialService")

if SocialService:CanSendGameInviteAsync(Player) then
	local inviteOptions = Instance.new("ExperienceInviteOptions")
	inviteOptions.PromptMessage = "More friends = more rewards!"
	
	SocialService:PromptGameInvite(Player)
else
	script.OnErrorGui.Enabled = true
end
task.wait(2)
script:Destroy()
