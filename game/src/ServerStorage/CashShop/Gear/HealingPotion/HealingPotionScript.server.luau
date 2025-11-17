local Tool = script.Parent
local HealAmount = 35             -- How much health to restore
local CooldownTime = 30           -- Cooldown duration in seconds

-- State
local lastUsed = 0
local isDrinking = false

-- Optional sound or animation
local drinkSound = Tool:FindFirstChild("DrinkSound")
local handle = Tool:FindFirstChild("Handle")

-- Heal logic
local function healPlayer(character)
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid and humanoid.Health > 0 then
		humanoid.Health = math.min(humanoid.MaxHealth, humanoid.Health + HealAmount)
	end
end

-- Drink/activate tool
Tool.Activated:Connect(function()
	if isDrinking or not Tool.Enabled then 
		return 
	end

	local now = os.clock()
	if now - lastUsed < CooldownTime then
		return
	end

	local character = Tool.Parent
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then return end

	isDrinking = true
	Tool.Enabled = false
	lastUsed = now
	
	Tool.GripForward = Vector3.new(0,-.759,-.651)
	Tool.GripPos = Vector3.new(1.5,-.5,.3)
	Tool.GripRight = Vector3.new(1,0,0)
	Tool.GripUp = Vector3.new(0,.651,-.759)

	if drinkSound then
		drinkSound:Play()
	end

	-- Simulate a short delay for drinking
	task.wait(3)

	-- Heal the player
	healPlayer(character)
	
	Tool.GripForward = Vector3.new(-.976,0,-0.217)
	Tool.GripPos = Vector3.new(0.03,0,0)
	Tool.GripRight = Vector3.new(.217,0,-.976)
	Tool.GripUp = Vector3.new(0,1,0)

	isDrinking = false

	-- Cooldown reset
	task.delay(CooldownTime, function()
		if Tool then
			Tool.Enabled = true
		end
	end)
end)

-- Optional reset on unequip
Tool.Unequipped:Connect(function()
	isDrinking = false
end)
