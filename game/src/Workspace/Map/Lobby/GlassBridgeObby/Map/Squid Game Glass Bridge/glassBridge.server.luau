local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local Defaults = require(ReplicatedStorage.Defaults)

local glassFolder = script.Parent:WaitForChild("glass")
local glassSFXFolder = script.Parent:WaitForChild("glassSFX")

-- Customize cooldown time (in seconds)
local GLASS_RESPAWN_TIME = 5

local function playRandomSFX(parent: Instance)
	local sfxList = glassSFXFolder:GetChildren()
	if #sfxList == 0 then return end

	local sfx = sfxList[math.random(1, #sfxList)]:Clone()
	sfx.Parent = parent
	sfx:Play()
	Debris:AddItem(sfx, sfx.TimeLength + 1)
end

local function cloneOriginalGlass(original: Part): Part
	local clone = original:Clone()
	clone.Anchored = true
	clone.CanCollide = true
	clone.Transparency = 0
	clone.Parent = original.Parent
	return clone
end

local function initGlass(glass: Part)
	local originalCFrame = glass.CFrame
	local originalParent = glass.Parent
	local originalClone = glass:Clone()

	local debounced = false

	glass.Touched:Connect(function(hit: BasePart)
		if debounced then return end

		local character = hit:FindFirstAncestorOfClass("Model")
		local player = Players:GetPlayerFromCharacter(character)
		if not player then return end

		local humanoid = character:FindFirstChildOfClass("Humanoid")
		local hrp = character:FindFirstChild("HumanoidRootPart")
		if not humanoid or not hrp then return end

		debounced = true

		humanoid.JumpPower = 0
		hrp.AssemblyLinearVelocity = Vector3.zero

		glass.Anchored = false
		glass.CanCollide = false
		glass:SetNetworkOwner(nil)

		playRandomSFX(glass)

		task.delay(0.5, function()
			glass.Transparency = 1
			humanoid.JumpPower = Defaults.Player.JumpPower
		end)

		task.delay(GLASS_RESPAWN_TIME, function()
			local newGlass = originalClone:Clone()
			newGlass.Anchored = true
			newGlass.CanCollide = true
			newGlass.Transparency = .5
			newGlass.Parent = originalParent
			initGlass(newGlass) -- reattach logic
			glass:Destroy()
		end)
	end)
end

-- Initialize random glass pieces
for _, glassModel in ipairs(glassFolder:GetChildren()) do
	local choices = glassModel:GetChildren()
	if #choices > 0 then
		local selectedGlass = choices[math.random(1, #choices)]
		initGlass(selectedGlass)
	end
end
