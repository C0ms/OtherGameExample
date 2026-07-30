-- @ScriptType: ModuleScript
const ReplicatedStorage = game:GetService("ReplicatedStorage")

local MovementServiceServer = {}
MovementServiceServer.__index = MovementServiceServer

const networker = require(ReplicatedStorage.Shared.networker)
const DataService = require(ReplicatedStorage.Packages.DataService).server
const DumbellData = require(ReplicatedStorage.Core.Data.DumbellData)

local Cooldowns = {}
local COOLDOWN = 1

function MovementServiceServer:init()
	local self = setmetatable({}, MovementServiceServer)

	networker.RequestTrain.OnServerEvent:Connect(function(Player: Player)
		local CurrentTime = os.clock()
		local LastTrain = Cooldowns[Player]

		if LastTrain and CurrentTime - LastTrain < COOLDOWN then return end

		Cooldowns[Player] = CurrentTime

		local CurrentEnergy = DataService:get(Player, {"data", "energy"})
		local CurrentDumbell = DataService:get(Player, {"data", "EquippedDumbell"})

		if CurrentEnergy >= 10 then
			DataService:update(Player, {"data", "energy"}, function(Value)
				return Value - 10
			end)

			networker.ReplicateLiftAnimation:FireClient(Player)

			local CurrentData = DumbellData[CurrentDumbell]
			if not CurrentData then warn("no dumbell data for " .. CurrentDumbell) return end

			local Amount = CurrentData.StrengthGiven
			
			networker.ReplicateStrengthGiven:FireClient(Player, Amount)

			DataService:update(Player, {"data", "strength"}, function(Value)
				return Value + Amount
			end)
		end
	end)

	return self
end

return MovementServiceServer