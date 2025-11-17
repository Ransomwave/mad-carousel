local plr = game.Players.LocalPlayer

local MarketplaceService = game:GetService("MarketplaceService")

local TS = game:GetService("TweenService")
local TI = TweenInfo
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GetProducts = require(ReplicatedStorage:WaitForChild("GetProducts"))

local VoteGui = script.Parent
local VotePromptGroup = VoteGui:WaitForChild("VotePromptGroup")
local VotePrompt = VotePromptGroup:WaitForChild("VotePrompt")

local function toggleUI(state: boolean)
	if state == true then
		VotePrompt.ProgressBar.Size = UDim2.fromScale(1, 0.022)
		TS:Create(VotePromptGroup, TI.new(0.5), { GroupTransparency = 0 }):Play()
	else
		TS:Create(VotePromptGroup, TI.new(0.5), { GroupTransparency = 1 }):Play()
		task.delay(0.5, function()
			for _, option in VotePrompt.OptionsContainer:GetChildren() do
				if not option:IsA("Frame") or option.Name == "OptionTemplate" then continue end
				option:Destroy()
			end
		end)
	end
end

local function toggleButtons(state: boolean)
	for _, option in VotePrompt.OptionsContainer:GetChildren() do
		if not option:IsA("Frame") or option.Name == "OptionTemplate" then continue end
		local voteButton = option:FindFirstChild("VoteButton") :: TextButton
		voteButton.Interactable = state
	end
end

ReplicatedStorage.Events.UI.ToggleVoteScreen.OnClientEvent:Connect(function(modes, VOTE_TIME)
	local interacted = false

	toggleUI(true)
	toggleButtons(true)

	for key, mode in modes do
		print(key, mode.Name, mode.Description, mode.Image)
		local c = VotePrompt.OptionsContainer.OptionTemplate:Clone()
		c.Name = key
		c.Title.Text = mode.Name
		c.Description.Text = mode.Description
		c.ImageLabel.Image = mode.Image
		c.Visible = true
		c.Parent = VotePrompt.OptionsContainer
	end

	local connections = {} :: { RBXScriptConnection }
	for _, option in VotePrompt.OptionsContainer:GetChildren() do
		if not option:IsA("Frame") or option.Name == "OptionTemplate" then continue end
		local voteButton = option:FindFirstChild("VoteButton") :: TextButton

		local buttonConnection = voteButton.Activated:Connect(function()
			toggleButtons(false)

			-- Disconnect all button connections
			for i, connection in connections do
				connection:Disconnect()
			end

			ReplicatedStorage.Events.Vote.SendVoteServer:FireServer(voteButton.Parent.Name)
		end)
		table.insert(connections, buttonConnection)
	end

	local C_sendVotesClient = ReplicatedStorage.Events.Vote.SendVotesClient.OnClientEvent:Connect(
		function(receivedVotes: {})
			--print("Update votes: ", receivedVotes)

			for key, value in receivedVotes do
				--print(key,value)
				local success, error = pcall(function()
					VotePrompt.OptionsContainer:WaitForChild(key).VoteCount.Text = `Votes: {receivedVotes[key].Votes}`
				end)
				if not success then warn(error) end
			end

			print(`Updated votes for player {plr}`)
		end
	)

	local tween_ProgressBar = TS:Create(VotePrompt.ProgressBar, TI.new(VOTE_TIME), { Size = UDim2.fromScale(0, 0.022) })
	tween_ProgressBar:Play()
	task.wait(VOTE_TIME)
	toggleUI(false)
end)
