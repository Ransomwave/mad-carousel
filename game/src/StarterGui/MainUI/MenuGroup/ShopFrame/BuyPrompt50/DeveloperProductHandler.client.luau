local MarketplaceService = game:GetService("MarketplaceService")
local StarterGui = game:GetService("StarterGui")
local GetProducts = require(game:GetService("ReplicatedStorage"):WaitForChild("GetProducts"))
local plr = game.Players.LocalPlayer

local function onButtonClicked()
	MarketplaceService:PromptProductPurchase(game.Players.LocalPlayer, GetProducts.DevProducts.Buy50) -- buy 50 tokens
end

script.Parent.Activated:Connect(onButtonClicked)