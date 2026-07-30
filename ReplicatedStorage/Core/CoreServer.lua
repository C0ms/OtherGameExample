-- @ScriptType: ModuleScript
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local RunService = game:GetService("RunService")

if RunService:IsClient() then
	return {} :: CoreServer
end

local CoreServer = {}
CoreServer.__index = CoreServer

local Started = false

local FeatureRoot = ServerStorage:WaitForChild("src")
local FeaturesFolder = FeatureRoot:WaitForChild("Features")

local ServerModules = {}

function CoreServer:Init()
	if Started then
		return
	end

	Started = true

	local Root = ReplicatedStorage:WaitForChild("Core")

	for _, moduleScript in Root:GetDescendants() do
		if not moduleScript:IsA("ModuleScript") then
			continue
		end

		if CollectionService:HasTag(moduleScript, "ServerModule") then
			local featureFolder = moduleScript.Parent

			while featureFolder.Parent ~= Root do
				featureFolder = featureFolder.Parent
			end

			local destination = FeaturesFolder:FindFirstChild(featureFolder.Name)

			if not destination then
				destination = Instance.new("Folder")
				destination.Name = featureFolder.Name
				destination.Parent = FeaturesFolder
			end

			moduleScript.Parent = destination
			table.insert(ServerModules, moduleScript)
		end
	end
end

export type CoreServer = typeof(CoreServer)

return CoreServer