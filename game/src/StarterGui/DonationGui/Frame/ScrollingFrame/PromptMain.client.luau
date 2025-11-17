local DonationProducts = require(game:GetService("ReplicatedStorage"):WaitForChild("Leaderboards"):WaitForChild("DonationProducts"))
local buttonTemplate = script.Parent:WaitForChild("ButtonTemplate")

local robuxSymbol = utf8.char(0xE002)

local function addCommas(num: number)
	return tostring(math.floor(num)):reverse():gsub("(%d%d%d)", "%1,"):gsub(",(%-?)$", "%1"):reverse()
end

for productPrice,productID in DonationProducts do
	local buttonClone = buttonTemplate:Clone()
	buttonClone.LayoutOrder = productPrice
	buttonClone.Name = productPrice
	buttonClone.Visible = true
	buttonClone.Text = `Donate {robuxSymbol}{addCommas(productPrice)}`
	buttonClone.Parent = script.Parent
	
	buttonClone.Activated:Connect(function()
		game.MarketplaceService:PromptProductPurchase(game.Players.LocalPlayer, productID)
	end)
end