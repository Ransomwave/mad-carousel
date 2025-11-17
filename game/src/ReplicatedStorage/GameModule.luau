local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TS = game:GetService("TweenService")
local TI = TweenInfo
local gameModule = {}

function gameModule.setWalkspeed(plr: Player, speedvalue)
	plr.Character.Humanoid.WalkSpeed = speedvalue
end

function gameModule.anchorPlayer(plr: Player, value: boolean)
	plr.Character:WaitForChild("HumanoidRootPart").Anchored = value
end

function gameModule.setCameraMode(plr, value: Enum.CameraMode)
	plr.CameraMode = value
end

-- Yields!
function gameModule.SmoothMusicPlay(song: Sound, seconds: number?, vol: number?)
	song = song or error("No Sound specified!")
	vol = vol or song.Volume
	seconds = seconds or 1

	local tween = TS:Create(song, TI.new(seconds, Enum.EasingStyle.Linear), { Volume = vol })
	song.Volume = 0
	song:Play()

	tween:Play()
	tween.Completed:Wait()
end

function gameModule.SmoothMusicStop(song: Sound, seconds: number?)
	seconds = seconds or 1

	local originalVolume = song.Volume

	local tween = TS:Create(song, TI.new(seconds, Enum.EasingStyle.Linear), { Volume = 0 })
	tween:Play()
	tween.Completed:Wait()
	song:Stop()
	song.Volume = originalVolume
end

function gameModule.SmoothMusicVolumeChange(song: Sound, vol: number, seconds: number?)
	vol = vol or error(`"Volume argument needed for SmoothMusicVolumeChange to change the Volume of {song.Name}`)
	seconds = seconds or 1

	local tween = TS:Create(song, TI.new(seconds, Enum.EasingStyle.Linear), { Volume = vol })
	tween:Play()
	tween.Completed:Wait()
end

--Yields
function gameModule.SetBlackScreen(
	plr: Player,
	value: boolean,
	seconds: number,
	style: Enum.EasingStyle?,
	color: Color3?
)
	-- Script moved to StarterGui.uiEventsHandler to allow the client to handle UI
	--print("SetBlackScreen", plr, value, seconds)
	local success, msg = pcall(function()
		ReplicatedStorage.Events.UI.setBlackScreen:InvokeClient(plr, value, seconds, style, color)
	end)

	if not success then warn(msg) end
end

function gameModule.lookAt(
	looker: { HumanoidRootPart: Instance },
	timeittakes: number,
	looked: { Position: { X: number?, Z: number? } }
)
	local TweenService = game:GetService("TweenService")
	timeittakes = timeittakes or 1

	TweenService:Create(
		looker.HumanoidRootPart,
		TweenInfo.new(timeittakes, Enum.EasingStyle.Sine),
		{
			CFrame = CFrame.new(
				looker.HumanoidRootPart.Position,
				Vector3.new(looked.Position.X, looker.HumanoidRootPart.Position.Y, looked.Position.Z)
			),
		}
	):Play()
end

function gameModule.DestroyTools(plr: Player)
	for _, child in pairs(plr.Character:GetChildren()) do
		if child:IsA("Tool") then child:Destroy() end
	end

	for _, child in pairs(plr.Backpack:GetChildren()) do
		if child:IsA("Tool") then child:Destroy() end
	end
end

-- Function to convert RGB to grayscale
function gameModule.SetToGrayscale(model: Model)
	local function rgbToGrayscale(color)
		local luminance = 0.299 * color.r + 0.587 * color.g + 0.114 * color.b
		return Color3.new(luminance, luminance, luminance)
	end

	-- Function to process a descendant and convert its color to grayscale if valid
	local function processDescendant(descendant)
		if descendant:IsA("BasePart") then
			local originalColor = descendant.BrickColor.Color
			if originalColor then
				local grayscaleColor = rgbToGrayscale(originalColor)
				descendant.BrickColor = BrickColor.new(grayscaleColor)
			end
		end

		for _, child in pairs(descendant:GetChildren()) do
			processDescendant(child)
		end
	end

	if model then
		-- Process each descendant of the model
		for _, descendant in pairs(model:GetDescendants()) do
			processDescendant(descendant)
		end
	else
		print("Model not found or not specified.")
	end
end

function gameModule.getCFrameBetweenTwoParts(centerPart: Part, part: Part) -- returned CFrame will be facing centerPart
	local distanceBetweenParts = (centerPart.Position - part.Position).magnitude
	local halfDistance = distanceBetweenParts / 2
	local newCFrame = CFrame.new(part.Position, centerPart.Position) * CFrame.new(0, 0, -halfDistance)
	return newCFrame
end

function gameModule.getDistanceBewteen(part1: Part, part2: Part)
	return (part1.Position - part2.Position).Magnitude
end

function gameModule.TweenModelToCFrame(model: Model, info: TweenInfo, result: CFrame)
	local cframe = Instance.new("CFrameValue")
	do
		cframe.Value = model:GetPivot()
	end

	cframe:GetPropertyChangedSignal("Value"):Connect(function()
		model:PivotTo(cframe.Value)
	end)

	local tween = TS:Create(cframe, info, { Value = result })
	tween:Play()
	tween.Completed:Connect(function()
		cframe:Destroy()
	end)

	-- Example:
	-- TweenModelToCFrame(workspace.Model, TweenInfo.new(10), workspace.Model:GetPivot() + Vector3.new(50, 0, 0))
end

function gameModule.Preload(arrayToPreload: { any })
	--Example of valid arrayToPreload:
	-- YOU CAN ONLY USE IT ON A LOCALSCRIPT
	--local assets = {
	--	"rbxassetid://1234",
	--	"rbxassetid://5678",
	--}

	local ContentProvider = game:GetService("ContentProvider")

	local function checkFailed(contentId, Status)
		if Status == Enum.AssetFetchStatus.Failure then print("Failed to load: " .. contentId) end
	end

	ContentProvider:PreloadAsync(arrayToPreload, checkFailed)
end

function gameModule.formatNumber(n: number)
	if typeof(n) ~= "number" then return n end
	n = tostring(n)
	return n:reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

return gameModule
