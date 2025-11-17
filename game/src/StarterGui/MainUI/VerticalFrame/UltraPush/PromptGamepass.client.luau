local MarketplaceService = game:GetService("MarketplaceService")
local GetProducts = require(game:GetService("ReplicatedStorage"):WaitForChild("GetProducts"))
local plr = game.Players.LocalPlayer

script.Parent.TextButton.Activated:Connect(function()
	MarketplaceService:PromptGamePassPurchase(plr, GetProducts.Gamepasses.UltraPush)
end)

MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(playerWhoPurchased: Player, gamePassId: number, wasPurchased: boolean) 
	if playerWhoPurchased == plr and gamePassId == GetProducts.Gamepasses.UltraPush and wasPurchased then
		workspace.Sounds.UI.Buy:Play()
		script.Parent.TextButton.TextLabel.Text = "Purchased!"
	end
	
end)

while plr:GetAttribute("CanUltraPush") == nil do task.wait() end
if plr:GetAttribute("CanUltraPush") == true then
	script.Parent.Visible = false
	script.Parent.TextButton.UIStroke.RainbowStroke.Enabled = false
end

plr:GetAttributeChangedSignal("CanUltraPush"):Connect(function()
	if plr:GetAttribute("CanUltraPush") == true then
		task.wait(5)
		script.Parent.Visible = false
		script.Parent.TextButton.UIStroke.RainbowStroke.Enabled = false
	end
end)