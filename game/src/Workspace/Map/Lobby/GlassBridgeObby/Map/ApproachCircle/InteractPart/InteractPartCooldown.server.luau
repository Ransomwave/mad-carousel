local Players = game:GetService("Players")
local plr = Players.LocalPlayer

--local ObbyArea = script.Parent.Parent.Parent.Parent.Parent
local ApproachCircle = script.Parent.Parent

function convertToHMS(Seconds)
	local function format(Int)
		return string.format("%02i", Int)
	end
	
	local Minutes = (Seconds - Seconds%60)/60
	Seconds = Seconds - Minutes*60
	local Hours = (Minutes - Minutes%60)/60
	Minutes = Minutes - Hours*60
	return format(Hours)..":"..format(Minutes)..":"..format(Seconds)
end

local function handleObbyCooldown()
	if typeof(plr:GetAttribute("ObbyCooldown"))=="number" then

		task.spawn(function()
			
			while os.time() <= plr:GetAttribute("ObbyCooldown") do
				ApproachCircle:WaitForChild("Circle").TitleGui.TextLabel.Text = `On cooldown! ({convertToHMS(plr:GetAttribute("ObbyCooldown") - os.time())})`
				--ObbyArea:WaitForChild("Info"):WaitForChild("Circle").TitleGui.Text.Text = `On cooldown! ({convertToHMS(plr:GetAttribute("ObbyCooldown") - os.time())})`
				task.wait(1)
			end
			
			print("InteractPartCooldown :: Timer ended")
			script.Parent.cooldownTimerEnded:FireServer()
			ApproachCircle:WaitForChild("Circle").TitleGui.TextLabel.Text = `CLAIM FREE CASH`
			--ObbyArea:WaitForChild("Info"):WaitForChild("Circle").TitleGui.Text.Text = `EXTRA LUCK OBBY`
		end)

	--else
		--print("No cooldown")
	end	
end

handleObbyCooldown()
plr:GetAttributeChangedSignal("ObbyCooldown"):Connect(handleObbyCooldown)