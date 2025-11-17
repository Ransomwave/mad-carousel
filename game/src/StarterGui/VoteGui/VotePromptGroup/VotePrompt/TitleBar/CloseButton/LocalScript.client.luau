local TS = game:GetService("TweenService")
local TI = TweenInfo

local plr = game.Players.LocalPlayer

-- // UI variables


local Frame = script.Parent
local Button = Frame.TextButton

local MainUI = plr.PlayerGui.MainUI
local UI_MenuGroup = MainUI.MenuGroup

local CLOSED_POS=UDim2.fromScale(-.7, .177)
local OPEN_POS=UDim2.fromScale(.2, .177)

Button.Activated:Connect(function()
	TS:Create(UI_MenuGroup.RobuxShopFrame, TI.new(1,Enum.EasingStyle.Exponential), {Position = CLOSED_POS}):Play()
end)