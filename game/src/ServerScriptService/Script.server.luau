--!strict

local Players = game:GetService("Players")

function onPlayerAdded(plr)

	local savedTools = {}

	local function onCharacterAdded(Character)

		for _, Tool in pairs(savedTools) do --Loads all the saved tools from the player's last death
			Tool.Parent = plr.Backpack
		end

		--savedTools = {}
		table.clear(savedTools)

		local function onDied() --Copies all your tools when you die and saves them to a table attached to the player
			for _, Tool in pairs(plr.Backpack:GetChildren()) do
				local CopiedTool = Tool:Clone()
				table.insert(savedTools, CopiedTool)
			end

			for _, Tool in pairs(plr.Character:GetChildren()) do --Checks if theres a tool being currently used/equipped by the player
				if Tool:IsA("Tool") then
					local CopiedTool = Tool:Clone()
					table.insert(savedTools, CopiedTool)
				end
			end
		end

		Character.Humanoid.Died:Connect(onDied)

	end

	plr.CharacterAdded:Connect(onCharacterAdded)

end

for _, plr in pairs(Players:GetChildren()) do --Redundency incase a player has joined before the event sets up
	onPlayerAdded(plr)
end

Players.PlayerAdded:Connect(onPlayerAdded)