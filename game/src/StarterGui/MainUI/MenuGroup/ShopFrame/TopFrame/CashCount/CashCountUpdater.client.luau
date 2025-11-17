-- Modules and services
local GameModule = require(game:GetService("ReplicatedStorage"):WaitForChild("GameModule"))

-- Instances
local plr = game.Players.LocalPlayer
local lead = plr:WaitForChild("leaderstats")

script.Parent.Text = `💸 {GameModule.formatNumber(plr:GetAttribute("Cash"))}`

plr:GetAttributeChangedSignal("Cash"):Connect(function()
	script.Parent.Text = `💸 {GameModule.formatNumber(plr:GetAttribute("Cash"))}`
end)