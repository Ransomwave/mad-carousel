local DataStoreService = game:GetService("DataStoreService")

local DataStore = DataStoreService:GetOrderedDataStore("Wins")

game.Players.PlayerAdded:Connect(function(player)
	--local Value = Instance.new("NumberValue")
	--Value.Parent = player
	--Value.Name = "TimesRolled"
	--Value.Value = 0
	
	player:SetAttribute("Wins",0)
	
	local data 
	local success, errormassage = pcall(function()
		data = DataStore:GetAsync(player.UserId)
	end)
	
	if success then
		--print("GotAsync")
		if data ~= nil then
			--Value.Value = data
			player:SetAttribute("Wins",data)
		end
	end
end)

game.Players.PlayerRemoving:Connect(function(Player)
	local success, errormassage = pcall(function()
		DataStore:SetAsync(Player.UserId, Player:GetAttribute("Wins"))
	end)
	
	if success then
		print("Success Saving WinsBoard.")
	else
		warn(errormassage)
	end
end)