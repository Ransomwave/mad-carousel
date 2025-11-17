local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

function load()
	local char = script.Parent
	local humdesc = game.Players:GetHumanoidDescriptionFromUserId(script.Parent.UserID.Value)

	char.Humanoid:ApplyDescription(humdesc)
	Players:GetNameFromUserIdAsync(script.Parent.UserID.Value)
	--char.Name = game.Players:GetNameFromUserIdAsync(script.Parent.UserID.Value)
	char.Animate.Disabled = false
	
	if char.Head:FindFirstChild("DonatorText") then char.Head:FindFirstChild("DonatorText"):Destroy() end
	
	-- Apply overhead text
	local overheadText = ReplicatedStorage:WaitForChild("Leaderboards"):WaitForChild("DonatorText"):Clone()
	overheadText:WaitForChild("Frame"):WaitForChild("PlayerName").Text = Players:GetNameFromUserIdAsync(script.Parent.UserID.Value)
	overheadText.Parent = char.Head
end

load()

script.Parent.UserID.Changed:Connect(function()
	load()
end)