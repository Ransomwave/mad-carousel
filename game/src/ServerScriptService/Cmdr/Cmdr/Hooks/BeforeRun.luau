local Players = game:GetService("Players")

local GROUP_ID = 523334
local MIN_ADMIN_RANK = 250

local ADMINS = {
	--[208211337] = true -- Roblox player userid
}

return function(registry)
	registry:RegisterHook("BeforeRun", function(context)
		
		if not ADMINS[context.Executor.UserId] then
			local player = Players:GetPlayerByUserId(context.Executor.UserId)
			local success, playerRank = pcall(function()
				return player:GetRankInGroup(GROUP_ID)
			end)
			
			if playerRank >= MIN_ADMIN_RANK then
				ADMINS[context.Executor.UserId] = true
				print(`{player}'s rank is {playerRank} >= {MIN_ADMIN_RANK}. Added to local admins list.`)
			end
		end
		
		if context.Group == "DefaultAdmin" and not ADMINS[context.Executor.UserId] then
			return "You don't have permission to run this command"
		end
	end)
end