local MarketplaceService = game:GetService("MarketplaceService")
local StarterGui = game:GetService("StarterGui")
local GetProducts = require(game:GetService("ReplicatedStorage"):WaitForChild("GetProducts"))
local plr = game.Players.LocalPlayer

local function rejoin()
	game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
end

local function onButtonClicked()
	MarketplaceService:PromptGamePassPurchase(game.Players.LocalPlayer, GetProducts.Gamepasses.DoubleVotes)
end

script.Parent.Activated:Connect(onButtonClicked)

MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(playerWhoPurchased, gamepassId, wasPurchased)
	if playerWhoPurchased == plr and gamepassId == GetProducts.Gamepasses.DoubleVotes and wasPurchased then 
		script.Parent.TextLabel.Text = "✅ Success! Rejoining..."
		rejoin() 
	end 
end)

while plr:GetAttribute("DoubleVotes") == nil do task.wait() end
if plr:GetAttribute("DoubleVotes") == true then
	script.Parent.Visible = false
	script.Parent.UIStroke.RainbowStroke.Enabled = false
end

plr:GetAttributeChangedSignal("DoubleVotes"):Connect(function()
	if plr:GetAttribute("DoubleVotes") == true then
		task.wait(5)
		script.Parent.Visible = false
		script.Parent.UIStroke.RainbowStroke.Enabled = false
	end
end)