local Defaults = require(game:GetService("ReplicatedStorage").Defaults)
-- Freeze Ray Ball Script (Refactored)

local ball = script.Parent
local DAMAGE = 10
local FREEZE_DURATION = 10
local FREEZE_SPEED = 0
local NORMAL_SPEED = 16
local ICE_COLOR = BrickColor.new("Cyan")
local ICE_SIZE = Vector3.new(5, 7, 5)

-- Create and attach the hit sound once
local hitSound = Instance.new("Sound")
hitSound.Name = "HitSound"
hitSound.SoundId = "rbxassetid://11945266"
hitSound.Volume = 1
hitSound.Parent = ball

-- Util: Tagging the humanoid for kill credit
local function tagHumanoid(humanoid)
	local tag = ball:FindFirstChild("creator")
	if tag then
		local clonedTag = tag:Clone()
		clonedTag.Parent = humanoid
	end
end

local function untagHumanoid(humanoid)
	local tag = humanoid:FindFirstChild("creator")
	if tag then
		tag:Destroy()
	end
end

-- Main logic when the ball touches a target
local function onTouched(hit)
	local character = hit.Parent
	if not character then return end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local hrp = character:FindFirstChild("HumanoidRootPart")

	if humanoid and hrp and not character:FindFirstChild("FreezeRayIceCube") then
		touchConnection:Disconnect()

		tagHumanoid(humanoid)
		untagHumanoid(humanoid)

		-- Create ice cube and attach to HRP
		local iceCube = Instance.new("Part")
		iceCube.Name = "FreezeRayIceCube"
		iceCube.Size = ICE_SIZE
		iceCube.CFrame = hrp.CFrame
		iceCube.BrickColor = ICE_COLOR
		iceCube.Transparency = 0.5
		iceCube.Anchored = true
		iceCube.CanCollide = false
		iceCube.TopSurface = Enum.SurfaceType.Smooth
		iceCube.BottomSurface = Enum.SurfaceType.Smooth
		iceCube.Parent = character

		local weld = Instance.new("Weld")
		weld.Part0 = iceCube
		weld.Part1 = hrp
		weld.C1 = CFrame.new()
		weld.Parent = iceCube

		-- Freeze player
		humanoid.WalkSpeed = FREEZE_SPEED

		-- Mark frozen with a tag
		local frostyTag = Instance.new("BoolValue")
		frostyTag.Name = "FrostyValue"
		frostyTag.Value = true
		frostyTag.Parent = character

		hitSound:Play()
		ball:Destroy()

		-- Cleanup after duration
		task.delay(FREEZE_DURATION, function()
			if humanoid and humanoid.Parent then
				humanoid.WalkSpeed = Defaults.Player.WalkSpeed
			end
			iceCube:Destroy()
			frostyTag:Destroy()
		end)
	else
		hitSound:Play()
		ball:Destroy()
	end
end

-- Connect touch event
touchConnection = ball.Touched:Connect(onTouched)

-- Optional: auto-expire the ball if it hasn't hit anything after 4 seconds
task.delay(4, function()
	if ball and ball.Parent then
		ball:Destroy()
	end
end)