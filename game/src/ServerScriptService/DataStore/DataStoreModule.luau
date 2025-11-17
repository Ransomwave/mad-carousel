local RunService = game:GetService("RunService")
local DatastoreModule = {}

local DataStoreService = game:GetService("DataStoreService")
local PlayerDataStore = DataStoreService:GetDataStore("PlayerData")

-- Cache already loaded player data in memory to reduce datastore calls.
local cachedPlayerData = {}

local function compareDict(d1, d2)
	if type(d1) ~= "table" or type(d2) ~= "table" then
		return d1 == d2  -- Direct comparison for non-table values
	end

	for k, v in pairs(d1) do
		if not compareDict(v, d2[k]) then return false end
	end

	for k, v in pairs(d2) do
		if not compareDict(v, d1[k]) then return false end
	end

	return true
end


function DatastoreModule:SaveData(plr:Player)
	--if not RunService:IsStudio() then print(`DatastoreModule :: {plr} is in studio. Not saving data.`) return end
	
	local playerInventory = {}
	for _,value:ValueBase in pairs(plr:WaitForChild("Inventory"):GetChildren()) do
		if value:IsA("ValueBase") then
			table.insert(playerInventory,value.Name)
		end
	end
	
	-- Load cached data
	local PlayerData =  { 
		Wins = plr:GetAttribute("Wins"),
		Cash = plr:GetAttribute("Cash"),
		Inventory = playerInventory
	}
	
	if compareDict(PlayerData,cachedPlayerData[plr.Name]) then
		print(`DatastoreModule :: {plr.Name}'s data is the same as the cached data. Not saving data.`)
	else
		PlayerDataStore:SetAsync(`{plr.UserId}_PlayerData`,PlayerData)
		print(`DataStoreModule :: Saved data - PlaterData: {PlayerData}`)
		cachedPlayerData[plr.Name] = PlayerData
	end
	
end

function DatastoreModule:GetSavedData(plr:Player)
	if cachedPlayerData[plr.Name] then
		print(`{plr.Name}'s data was found. Returning cached data.`)
		return cachedPlayerData[plr.Name]
	end
	
	local PlayerData = PlayerDataStore:GetAsync(`{plr.UserId}_PlayerData`)	

	if PlayerData == nil then
		print(`{plr} is a first time player. Creating and saving template PlayerData.`)
		local TemplatePlayerData = {
			Wins = 0,
			Cash = 0,
			Inventory = {}
		}
		PlayerDataStore:SetAsync(`{plr.UserId}_PlayerData`,TemplatePlayerData)
		
		cachedPlayerData[plr.Name]=TemplatePlayerData
		return TemplatePlayerData 
	end
	
	print(PlayerData)
	cachedPlayerData[plr.Name]=PlayerData
	
	return PlayerData
end

function DatastoreModule:ClearCache(plr:Player)
	if cachedPlayerData[plr.Name] then
		cachedPlayerData[plr.Name]=nil
		print(`Successfully cleared {plr.Name}'s Cache: {cachedPlayerData[plr.Name]}`)
	end
end


return DatastoreModule
