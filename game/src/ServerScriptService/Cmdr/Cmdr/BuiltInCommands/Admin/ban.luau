return {
	Name = "ban",
	Description = "Bans a user using the Roblox Ban API. (eg. ban Ransomwavee 1{s,m,h,d,perm} Exploiting)",
	Group = "DefaultAdmin",
	Args = {
		{ Name = "Target", Type = "player" },
		{ Name = "Duration", Type = "string", Optional = true },
		{ Name = "Reason", Type = "string", Optional = true },
	},
}
