-- @ScriptType: ModuleScript
local Packet = require(game.ReplicatedStorage.Packages.Packet)

return {
	-- Client > Server
	RequestTrain = Packet("RequestTrain"),
	
	-- Server > Client
	ReplicateLiftAnimation = Packet("ReplicateLiftAnimation"),
	ReplicateStrengthGiven = Packet("ReplicateStrengthGiven", Packet.NumberU16),
	ReplicateFruitPickUp = Packet("ReplicateFruitPickUp", Packet.Vector3F32, Packet.String),
	
	-- DEBUG
	
	GiveEnergy = Packet("GiveEnergy")
}