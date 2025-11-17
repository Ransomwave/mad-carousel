local tool = script.Parent
local cooldownTime = 25
local lastActivatedTime = 0
local mouseRef

-- Update the mouse icon based on tool state
local function updateIcon()
	if mouseRef then
		mouseRef.Icon = tool.Enabled
			and "rbxasset://textures/GunCursor.png"
			or "rbxasset://textures/GunWaitCursor.png"
	end
end

-- Handle tool being equipped and store the mouse
local function onEquipped(mouse)
	mouseRef = mouse
	updateIcon()
end

-- Handle tool use and apply cooldown
local function onActivated()
	local now = os.clock()
	if now - lastActivatedTime < cooldownTime then
		return -- still cooling down
	end

	lastActivatedTime = now
	tool.Enabled = false
	updateIcon()

	-- Your actual action (firing, zapping, etc.) would go here

	-- Cooldown timer
	task.delay(cooldownTime, function()
		if tool then
			tool.Enabled = true
			updateIcon()
		end
	end)
end

-- Connections
tool.Equipped:Connect(onEquipped)
tool.Changed:Connect(updateIcon)
tool.Activated:Connect(onActivated)