local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContextActionUtility = require(ReplicatedStorage:WaitForChild("Libraries"):WaitForChild("ContextActionUtility"))

local PushEvent = ReplicatedStorage:WaitForChild("Push"):WaitForChild("PushEvent")

local function handlePush(actionName, inputState)
	if actionName == "Push" and inputState == Enum.UserInputState.Begin then
		print("Client Push")
		PushEvent:FireServer()
	end
end

-- Bind to F and Console X
ContextActionUtility:BindAction("Push", handlePush, true, Enum.KeyCode.F, Enum.KeyCode.ButtonX)

-- Create and style mobile button
ContextActionUtility:SetImage("Push", "rbxassetid://8618269848")
ContextActionUtility:SetPressedImage("Push", "rbxassetid://14112658774")
ContextActionUtility:SetInnerImage("Push", "rbxassetid://77257742628579")

print("Bound push to F key and Console X.")