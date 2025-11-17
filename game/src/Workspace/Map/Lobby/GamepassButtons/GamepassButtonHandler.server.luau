local MarketplaceService = game:GetService("MarketplaceService")

local function rejoin(plr: Player)
	local success, result = pcall(function()
		game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
	end)

	if not success then warn(`GamepassButtonHandler :: Error teleporting player - {result}`) end
end

for _, button: Model in script.Parent:GetChildren() do
	if not button:IsA("Model") then continue end
	local touchPart = button:WaitForChild("TouchPart") :: Part
	local hologramPart = button:WaitForChild("Hologram") :: UnionOperation

	local gamepassValue = button:FindFirstChildOfClass("NumberValue")

	if not touchPart then
		warn(`TouchPart not found for GamepassButton {button}`)
		continue
	end

	if not gamepassValue or gamepassValue.Value == 0 then
		warn(`Gamepass ID not found or 0 for GamepassButton {button}`)
		continue
	end

	local productInfo = MarketplaceService:GetProductInfo(gamepassValue.Value, Enum.InfoType.GamePass)

	hologramPart:FindFirstChildOfClass("BillboardGui"):FindFirstChildOfClass("TextLabel").Text = productInfo.Name

	if button:FindFirstChild("ImagePart") then
		button
			:FindFirstChild("ImagePart")
			:FindFirstChildOfClass("BillboardGui")
			:FindFirstChildOfClass("ImageLabel").Image =`rbxassetid://{productInfo.IconImageAssetId}`
	end

	touchPart.Touched:Connect(function(partThatTouched)
		local player = game.Players:GetPlayerFromCharacter(partThatTouched.Parent)

		if player ~= nil then
			local character = partThatTouched.Parent
			MarketplaceService:PromptGamePassPurchase(player, gamepassValue.Value)
		end
	end)

	MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(plr, gamepassID, wasPurchased)
		if gamepassID == gamepassValue.Value and wasPurchased then rejoin(plr) end
	end)
end
