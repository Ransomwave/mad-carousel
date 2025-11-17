--!strict
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Products = require(ReplicatedStorage.GetProducts)

local COOLDOWN = 2
local MAX_DISTANCE = 5
local PUSH_FORCE = 45

game.Players.PlayerAdded:Connect(function(plr)
	plr:SetAttribute("CanPush", true)

	local success, err = pcall(function()
		if MarketplaceService:UserOwnsGamePassAsync(plr.UserId, Products.Gamepasses.UltraPush) then
			plr:SetAttribute("CanUltraPush", true)
			PUSH_FORCE = 65
		else
			plr:SetAttribute("CanUltraPush", false)
		end
	end)
	if not success then
		warn(err)
		plr:SetAttribute("CanUltraPush", false)
	end
end)

MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(plr, gamepassId, wasPurchased)
	if gamepassId == Products.Gamepasses.UltraPush and wasPurchased then
		plr:SetAttribute("CanUltraPush", true)
		PUSH_FORCE = 45
	else
		plr:SetAttribute("CanUltraPush", false)
	end
end)

local function getClosestPlayer(player)
	local character = player.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end

	local rootPart = character.HumanoidRootPart
	local closestPlayer = nil
	local closestDistance = MAX_DISTANCE

	for _, otherPlayer in pairs(Players:GetPlayers()) do
		if
			otherPlayer ~= player
			and otherPlayer.Character
			and otherPlayer.Character:FindFirstChild("HumanoidRootPart")
		then
			local otherRootPart = otherPlayer.Character.HumanoidRootPart
			local distance = (rootPart.Position - otherRootPart.Position).Magnitude
			if distance < closestDistance then
				closestDistance = distance
				closestPlayer = otherPlayer
			end
		end
	end

	return closestPlayer
end

ReplicatedStorage:WaitForChild("Push").PushEvent.OnServerEvent:Connect(function(player)
	--print("OnServerEvent Push")
	if not player:GetAttribute("CanPush") or player:GetAttribute("LockPush") then return end
	
	--print(`{player} CanPush is true`)
	local targetPlayer = getClosestPlayer(player)

	if targetPlayer and targetPlayer.Character then
		ReplicatedStorage.Events.Animations.PlayPushAnimation:FireClient(player)
		
		--print(`targetPlayer: {targetPlayer}`)
		local targetRootPart: Part = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
		if targetRootPart then
			--print(`targetRootPart: {targetRootPart}`)
			player:SetAttribute("CanPush", false)
			targetRootPart:SetNetworkOwner(nil)

			local Humanoid: Humanoid = targetPlayer.Character:FindFirstChild("Humanoid")
			task.spawn(function()
				Humanoid.PlatformStand = true
				task.wait(0.5)
				Humanoid.PlatformStand = false
			end)
			--Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)

			-- Apply push force
			local direction = (targetRootPart.Position - player.Character.HumanoidRootPart.Position).Unit
			targetRootPart.AssemblyLinearVelocity = direction * PUSH_FORCE

			-- Restore network ownership
			if Players:GetPlayerFromCharacter(targetPlayer.Character) == targetPlayer then
				targetRootPart:SetNetworkOwner(targetPlayer)
			else
				warn(`Could not restore network owner of targetPlayer "{targetPlayer}"`)
			end

			-- Play push sound
			local pushSounds = ReplicatedStorage:WaitForChild("Push").PushSounds:GetChildren()
			if pushSounds and #pushSounds > 0 then
				local pushSound = pushSounds[math.random(1, #pushSounds)]:Clone()
				pushSound.Parent = player.Character:WaitForChild("HumanoidRootPart")
				pushSound.PlayOnRemove = true
				task.wait()
				pushSound:Destroy()
			end

			-- Cooldown
			task.wait(COOLDOWN)
			player:SetAttribute("CanPush", true)
		end
	end
end)
