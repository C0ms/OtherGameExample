-- @ScriptType: ModuleScript
const ReplicatedStorage = game:GetService("ReplicatedStorage")
const Players = game:GetService("Players")
const RunService = game:GetService("RunService")

const networker = require(ReplicatedStorage.Shared.networker)

local Player = Players.LocalPlayer

local SpawnServiceClient = {}
SpawnServiceClient.__index = SpawnServiceClient

local function Bezier(A, B, C, T)
	local AB = A:Lerp(B, T)
	local BC = B:Lerp(C, T)

	return AB:Lerp(BC, T)
end

function SpawnServiceClient:CollectFruit(Position, FruitName)
	local Character = Player.Character
	local HRP = Character and Character:FindFirstChild("HumanoidRootPart")
	if not HRP then return end

	local Template = ReplicatedStorage.Assets.Fruits:FindFirstChild(FruitName)
	if not Template then return end

	local Fruit = Template:Clone()
	Fruit.Parent = workspace
	Fruit.CFrame = CFrame.new(Position)

	local Start = Position
	local Control = (Start + HRP.Position) / 2 + Vector3.new(0, 10, 0)

	local Duration = 0.45
	local Time = 0

	local Connection
	Connection = RunService.RenderStepped:Connect(function(dt)
		Time += dt

		local Alpha = math.min(Time / Duration, 1)

		Fruit.CFrame = CFrame.new(Bezier(Start, Control, HRP.Position, Alpha)) * Fruit.CFrame.Rotation
		Fruit.CFrame *= CFrame.Angles(0, math.rad(180 * dt), 0)

		if Alpha >= 1 then
			-- REPLACE WITH MODULE LATER
			local Sound = Instance.new("Sound")
			Sound.SoundId = "rbxassetid://136650469995272"
			Sound.Volume = 1
			Sound.Parent = HRP
			Sound.RollOffMaxDistance = 500
			Sound:Play()

			Sound.Ended:Connect(function()
				Sound:Destroy()
			end)
			
			Connection:Disconnect()
			Fruit:Destroy()
		end
	end)
end

function SpawnServiceClient:init()
	networker.ReplicateFruitPickUp.OnClientEvent:Connect(function(Position, FruitName)
		self:CollectFruit(Position, FruitName)
	end)
end

return SpawnServiceClient