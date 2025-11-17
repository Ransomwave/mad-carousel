-- Services
local TS = game:GetService("TweenService")
local TI = TweenInfo
local RunService = game:GetService("RunService")

-- Instances
local killPart = script.Parent
local sweeperModel = killPart.Parent
local toggleEvent = sweeperModel.Toggle

local rotationSpeed = -10 -- degrees per second

-- Start local spinConnection
local spinConnection: RBXScriptConnection

local function spin()
	spinConnection = RunService.Heartbeat:Connect(function(deltaTime)
		if killPart and killPart.Parent then
			local angle = math.rad(rotationSpeed * deltaTime)
			killPart.CFrame = killPart.CFrame * CFrame.Angles(0, angle, 0)
		end
	end)
end

local currentState = false

toggleEvent.Event:Connect(function(state: boolean)
	if currentState == state then
		warn(
			`Attempted to change state of killPart to {state} (state) but it was already {currentState} (currentState). Returned in order to prevent connection leaks.`
		)
	end

	currentState = state

	if state == true then
		-- Start spinning
		spin()

		-- Make part visible
		TS:Create(script.Parent, TI.new(5, Enum.EasingStyle.Exponential), { Transparency = 0 }):Play()
		
		-- Enable particles
		script.Parent.Particles.Enabled = true

		task.wait(5)

		killPart.TouchHandler.Enabled = true
	else
		TS:Create(script.Parent, TI.new(1, Enum.EasingStyle.Exponential), { Transparency = 1 }):Play()
		
		-- Disable TouchHandler script (so players can't take damage anymore)
		killPart.TouchHandler.Enabled = false
		
		-- Disable particles
		script.Parent.Particles.Enabled = false

		if spinConnection then spinConnection:Disconnect() end
	end
end)
