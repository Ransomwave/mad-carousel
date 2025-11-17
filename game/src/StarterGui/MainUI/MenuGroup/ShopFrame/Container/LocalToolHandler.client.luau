local RepStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local TS = game:GetService("TweenService")
local Tools = RepStorage.CashShop:WaitForChild("Gear")

local itemFrame = script.Parent:WaitForChild("ItemFrame")
local ToolEvent = RepStorage.Events.CashShop:WaitForChild("EquipTool")

local SpinObjects = {}
local rot = 0

local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local userInputService = game:GetService("UserInputService")
local GameModule = require(RepStorage:WaitForChild("GameModule"))
local backpack = plr:WaitForChild("Backpack")
local Inventory = plr:WaitForChild("Inventory")

local MainUI = plr.PlayerGui.MainUI
local openButton = MainUI.VerticalFrame:WaitForChild("CashShop")

local currentTool
local currentFrame

local function spin()
	coroutine.wrap(function()
		RunService.Heartbeat:Connect(function(deltaTime)
			for i = 1, #SpinObjects do
				SpinObjects[i].CFrame *= CFrame.Angles(0, math.rad(100 * deltaTime), 0)
			end

			rot += .005
		end)
	end)()
end

local buttonColors = {
	Buy = {
		Text = Color3.fromRGB(132, 255, 125),
		Stroke = Color3.fromRGB(132, 255, 125),
		Background = Color3.fromRGB(97, 185, 91)
	},
	Equip = {
		Text = Color3.fromRGB(119, 219, 255),
		Stroke = Color3.fromRGB(119, 219, 255),
		Background = Color3.fromRGB(85, 170, 255)
	}
}

local function loadTools()
	local toolsList = {}

	-- Collect tools into a list for sorting
	for _, tool in pairs(Tools:GetChildren()) do
		if tool:FindFirstChild("Price") and typeof(tool.Price.Value) == "number" then
			table.insert(toolsList, tool)
		end
	end

	-- Sort tools by price (lowest to highest)
	table.sort(toolsList, function(a, b)
		return a.Price.Value < b.Price.Value
	end)

	-- Now create UI for each tool in order
	for i, tool in ipairs(toolsList) do
		local toolFrame = script:WaitForChild("Item"):Clone()
		toolFrame.LayoutOrder = i
		toolFrame.Name = tool.Name 

		if tool:FindFirstChild("Handle") then
			local newTool = tool.Handle:Clone()
			newTool.Parent = toolFrame.ViewportFrame

			local cam = Instance.new("Camera")
			cam.Parent = toolFrame.ViewportFrame

			toolFrame.ViewportFrame.CurrentCamera = cam
			cam.CFrame = CFrame.new(0, 0, 2)
			newTool.Position = Vector3.new(0, 0, 0)

			table.insert(SpinObjects, newTool)
		end

		toolFrame.Visible = true
		toolFrame.Parent = script.Parent:WaitForChild("ObjectFrame").ScrollingFrame

		toolFrame.ClickButton.Activated:Connect(function()
			currentTool = tool.Name 
			currentFrame = tool

			itemFrame.EquipButton.Text = "BUY"
			itemFrame.ItemLabel.Text = tool.Name
			itemFrame.PriceLabel.Text = `💸 {GameModule.formatNumber(tool.Price.Value)}`
			
			itemFrame.EquipButton.TextColor3 = buttonColors.Buy.Text
			itemFrame.EquipButton.UIStroke.Color = buttonColors.Buy.Stroke
			itemFrame.EquipButton.BackgroundColor3 = buttonColors.Buy.Background

			if Inventory:FindFirstChild(tool.Name) then
				itemFrame.EquipButton.TextColor3 = buttonColors.Equip.Text
				itemFrame.EquipButton.UIStroke.Color = buttonColors.Equip.Stroke
				itemFrame.EquipButton.BackgroundColor3 = buttonColors.Equip.Background
				if backpack:FindFirstChild(tool.Name) or char:FindFirstChild(tool.Name) then
					itemFrame.EquipButton.Text = "UNEQUIP"
				else
					itemFrame.EquipButton.Text = "EQUIP"
				end
			end

			if tool:FindFirstChild("Handle") then
				local newClone = toolFrame.ViewportFrame.Handle:Clone()

				for _, obj in pairs(itemFrame.ViewportFrame:GetChildren()) do
					local foundObj = table.find(SpinObjects, obj)
					if foundObj then
						table.remove(SpinObjects, foundObj)
					end
					if obj:IsA("BasePart") or obj:IsA("Model") then
						obj:Destroy()
					end
				end

				local newCam = Instance.new("Camera")
				newCam.CFrame = CFrame.new(0, 0, 2)
				itemFrame.ViewportFrame.CurrentCamera = newCam

				table.insert(SpinObjects, newClone)
				newClone.Parent = itemFrame.ViewportFrame
			end
		end)
	end

	spin()
end


loadTools()

itemFrame.EquipButton.Activated:Connect(function()
	if currentTool then
		ToolEvent:FireServer(currentTool)
	end
end)

char.ChildAdded:Connect(function(obj)
	if obj:IsA("Tool") and Tools:FindFirstChild(obj.Name) then
		currentTool = obj
	end
end)

backpack.ChildAdded:Connect(function(obj)
	if currentFrame then
		if obj.Name == currentFrame.Name then
			itemFrame.EquipButton.Text = "UNEQUIP"
		end
	end
end)

backpack.ChildRemoved:Connect(function(obj)
	if currentFrame then
		if obj.Name == currentFrame.Name then
			itemFrame.EquipButton.Text = "EQUIP"
		end
	end
end)

Inventory.ChildAdded:Connect(function(obj)
	if currentFrame then
		if obj.Name == currentFrame.Name then
			itemFrame.EquipButton.Text = "EQUIP"
		end
	end
end)

--local isOpen = openFrame.IsOpen
local isOpen = MainUI.MenuGroup.ShopFrame.IsOpen

openButton.Activated:Connect(function()
	if not isOpen.Value then
		openButton.Click:Play()
		isOpen.Value = true

		local Tween = TS:Create(script.Parent.Parent, TweenInfo.new(.5), {Position = UDim2.fromScale(.5,.5)})
		Tween:Play()
	else
		openButton.Click:Play()
		local Tween = TS:Create(script.Parent.Parent, TweenInfo.new(.3), {Position = UDim2.fromScale(.5,-1.5)})
		Tween:Play()

		isOpen.Value = false
	end
end)