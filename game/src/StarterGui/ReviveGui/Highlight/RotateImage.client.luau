local RunService = game:GetService("RunService")
local Image = script.Parent


local INCREMENT = 10

RunService.PostSimulation:Connect(function(delta)
	Image.Rotation += INCREMENT*delta
end)