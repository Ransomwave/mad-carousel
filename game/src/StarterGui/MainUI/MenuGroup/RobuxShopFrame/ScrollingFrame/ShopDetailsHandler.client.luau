--!strict

local plr = game.Players.LocalPlayer
local MarketplaceService = game:GetService("MarketplaceService")
local RepStorage = game.ReplicatedStorage

local function Rejoin()
	game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
end

for _,Frame in script.Parent:GetDescendants() do
	if not Frame:IsA("Frame") then continue end
	if not Frame:FindFirstChild("GamepassID") then continue end
	
	local GamepassID = Frame:WaitForChild("GamepassID").Value :: NumberValue
	local ProductInfo = MarketplaceService:GetProductInfo(GamepassID, Enum.InfoType.GamePass)
	
	Frame:WaitForChild("Title").Text = ProductInfo.Name
	Frame:WaitForChild("Desc").Text = ProductInfo.Description
	Frame:WaitForChild("PassIcon").Image = "rbxassetid://" .. ProductInfo.IconImageAssetId
	
	if MarketplaceService:UserOwnsGamePassAsync(plr.UserId,GamepassID)==true then
		Frame:WaitForChild("PurchaseButton").TextButton.BackgroundTransparency = 1
		Frame:WaitForChild("PurchaseButton").TextButton.UIStroke.Enabled = false
		
		Frame:WaitForChild("PurchaseButton").TextButton.Interactable = false
		Frame:WaitForChild("PurchaseButton").TextButton.Text = `<i><font transparency="0.5">Purchased!</font></i>`
	else	
		Frame:WaitForChild("PurchaseButton").TextButton.Text = ` <b>{ProductInfo.PriceInRobux}</b>`
		
		local Connection = Frame:WaitForChild("PurchaseButton").TextButton.Activated:Connect(function()
			
			MarketplaceService:PromptGamePassPurchase(plr,GamepassID)
			MarketplaceService.PromptGamePassPurchaseFinished:Once(function(player, assetId, isPurchased)
				if player == plr and assetId == GamepassID and isPurchased == true then
					Frame:WaitForChild("PurchaseButton").TextButton.Interactable = false
					Frame:WaitForChild("PurchaseButton").TextButton.Text = `Purchased! Rejoining...`
					Rejoin()
				end
			end)
		end)
	end
	task.wait()
end