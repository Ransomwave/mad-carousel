local Obby = workspace.Map.Lobby.GlassBridgeObby

local function PlayerTouched(Part)
	local Parent = Part.Parent
	if game.Players:GetPlayerFromCharacter(Parent) then
		Parent:MoveTo(Obby.SpawnPart.Position)
	end
end

script.Parent.Touched:Connect(PlayerTouched)