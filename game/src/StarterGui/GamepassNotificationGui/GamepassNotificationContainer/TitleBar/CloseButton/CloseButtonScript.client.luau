local TS = game:GetService("TweenService")
local TI = TweenInfo

local plr = game.Players.LocalPlayer

-- // UI variables
local MainUI = plr.PlayerGui:WaitForChild("MainUI")
local UI_MainFrame = MainUI.Frame
local UI_RollScreen = MainUI.RollScreen
local UI_RollFrame = MainUI.Frame.Roll
local UI_MenuCanvas = MainUI.MenuCanvas


local Frame = script.Parent
local Button = Frame.TextButton

Button.Activated:Connect(function()
	TS:Create(UI_MenuCanvas.DailyRewardsFrame, TI.new(1,Enum.EasingStyle.Exponential), {Position = UDim2.fromScale(-.9, .223)}):Play()
end)