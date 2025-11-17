script.Parent.Event:Connect(function(seconds)
	script.Parent.Parent.Confetti.Enabled = true
	wait(seconds)
	script.Parent.Parent.Confetti.Enabled = false
end)