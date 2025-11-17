--!strict

-- Services
local RepStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local TS = game:GetService("TweenService")
local TI = TweenInfo

-- Modules
local GetProducts = require(game:GetService("ReplicatedStorage"):WaitForChild("GetProducts"))

-- Instances
local plr = game.Players.LocalPlayer

local Container = script.Parent
local TitleBar = Container.TitleBar
local GamepassNotification = script.Parent.GamepassNotification
local GamepassTitle = GamepassNotification.Title
local GamepassImage = GamepassNotification.PassIcon
local PurchaseButton = GamepassNotification.PurchaseButton
local CloseButton = TitleBar.CloseButton.TextButton

local function rejoin()
	game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
end

local function convertGamepasses(dict: { [string]: number }) --> Used to convert the gamepasses dictionary to a table of tables that looks like {name, id}
	local result = {}

	for name, id in pairs(dict) do
		table.insert(result, { name = name, id = id })
	end

	return result
end

local Passes = convertGamepasses(GetProducts.Gamepasses)

local function displayRandomGamepass() 
	print(`displayRandomGamepass() :: Displaying a random gamepass for {plr}`)
	local randomGamepass = Passes[math.random(1, #Passes)]

	if MarketplaceService:UserOwnsGamePassAsync(plr.UserId, randomGamepass.id) == false then
		local success, productInfo = pcall(function()
			return MarketplaceService:GetProductInfo(randomGamepass.id, Enum.InfoType.GamePass)
		end)

		if not success then
			warn(
				`RandomGamepassHandler :: Failed to GetProductInfo for id: {randomGamepass.id}. Result: "{productInfo}"`
			)
			return
		end

		TS:Create(Container, TI.new(1, Enum.EasingStyle.Exponential), { Position = UDim2.fromScale(0.03, 0.785) })
			:Play()

		GamepassTitle.Text = productInfo.Name
		GamepassImage.Image = "rbxassetid://" .. productInfo.IconImageAssetId

		PurchaseButton.TextButton.Text = ` <b>{productInfo.PriceInRobux}</b>`

		local Connection = PurchaseButton.TextButton.Activated:Connect(function()
			MarketplaceService:PromptGamePassPurchase(plr, randomGamepass.id)
			MarketplaceService.PromptGamePassPurchaseFinished:Once(function(player, assetId, isPurchased)
				if player == plr and assetId == randomGamepass.id and isPurchased == true then
					PurchaseButton.TextButton.Interactable = false
					PurchaseButton.TextButton.Text = `Purchased! Rejoining...`
					rejoin()
				end
			end)
		end)

		CloseButton.Activated:Wait()
		Connection:Disconnect()
		TS:Create(Container, TI.new(1, Enum.EasingStyle.Exponential), { Position = UDim2.fromScale(0.03, 1.3) }):Play()
	end
end

while true do
	task.wait(math.random(60, 120))
	displayRandomGamepass()
end
