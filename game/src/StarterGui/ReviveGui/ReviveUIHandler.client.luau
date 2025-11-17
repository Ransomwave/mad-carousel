--!strict
local plr = game.Players.LocalPlayer

local MarketplaceService = game:GetService("MarketplaceService")

local TS = game:GetService("TweenService")
local TI = TweenInfo
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GetProducts = require(ReplicatedStorage:WaitForChild("GetProducts"))

local ReviveGui = script.Parent
local RevivePrompt = ReviveGui.RevivePromptGroup
local ReviveButton = RevivePrompt.ReviveButton
local CancelButton = RevivePrompt.CancelButton

local COOLDOWN_TIME = 12

local function toggleUI(state: boolean)
	if state == true then
		ReviveGui.Highlight.RotateImage.Enabled = true
		TS:Create(RevivePrompt, TI.new(0.5), { GroupTransparency = 0 }):Play()
		TS:Create(ReviveGui.Highlight, TI.new(0.5), { ImageTransparency = 0.5 }):Play()
		TS:Create(RevivePrompt.UIStroke, TI.new(0.5), { Transparency = 0 })
		RevivePrompt.ReviveButton.Interactable = true
		RevivePrompt.CancelButton.Interactable = true
	else
		RevivePrompt.ReviveButton.Interactable = false
		RevivePrompt.CancelButton.Interactable = false
		TS:Create(RevivePrompt, TI.new(0.5), { GroupTransparency = 1 }):Play()
		TS:Create(ReviveGui.Highlight, TI.new(0.5), { ImageTransparency = 1 }):Play()
		TS:Create(RevivePrompt.UIStroke, TI.new(0.5), { Transparency = 1 })
		task.wait(0.5)
		ReviveGui.Highlight.RotateImage.Enabled = false
	end
end

ReplicatedStorage.Events.UI.PromptRevive.OnClientEvent:Connect(function()
	toggleUI(true)

	RevivePrompt.ProgressBar.Size = UDim2.fromScale(1, 0.022)

	TS:Create(RevivePrompt.ProgressBar, TI.new(COOLDOWN_TIME), { Size = UDim2.fromScale(0, 0.022) }):Play()
	--tween_ProgressBar:Play()
	task.wait(COOLDOWN_TIME)
	toggleUI(false)
end)

RevivePrompt.ReviveButton.Activated:Connect(function()
	print("Activated ReviveButton")
	MarketplaceService:PromptProductPurchase(plr, GetProducts.DevProducts.Revive)
end)

RevivePrompt.CancelButton.Activated:Connect(function()
	toggleUI(false)
end)

toggleUI(false)
