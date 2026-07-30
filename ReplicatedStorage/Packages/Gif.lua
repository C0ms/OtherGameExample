-- @ScriptType: ModuleScript
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Vide = require(ReplicatedStorage.Packages.Vide)

local function getFrameIndexFromTime(props, time)
	local totalFrames = ((if type(props.TotalFrames) ~= "function" then props.TotalFrames else props.TotalFrames())) or 1
	local startFrame = ((if type(props.StartFrame) ~= "function" then props.StartFrame else props.StartFrame())) or 1
	local endFrame = math.min(((if type(props.EndFrame) ~= "function" then props.EndFrame else props.EndFrame())) or totalFrames, totalFrames)
	local fps = math.max(((if type(props.FPS) ~= "function" then props.FPS else props.FPS())) or 12, 0.001)

	local loopedValue = props.Looped
	local looped

	if ((if type(loopedValue) ~= "function" then loopedValue else loopedValue())) == nil then
		looped = true
	else
		local loopedValue2 = props.Looped
		looped = if type(loopedValue2) ~= "function" then loopedValue2 else loopedValue2()
	end

	local inOut = props.InOut
	local useInOut = ((if type(inOut) ~= "function" then inOut else inOut())) == true

	local frameCount = math.max(endFrame - startFrame + 1, 1)
	local frameIndex = math.floor(time * fps)

	if useInOut then
		if frameCount == 1 then
			return startFrame
		end

		local cycleLength = (frameCount - 1) * 2
		local step = if not looped then math.min(frameIndex, cycleLength) else frameIndex % cycleLength

		if step < frameCount then
			return startFrame + step
		end

		return endFrame - (step - (frameCount - 1))
	end

	if looped then
		return startFrame + frameIndex % frameCount
	end

	return math.min(startFrame + frameIndex, endFrame)
end

return function(props)
	local timeSource = Vide.source(0)
	local hasExternalTime = props.Time ~= nil

	local frameIndex = Vide.derive(function()
		local currentTime

		if hasExternalTime then
			local timeValue = props.Time
			currentTime = ((if type(timeValue) ~= "function" then timeValue else timeValue())) or 0
		else
			currentTime = timeSource()
		end

		return getFrameIndexFromTime(props, currentTime)
	end)

	if not hasExternalTime then
		Vide.effect(function()
			local connection = RunService.Heartbeat:Connect(function(dt)
				timeSource(timeSource() + dt)
			end)

			Vide.cleanup(function()
				connection:Disconnect()
			end)
		end)
	end

	local frameOffset = Vide.derive(function()
		local currentFrame = frameIndex()

		local frameSize = ((if type(props.FrameSize) ~= "function" then props.FrameSize else props.FrameSize())) or Vector2.zero
		local framesPerRow = math.max(((if type(props.FramesPerRow) ~= "function" then props.FramesPerRow else props.FramesPerRow())) or 1, 1)

		local index = currentFrame - 1
		local x = index % framesPerRow
		local y = math.floor(index / framesPerRow)

		return Vector2.new(x * frameSize.X, y * frameSize.Y)
	end)

	return Vide.create("ImageLabel")({
		Name = props.Name,
		Active = props.Active,
		BackgroundTransparency = props.BackgroundTransparency,
		Size = props.Size,
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,
		ScaleType = props.ScaleType,
		BackgroundColor3 = props.BackgroundColor3,
		ClipsDescendants = props.ClipsDescendants,
		LayoutOrder = props.LayoutOrder,
		ZIndex = props.ZIndex,
		Visible = props.Visible,
		Rotation = props.Rotation,
		SizeConstraint = props.SizeConstraint,
		AutomaticSize = props.AutomaticSize,

		Image = props.Image,
		ImageColor3 = props.ImageColor3,
		ImageTransparency = props.ImageTransparency,

		ImageRectSize = props.FrameSize,
		ImageRectOffset = frameOffset,

		SliceCenter = props.SliceCenter,
		TileSize = props.TileSize,
	})
end