local DataStoreModule = require(script.Parent.DataStore.DataStoreModule)

local function InventoryToFolder(inv) -- Gets PlayerData.Inventory as Input and outputs "Inventory"
	local container = Instance.new("Folder")
	container.Name = "Inventory"

	--print(inv)
	if inv ~= nil then		
		for _, inventoryItem in inv do
			--print(`{inventoryItem} added to inventory`)
			local stringValue = Instance.new("StringValue")
			stringValue.Name = inventoryItem
			stringValue.Value = inventoryItem
			stringValue.Parent = container
		end
	end	

	return container
end

game.Players.PlayerAdded:Connect(function(plr:Player)
	repeat task.wait() until plr.Character
	
	local PlayerData = DataStoreModule:GetSavedData(plr)
	
	print(PlayerData.Inventory)
	
	-- Inventory
	local InvFolder = InventoryToFolder(PlayerData.Inventory)
	InvFolder.Parent = plr
	--
end)

--Remotes.AddCurrentToInventory.OnServerInvoke = function(plr)
--	local InvFolder = plr:FindFirstChild("Inventory")
--	for _,v in InvFolder:GetChildren() do
--		if v.Value == plr:GetAttribute("Equipped") then
--			print("Already added to inventory!")
--			return false
--		end
--	end
	
--	local NewValue = Instance.new("StringValue")
--	NewValue.Name = `{plr:GetAttribute("Equipped")}`
--	NewValue.Value = plr:GetAttribute("Equipped")
--	NewValue.Parent = InvFolder
--	print(`Created new Value: NewValue: {NewValue}, NewValue.Name: {NewValue.Name}, NewValue.Value: {NewValue.Value}`)
--	return true
--end

--Remotes.RemoveFromInventory.OnServerInvoke = function(plr,valueToRemove)
--	local InvFolder = plr:FindFirstChild("Inventory")
--	if not InvFolder:FindFirstChild(valueToRemove) then
--		warn(`{valueToRemove} could not be found in Inventory!`) 
--		return false
--	end
--	--for _,v in InvFolder:GetChildren() do
--		if v.Value == valueToRemove then
--			v:Destroy()
--			print(`Destroyed Value: {v}, {v.Name}, {v.Value}`)
--			return true
--		end
--	end
--	InvFolder:FindFirstChild(valueToRemove):Destroy()
--	return true
--end