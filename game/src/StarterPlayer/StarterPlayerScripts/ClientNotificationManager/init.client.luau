local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

--task.wait(4)

local function CreateNotification(title:string,text:string,duration:number,icon:string?,sound:Sound?)
	local SetCore = StarterGui:SetCore("SendNotification", {
		Title = title,
		Text = text,
		Icon = icon or "",
		Duration = duration or 5
	})
	if sound then sound:Play() end
end

ReplicatedStorage:WaitForChild("Events"):WaitForChild("UI"):WaitForChild("SendNotification").OnClientEvent:Connect(function(title:string,text:string,duration:number,icon:string?)
	CreateNotification(title, text, duration, icon)
	if string.find(title, "Cash") then workspace.Sounds.UI.Cash:Play() end
end)