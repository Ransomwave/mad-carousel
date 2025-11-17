-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BadgeService = game:GetService("BadgeService")
local Players = game:GetService("Players")
local TS = game:GetService("TweenService")
local TI = TweenInfo

-- Modules
local Zone = require(game:GetService("ReplicatedStorage").Zone)

-- Instances
local ObbyArea = script.Parent.Parent.Parent.Parent
local Part = script.Parent -- InteractPart

local zone1 = Zone.new(Part)

-- Functions
local function giveCash(plr: Player, amount: number)
	amount = amount or (error("No cash amount specified!") and 0)

	plr:SetAttribute("Cash", plr:GetAttribute("Cash") + amount)
	ReplicatedStorage.Events.UI.SendNotification:FireClient(
		plr,
		"Cash Reward",
		`You earnt {amount} cash.`,
		5,
		"rbxassetid://8150337440",
		workspace.Sounds.UI.Cash
	)
end

Players.PlayerAdded:Connect(function(plr)
	if typeof(plr:GetAttribute("ObbyCooldown")) == "number" then
		if plr:GetAttribute("ObbyCooldown") <= os.time() then plr:SetAttribute("ObbyCooldown", false) end
	end
end)

script.Parent.cooldownTimerEnded.OnServerEvent:Connect(function(plr)
	if plr:GetAttribute("ObbyCooldown") <= os.time() then plr:SetAttribute("ObbyCooldown", false) end
end)

zone1.playerEntered:Connect(function(player: Player)
	if typeof(player:GetAttribute("ObbyCooldown")) == "number" then
		print(`Player {player} was in cooldown!`)
		return
	end

	giveCash(player, 75)
	BadgeService:AwardBadge(player.UserId, 3665545254062090)

	player:SetAttribute("ObbyCooldown", os.time() + (game["Run Service"]:IsStudio() and 20 or 600))

	player.Character:MoveTo(ObbyArea.SpawnPart.Position)
end)
