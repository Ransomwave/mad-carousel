local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ZoneModule = require(ReplicatedStorage.Zone)
-- This script handles the "PlayersInside" value under all rooms

for _, Room: Model in script.Parent:GetChildren() do
	if not Room:IsA("Model") then continue end

	local PlayersInside: NumberValue = Room:WaitForChild("PlayersInside")
	local Zone = ZoneModule.new(Room.ZonePart)
	
	local counterFolder: Folder = Room:WaitForChild("Outside").Counter
	local guiPart: Part = counterFolder:WaitForChild("GuiPart")
	local counterGui = guiPart:FindFirstChildOfClass("SurfaceGui")
	local counterText = counterGui:FindFirstChildOfClass("TextLabel")

	Zone.playerEntered:Connect(function(plr: Player)
		counterText.Text = `{#Zone:getPlayers()}/{workspace:GetAttribute("PlayerGroupSize")}`
		PlayersInside.Value = #Zone:getPlayers()
		
		print(#Zone:getPlayers(), Zone:getPlayers())

		plr:SetAttribute("InsideRoom", true)
		print("playerEntered", PlayersInside.Value, plr:GetAttribute("InsideRoom"))
	end)

	Zone.playerExited:Connect(function(plr: Player)
		counterText.Text = `{#Zone:getPlayers()}/{workspace:GetAttribute("PlayerGroupSize")}`
		PlayersInside.Value = #Zone:getPlayers()
		
		print(#Zone:getPlayers(), Zone:getPlayers())

		plr:SetAttribute("InsideRoom", false)
		print("playerEntered", PlayersInside.Value, plr:GetAttribute("InsideRoom"))
	end)
	
	workspace:GetAttributeChangedSignal("PlayerGroupSize"):Connect(function()
		counterText.Text = `{#Zone:getPlayers()}/{workspace:GetAttribute("PlayerGroupSize")}`
		PlayersInside.Value = #Zone:getPlayers()
	end)

	local getPlayersInZone: BindableFunction = Room.getPlayersInZone

	getPlayersInZone.OnInvoke = function()
		return Zone:getPlayers()
	end
end
