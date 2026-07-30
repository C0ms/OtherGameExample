-- @ScriptType: ModuleScript
const ReplicatedStorage = game:GetService("ReplicatedStorage")

local StrengthUi = {}
StrengthUi.__index = StrengthUi

const SuperTween = require(ReplicatedStorage.Core.Startup.ui.Util.SuperTween)
const CalculateBarSize = require(ReplicatedStorage.Core.Startup.ui.Util.CalculateBarSize)
const DataService = require(ReplicatedStorage.Packages.DataService).client
const Abbreviate = require(ReplicatedStorage.Core.Startup.ui.Util.Abbreviate)

function StrengthUi.new(GuiObject)
	local self = setmetatable({}, StrengthUi)
	self.GuiObject = GuiObject
	self.BarBack = GuiObject
	self.Display = GuiObject.Display
	self.BaseSize = GuiObject.Size
	
	self:Update()

	return self
end

function StrengthUi:Animate()
	SuperTween.new(self.GuiObject, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {Size = UDim2.new(0.326, 0,0.078, 0)}):Play()
	
	task.wait(0.35)
	
	SuperTween.new(self.GuiObject, 0.25, Enum.EasingStyle.Exponential, Enum.EasingDirection.In, {Size = self.BaseSize}):Play()
end

function StrengthUi:Update()
	local CurrentStrength = DataService:get({"data", "strength"}) :: number
	
	self.Display.Text = Abbreviate(CurrentStrength).. " Strength"
end

return StrengthUi