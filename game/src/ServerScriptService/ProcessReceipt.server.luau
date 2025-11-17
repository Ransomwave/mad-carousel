local Teams = game:GetService("Teams")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local GetProducts = require(game:GetService("ReplicatedStorage").GetProducts)
local DonationProducts = require(game:GetService("ReplicatedStorage"):WaitForChild("Leaderboards").DonationProducts)

local Tent = workspace:WaitForChild("Map").Tent
local Spawns = Tent.SpawnParts

local productFunctions = {}

-- Example: product ID 456456 awards 100 gold coins to the user
productFunctions[GetProducts.DevProducts.Revive] = function(receipt, plr:Player)
	plr:LoadCharacter()
	plr.Team = Teams.Playing
	plr.Character:MoveTo(Spawns[`Spawn1`].Position)
end

productFunctions[GetProducts.DevProducts.Buy50] = function(receipt, plr:Player)
	plr:SetAttribute("Cash", plr:GetAttribute("Cash")+50)
end
productFunctions[GetProducts.DevProducts.Buy500] = function(receipt, plr:Player)
	plr:SetAttribute("Cash", plr:GetAttribute("Cash")+500)
end

-- Set up donation handlers
for donationValue, productId in pairs(DonationProducts) do
	productFunctions[productId] = function(receipt, player)
		local donation = player:GetAttribute("DonationValue")

		--donation.Value = donation.Value + donationValue
		player:SetAttribute("DonationValue", donation+donationValue)
		return true
	end
end

--productFunctions[000] = function(receipt, player)
--	local leaderstats = player:FindFirstChild("leaderstats")
--	local gold = leaderstats and leaderstats:FindFirstChild("Gold")

--	if gold then
--		gold.Value += 100
--		return true
--	end
--end

local function processReceipt(receiptInfo)
	local userId = receiptInfo.PlayerId
	local productId = receiptInfo.ProductId

	local plr = Players:GetPlayerByUserId(userId)
	if plr then
		-- Gets the handler function associated with the developer product ID and attempts to run it
		local handler = productFunctions[productId]
		local success, result = pcall(handler, receiptInfo, plr)
		if success then
			-- The user has received their items
			-- Returns "PurchaseGranted" to confirm the transaction
			return Enum.ProductPurchaseDecision.PurchaseGranted
		else
			warn("Failed to process receipt:", receiptInfo, result)
		end
	end

	-- The user's items couldn't be awarded
	-- Returns "NotProcessedYet" and tries again next time the user joins the experience
	return Enum.ProductPurchaseDecision.NotProcessedYet
end

-- Sets the callback
-- This can only be done once by one server-side script
MarketplaceService.ProcessReceipt = processReceipt