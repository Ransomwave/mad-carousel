local RunService = game:GetService("RunService")

RunService.Heartbeat:Connect(function(deltaTime)
	script.Parent.CFrame = script.Parent.CFrame * CFrame.fromEulerAnglesXYZ(0,0.7 * deltaTime,0)
end)