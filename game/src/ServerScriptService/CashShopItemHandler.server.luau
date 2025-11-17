local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local RS = game:GetService("ReplicatedStorage")
local SS = game:GetService("ServerStorage")

local Tools = SS.CashShop:WaitForChild("Gear")
--local ItemModule = require(script:WaitForChild("ItemModule"))
local ToolEvent = RS.Events.CashShop:WaitForChild("EquipTool")


local function start()
	Tools:Clone().Parent = RS.CashShop
end


--Players.PlayerAdded:Connect(function(plr)
--	ItemModule:CreateStats(plr)
--end)


--Players.PlayerRemoving:Connect(function(plr)
--	ItemModule:SaveStats(plr)
--end)


local function savePurchase(folder, toolName)
	local stringVal = Instance.new("StringValue")
	stringVal.Name = toolName

	stringVal.Parent = folder

	return
end


ToolEvent.OnServerEvent:Connect(function(plr:Player, toolName)
	if not toolName then
		warn(`CashShopItemHandler :: toolName not provided! ({toolName})`)	
		return
	end
	
	local foundTool = Tools:FindFirstChild(toolName)
	
	--local cash = plr:WaitForChild("leaderstats"):WaitForChild("Cash")

	if foundTool then
		local Inventory:Folder = plr:WaitForChild("Inventory")

		if not plr.Backpack:FindFirstChild(toolName) and not plr.Character:FindFirstChild(toolName) then
			if not Inventory:FindFirstChild(toolName) then
				if plr:GetAttribute("Cash") >= foundTool.Price.Value then
					plr:SetAttribute("Cash", plr:GetAttribute("Cash")-foundTool.Price.Value)

					savePurchase(Inventory, toolName)
					
					ReplicatedStorage:WaitForChild("Events").UI.PlayClientSound:FireClient(plr, workspace.Sounds.UI.Buy)

					foundTool:Clone().Parent = plr.Backpack
				else
					ReplicatedStorage:WaitForChild("Events").UI.PlayClientSound:FireClient(plr, workspace.Sounds.UI.Error)
				end

			else
				foundTool:Clone().Parent = plr.Backpack
			end
		else
			if plr.Backpack:FindFirstChild(toolName) then
				plr.Backpack[toolName]:Destroy()
			end

			if plr.Character:FindFirstChild(toolName) then
				plr.Character[toolName]:Destroy()
			end
		end
	end
end)

start()