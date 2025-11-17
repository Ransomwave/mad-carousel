local Teams = game:GetService("Teams")
local Players = game:GetService("Players")
local RoundModule = require(game:GetService("ServerScriptService").RoundModule)

local debouncedPlayers = {}

script.Parent.Touched:Connect(function(partThatTouched: Part)
	if Players:GetPlayerFromCharacter(partThatTouched.Parent) then
		local plr = Players:GetPlayerFromCharacter(partThatTouched.Parent)

		if plr.Team ~= Teams.Playing then
			--print(`Skipped player {plr} because they were on team {plr.Team}`)
			return
		end

		if plr.Team == Teams.Playing then
			local character = plr.Character
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			
			if humanoid.Health >= 35 then
				if table.find(debouncedPlayers, plr) then 
					print(`Skipped {plr} because they are in debouncedPlayers[{table.find(debouncedPlayers, plr)}]`) 
					return 
				end
				
				humanoid:TakeDamage(33)
				print(`Damaged {plr} (team {plr.Team}) for stepping on floor hitbox`)
				
				table.insert(debouncedPlayers, plr)
				
				task.delay(2, function()
					table.remove(debouncedPlayers, table.find(debouncedPlayers, plr))
				end)
				
			else
				local messages = {
					"Beware of the Sweeper! Next time, try timing your jump or outrunning it.",
					"Tip: If you're having trouble with the Sweeper, look at the Gear Shop for healing items!"
				}
				RoundModule:DeathScreen(plr, messages[math.random(1,#messages)])
				RoundModule:ExplodeAndKill(plr)
			end
		end
	end
end)
