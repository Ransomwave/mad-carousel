local Tool = script.Parent
local mouse = game.Players.LocalPlayer:GetMouse()

local COOLDOWN = 15 -- Cooldown duration in seconds
local lastUsed = 0

function onButton1Down()
	local now = os.clock()
	if now - lastUsed < COOLDOWN then
		mouse.Icon = "rbxasset://textures\\GunWaitCursor.png"
		return
	end
	
	lastUsed = now
end

function onEquippedLocal()

	if mouse == nil then
		print("Mouse not found")
		return 
	end
	
	local now = os.clock()
	if now - lastUsed < COOLDOWN then
		mouse.Icon = "rbxasset://textures\\GunWaitCursor.png"
		return
	end

	mouse.Icon = "rbxasset://textures\\GunCursor.png"
	mouse.Button1Down:connect(function() onButton1Down(mouse) end)
end

function onUnequipped()
	mouse.Icon = ""
end


Tool.Equipped:Connect(onEquippedLocal)
Tool.Unequipped:Connect(onUnequipped)