local Players = game:GetService("Players")
local DataStoreModule = require(script.Parent.DataStoreModule)

Players.PlayerAdded:Connect(function(plr)
	-- Setup player stats
	local playerData = DataStoreModule:GetSavedData(plr)
	
	plr:SetAttribute("Wins", playerData.Wins)
	plr:SetAttribute("Cash", playerData.Cash)
	plr:SetAttribute("DataLoaded", true)
end)

Players.PlayerRemoving:Connect(function(plr)
	DataStoreModule:SaveData(plr)
	DataStoreModule:ClearCache(plr)
end)