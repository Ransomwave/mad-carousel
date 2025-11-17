local ReplicatedStorage = game:GetService("ReplicatedStorage")

ReplicatedStorage:WaitForChild("Events"):WaitForChild("UI"):WaitForChild("PlayClientSound").OnClientEvent:Connect(function(soundToPlay:Sound)
	soundToPlay:Play()
end)