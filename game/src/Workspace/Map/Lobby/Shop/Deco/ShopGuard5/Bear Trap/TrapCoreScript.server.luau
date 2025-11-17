local Tool = script.Parent
local TrapTemplate = Tool:WaitForChild("Handle")
local TrapScript = Tool:WaitForChild("TrapScript")
local Buzzer = Tool:FindFirstChild("NoTrapsBuzzer")
local NumberOfTraps = Tool:WaitForChild("NumberOfTraps")
local StoreWeld = TrapTemplate:WaitForChild("FireWeld")

local GUI_IMAGE_ID = "rbxassetid://59712249"
local DEFAULT_NUMBER_OF_TRAPS = 3
local TRAP_OFFSET = 2
local RESET_TIME = 2
local RELOAD_TIME = 30

local function createTrap(player, torso)
	-- Clone and position the trap
	local clonedTrap = TrapTemplate:Clone()
	clonedTrap.CanCollide = true
	clonedTrap.Transparency = 0
	clonedTrap.Parent = workspace

	-- Orientation using BodyGyro
	local bodyGyro = Instance.new("BodyGyro")
	bodyGyro.P = 10000
	bodyGyro.MaxTorque = Vector3.new(1, 1, 1) * 10000
	bodyGyro.CFrame = (torso.CFrame + torso.CFrame.LookVector * TRAP_OFFSET) * CFrame.Angles(-math.pi/2, 0, 0)
	bodyGyro.Parent = clonedTrap

	-- Attach trap behavior
	local clonedScript = TrapScript:Clone()
	clonedScript.Enabled = true
	clonedScript.Parent = clonedTrap

	-- Track trap creator
	local creatorTag = Instance.new("ObjectValue")
	creatorTag.Name = "creator"
	creatorTag.Value = player
	creatorTag.Parent = clonedTrap

	return clonedTrap
end

local function createTrapGui(player)
	local playerGui = player:FindFirstChild("PlayerGui")
	if not playerGui then return end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "TrapsGui"
	screenGui.Parent = playerGui

	local frame = Instance.new("Frame")
	frame.Name = "TrapContainer"
	frame.AnchorPoint = Vector2.new(.5,.5)
	frame.Position = UDim2.fromScale(.5,.85)
	frame.Size = UDim2.fromScale(.2,.05)
	frame.BackgroundTransparency = 1
	frame.Parent = screenGui

	local text = Instance.new("TextLabel")
	text.RichText = true
	text.Text = `<b>Traps left: {tostring(NumberOfTraps.Value)}</b>`
	text.Position = UDim2.fromScale(0,0)
	text.Size = UDim2.fromScale(1,1)
	text.BackgroundTransparency = 1
	text.TextColor3 = Color3.fromRGB(255,255,255)
	text.TextStrokeTransparency = 0
	text.TextStrokeColor3 = Color3.fromRGB(0,0,0)
	text.Font = Enum.Font.Montserrat
	text.FontFace.Weight = Enum.FontWeight.Bold
	text.TextScaled = true
	text.Parent = frame

	-- Update trap count dynamically
	NumberOfTraps.Changed:Connect(function()
		text.Text = `<b>Traps left: {tostring(NumberOfTraps.Value)}</b>`
	end)

	return screenGui
end

local function onActivated()
	if not Tool.Enabled then return end
	if NumberOfTraps.Value <= 0 then
		if Buzzer then Buzzer:Play() end
		return
	end

	Tool.Enabled = false
	NumberOfTraps.Value -= 1

	local character = Tool.Parent
	local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
	if not torso then return end

	local player = game.Players:GetPlayerFromCharacter(character)
	if not player then return end

	-- Hide template trap and create actual trap in world
	TrapTemplate.Transparency = 1
	createTrap(player, torso)

	task.wait(RESET_TIME)
	TrapTemplate.Transparency = 0
	Tool.Enabled = true
end

NumberOfTraps.Changed:Connect(function()
	if NumberOfTraps.Value <= 0 then
		Tool.Enabled = false
		task.wait(RELOAD_TIME)
		NumberOfTraps.Value = DEFAULT_NUMBER_OF_TRAPS
		Tool.Enabled = true
	end
end)

local guiRef -- store GUI for removal

local function onEquipped()
	local character = Tool.Parent
	local player = game.Players:GetPlayerFromCharacter(character)
	if not player then return end

	guiRef = createTrapGui(player)

	-- Ensure weld exists
	if not TrapTemplate:FindFirstChild("FireWeld") then
		local weldClone = StoreWeld:Clone()
		weldClone.Parent = TrapTemplate
	end
end

local function onUnequipped()
	TrapTemplate.Transparency = 0
	if guiRef then
		guiRef:Destroy()
		guiRef = nil
	end
end

-- Event connections
Tool.Activated:Connect(onActivated)
Tool.Equipped:Connect(onEquipped)
Tool.Unequipped:Connect(onUnequipped)