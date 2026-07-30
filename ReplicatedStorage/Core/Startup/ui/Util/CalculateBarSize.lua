-- @ScriptType: ModuleScript
return function(BackBar: Frame, TopBar: Frame, Value: number, MaxValue: number)
	local Percentage = math.clamp(Value / MaxValue, 0, 1)
	return UDim2.fromScale(Percentage, TopBar.Size.Y.Scale)
end