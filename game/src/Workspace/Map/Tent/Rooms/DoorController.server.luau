local TS = game:GetService("TweenService")
local TI = TweenInfo

local Rooms = script.Parent

for i,Room:Model in Rooms:GetChildren() do
	if not Room:IsA("Model") then continue end
	
	--print(`Indexed room {Room}`)
	
	local DoorFolder:Folder = Room.Inside:WaitForChild("Door")
	local DoorPart:Part = DoorFolder:WaitForChild("DoorPart")
	local Prompt:ProximityPrompt = DoorFolder.InteractPart.ProximityPrompt
	
	local sfx:Sound = DoorPart.sfx
	local openPos = DoorPart.Position
	
	-- set it as local otherwise the state will be shared across all the iterations of the for loop
	local function toggleDoor(state:boolean)
		if state==true then
			-- Open door
			sfx:Play()
			TS:Create(DoorPart, TI.new(.3, Enum.EasingStyle.Quad), {Position=openPos}):Play()
		else
			-- Close door
			sfx:Play()
			TS:Create(DoorPart, TI.new(.3, Enum.EasingStyle.Quad), {Position=openPos-Vector3.new(0,10,0)}):Play()
		end
	end
	
	DoorFolder.State.Changed:Connect(function()
		if DoorFolder.State.Value==true then
			toggleDoor(true)
			
		elseif DoorFolder.State.Value==false then
			toggleDoor(false)
		end
		
	end)
	
	DoorFolder.Locked.Changed:Connect(function()
		Prompt.Enabled = false
		
		if DoorFolder.Locked.Value==true then
			if DoorFolder.State.Value==true then -- Door is open, close it
				DoorFolder.State.Value=false
			end
			Prompt.Enabled = false
			Prompt.MaxActivationDistance = 0
			
		elseif DoorFolder.Locked.Value==false then
			if DoorFolder.State.Value==false then -- Door is closed, open it
				DoorFolder.State.Value=true
			end
			Prompt.Enabled = true
			Prompt.MaxActivationDistance = 5
			
			--while Prompt.Enabled == false do
			--	Prompt.Enabled = true
			--end
		
		end
	end)
	
	-- For proximity prompts
	Prompt.Triggered:Connect(function(plr) 
		if not plr:GetAttribute("InsideRoom") then return end
		
		Prompt.Enabled=false
		
		if DoorFolder.State.Value==true then
			--sfx:Play()
			-- If it is already open, close it
			DoorFolder.State.Value=false
			
			task.wait(1)
			Prompt.Enabled=true
			
		elseif DoorFolder.State.Value==false then
			--sfx:Play()
			-- If it is already closed, open it
			DoorFolder.State.Value=true

			task.wait(1)
			Prompt.Enabled=true
		end
	end)
	
end

