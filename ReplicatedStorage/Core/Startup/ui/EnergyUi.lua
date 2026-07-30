-- @ScriptType: ModuleScript
const ReplicatedStorage = game:GetService("ReplicatedStorage")

local EnergyUi = {}
EnergyUi.__index = EnergyUi

const SuperTween = require(ReplicatedStorage.Core.Startup.ui.Util.SuperTween)
const CalculateBarSize = require(ReplicatedStorage.Core.Startup.ui.Util.CalculateBarSize)
const DataService = require(ReplicatedStorage.Packages.DataService).client

function EnergyUi.new(GuiObject)
	local self = setmetatable({}, EnergyUi)
	self.GuiObject = GuiObject
	self.Top = GuiObject.Top
	self.Display = GuiObject.Display
	self.CurrentEnergy = DataService:get({"data", "energy"}) :: number
	
	local BarSize = CalculateBarSize(GuiObject, self.Top, self.CurrentEnergy, 100)
	self.Top.Size = BarSize
	
	local Upd = DataService:getChangedSignal({"data", "energy"}):Connect(function(NewValue)
		local BarSize = CalculateBarSize(GuiObject, self.Top, NewValue, 100)
		SuperTween.new(self.Top, 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out, {Size = BarSize}):Play()
		
		self.CurrentEnergy = NewValue
	end)
	
	return self
end

return EnergyUi