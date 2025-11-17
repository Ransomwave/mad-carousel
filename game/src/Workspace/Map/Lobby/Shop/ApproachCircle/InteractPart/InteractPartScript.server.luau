local Players = game:GetService("Players")
local Zone = require(game:GetService("ReplicatedStorage").Zone)
local TS = game:GetService("TweenService")
local TI = TweenInfo

local player = game.Players.LocalPlayer

-- Interact part
local Part = script.Parent

local MainUI = game.Players.LocalPlayer.PlayerGui.MainUI
local UI_MenuGroup = MainUI.MenuGroup

local CLOSED_POS=UDim2.fromScale(.5,-1.5)
local OPEN_POS=UDim2.fromScale(.5,.5)

local zone1 = Zone.new(Part)

zone1.playerEntered:Connect(function(plr)
	--print(`player entered`)
	if plr ~= Players.LocalPlayer then 
		--print(`playerEntered was triggered by {plr}, not by {Players.LocalPlayer}. Ignored.`) 
		return
	end
	
	local State = UI_MenuGroup.ShopFrame.IsOpen
	
	State.Value = true
	TS:Create(UI_MenuGroup.ShopFrame, TweenInfo.new(.5), {Position = OPEN_POS}):Play()
end)


zone1.playerExited:Connect(function(plr)
	--print(`player exited`)
	
	if plr ~= Players.LocalPlayer then
		--print(`playerExited was triggered by {plr}, not by {Players.LocalPlayer}. Ignored.`)
		return
	end
	
	local State = UI_MenuGroup.ShopFrame.IsOpen

	State.Value = false
	TS:Create(UI_MenuGroup.ShopFrame, TI.new(1,Enum.EasingStyle.Exponential), {Position = CLOSED_POS}):Play()
end)
