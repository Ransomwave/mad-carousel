local TS = game:GetService("TweenService")
local TI = TweenInfo

local plr = game.Players.LocalPlayer

-- // UI variables
local MainUI = plr.PlayerGui:WaitForChild("MainUI")
local UI_MenuGroup = MainUI.MenuGroup

local Frame = script.Parent
local Button = Frame.TextButton
local State = Frame.State

local CLOSED_POS=UDim2.fromScale(-.7, .25)
local OPEN_POS=UDim2.fromScale(.2, .25)

Button.Activated:Connect(function()
	if State.Value == false then -- Not activated
		State.Value = true
		TS:Create(UI_MenuGroup.RobuxShopFrame, TI.new(1,Enum.EasingStyle.Exponential), {Position = OPEN_POS}):Play()
	else
		State.Value = false
		TS:Create(UI_MenuGroup.RobuxShopFrame, TI.new(1,Enum.EasingStyle.Exponential), {Position = CLOSED_POS}):Play()
	end
end)