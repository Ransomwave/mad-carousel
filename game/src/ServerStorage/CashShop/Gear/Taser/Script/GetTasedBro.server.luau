local character = script.Parent
local humanoid = character:FindFirstChildOfClass("Humanoid")
local rootPart = character:FindFirstChild("HumanoidRootPart")

print(`Tased {character}: {humanoid:GetFullName()}, {rootPart:GetFullName()}`)

local TASE_DURATION = 2

-- Collect all joints from the root part
local joints = {}
if rootPart then
	for _, child in ipairs(rootPart:GetChildren()) do
		if child:IsA("Motor") or child:IsA("Motor6D") or child:IsA("Weld") or child:IsA("ManualWeld") then
			table.insert(joints, child)
		end
	end
end

-- Declare outside for cleanup scope
local clonedEffect

-- Optional visual effect
if humanoid then
	--local trippyEffect = script:FindFirstChild("Trippy")
	--if trippyEffect then
	--	print(`Cloned trippyEffect for {character}`)
	--	clonedEffect = trippyEffect:Clone()
	--	clonedEffect.Parent = humanoid
	--	clonedEffect.Enabled = true
	--end
	
	humanoid.PlatformStand = true
	task.wait(TASE_DURATION)
	humanoid.PlatformStand = false
end

script:Destroy()
