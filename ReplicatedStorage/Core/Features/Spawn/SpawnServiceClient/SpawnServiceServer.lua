-- @ScriptType: ModuleScript
const ReplicatedStorage = game:GetService("ReplicatedStorage")
const Players = game:GetService("Players")
const RunService = game:GetService("RunService")

const networker = require(ReplicatedStorage.Shared.networker)
const DataService = require(ReplicatedStorage.Packages.DataService).server
const FruitData = require(ReplicatedStorage.Core.Data.FruitData)

local SpawnServiceServer = {}
SpawnServiceServer.__index = SpawnServiceServer

const Max = 15
const SpawnCooldown = 2
const CollectDistance = 6
const RotationSpeed = 60
const SpawnZone = workspace.SpawnZones.Spawn

function SpawnServiceServer:GetRandomPosition()
	local Size = SpawnZone.Size
	local Position = SpawnZone.Position

	return Position + Vector3.new(
		(math.random() - 0.5) * Size.X,
		(Size.Y * 0.5) + 1,
		(math.random() - 0.5) * Size.Z
	)
end


function SpawnServiceServer:SpawnFruit()
	local Templates = ReplicatedStorage.Assets.Fruits:GetChildren()

	if #Templates == 0 then
		return
	end

	local Fruit = Templates[math.random(#Templates)]:Clone()
	Fruit.Position = self:GetRandomPosition()
	Fruit.Parent = workspace

	self.Current += 1

	local Connection
	Connection = RunService.Heartbeat:Connect(function(dt)
		if not Fruit.Parent then
			Connection:Disconnect()
			return
		end

		Fruit.CFrame *= CFrame.Angles(0,math.rad(RotationSpeed * dt),0)

		for _, Player in Players:GetPlayers() do
			local Character = Player.Character
			local Root = Character and Character:FindFirstChild("HumanoidRootPart")

			if Root and (Root.Position - Fruit.Position).Magnitude <= CollectDistance then
				Connection:Disconnect()
				self.Current -= 1

				self:OnCollect(Player, Fruit)

				Fruit:Destroy()
				return
			end
		end
	end)
end


function SpawnServiceServer:OnCollect(Player: Player, Fruit: Instance)
	local PickedFruitTable = FruitData[Fruit.Name]
	local EnergyGivenAmount = PickedFruitTable.EnergyGiven
	
	local Updated = DataService:update(Player, {"data", "energy"}, function(NewValue)
		return NewValue + EnergyGivenAmount
	end)
	
	networker.ReplicateFruitPickUp:FireClient(Player,Fruit.Position, Fruit.Name)
end


function SpawnServiceServer:init()
	local self = setmetatable({Current = 0,}, SpawnServiceServer)

	task.spawn(function()
		while true do
			task.wait(SpawnCooldown)

			if self.Current < Max then
				self:SpawnFruit()
			end
		end
	end)

	return self
end


return SpawnServiceServer