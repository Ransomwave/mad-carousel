--!strict

local RoundModule = {}

-- Services
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local BadgeService = game:GetService("BadgeService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Teams = game:GetService("Teams")
local Players = game:GetService("Players")
local TS = game:GetService("TweenService")
local TI = TweenInfo

-- Modules
local GameModes = require(ReplicatedStorage:WaitForChild("GameModes"))
local GameModule = require(ReplicatedStorage:WaitForChild("GameModule"))

-- Instances
local Map = workspace:WaitForChild("Map")
local Tent = Map:WaitForChild("Tent")
local Lobby = Map:WaitForChild("Lobby")

-- Execute a function for all players in the game
-- The function has the i and v arguments
local function forAllPlayers(func: (index: number, player: Player) -> ())
	for index, player in Players:GetPlayers() do
		local success, result = pcall(function()
			func(index, player)
		end)

		if not success then warn(`forAllPlayers failed: {result}`) end
	end
end

-- Execute a function for all players in specified team
-- The function has the i and v arguments
local function teamForAllPlayers(team: Team, func: (index: number, player: Player) -> ())
	for index, player in team:GetPlayers() do
		local success, result = pcall(function()
			func(index, player)
		end)

		if not success then warn(`teamForAllPlayers {team} failed: {result}`) end
	end
end

-- Tweens the status text to a visible or invisible state
-- Does not yield
local function toggleStatusText(state: boolean)
	if state == true then
		forAllPlayers(function(i, plr)
			TS:Create(
				plr.PlayerGui.GameUI.StatusText,
				TweenInfo.new(0.7, Enum.EasingStyle.Quad),
				{ TextTransparency = 0 }
			):Play()
			TS:Create(
				plr.PlayerGui.GameUI.StatusText.UIStroke,
				TweenInfo.new(0.7, Enum.EasingStyle.Quad),
				{ Transparency = 0 }
			):Play()
		end)
	else
		forAllPlayers(function(i, plr)
			TS:Create(
				plr.PlayerGui.GameUI.StatusText,
				TweenInfo.new(0.7, Enum.EasingStyle.Quad),
				{ TextTransparency = 1 }
			):Play()
			TS:Create(
				plr.PlayerGui.GameUI.StatusText.UIStroke,
				TweenInfo.new(0.7, Enum.EasingStyle.Quad),
				{ Transparency = 1 }
			):Play()
		end)
	end
end

local function giveCash(plr: Player, amount: number)
	amount = amount or (error("No cash amount specified!") and 0)

	if plr:GetAttribute("DoubleCash") == true then
		amount *= 2
	end
	
	if plr:GetAttribute("Cash") ~= nil then
		plr:SetAttribute("Cash", plr:GetAttribute("Cash") + amount)
	else
		warn(`RoundModule :: Could not give {plr.Name} cash since plr:GetAttribute("Cash") was nil ({plr:GetAttribute("Cash")})`)
	end
	
	ReplicatedStorage.Events.UI.SendNotification:FireClient(
		plr,
		"Cash Reward",
		`You earnt {amount} cash.`,
		5,
		"rbxassetid://8150337440",
		workspace.Sounds.UI.Cash
	)
end

function RoundModule:DeathScreen(plr: Player, text: string)
	ReplicatedStorage.Events.UI.PromptDeathScreen:FireClient(plr, text)
end

function RoundModule:GetVotes()
	local VOTE_TIME = 15

	-- Get 3 random gamemodes from the GameModes module
	local selectedModes = GameModes:getRandomModes(3)

	forAllPlayers(function(i, plr: Player)
		plr.PlayerGui:WaitForChild("GameUI").StatusText.Text = `CAST YOUR VOTES...`
	end)

	ReplicatedStorage.Events.UI.ToggleVoteScreen:FireAllClients(selectedModes, VOTE_TIME)

	-- Initialize voting system
	-- Put every selected mode in a dictionary and add useful values
	local votes = {}
	for key, v in pairs(selectedModes) do
		votes[key] = {
			Votes = 0,
			VotedPlayers = {},
		}
	end

	local C_sendVoteServer = ReplicatedStorage.Events.Vote.SendVoteServer.OnServerEvent:Connect(
		function(plr: Player, modeName: string)
			local voteEntry = votes[modeName]
			if voteEntry then
				if table.find(voteEntry.VotedPlayers, plr.Name) then
					print(`Player ({plr.Name}) already voted`)
					return
				end

				if plr:GetAttribute("DoubleVotes") == true then
					voteEntry.Votes += 2
				else
					voteEntry.Votes += 1
				end

				table.insert(voteEntry.VotedPlayers, plr.Name) -- Store player names instead of objects for safety
				ReplicatedStorage.Events.Vote.SendVotesClient:FireAllClients(votes)
			else
				warn(`Gamemode {modeName} not found!`)
			end
		end
	)

	task.wait(VOTE_TIME)

	C_sendVoteServer:Disconnect()

	-- Determine the winning mode
	local highestVotes = 0
	local winningModes = {}

	for key, data in pairs(votes) do
		if data.Votes > highestVotes then
			highestVotes = data.Votes
			winningModes = { key } -- Reset with the new highest-voted mode
		elseif data.Votes == highestVotes then
			table.insert(winningModes, key) -- Add to the list of ties
		end
	end

	-- Pick the final gamemode (random if there's a tie or no votes)
	local chosenModeKey = winningModes[math.random(#winningModes)]
	local chosenMode = selectedModes[chosenModeKey]

	print(`Winning gamemode: {chosenModeKey} ({chosenMode.Name}) with {highestVotes} votes`)

	forAllPlayers(function(i, plr: Player)
		plr.PlayerGui:WaitForChild("GameUI").StatusText.Text = `WINNING GAMEMODE: {chosenMode.Name}`
	end)

	task.wait(2)

	return chosenModeKey, chosenMode
end

function RoundModule:ExplodeAndKill(plr: Player)
	if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
		local humanoidRootPart = plr.Character:FindFirstChild("HumanoidRootPart") :: Part
		
		local explosion = Instance.new("Explosion")
		explosion.ExplosionType = Enum.ExplosionType.NoCraters
		explosion.DestroyJointRadiusPercent = 0
		explosion.Parent = plr.Character
		explosion.Position = humanoidRootPart.Position

		local sound = workspace.Sounds.Explosion:Clone()
		sound.Parent = humanoidRootPart
		sound:Play()
		
		local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid:TakeDamage(101)
		end
		plr.Team = Teams.Lobby
	end
end

function RoundModule:TimerWait(seconds: number)
	--print("timerWait")
	for s = seconds, 0, -1 do
		forAllPlayers(function(i, plr: Player)
			plr.PlayerGui:WaitForChild("GameUI").StatusText.Text = `INTERMISSION: {s}`
		end)
		task.wait(1)
	end
	--print("end timerWait")
end

function RoundModule:WaitForPlayers(minAmount: number)
	forAllPlayers(function(i, plr)
		toggleStatusText(true)
		plr.PlayerGui:WaitForChild("GameUI").StatusText.Visible = true
		plr.PlayerGui:WaitForChild("GameUI").StatusText.Text = `WAITING FOR PLAYERS... ({minAmount})`
	end)

	while #game.Players:GetPlayers() < minAmount do
		forAllPlayers(function(i, plr)
			plr.PlayerGui:WaitForChild("GameUI").StatusText.Text = `WAITING FOR PLAYERS... ({#game.Players:GetPlayers()}/{minAmount})`
		end)
		task.wait(1)
	end
end

function RoundModule:Start(modifier: string? | "classic" | "x2" | "noRoomNumbers" | "battleRoyale" | "sweeper")
	local Rotating = Tent.Rotating

	---- Config
	local MIN_PLAYERS_TO_WIN = 5
	local PLAYER_GROUPS_RANGE = { 2, 5 } -- The range of players that can fit in 1 room.
	local ROTATE_TIME_RANGE = { 12, 17 } -- The amount of time the carousel will rotate
	local DEFAULT_ROT_SPD = 0.6 -- Speed of the carousel's rotation
	local SHOW_DOOR_PLAYER_NUMBER = true -- Show the amount of players in each room?
	
	-- Reset PlayerGroupSize attribute for doors
	workspace:SetAttribute("PlayerGroupSize", 0)
	
	-- Set minimum players based on current player count (for better balancing)
	if #Players:GetPlayers() < 20 then
		MIN_PLAYERS_TO_WIN = 3
		print(`Set MIN_PLAYERS_TO_WIN to {MIN_PLAYERS_TO_WIN} because {#Players:GetPlayers()} < 20.`)
	end
	
	-- Reset playback speed of all sounds
	workspace.Sounds.Theme.PlaybackSpeed = 1
	for _, sound: Sound in workspace.Sounds.Suspense:GetChildren() do
		sound.PlaybackSpeed = 1
	end

	---- Apply configs
	if modifier == "battleRoyale" then MIN_PLAYERS_TO_WIN = 1 end

	if modifier == "noRoomNumbers" then SHOW_DOOR_PLAYER_NUMBER = false end

	if modifier == "x2" then
		DEFAULT_ROT_SPD *= 2
		workspace.Sounds.Theme.PlaybackSpeed = 1.3
		for _, sound: Sound in workspace.Sounds.Suspense:GetChildren() do
			sound.PlaybackSpeed = 1.3
		end
	end
	
	--if modifier == "sweeper" then
		
	--end

	----- Local functions
	
	-- Toggles the hinge of the spinning platform, meaning it can change the speed of its rotation or disable it completely.
	local function toggleHinge(state: boolean, seconds: number?)
		seconds = seconds or 0.1
		if state == true then
			TS:Create(
				Rotating.base.HingeConstraint,
				TI.new(1, Enum.EasingStyle.Exponential),
				{ AngularVelocity = DEFAULT_ROT_SPD }
			):Play()
		else
			TS:Create(
				Rotating.base.HingeConstraint,
				TI.new(seconds, Enum.EasingStyle.Exponential),
				{ AngularVelocity = 0 }
			):Play()
		end
	end

	local function timer(seconds: number, text: string)
		forAllPlayers(function(i, plr)
			-- Make a timer like above
			plr.PlayerGui:WaitForChild("GameUI").StatusText.Text = text
		end)

		local oneSecond = 1
		if modifier == "x2" then
			oneSecond /= 2
		end

		for i = seconds, 0, -1 do
			pcall(function() -- In case it fails for a player, don't mess up the entire script
				for _, player: Player in Players:GetPlayers() do
					player.PlayerGui:WaitForChild("GameUI").StatusText.Text = `{text}: {i}`
				end
			end)
			task.wait(oneSecond)
		end
	end

	local function tweenLights(brightness: number, duration: number?, lightColor: Color3?)
		duration = duration or 1

		for _, Light: Part in Tent.Lights:GetChildren() do
			if not Light:IsA("Part") then continue end
			
			local Attachment = Light:FindFirstChildOfClass("Attachment")
			
			if Attachment then			
				local SpotLight = Attachment:FindFirstChildOfClass("SpotLight")
				
				TS:Create(SpotLight, TI.new(duration, Enum.EasingStyle.Exponential), { Brightness = brightness, Color = lightColor }):Play()
			end
			
		end
	end

	--force: Forces the function to open or close all doors regardless of the players left
	local function lockDoors(state: boolean)
		print("lockDoors", state)

		for _, Room in Tent.Rooms:GetChildren() do
			if not Room:IsA("Model") then continue end
			Room.Inside.Door.Locked.Value = state
			
			--print(`Set Locked.Value={state} on room {Room}`)
		end
	end

	local function dynamicLockDoors(state: boolean, force: boolean?)
		local remainingPlayers = #Teams.Playing:GetPlayers()

		print("dynamicLockDoors", state, force)

		if state == true then
			for _, Room in Tent.Rooms:GetChildren() do
				if not Room:IsA("Model") then continue end
				Room.Inside.Door.Locked.Value = state
				print(`Set Locked.Value={state} on room {Room}`)
			end
			return
		end

		if state == false then
			if remainingPlayers > 3 or force == true then
				for _, Room in Tent.Rooms:GetChildren() do
					if not Room:IsA("Model") then continue end
					Room.Inside.Door.Locked.Value = state
					--print(`Set Locked.Value={state} on room {Room}`)
				end
				return
			else
				print(`There are 3 or less players remaining, only certain doors will open.`)
				local availableDoors = remainingPlayers - 1

				-- start value, end value, step size
				for count = availableDoors, 1, -1 do
					print(`dynamicLockDoors :: count: {count}`)
					local numberOfRooms = 0
					
					for _, Room in Tent.Rooms:GetChildren() do
						if not Room:IsA("Model") then continue end
						numberOfRooms += 1
					end
					
					local randomRoom = math.random(1, numberOfRooms)
					local Room = Tent.Rooms:FindFirstChild(`Room{randomRoom}`)
					if not Room then
						warn(`Room{randomRoom} ({Room}) does not exist!`, `Count: {count}`)
						continue
					end

					Room:WaitForChild("Inside").Door.Locked.Value = state
					print(`Opened door from room {Room.Name}`)
				end
			end
		end
	end

	local function randomRecolorRooms()
		local Colors = {
			Color3.fromRGB(255, 89, 89),
			Color3.fromRGB(253, 234, 141),
			Color3.fromRGB(75, 151, 75),
			Color3.fromRGB(82, 124, 174),
			Color3.fromRGB(255, 102, 204),
		}

		for _, Room in Tent.Rooms:GetChildren() do
			if not Room:IsA("Model") then continue end

			local selectedColor = Colors[math.random(1, #Colors)]

			for _, i in Room.Inside.InsideWalls:GetChildren() do
				if i:IsA("BasePart") then i.Color = selectedColor end
			end

			Room.Inside.Door.DoorPart.Color = selectedColor
		end
	end

	local function toggleDoorPlayerNumber(state)
		for _, Room in Tent.Rooms:GetChildren() do
			if not Room:IsA("Model") then continue end
			local SurfaceGui = Room.Outside.Counter.GuiPart:FindFirstChildOfClass("SurfaceGui") :: SurfaceGui
			local TextLabel = SurfaceGui:FindFirstChildOfClass("TextLabel")
			
			if TextLabel then
				TextLabel.Visible = state
			end
			--print(`Set Locked.Value={state} on room {Room}`)
		end
	end
	
	-- Macro function for toggling the Sweeper and its visibility.
	local function toggleSweeper(state: boolean)
		local sweeperModel = Tent.Sweeper
		sweeperModel.Toggle:Fire(state)
	end
	-----

	toggleDoorPlayerNumber(SHOW_DOOR_PLAYER_NUMBER)

	randomRecolorRooms()

	forAllPlayers(function(i, plr)
		plr.Team = Teams.Playing

		-- Make screen black and teleport players asynchronously\
		task.spawn(function()
			GameModule.SetBlackScreen(plr, true, 0.5)
			task.wait(1)
			GameModule.SetBlackScreen(plr, false, 0.5)
		end)

		task.spawn(function()
			task.wait(0.5)
			if plr.Character then
				plr.Character:MoveTo(Tent.SpawnParts[`Spawn{i}`].Position)
			end
		end)
	end)

	lockDoors(true)
	
	-- Main loop
	while #Teams.Playing:GetPlayers() > MIN_PLAYERS_TO_WIN do
		toggleStatusText(false)
		toggleHinge(true, 1)
		tweenLights(1, 1, Color3.fromRGB(255, 255, 192))

		-- Forcefully close all doors
		dynamicLockDoors(true)
		
		if modifier == "sweeper" then
			toggleSweeper(true)
		end

		--teamForAllPlayers(Teams.Playing, function(_, plr)
		--	plr:SetAttribute("LockPush", true)
		--end)

		task.wait(1)
		Tent.FloorHitbox.CanTouch = true

		GameModule.SmoothMusicPlay(workspace.Sounds.Theme)

		teamForAllPlayers(Teams.Playing, function(_, plr)
			plr:SetAttribute("LockPush", true)
			plr:SetAttribute("CanPush", false)
		end)
		
		--teamForAllPlayers(Teams.Playing, function(_, plr)
			
		--end)
		
		teamForAllPlayers(Teams.Playing, function(_, plr)
			plr.PlayerGui:WaitForChild("GameUI").StatusText.Text = `The carousel is spinning; don't step off!`
		end)
		
		toggleStatusText(true)
		
		teamForAllPlayers(Teams.Playing, function(_, plr)
			plr.PlayerGui:WaitForChild("GameUI").StatusText.Text = `The carousel is spinning; don't step off!`
		end)
		
		-- Wait random time in range
		task.wait(math.random(ROTATE_TIME_RANGE[1], ROTATE_TIME_RANGE[2]))
		
		toggleStatusText(false)
		
		if modifier == "sweeper" then
			toggleSweeper(false)
		end

		Tent.FloorHitbox.CanTouch = false

		workspace.Sounds.Theme:Stop()

		if #Teams.Playing:GetPlayers() <= MIN_PLAYERS_TO_WIN then break end

		local playerCount = #Teams.Playing:GetPlayers()

		if modifier == "battleRoyale" then
			-- This is specifically tethered to make sure the winner is always only 1 person.
			playerCount -= 1 --> Substract 1 to make sure not all players will be needed in 1 room.
		end
		--local maxGroupSize = math.min(PLAYER_GROUPS_RANGE[2], playerCount - 1) --> Ensures we don't exceed the number of players
		
		local maxGroupSize = math.min(PLAYER_GROUPS_RANGE[2], playerCount) --> Ensures we don't exceed the number of players
		
		--if playerCount - 1 == 0 then
		--	maxGroupSize = math.min(PLAYER_GROUPS_RANGE[2], playerCount) --> Ensures we don't exceed the number of players
		--end
		local playerGroupSize

		if maxGroupSize < PLAYER_GROUPS_RANGE[2] then
			print(
				`There are fewer players in the team ({playerCount}) than the last value of PLAYER_GROUPS_RANGE ({PLAYER_GROUPS_RANGE[2]}). Adjusted max group size to {maxGroupSize}.`
			)
		end

		if PLAYER_GROUPS_RANGE[1] > maxGroupSize then
			-- It's normal for battleRoyale to throw this error, since there will be 2 players left at some point. 2-1 = 1, which is less than PLAYER_GROUPS_RANGE[1] which is 2.
			if modifier ~= "battleRoyale" then 
				warn(`Invalid group range: PLAYER_GROUPS_RANGE[1]: {PLAYER_GROUPS_RANGE[1]} > maxGroupSize: {maxGroupSize}`)
			end
			playerGroupSize = maxGroupSize
		elseif PLAYER_GROUPS_RANGE[1] == maxGroupSize then
			playerGroupSize = maxGroupSize
		else
			playerGroupSize = math.random(PLAYER_GROUPS_RANGE[1], maxGroupSize)
		end

		--print(`GROUP INSIDE ROOMS WITH {playerGroupSize} OTHER PLAYERS!`)

		teamForAllPlayers(Teams.Playing, function(_, plr)
			plr:SetAttribute("LockPush", false)
			plr:SetAttribute("CanPush", true)
		end)

		workspace.Sounds.CinematicBoom:Play()
		task.spawn(function()
			task.wait(0.1)
			teamForAllPlayers(Teams.Playing, function(_, plr)
				plr.PlayerGui:WaitForChild("GameUI").NoticeGroup.NoticeText.Text = `{playerGroupSize} PLAYERS`
				plr.PlayerGui:WaitForChild("GameUI").NoticeGroup.GroupTransparency = 0
			end)
			task.wait(0.5)
			teamForAllPlayers(Teams.Playing, function(_, plr)
				TS:Create(plr.PlayerGui:WaitForChild("GameUI").NoticeGroup, TI.new(4), { GroupTransparency = 1 }):Play()
			end)
		end)
		
		workspace:SetAttribute("PlayerGroupSize", playerGroupSize)

		-- Select random suspense sound
		local randomSuspenseSound =
			workspace.Sounds.Suspense:GetChildren()[math.random(1, #workspace.Sounds.Suspense:GetChildren())]

		task.spawn(GameModule.SmoothMusicPlay, randomSuspenseSound)
		tweenLights(0.7, 1, Color3.fromRGB(255, 110, 97))

		-- Forcefully open all doors
		dynamicLockDoors(false)

		toggleHinge(false)
		toggleStatusText(true)
		timer(20, "FIND A DOOR & GROUP UP")
		--task.wait(30)
		toggleStatusText(false)

		task.spawn(GameModule.SmoothMusicStop, randomSuspenseSound)

		-- Forcefully close all doors
		dynamicLockDoors(true)

		task.wait(1)

		-- Kill players inside "Playing" team that arent inside a room
		for i, plr: Player in Teams.Playing:GetPlayers() do
			if not plr:GetAttribute("InsideRoom") then
				print(`Killing {plr.Name} because they are outside of any room.`)
				RoundModule:DeathScreen(plr, "You were outside of any room! You must be in a room with the right amount of players to survive.")
				RoundModule:ExplodeAndKill(plr)
				task.wait(0.4)
			end
		end
		--print("Finished killing outside players")

		-- THIS IS DEBUG REMOVE THIS AFTER
		--playerGroupSize=1

		-- Kill players inside "Playing" team that are inside rooms that don't have the required amount of players
		for _, Room in Tent.Rooms:GetChildren() do
			if not Room:IsA("Model") then continue end
			if Room.PlayersInside.Value ~= playerGroupSize then
				--print(`Room {Room} not in player size (room player size: {Room.PlayersInside.Value}) (size: {playerGroupSize})`)
				local playersInZone = Room.getPlayersInZone:Invoke()

				for _, plr: Player in playersInZone do
					if plr.Team ~= Teams.Playing then continue end
					print(`Killing {plr.Name} because they are in a room that is above or below the required amount.`)
					RoundModule:DeathScreen(plr, `You were in a room with {Room.PlayersInside.Value} players, but you needed {playerGroupSize}!`)
					RoundModule:ExplodeAndKill(plr)
					task.wait(0.1)
				end
			else
				print(`Room {Room} is in player size`)
			end
		end
		--print("Finished killing players that aren't in the required amount")

		task.wait(1)

		-- Forcefully open all doors
		dynamicLockDoors(false, true)

		if #Teams.Playing:GetPlayers() <= MIN_PLAYERS_TO_WIN then break end

		-- Wait seconds for everyone to get on the platform
		toggleStatusText(true)

		--teamForAllPlayers(Teams.Playing, function(_, plr)
		--	plr:SetAttribute("LockPush", false)
		--end)

		timer(10, "RETURN TO THE PLATFORM")
		--task.wait(13)
		toggleStatusText(false)
		task.wait(1)

		--Tent.FloorHitbox.CanTouch = true
	end

	if #Teams.Playing:GetPlayers() > 0 then
		-- Win sequence
		workspace.Sounds.WinnerTheme:Play()

		for _, Emitter: ParticleEmitter in Tent.ConfettiPart:GetChildren() do
			if not Emitter:IsA("ParticleEmitter") then continue end
			Emitter.Enabled = true
		end

		teamForAllPlayers(Teams.Lobby, function(_, plr)
			local randomCash = math.random(5, 15)
			giveCash(plr, randomCash)
		end)

		local winners = {}
		teamForAllPlayers(Teams.Playing, function(_, plr)
			table.insert(winners, plr.Name)

			local randomCash = math.random(55, 75)

			if modifier == "battleRoyale" then
				randomCash *= 2
				BadgeService:AwardBadge(plr.UserId, 3749591981082606) -- Battle Royale win badge
			end

			giveCash(plr, randomCash)
		end)

		toggleStatusText(true)
		forAllPlayers(function(i, plr)
			plr.PlayerGui:WaitForChild("GameUI").StatusText.Text = `{table.concat(winners, ", ")} won!`
		end)

		task.wait(3)

		for _, Emitter: ParticleEmitter in Tent.ConfettiPart:GetChildren() do
			if not Emitter:IsA("ParticleEmitter") then continue end
			Emitter.Enabled = false
		end

		task.wait(2)

		teamForAllPlayers(Teams.Playing, function(i, plr)
			--print(`{plr.Name} won!`)
			plr:SetAttribute("Wins", plr:GetAttribute("Wins") + 1)
			plr.Team = Teams.Lobby

			local success, message = pcall(function()
				task.spawn(function()
					GameModule.SetBlackScreen(plr, true, 0.5)
					
					local randomSpawnIndex = math.random(1, #Lobby.Spawns:GetChildren())
					if plr.Character then
						if Lobby.Spawns[`Spawn{randomSpawnIndex}`] then
							plr.Character:MoveTo(Lobby.Spawns[`Spawn{randomSpawnIndex}`].Position)
						else
							plr.Character:MoveTo(Lobby.Spawns["Spawn1"].Position)
						end
					end
					task.wait(1)
					GameModule.SetBlackScreen(plr, false, 0.5)
				end)
			end)
			if not success then warn(message) end
		end)
		task.wait(1)
		toggleStatusText(false)
		GameModule.SmoothMusicStop(workspace.Sounds.WinnerTheme, 2)
	else
		teamForAllPlayers(Teams.Lobby, function(_, plr)
			local randomCash = math.random(5, 7)
			giveCash(plr, randomCash)
		end)

		toggleStatusText(true)
		forAllPlayers(function(_, plr)
			plr.PlayerGui.GameUI.StatusText.Text = `Nobody won!`
		end)
		task.wait(3)
		toggleStatusText(false)
	end
end

return RoundModule
