local success = false
while not success do
	task.wait(.5)
	print("Retrying to set ResetButtonCallback to false")
	success = pcall(function()
		game.StarterGui:SetCore("ResetButtonCallback", false)
	end)
end
print("CoreGUI Success!")

--game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
