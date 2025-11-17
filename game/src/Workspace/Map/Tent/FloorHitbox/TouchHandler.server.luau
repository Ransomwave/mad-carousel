local Teams = game:GetService("Teams")
local Players = game:GetService("Players")
local RoundModule = require(game:GetService("ServerScriptService").RoundModule)

script.Parent.Touched:Connect(function(partThatTouched: Part)
	if Players:GetPlayerFromCharacter(partThatTouched.Parent) then
		local plr = Players:GetPlayerFromCharacter(partThatTouched.Parent)

		if plr.Team ~= Teams.Playing then
			--print(`Skipped player {plr} because they were on team {plr.Team}`)
			return
		end

		if plr.Team == Teams.Playing then
			print(`Killed {plr} (team {plr.Team}) for stepping on floor hitbox`)
			RoundModule:DeathScreen(plr, "Don't step off the carousel while it's spinning!")
			RoundModule:ExplodeAndKill(plr)
		end
	end
end)

--script.Parent.Changed:Connect(function()
--	warn("TODO: THIS IS DEBUG CHANGE IT")
--	if script.Parent.CanTouch==true then
--		script.Parent.Transparency=0.5
--	elseif script.Parent.CanTouch==false then
--		script.Parent.Transparency=1
--	end
--end)
