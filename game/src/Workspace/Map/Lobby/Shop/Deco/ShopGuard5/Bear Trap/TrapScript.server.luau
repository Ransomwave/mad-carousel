local Defaults = require(game:GetService("ReplicatedStorage").Defaults)
local Trap:Part = script.Parent
local Mesh = Trap:WaitForChild("Mesh")
local ChompSound = Trap:FindFirstChild("ChompSound")

-- Configuration
--local TRAP_DAMAGE = 50
local MESH_CLOSED = "rbxassetid://59711981"
local MESH_OPEN = "rbxassetid://59713741"
local CLOSED_SIZE = Vector3.new(2.47, 2.25, 1.21)
local OPEN_SIZE = Vector3.new(2, 3, 0.5)
local POST_TRIGGER_TRANSPARENCY = 0.2
local SLOW_WALK_SPEED = 10
local TRAP_RESET_DELAY = 5

-- Initialization
task.wait(0.5)
Mesh.MeshId = MESH_OPEN
Trap.Size = OPEN_SIZE

task.wait(1.5)
--Trap.Transparency = INITIAL_TRANSPARENCY

-- Debounce flag
local isTriggered = false

local function onTouched(hit)
	if isTriggered then return end

	local humanoid = hit.Parent:FindFirstChildWhichIsA("Humanoid")
	if not humanoid then return end

	isTriggered = true

	-- Trigger trap visuals and effects
	--Trap.Transparency = ACTIVE_TRANSPARENCY
	Mesh.MeshId = MESH_CLOSED
	Trap.Size = CLOSED_SIZE

	if ChompSound then
		ChompSound:Play()
	end

	--humanoid:TakeDamage(TRAP_DAMAGE)
	humanoid.WalkSpeed = SLOW_WALK_SPEED

	task.wait(TRAP_RESET_DELAY)

	-- Reset state
	humanoid.WalkSpeed = Defaults.Player.WalkSpeed
	--Trap.Transparency = INITIAL_TRANSPARENCY
	Mesh.MeshId = MESH_OPEN
	Trap.Size = OPEN_SIZE
	
	task.wait(2)
	Trap:Destroy()
	--isTriggered = false
end

Trap.Touched:Connect(onTouched)

task.wait(10)
if not isTriggered then
	Trap:Destroy()
end