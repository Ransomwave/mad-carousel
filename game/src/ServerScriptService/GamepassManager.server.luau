-- Modules & Services
local ServerStorage = game:GetService("ServerStorage")
local GetProducts = require(game:GetService("ReplicatedStorage").GetProducts)

-- Instances
local VFXFolder = ServerStorage.VFX

local function ifGamepass(plr: Player, attributeName: string, gamepassId: number)
	if game:GetService("MarketplaceService"):UserOwnsGamePassAsync(plr.UserId,gamepassId) then
		plr:SetAttribute(attributeName, true)
	else
		plr:SetAttribute(attributeName, false)
	end
end

local function handleWalkspeed(plr: Player)
	if plr:GetAttribute("WalkspeedBoost")==true then
		if plr.Character then
			plr.Character:WaitForChild("Humanoid").WalkSpeed = 32
			task.spawn(function()
				for _, v in VFXFolder.SpeedPassFX:GetChildren() do
					v:Clone().Parent = plr.Character:WaitForChild("HumanoidRootPart")
				end
				task.wait(0.1)
				plr.Character.HumanoidRootPart:WaitForChild("SpeedTrail1").Attachment0 = plr.Character.HumanoidRootPart:WaitForChild("T1")
				plr.Character.HumanoidRootPart:WaitForChild("SpeedTrail1").Attachment1 = plr.Character.HumanoidRootPart:WaitForChild("T2")
				plr.Character.HumanoidRootPart:WaitForChild("SpeedTrail2").Attachment0 = plr.Character.HumanoidRootPart:WaitForChild("TT1")
				plr.Character.HumanoidRootPart:WaitForChild("SpeedTrail2").Attachment1 = plr.Character.HumanoidRootPart:WaitForChild("TT2")
			end)
		end

		plr.CharacterAdded:Connect(function(character)
			character:WaitForChild("Humanoid").WalkSpeed = 32
			task.spawn(function()
				for _, v in VFXFolder.SpeedPassFX:GetChildren() do
					v:Clone().Parent = plr.Character:WaitForChild("HumanoidRootPart")
				end
				task.wait(0.1)
				plr.Character.HumanoidRootPart:WaitForChild("SpeedTrail1").Attachment0 = plr.Character.HumanoidRootPart:WaitForChild("T1")
				plr.Character.HumanoidRootPart:WaitForChild("SpeedTrail1").Attachment1 = plr.Character.HumanoidRootPart:WaitForChild("T2")
				plr.Character.HumanoidRootPart:WaitForChild("SpeedTrail2").Attachment0 = plr.Character.HumanoidRootPart:WaitForChild("TT1")
				plr.Character.HumanoidRootPart:WaitForChild("SpeedTrail2").Attachment1 = plr.Character.HumanoidRootPart:WaitForChild("TT2")
			end)
		end)
	end
end

game.Players.PlayerAdded:Connect(function(plr)
	ifGamepass(plr, "WalkspeedBoost", GetProducts.Gamepasses.WalkspeedBoost)
	handleWalkspeed(plr)
	
	ifGamepass(plr, "DoubleCash", GetProducts.Gamepasses.DoubleCash)
	ifGamepass(plr, "DoubleVotes", GetProducts.Gamepasses.DoubleVotes)
end)