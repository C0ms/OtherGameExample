-- @ScriptType: ModuleScript
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

const Signal = require(ReplicatedStorage.Packages.Signal)
const FormatCurrency = require(ReplicatedStorage.Core.Startup.ui.Util.FormatCurrency)

return function(TextLabel: TextLabel, CurrentValue: number, NewValue: number)
	local OnIncrease = Signal()

	TextLabel.Text = FormatCurrency(CurrentValue)

	task.spawn(function()
		local Value = CurrentValue
		local Duration = 0.8
		local StartTime = os.clock()

		while Value ~= NewValue do
			local Alpha = math.clamp((os.clock() - StartTime) / Duration, 0, 1)
			Value = math.floor(CurrentValue + (NewValue - CurrentValue) * Alpha)

			OnIncrease:Fire(Value)
			TextLabel.Text = FormatCurrency(Value)

			if Alpha >= 1 then
				break
			end

			RunService.Heartbeat:Wait()
		end

		TextLabel.Text = FormatCurrency(NewValue)
		OnIncrease:Fire(NewValue)
	end)

	return OnIncrease
end