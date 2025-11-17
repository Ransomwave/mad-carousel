local ReplicatedStorage = game:GetService("ReplicatedStorage")

ReplicatedStorage.Events.UI.setBlackScreen.OnClientInvoke = function(value, seconds, style, color)
	local plr = game.Players.LocalPlayer
	
	local TweenService = game:GetService("TweenService")
	local BlackScreen = plr.PlayerGui:WaitForChild("BlackScreen")
	plr.PlayerGui:WaitForChild("BlackScreen").Frame.Visible = true

	style = style or Enum.EasingStyle.Linear
	color = color or Color3.fromRGB(0,0,0)

	if value == true then
		plr.PlayerGui.BlackScreen.Frame.Transparency = 1
		BlackScreen.Frame.BackgroundColor3 = color
		local Tw = TweenService:Create(plr.PlayerGui.BlackScreen.Frame, TweenInfo.new(seconds, style), {Transparency = 0})

		Tw:Play()
		Tw.Completed:Wait()

	elseif value == false then
		plr.PlayerGui.BlackScreen.Frame.Transparency = 0
		BlackScreen.Frame.BackgroundColor3 = color
		local Tw = TweenService:Create(plr.PlayerGui.BlackScreen.Frame, TweenInfo.new(seconds, style), {Transparency = 1})

		Tw:Play()
		Tw.Completed:Wait()


		plr.PlayerGui.BlackScreen.Frame.Visible = false
	else
		local Tw = TweenService:Create(plr.PlayerGui.BlackScreen.Frame, TweenInfo.new(seconds, style), {Transparency = value})

		Tw:Play()
		Tw.Completed:Wait()
		--		task.wait(seconds)
	end
end