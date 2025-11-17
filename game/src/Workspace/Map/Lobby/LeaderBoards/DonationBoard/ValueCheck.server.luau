local DataStoreService = game:GetService("DataStoreService")
local DonationDataStore = DataStoreService:GetOrderedDataStore("Donation")

game.Players.PlayerAdded:Connect(function(plr)
	plr:SetAttribute("DonationValue",0)
	
	local data 
	local success, errormassage = pcall(function()
		data = DonationDataStore:GetAsync(plr.UserId)
	end)
	
	if success then
		--print("GotAsync")
		if data ~= nil then
			plr:SetAttribute("DonationValue", data)
			plr:SetAttribute("OriginalDonationValue", data)
		end
	end
end)

game.Players.PlayerRemoving:Connect(function(plr)
	local success, errormassage = pcall(function()
		
		if plr:GetAttribute("DonationValue") > 0 and plr:GetAttribute("DonationValue") ~= plr:GetAttribute("OriginalDonationValue") then
			DonationDataStore:SetAsync(`{plr.UserId}`, plr:GetAttribute("DonationValue"))
			print(`Saved {plr.Name}'s DonationValue ({plr:GetAttribute("DonationValue")}).`)
		else
			if plr:GetAttribute("DonationValue") <= 0 then
				print(`Did not save donations for {plr.Name}: DonationValue ({plr:GetAttribute("DonationValue")}) is 0 or lower.`)
			elseif plr:GetAttribute("DonationValue") == plr:GetAttribute("OriginalDonationValue") then
				print(`Did not save donations for {plr.Name}: DonationValue ({plr:GetAttribute("DonationValue")}) is equal to OriginalDonationValue ({plr:GetAttribute("OriginalDonationValue")}).`)
			else
				print(`Did not save donations for {plr.Name}: Unknown issue.`)
			end
		end
		
	end)
	
	if success then
		print("Success Saving DonationBoard.")
	else
		warn(errormassage)
	end
end)