-- @ScriptType: ModuleScript
export type Connection = {
	Disconnect: () -> (),
}

export type Link = {
	Send: (...any) -> (),
	OnReceive: (callback: (...any) -> ()) -> Connection,
	Wait: (timeout: number?) -> (...any)?,
	Destroy: () -> (),
}

return {}