local Tool = script.Parent;

function onEquipped()
wait(0.1)
Tool.Handle.EquipSound:play()
end
script.Parent.Equipped:connect(onEquipped)