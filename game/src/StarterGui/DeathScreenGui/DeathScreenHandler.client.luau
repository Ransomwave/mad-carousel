--!strict

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TS = game:GetService("TweenService")
local TI = TweenInfo

-- Instances
local Events = ReplicatedStorage.Events
local DeathScreenGroup = script.Parent.DeathScreenGroup

Events.UI.PromptDeathScreen.OnClientEvent:Connect(function(text: string)
	DeathScreenGroup.NoticeText.BottomText.Text = text
	TS:Create(DeathScreenGroup, TI.new(.3, Enum.EasingStyle.Exponential), {GroupTransparency = 0}):Play()
	task.wait(3)
	TS:Create(DeathScreenGroup, TI.new(.3, Enum.EasingStyle.Exponential), {GroupTransparency = 1}):Play()
end)