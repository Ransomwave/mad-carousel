local Model = script.Parent.Parent.Parent.Parent

Model.PlayersInside.Changed:Connect(function()
	script.Parent.SurfaceGui.TextLabel.Text = Model.PlayersInside.Value
end)