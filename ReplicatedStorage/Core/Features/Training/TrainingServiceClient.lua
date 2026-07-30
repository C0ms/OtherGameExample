-- @ScriptType: ModuleScript
const ReplicatedStorage = game:GetService("ReplicatedStorage")

local TrainClient = {}
TrainClient.__index = TrainClient

const networker = require(game.ReplicatedStorage.Shared.networker)
const DataService = require(game.ReplicatedStorage.Packages.DataService).client
const SuperTween = require(ReplicatedStorage.Core.Startup.ui.Util.SuperTween)

const TrainingGuiModule = require(ReplicatedStorage.Core.Startup.ui.TrainingUi)
const EnergyUiModule = require(ReplicatedStorage.Core.Startup.ui.EnergyUi)
const StrengthUi = require(ReplicatedStorage.Core.Startup.ui.StrengthUi)

function TrainClient:init()
	local self = setmetatable({}, TrainClient)
	self.Player = game.Players.LocalPlayer
	self.Character = self.Player.Character or self.Player.CharacterAdded:Wait()
	self.Humanoid = self.Character.Humanoid :: Humanoid
	self.Animator = self.Humanoid.Animator :: Animator
	self.PlayerGui = self.Player.PlayerGui
	self.TopGui = self.PlayerGui:WaitForChild("Main"):WaitForChild("Top")
	self.GuiFolder = self.PlayerGui:WaitForChild("Main"):WaitForChild("Top")
	self.MainHud = self.GuiFolder:WaitForChild("MainHud")
	
	self.LiftingAnimation = ReplicatedStorage.Assets.Animations.LiftAnimation :: Animation
	self.LiftingAnimationTrack = self.Animator:LoadAnimation(self.LiftingAnimation)
	
	self.MainTrainingUi = self.MainHud.Train
	self.TrainingGui = TrainingGuiModule.new(self.MainTrainingUi)
	
	self.MainEnergyUi = self.MainHud.Energy
	self.EnergyGui = EnergyUiModule.new(self.MainEnergyUi)
	
	self.MainStrengthUi = self.MainHud.Strength
	self.StrengthGui = StrengthUi.new(self.MainStrengthUi)
	
	self.TrainButton = self.MainTrainingUi.Button
	self.Training = false
	
	task.spawn(function()
		while true do
			task.wait(0.1)
			if not self.Training then continue end
			
			networker.RequestTrain:Fire()
		end
	end)
	
	networker.ReplicateLiftAnimation.OnClientEvent:Connect(function()
		self.LiftingAnimationTrack:Play()
	end)
	
	networker.ReplicateStrengthGiven.OnClientEvent:Connect(function(Amount)
		local NewItem = ReplicatedStorage.Assets.StrengthTemplate:Clone() :: ImageLabel
		NewItem.Parent = self.TopGui
		NewItem.TopShadow.Text = "+" .. Amount .. " Strength"
		NewItem.TopShadow.Display.Text = "+" .. Amount .. " Strength"
		
		NewItem.Size = UDim2.new(0,0,0,0)
		
		SuperTween.new(NewItem, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out, {Size = UDim2.new(0.07, 0,0.1, 0)}):Play()
		
		local RandomX = 0.5 + (math.random() - 0.5) * 0.3 
		local RandomY = 0.5 + (math.random() - 0.5) * 0.3 

		NewItem.Position = UDim2.fromScale(RandomX, RandomY)

		task.delay(0.5, function()
			SuperTween.new(NewItem, 0.45, Enum.EasingStyle.Sine, Enum.EasingDirection.In, {Size = UDim2.new(0, 0, 0, 0)}):Play()
			SuperTween.new(NewItem, 0.45, Enum.EasingStyle.Sine, Enum.EasingDirection.In, {Position = UDim2.new(0.505, 0, 0.067, 0)}):Play()

			task.wait(0.45)
			
			self.StrengthGui:Animate()
			self.StrengthGui:Update()
			
			NewItem:Destroy()
		end)
	end)
	
	self.TrainButton.MouseButton1Click:Connect(function()
		if self.Training then
			self.Training = false
			self.TrainingGui:Click("Stop")
		else
			self.Training = true
			self.TrainingGui:Click("Start")
		end
	end)

	return self
end

return TrainClient