-- @ScriptType: ModuleScript
const ReplicatedStorage = game:GetService("ReplicatedStorage")

local TrainingUi = {}
TrainingUi.__index = TrainingUi

const SuperTween = require(ReplicatedStorage.Core.Startup.ui.Util.SuperTween)
local Hovering = false

function TrainingUi.new(GuiObject: Instance)
	local self = setmetatable({}, TrainingUi)
	self.GuiObject = GuiObject
	self.Button = GuiObject:WaitForChild("Button") :: TextButton
	self.DropShadowText = GuiObject:WaitForChild("DropShadow")
	self.MainText = self.DropShadowText:WaitForChild("MainText")

	self.DefaultSize = GuiObject.Size
	self.DefaultSize = GuiObject.Size
	self.HoverSize = UDim2.new(self.DefaultSize.X.Scale * 1.05, self.DefaultSize.X.Offset, self.DefaultSize.Y.Scale * 1.05, self.DefaultSize.Y.Offset)
	self.PressedSize = UDim2.new(self.DefaultSize.X.Scale * 0.98, self.DefaultSize.X.Offset, self.DefaultSize.Y.Scale * 0.98, self.DefaultSize.Y.Offset)

	self.Button.MouseEnter:Connect(function()
		Hovering = true
		SuperTween.new(GuiObject, 0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {Size = self.HoverSize}):Play()
	end)

	self.Button.MouseLeave:Connect(function()
		Hovering = false
		SuperTween.new(GuiObject, 0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {Size = self.DefaultSize}):Play()
	end)

	self.Button.MouseButton1Down:Connect(function()
		SuperTween.new(GuiObject, 0.08, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {Size = self.PressedSize}):Play()
	end)

	self.Button.MouseButton1Up:Connect(function()
		SuperTween.new(GuiObject, 0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out, {Size = Hovering and self.HoverSize or self.DefaultSize}):Play()
	end)
	
	return self
end

function TrainingUi:Click(ButtonState: string)
	if ButtonState == "Start" then
		self.ButtonState = true
		self.DropShadowText.Text = "Stop"
		self.MainText.Text = "Stop"
		
		self.GuiObject.TrainGradient.Enabled = false
		self.GuiObject.StopGradient.Enabled = true
		self.GuiObject.InnerStroke.UIStroke.Color = Color3.fromRGB(255, 124, 124)
		self.GuiObject.Shadow.BackgroundColor3 = Color3.fromRGB(157, 40, 40)
	elseif ButtonState == "Stop" then
		self.ButtonState = false
		self.DropShadowText.Text = "Train"
		self.MainText.Text = "Train"
		
		self.GuiObject.TrainGradient.Enabled = true
		self.GuiObject.StopGradient.Enabled = false
		self.GuiObject.InnerStroke.UIStroke.Color = Color3.fromRGB(255, 249, 217)
		self.GuiObject.Shadow.BackgroundColor3 = Color3.fromRGB(157, 128, 60)
	end
end

return TrainingUi