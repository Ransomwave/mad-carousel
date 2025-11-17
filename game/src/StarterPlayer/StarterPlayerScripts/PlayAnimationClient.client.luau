local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Create a Animation
local pushR6 = Instance.new("Animation")
local pushR15 = Instance.new("Animation")
pushR6.AnimationId = "rbxassetid://86523162159454"
pushR15.AnimationId = "rbxassetid://79278594075645"

ReplicatedStorage:WaitForChild("Events"):WaitForChild("Animations"):WaitForChild("PlayPushAnimation").OnClientEvent:Connect(function()
	print("PlayPushAnimation")
	local plr = game.Players.LocalPlayer
	local character = plr.Character

	-- Ensure that the character's humanoid contains an "Animator" object
	local humanoid: Humanoid = character:WaitForChild("Humanoid")
	local animator: Animator = humanoid:WaitForChild("Animator")

	-- Load animations
	local pushR6track = animator:LoadAnimation(pushR6)
	pushR6track.Priority = Enum.AnimationPriority.Action
	
	local pushR15track = animator:LoadAnimation(pushR15)
	pushR15track.Priority = Enum.AnimationPriority.Action

	if humanoid.RigType == Enum.HumanoidRigType.R6 then
		pushR6track:Play(.1, 1, 2)
	else
		pushR15track:Play(.1, 1, 2)
	end
end)
