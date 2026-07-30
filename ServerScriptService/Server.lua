-- @ScriptType: Script
-- services
const ReplicatedStorage = game:GetService("ReplicatedStorage")
const ServerStorage = game:GetService("ServerStorage")

-- modules
const networker = require(ReplicatedStorage.Shared.networker)
const DataTemplate = require(ReplicatedStorage.Packages.DataService.DataTemplate)
const DataService = require(ReplicatedStorage.Packages.DataService).server

const TrainingServiceServer = require(ReplicatedStorage.Core.Features.Training.TrainingServiceClient.TrainingServiceServer)
const SpawnServiceServer = require(ReplicatedStorage.Core.Features.Spawn.SpawnServiceClient.SpawnServiceServer)
const CharacterClass = require(ReplicatedStorage.Core.Classes.CharacterClass)

TrainingServiceServer:init()
SpawnServiceServer:init()

-- INIT AFTER SO IT CAN REQUIRE AND RUN BEFORE MOVING THEM
const Core = require(ReplicatedStorage.Core)
Core:Init()

-- main
function DataService:onPlayerInit(player, data)
	
end

DataService:addPlayerRemovingCallback(function(player, data)

end)

game.Players.PlayerAdded:Connect(function(Player: Player)
	Player.CharacterAdded:Connect(function(Character: Model)
		local NewClass = CharacterClass.new(Character)
	end)
	
	DataService:waitForData(Player)
	
	local Updated = DataService:set(Player, {"data", "energy"}, 100)
end)

DataService:init({
	template = DataTemplate,
	profileStoreIndex = "v1",
	useMock = false,
	resetData = false,
	dontSave = false,
	--viewedUserId = 00000000,
	--overridenUserId = 000000000,
})

networker.GiveEnergy.OnServerEvent:Connect(function(Player: Player)
	DataService:set(Player, {"data", "energy"}, 100)
end)

ReplicatedStorage:SetAttribute("ServerLoaded", true)