local Tool = script.Parent
local fireEvent = Tool:WaitForChild("FireEvent")
local laserScript = Tool:WaitForChild("LaserBlast")
local handle = Tool:WaitForChild("Handle")

local ICE_COLOR = BrickColor.new("Toothpaste")
local ICE_EFFECT_TEMPLATE = Instance.new("Smoke")
ICE_EFFECT_TEMPLATE.Color = Color3.new(0, 0.5, 1)
ICE_EFFECT_TEMPLATE.RiseVelocity = 5
ICE_EFFECT_TEMPLATE.Size = 1
ICE_EFFECT_TEMPLATE.Name = "IceFog"


local RELOAD_TIME = 20
local enabled = true

-- Firing logic
local function fire(direction: Vector3)
	local character = Tool.Parent
	local player = game.Players:GetPlayerFromCharacter(character)
	if not player then return end

	-- Spawn projectile
	local missile = Instance.new("Part")
	missile.Name = "Spark"
	missile.Size = Vector3.new(1, 1, 15)
	missile.BrickColor = ICE_COLOR
	missile.Reflectance = 0.5
	missile.Shape = Enum.PartType.Block
	missile.Anchored = false
	missile.CanCollide = false
	missile.TopSurface = Enum.SurfaceType.Smooth
	missile.BottomSurface = Enum.SurfaceType.Smooth

	local spawnPos = character.PrimaryPart.Position + (direction * 15)
	missile.CFrame = CFrame.new(spawnPos, spawnPos + direction)
	missile.Velocity = direction * 100
	missile.RotVelocity = 20 * missile.CFrame:VectorToWorldSpace(Vector3.new(0, 0, 1)).Unit

	-- Add visual effect
	local effect = ICE_EFFECT_TEMPLATE:Clone()
	effect.Parent = missile

	-- Anti-gravity
	local bodyForce = Instance.new("BodyForce")
	bodyForce.Force = Vector3.new(0, 196 * missile:GetMass(), 0)
	bodyForce.Parent = missile

	-- Creator tag for kill credit
	local creatorTag = Instance.new("ObjectValue")
	creatorTag.Name = "creator"
	creatorTag.Value = player
	creatorTag.Parent = missile

	-- Attach blast script
	local blastScript = laserScript:Clone()
	blastScript.Disabled = false
	blastScript.Parent = missile

	-- Parent to workspace (after setup)
	missile.Parent = workspace

	-- Play sound
	local fireSound = handle:FindFirstChild("DrinkSound")
	if fireSound then
		fireSound:Play()
	end
end

-- Weapon orientation
local function gunUp()
	Tool.GripForward = Vector3.new(0, -0.981, 0.196)
	Tool.GripRight = Vector3.new(-1, 0, 0)
	Tool.GripUp = Vector3.new(0, 0.196, 0.981)
end

local function gunOut()
	Tool.GripForward = Vector3.new(0, -1, 0)
	Tool.GripRight = Vector3.new(-1, 0, 0)
	Tool.GripUp = Vector3.new(0, 0, 1)
end

-- Optional turbo logic
local function isTurbo(character: Model): boolean
	return character:FindFirstChild("BoltHelm") ~= nil
end

-- Trigger firing
local function onActivated(targetPos: Vector3)
	if not enabled then return end
	enabled = false

	local character = Tool.Parent
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		warn("Gear: No humanoid found")
		return
	end

	local direction = (targetPos - character.Head.Position).Unit
	
	gunUp()
	fire(direction)
	task.wait(RELOAD_TIME)
	gunOut()
	task.wait(RELOAD_TIME)

	enabled = true
end

-- Equip handler (sound or animation)
local function onEquipped()
	-- Optional: Play equip sound
	-- local equipSound = handle:FindFirstChild("EquipSound")
	-- if equipSound then equipSound:Play() end
end

-- Event connections
fireEvent.OnServerEvent:Connect(function(player, targetPos)
	onActivated(targetPos)
end)

Tool.Equipped:Connect(onEquipped)