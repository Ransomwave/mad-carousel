local Players = game:GetService("Players")

return function(context, target: string | Player | number, durationStr: string?, reason: string?)
	local userId

	-- Convert username to UserId if needed
	if tonumber(target) then
		userId = tonumber(target)
	else
		local success, result = pcall(function()
			return Players:GetUserIdFromNameAsync(target)
		end)
		if not success then
			return "User not found."
		end
		userId = result
	end

	-- Parse duration (default = perm)
	local duration = -1
	if durationStr then
		if durationStr == "perm" then
			duration = -1
		else
			local num, unit = durationStr:match("^(%d+)([smhd])$")
			if not num or not unit then
				return "Invalid duration format. Use 1h, 30m, 1d, or 'perm'."
			end
			local multipliers = { s = 1, m = 60, h = 3600, d = 86400 }
			duration = tonumber(num) * multipliers[unit]
		end
	end

	local displayReason = reason or "You have been banned."
	local privateReason = string.format("Banned by %s (%d)", context.Executor.Name, context.Executor.UserId)

	local success, err = pcall(function()
		Players:BanAsync({
			UserIds = { userId },
			ApplyToUniverse = true,
			Duration = duration,
			DisplayReason = displayReason,
			PrivateReason = privateReason,
			ExcludeAltAccounts = false,
		})
	end)

	if not success then
		return "Ban failed: " .. tostring(err)
	end

	local plr = Players:GetPlayerByUserId(userId)
	if plr then
		plr:Kick(displayReason)
	end

	return string.format("User %s (UserId: %d) has been banned.", target, userId)
end
