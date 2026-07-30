-- @ScriptType: ModuleScript
const ReplicatedStorage = game:GetService("ReplicatedStorage")

local CurrencyDisplayServiceClient = {}
CurrencyDisplayServiceClient.__index = CurrencyDisplayServiceClient

const networker = require(game.ReplicatedStorage.Shared.networker)
const DataService = require(game.ReplicatedStorage.Packages.DataService).client
const SuperTween = require(ReplicatedStorage.Core.Startup.ui.Util.SuperTween)
const AnimateCurrencyIncrease = require(ReplicatedStorage.Core.Startup.ui.Util.AnimateCurrencyIncrease)
const FormatCurrency = require(ReplicatedStorage.Core.Startup.ui.Util.FormatCurrency)

function CurrencyDisplayServiceClient:init()
	local self = setmetatable({}, CurrencyDisplayServiceClient)

	self.Player = game.Players.LocalPlayer
	self.PlayerGui = self.Player.PlayerGui
	self.MainGui = self.PlayerGui:WaitForChild("Main"):WaitForChild("Top"):WaitForChild("CurrencyDisplay")
	self.Currency = self.MainGui:WaitForChild("Money")

	local CurrentValue = DataService:get({"data", "currency"})
	self.Currency.Text = FormatCurrency(CurrentValue)

	DataService:getChangedSignal({"data", "currency"}):Connect(function(NewValue)
		local Animate = AnimateCurrencyIncrease(self.Currency, CurrentValue, NewValue)
		CurrentValue = NewValue
	end)

	return self
end

return CurrencyDisplayServiceClient