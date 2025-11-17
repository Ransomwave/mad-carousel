local plr = game.Players.LocalPlayer
local gM = require(game.ReplicatedStorage.GameModule)
local TweenService = game:GetService("TweenService")

script.Parent.Triggered:Connect(function()
	script.Parent.Enabled = false
	local DonationGUI = plr.PlayerGui:WaitForChild("DonationGui")
	
	--gM.anchorPlayer(plr, true)
	DonationGUI.Frame.Visible = true
	TweenService:Create(DonationGUI.Frame, TweenInfo.new(1,Enum.EasingStyle.Exponential), {Position = UDim2.fromScale(.259,.227)}):Play()
	
	DonationGUI.Frame.TitleBar.CloseButton.TextButton.Activated:Wait()
	--gM.anchorPlayer(plr, false)
	TweenService:Create(DonationGUI.Frame, TweenInfo.new(1,Enum.EasingStyle.Exponential), {Position = UDim2.fromScale(.259,1.3)}):Play()
	task.wait(1)
	DonationGUI.Frame.Visible = false
	script.Parent.Enabled = true
end)