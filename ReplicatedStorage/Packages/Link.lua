-- @ScriptType: ModuleScript
export type Link = {
	Name: string,
	Bindable: BindableEvent,
	Connections: { RBXScriptConnection },
	Fire: (self: Link, ...any) -> (),
	OnReceive: (self: Link, callback: (...any) -> ()) -> RBXScriptConnection,
	Once: (self: Link, callback: (...any) -> ()) -> (),
	Wait: (self: Link) -> ...any,
	DisconnectAll: (self: Link) -> (),
	Destroy: (self: Link) -> (),
}

local Link = {}
Link.__index = Link

Link.Types = {
	String = "string",
	Number = "number",
	Instance = "Instance",
	Boolean = "boolean",
	Table = "table",
	Any = "any",
}

for k, v in Link.Types do
	Link[k] = v
end

local registry = {}

local function safeDestroy(event: BindableEvent?)
	if event and event.Destroy then
		pcall(function()
			event:Destroy()
		end)
	end
end

function Link.new(name: string, ...: string): Link
	local existing = registry[name]
	if existing then
		return existing
	end

	local self: Link = setmetatable({
		Name = name,
		Types = table.pack(...),
		Bindable = Instance.new("BindableEvent"),
		Connections = {},
	}, Link)

	registry[name] = self

	return self
end

setmetatable(Link, {
	__call = function(_, name: string, ...: string)
		return Link.new(name, ...)
	end,
})

function Link.Send(linkName: string, ...: any)
	local link = registry[linkName]
	if not link then
		warn("[Link] '" .. tostring(linkName) .. "' does not exist")
		return
	end

	link:Fire(...)
end

function Link:Fire(...: any)
	if self.Bindable then
		self.Bindable:Fire(...)
	end
end

function Link:OnReceive(callback: (...any) -> ()): RBXScriptConnection
	if not self.Bindable then
		error("[Link] '" .. self.Name .. "' missing BindableEvent")
	end

	local connection = self.Bindable.Event:Connect(callback)
	self.Connections[#self.Connections + 1] = connection

	return connection
end

function Link:Once(callback: (...any) -> ())
	if not self.Bindable then
		error("[Link] '" .. self.Name .. "' missing BindableEvent")
	end

	local connection
	connection = self.Bindable.Event:Connect(function(...)
		if connection then
			connection:Disconnect()
		end
		callback(...)
	end)

	self.Connections[#self.Connections + 1] = connection
end

function Link:Wait(): ...any
	if not self.Bindable then
		error("[Link] '" .. self.Name .. "' missing BindableEvent")
	end

	return self.Bindable.Event:Wait()
end

function Link:DisconnectAll()
	for i, conn in self.Connections do
		if conn and conn.Disconnect then
			conn:Disconnect()
		end
	end

	table.clear(self.Connections)
end

function Link:Destroy()
	self:DisconnectAll()
	safeDestroy(self.Bindable)

	registry[self.Name] = nil
	setmetatable(self, nil)
end

return Link