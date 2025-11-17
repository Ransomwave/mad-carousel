-- Modules and Services
local GameModule = require(game:GetService("ReplicatedStorage"):WaitForChild("GameModule"))
local Players = game:GetService("Players")
local Icon = require(game:GetService("ReplicatedStorage"):WaitForChild("Libraries"):WaitForChild("TopbarPlus"):WaitForChild("Icon"))

-- Instances
local plr = Players.LocalPlayer
 
local cashLabel = Icon.new()
	:setLabel(tostring(GameModule.formatNumber(plr:GetAttribute("Cash"))))
	:setImage("rbxassetid://126219767340442")

plr:GetAttributeChangedSignal("Cash"):Connect(function()
	cashLabel:setLabel(tostring(GameModule.formatNumber(plr:GetAttribute("Cash"))))
end)