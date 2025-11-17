--!strict

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Teams = game:GetService("Teams")
local Players = game:GetService("Players")

-- Modules
local GameModes = require(ReplicatedStorage.GameModes)
local gM = require(ReplicatedStorage:WaitForChild("GameModule"))
local RoundModule = require(script.Parent.RoundModule)

-- Workspace
local Map = workspace:WaitForChild("Map")
local Tent = Map.Tent
local Lobby = Map.Lobby

-- Setup
Tent.Rotating.propeller:SetNetworkOwner(nil)

Players.PlayerAdded:Connect(function(plr)
	print(`PlayerAdded {plr}`)

	plr.Team = Teams.Lobby

	plr.CharacterAdded:Connect(function(char)
		print(`CharacterAdded {plr}`)

		local humanoid = char:WaitForChild("Humanoid")

		humanoid.Died:Connect(function()
			print(`Player {plr} died`)
			plr.Team = Teams.Lobby
			
			task.delay(3, function()
				ReplicatedStorage.Events.UI.PromptRevive:FireClient(plr)
			end)
		end)
	end)
end)

-- Config
local INTERMISSION_TIME = 10
local MIN_PLAYERS = 6

-- Main loop
while true do
	local intermissionSounds = workspace.Sounds.Intermission:GetChildren()
	local randomIntermissionSong: Sound = intermissionSounds[math.random(1, #intermissionSounds)]
	print(`Playing intermission sound: {randomIntermissionSong.Name}`)
	gM.SmoothMusicPlay(randomIntermissionSong)

	RoundModule:WaitForPlayers(3)
	RoundModule:TimerWait(10)
	
	-- Soft limit of 6 players, hard limit of 3 players.
	-- If there are less than 6 players, the game will force itself to battle royale mode only.
	local chosenModeKey, chosenMode
	if #Players:GetPlayers() >= MIN_PLAYERS then
		chosenModeKey, chosenMode = RoundModule:GetVotes()
		
		RoundModule:WaitForPlayers(MIN_PLAYERS)
		RoundModule:TimerWait(INTERMISSION_TIME)
		--RoundModule:WaitForPlayers(MIN_PLAYERS)
	else
		print(`There are less players ({#Players:GetPlayers()}) than the minimum ({MIN_PLAYERS}). Forcing battle royale only.`)
		chosenModeKey, chosenMode = "battleRoyale", GameModes.battleRoyale
		RoundModule:WaitForPlayers(3)
		RoundModule:TimerWait(INTERMISSION_TIME)
		RoundModule:WaitForPlayers(3)
	end

	gM.SmoothMusicStop(randomIntermissionSong, 1)
	RoundModule:Start(chosenModeKey) -- start with chosen gamemode
end