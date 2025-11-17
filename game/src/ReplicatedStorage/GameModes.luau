local module = {
	
	classic = {
		Name = "Classic Mingle",
		Description = "Classic Mingle, with no extra changes or modifiers.",
		Image = "rbxassetid://113384125097885"
	},

	noRoomNumbers = {
		Name = "No player numbers",
		Description = "Rooms no longer show the amount of players inside.",
		Image = "rbxassetid://95566315088900"
	},
	
	x2 = {
		Name = "X2",
		Description = "Everything is twice as fast!",
		Image = "rbxassetid://126375751437514"
	},
	
	battleRoyale = {
		Name = "Battle Royale",
		Description = "Only 1 winner (double cash reward to the winner)",
		Image = "rbxassetid://9654144072"
	},

	sweeper = {
		Name = "Sweeper",
		Description = "Beware of the big red sweeper. Every round you'll have to avoid it or you'll die!",
		Image = "rbxassetid://134880760782489"
	}
}

-- Method to get random non-repeating key-value pairs
function module:getRandomModes(count: number)
	local keys = {}
	
	-- Get keys from self (since the gamemodes are stored inside the "module" table)
	for key in pairs(self) do
		if typeof(self[key]) == "table" then -- Ensure it's a valid mode (not a function)
			table.insert(keys, key)
		end
	end

	-- Shuffle the keys (Fisher-Yates shuffle)
	for i = #keys, 2, -1 do
		local j = math.random(i)
		keys[i], keys[j] = keys[j], keys[i]
	end

	-- Collect the random key-value pairs
	local result = {}
	for i = 1, math.min(count, #keys) do
		local key = keys[i]
		result[key] = self[key] -- Preserve the original key names
	end

	return result 
end

return module