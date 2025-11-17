local lbData = game:GetService("DataStoreService"):GetOrderedDataStore("Donation")
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
	--print("DonationBoard.Updater :: Updating donations leaderboard")
	local frames = DonationBoard.BoardModel.Board.SurfaceGui.ScrollingFrame:GetChildren()

	-- Clear existing frames
	for _, v in pairs(frames) do
		if v:IsA("Frame") then
			v:Destroy()
		end
	end

	-- Update DataStore for each player
	for _, plr: Player in pairs(game.Players:GetPlayers()) do
		if plr:GetAttribute("DonationValue") ~= 0 and plr:GetAttribute("DonationValue") ~= nil and plr:GetAttribute("DonationValue") ~= plr:GetAttribute("OriginalDonationValue") then
			local success, err = pcall(function()
				lbData:SetAsync(plr.UserId, plr:GetAttribute("DonationValue"))
			end)
			if not success then
				warn("Error setting DataStore for player: "..plr.Name..". Error: "..err)
			end
		end
	end

	-- Fetch sorted DataStore
	local success, data = pcall(function()
		return lbData:GetSortedAsync(false, 15)
	end)

	if not success then
		warn("Error getting sorted DataStore: "..data)
		return
	end

	local page = data:GetCurrentPage()

	-- Update the top donator
	if page and page[1] then
		DonationBoard:WaitForChild("TopDonator").UserID.Value = page[1].key
	end

	-- Update leaderboard frames
	for rank, info in ipairs(page) do
		local frame = script.Parent.Sample:Clone()
		local id = info.key
		if tonumber(id) <= 0 then id = 2 end

		local success, plrName = pcall(function()
			return game.Players:GetNameFromUserIdAsync(id)
		end)

		if not success then
			warn("Error getting player name for UserID: "..id..". Error: "..plrName)
			plrName = "Unknown"
		end

		frame:WaitForChild("Place").Text = "#" .. rank

		-- Apply color based on rank
		for _, v in pairs(frame:GetChildren()) do
			if not v:IsA("TextLabel") then continue end
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

		frame.Username.Text = plrName or "Unknown"
		frame.Value.Text = `{AddCommas(info.value)}`
		frame.Visible = true
		frame.Parent = DonationBoard.BoardModel.Board.SurfaceGui.ScrollingFrame
	end
end

-- Connect update function to an event
script.Parent.Update.Event:Connect(Update)

-- Initial countdown and update
Countdown(10, DonationBoard.BoardModel.Board.SurfaceGui.RefreshText)
task.wait(10)
Update()

-- Main loop to continuously update
while true do
	Countdown(120, DonationBoard.BoardModel.Board.SurfaceGui.RefreshText)
	task.wait(120)

	-- Update DataStore for each player
	--for _, plr in pairs(game.Players:GetPlayers()) do
	--	local success, err = pcall(function()
	--		lbData:SetAsync(plr.UserId, plr.DonationValue.Value)
	--	end)
	--	if not success then
	--		warn("Error setting DataStore for player: "..plr.Name..". Error: "..err)
	--	end
	--end

	-- Update leaderboard
	Update()
end
