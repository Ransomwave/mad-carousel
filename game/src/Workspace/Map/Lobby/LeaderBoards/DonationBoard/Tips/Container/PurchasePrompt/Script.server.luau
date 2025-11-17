local MarketplaceService = game:GetService("MarketplaceService")

local function PurchaseFinished(plr, id, purchased)
	-- Print all the details of the prompt, for example:
	-- PromptGamePassPurchaseFinished PlayerName 123456 false
	if purchased == true then
		if id == 1360751656 then
			script.Parent.Parent.Parent.PurchaseSound:Play()
			for i,v in game.Players:GetChildren() do v.PlayerGui.ActionMsgGui.trigger:Fire("Thank you for tipping 15 robux! :)", "nosound") end
			script.Parent.Parent.Parent.Lid.TriggerConfetti:Fire(1)
		end
	end
	print("PromptGamePassPurchaseFinished", id, purchased)
end

script.Parent.Triggered:Connect(function(plr)
	MarketplaceService:PromptProductPurchase(plr, 1360751656)
	MarketplaceService.PromptProductPurchaseFinished:Connect(PurchaseFinished)
end)