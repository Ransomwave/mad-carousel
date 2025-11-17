local TS = game:GetService("TweenService")
local TI = TweenInfo

local plr = game.Players.LocalPlayer

local Frame = script.Parent
local Button = Frame.TextButton

Button.Activated:Connect(function()
	TS:Create(script.Parent.Parent.Parent, TI.new(1,Enum.EasingStyle.Exponential), {Position = UDim2.fromScale(-.9, .223)}):Play()
end)