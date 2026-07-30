-- @ScriptType: ModuleScript
local CharacterClass = {}
CharacterClass.__index = CharacterClass

local DataService = require(game.ReplicatedStorage.Packages.DataService).server
const EquipItem = require(script.EquipItem)

function CharacterClass.new(Character: Model)
	local self = setmetatable({}, CharacterClass)
	self.Character = Character
	self.Player = game.Players:GetPlayerFromCharacter(Character)
	
	DataService:waitForData(self.Player)
	
	self.InitValue = DataService:get(self.Player, {"data", "EquippedDumbell"})
	self.CurrentItem = EquipItem.new(self.Character, self.InitValue)

	DataService:getChangedSignal(self.Player, {"data", "EquippedDumbell"}, function(NewValue)
		self.CurrentItem:End()
		self.CurrentItem = EquipItem.new(self.Character, NewValue)
	end)

	return self
end

return CharacterClass
