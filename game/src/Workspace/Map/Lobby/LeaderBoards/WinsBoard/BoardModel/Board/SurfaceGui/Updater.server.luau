local lbData = game:GetService("DataStoreService"):GetOrderedDataStore("Wins")
local DonationBoard = script.Parent.Parent.Parent.Parent
repeat task.wait() until #game.Players:GetPlayers() >= 1

function Countdown(seconds: number, label: TextLabel)
	seconds = seconds or error("Updater.Countdown() :: Seconds not specified")
	label = label or error("Updater.Countdown() :: TextLabel not specified")

	task.spawn(function()	
		for count = seconds, 0, -1 do
			task.wait(1)
			label.Text = "Updating in " .. count .. "s"
		end
	end)
end

function AddCommas(num: number)
	return tostring(math.floor(num)):reverse():gsub("(%d%d%d)", "%1,"):gsub(",(%-?)$", "%1"):reverse()
end

function Update()
	print("WinsBoard.Updater :: Updating Wins leaderboard")
	local frames = DonationBoard.BoardModel.Board.SurfaceGui.ScrollingFrame:GetChildren()

	-- Clear existing frames
	for _, v in pairs(frames) do
		if v:IsA("Frame") then
			v:Destroy()
		end
	end

	-- Update each player's donation data
	for _, plr in pairs(game.Players:GetPlayers()) do
		if plr:GetAttribute("Wins") ~= 0 and plr:GetAttribute("Wins") ~= nil then
			local success, err = pcall(function()
				lbData:SetAsync(plr.UserId, plr:GetAttribute("Wins"))
			end)
			if not success then
				warn("Error setting DataStore for player: " .. plr.Name .. ". Error: " .. err)
			end
		else
			print(`Did not get value for player {plr.Name} because Wins was 0. ({plr:GetAttribute("Wins")})`)
		end
	end

	-- Fetch and sort leaderboard data
	local success, data = pcall(function()
		return lbData:GetSortedAsync(false, 15)
	end)
	if not success then
		warn("Error retrieving sorted DataStore: " .. data)
		return
	end

	local page = data:GetCurrentPage()
	--print(page)

	-- Set the top player's UserID on the leaderboard
	if page and page[1] then
		if tonumber(page[1].key) <= 0 then
			DonationBoard:WaitForChild("TopPlayer").UserID.Value = 2
		else
			DonationBoard:WaitForChild("TopPlayer").UserID.Value = page[1].key
		end
	end

	-- Update the leaderboard UI
	for rank, info in ipairs(page) do
		--print(rank,info)
		local frame = script.Parent.Sample:Clone()
		local id = info.key
		if tonumber(id) <= 0 then id = 2 end

		local success, plrName = pcall(function()
			return game.Players:GetNameFromUserIdAsync(id)
		end)

		if not success then
			warn("Error retrieving player name for UserID: " .. id .. ". Error: " .. plrName)
			plrName = "Unknown"
		end

		-- Set the rank and color based on the position
		frame:WaitForChild("Place").Text = "#" .. rank
		for _, v in pairs(frame:GetChildren()) do
			if v:IsA("TextLabel") then
				if rank == 1 then
					v.TextColor3 = Color3.fromRGB(255, 255, 0)
				elseif rank == 2 then
					v.TextColor3 = Color3.fromRGB(255, 255, 0)
				elseif rank == 3 then
					v.TextColor3 = Color3.fromRGB(255, 255, 0)
				else
					v.TextColor3 = Color3.fromRGB(255, 255, 255)
				end
			end
		end

		-- Set player name and value
		frame.Username.Text = plrName or "Unknown"
		frame.Value.Text = AddCommas(info.value)
		frame.Visible = true
		frame.Parent = DonationBoard.BoardModel.Board.SurfaceGui.ScrollingFrame
	end
end

script.Parent.Update.Event:Connect(Update)

Countdown(5, DonationBoard.BoardModel.Board.SurfaceGui.RefreshText)
task.wait(5)
Update()

while true do
	Countdown(120, DonationBoard.BoardModel.Board.SurfaceGui.RefreshText)
	task.wait(120)
	--for _, plr in pairs(game.Players:GetPlayers()) do
	--	local success, err = pcall(function()
	--		lbData:SetAsync(plr.UserId, plr:GetAttribute("Wins"))
	--	end)
	--	if not success then
	--		warn("Error setting DataStore for player: " .. plr.Name .. ". Error: " .. err)
	--	end
	--end

	Update()
end
