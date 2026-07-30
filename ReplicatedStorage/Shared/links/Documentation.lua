-- @ScriptType: Script
--[[
Module Features
Works like BindableEvent, but more efficient.

Global link registry to avoid duplicate creation.

Automatic connection tracking and safe cleanup.

Type flexibility (Link.String, Link.Number, etc.).

Built-in :Once, :Wait, and :DisconnectAll helpers.


Creating and Using a Link

local Link = require(ReplicatedStorage.Shared.Link)

-- Create or get an existing link
local MyLink = Link("MyLink", Link.String, Link.Number)

If a link with the same name already exists, it automatically returns the existing one instead of creating a new one.



Sending Data

You can send data through a link using :Fire(...) or Link.Send(name, ...).
-- Using the instance directly
MyLink:Fire("Hello", 42)

-- Or using the global shortcut
Link.Send("MyLink", "Hello", 42)



Receiving Data

You can listen for link messages using :OnReceive().
MyLink:OnReceive(function(message: string, number: number)
	print("Received:", message, number)
end)

This returns an RBXScriptConnection, which can be disconnected if needed.

]]