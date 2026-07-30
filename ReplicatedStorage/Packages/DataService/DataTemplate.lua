-- @ScriptType: ModuleScript
export type stats = {
	timePlayed : number,
	RobuxSpent : number,
}

export type settings = {
	MusicVolume : number,
	SfxVolume : number,
}

export type tutorial = {
	CompletedTutorial : boolean,	
}

export type data = {
	currency: number,
	strength: number,
	energy: number,
	EquippedDumbell : string
}

export type buffs = {
	TwoXStrength : number,
}

return {
	data = {
		currency = 0,
		strength = 0,
		energy = 0,
		EquippedDumbell = "Basic"
	};
	
	buffs = {
		TwoXStrength = 0,
	};
	
	stats = {
		RobuxSpent = 0,
		timePlayed = 0,
	};

	settings = {
		MusicVolume = 1,
		SfxVolume = 1,
	};
}