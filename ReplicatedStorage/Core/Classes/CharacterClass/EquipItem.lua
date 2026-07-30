-- @ScriptType: ModuleScript
const ReplicatedStorage = game:GetService("ReplicatedStorage")

local EquipItem = {}
EquipItem.__index = EquipItem

const DumbellData = require(game.ReplicatedStorage.Core.Data.DumbellData)

function EquipItem.new(Character: Model, Item: string)
	local self = setmetatable({}, EquipItem)
	self.Item = Item
	self.ItemData = DumbellData[Item]
	self.RightHand = Character.RightHand
	self.ItemClone = ReplicatedStorage.Assets.Dumbells:FindFirstChild(Item):Clone()
	if not self.ItemClone then warn("No item for ".. Item) return end
	
	self.ItemClone.Parent = Character
	
	self.ItemClone:PivotTo(self.RightHand.CFrame)
	
	local Weld = Instance.new("WeldConstraint")
	Weld.Part0 = self.RightHand
	Weld.Part1 = self.ItemClone.Handle	
	
	Weld.Parent = self.RightHand
	
	self.Weld = Weld
	
	return self
end

function EquipItem:End()
	self.ItemClone:Destroy()
	self.Weld:Destroy()
end

return EquipItem
