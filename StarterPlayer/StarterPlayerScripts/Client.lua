-- @ScriptType: LocalScript
-- services
const ReplicatedStorage = game:GetService("ReplicatedStorage")
const UserInputService = game:GetService("UserInputService")

-- global

local AssetsFolder = ReplicatedStorage.Assets

-- modules
const networker = require(ReplicatedStorage.Shared.networker)

const DataService = require(ReplicatedStorage.Packages.DataService).client
DataService:init()

const TrainingServiceClient = require(ReplicatedStorage.Core.Features.Training.TrainingServiceClient)
const SpawnServiceClient = require(ReplicatedStorage.Core.Features.Spawn.SpawnServiceClient)
const CurrencyDisplayServiceClient = require(ReplicatedStorage.Core.Features.CurrencyDisplay.CurrencyDisplayServiceClient)

-- init

SpawnServiceClient:init()
TrainingServiceClient:init()
CurrencyDisplayServiceClient:init()

-- main

UserInputService.InputBegan:Connect(function(Input, GPE)
	if Input.KeyCode == Enum.KeyCode.Z then
		networker.GiveEnergy:Fire()
	end
end)