local Players = game:GetService("Players")
local DataStoreModule = require(script.Parent.DataStore.DataStoreModule)

local function setupLeaderboard(plr)
	local playerData = DataStoreModule:GetSavedData(plr)
	
	-- Create Leaderstats folder
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = plr
	
	-- Wins Leaderstat
	local wins = Instance.new("NumberValue")
	wins.Name = "Wins"
	wins.Value = playerData.Wins or 0
	wins.Parent = leaderstats
	plr:GetAttributeChangedSignal("Wins"):Connect(function()
		wins.Value = plr:GetAttribute("Wins")
	end)
	
	local cash = Instance.new("NumberValue")
	cash.Name = "Cash"
	cash.Value = playerData.Cash or 0
	cash.Parent = leaderstats
	plr:GetAttributeChangedSignal("Cash"):Connect(function()
		cash.Value = plr:GetAttribute("Cash")
	end)
end


Players.PlayerAdded:Connect(function(plr:Player)
	while not plr or plr:GetAttribute("DataLoaded")~=true do task.wait() end
	setupLeaderboard(plr)
end)