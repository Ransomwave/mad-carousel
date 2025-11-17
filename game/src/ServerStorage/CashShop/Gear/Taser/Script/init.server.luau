local Tool = script.Parent
local Handle = Tool:WaitForChild("Handle")
local Debris = game:GetService("Debris")

-- Configuration
local POWER_TIME = 3              -- How long taser stays active
local COOLDOWN_TIME = 20          -- Time between activations
local MAX_TASES_PER_USE = 1       -- Max targets tased per activation

-- State
local powered = false
local lastFiredTime = 0
local taseCount = 0

local storeWeld = Tool:WaitForChild("ElectricWeld")

if not storeWeld then
	Handle:FindFirstChild("Sound"):Stop()
end

local initialC0 = storeWeld.C0

-- Effects: visual zap flicker
local function startVisualEffect()
	local count = 0
	local pain = Tool:FindFirstChild("Pain")

	task.spawn(function()
		while powered do
			count += 1
			if storeWeld and count % 2 == 0 then
				storeWeld.C0 = initialC0 * CFrame.Angles(0, 0, math.random() / 3)
			end
			if pain then
				pain.Transparency = count % 2
			end
			task.wait(0.1)
		end

		-- Reset state
		if storeWeld then storeWeld.C0 = initialC0 end
		if pain then pain.Transparency = 1 end

		local sound = Handle:FindFirstChild("Sound")
		if sound then sound:Stop() end
	end)
end

-- Activation
Tool.Activated:Connect(function()
	local now = os.clock()
	if now - lastFiredTime < COOLDOWN_TIME then
		print("Taser is on cooldown.")
		return
	end

	local character = Tool.Parent
	local userHumanoid = character:FindFirstChild("Humanoid")
	if not userHumanoid or userHumanoid.Health <= 0 or powered then return end

	Tool.Enabled = false
	powered = true
	taseCount = 0
	lastFiredTime = now

	local sound = Handle:FindFirstChild("Sound")
	if sound then sound:Play() end

	startVisualEffect()

	task.wait(POWER_TIME)
	powered = false
	Tool.Enabled = true
end)

-- Tase Target
Handle.Touched:Connect(function(hit)
	if not powered or not hit or taseCount >= MAX_TASES_PER_USE then return end

	local character = Tool.Parent
	local ownerHumanoid = character:FindFirstChildOfClass("Humanoid")
	if not ownerHumanoid then return end

	local target = hit.Parent
	local targetHumanoid = target and target:FindFirstChildOfClass("Humanoid")
	if not targetHumanoid or targetHumanoid == ownerHumanoid then return end
	if ownerHumanoid.Health <= 0 or targetHumanoid.Health <= 0 then return end

	-- Prevent multiple tases on same person
	if target:FindFirstChild("GetTasedBro") then return end

	local taseScript = script:FindFirstChild("GetTasedBro")
	if taseScript then
		local clone = taseScript:Clone()
		clone.Disabled = false
		clone.Parent = target
		taseCount += 1
		print(`Tased {target.Name} ({taseCount}/{MAX_TASES_PER_USE})`)
	end
end)

-- Tool equip behavior
Tool.Equipped:Connect(function()
	powered = false
	local pain = Tool:FindFirstChild("Pain")
	if pain then pain.Transparency = 1 end
	if storeWeld then storeWeld.Parent = Tool end
end)

-- Tool unequip
Tool.Unequipped:Connect(function()
	powered = false
end)