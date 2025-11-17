-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BadgeService = game:GetService("BadgeService")
local Players = game:GetService("Players")
local TS = game:GetService("TweenService")
local TI = TweenInfo

-- Modules
local Zone = require(game:GetService("ReplicatedStorage").Zone)

-- Instances
local Part = script.Parent --> InteractPart

local zone1 = Zone.new(Part)

zone1.playerEntered:Connect(function(player: Player)
	local Invite = script.Invite:Clone()
	Invite.Parent = player.PlayerGui
	Invite.Enabled = true
end)
