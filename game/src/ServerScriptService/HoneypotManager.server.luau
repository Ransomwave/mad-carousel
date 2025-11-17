local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Honeypot remotes manager

ReplicatedStorage.Events.CashShop.GiveAllItems.OnServerEvent:Connect(function(plr)
	warn(`Player {plr} ({plr.UserId}) fired honeypot remote: GiveAllItems`)
	Players:BanAsync({
		UserIds = {plr.UserId},
		Duration = -1,
		DisplayReason = "If you believe this was a mistake, please contact us through our server.",
		PrivateReason = "Exploiting, fired honeypot remote 'GiveAllItems'.",
		ExcludeAltAccounts = false,
		ApplyToUniverse = true
	})
end)

ReplicatedStorage.Events.CashShop.UnlockAll.OnServerEvent:Connect(function(plr)
	warn(`Player {plr} ({plr.UserId}) fired honeypot remote: UnlockAll`)
	Players:BanAsync({
		UserIds = {plr.UserId},
		Duration = -1,
		DisplayReason = "If you believe this was a mistake, please contact us through our server.",
		PrivateReason = "Exploiting, fired honeypot remote 'UnlockAll'.",
		ExcludeAltAccounts = false,
		ApplyToUniverse = true
	})
end)

ReplicatedStorage.Events.CashShop.Admin_GiveMoney.OnServerEvent:Connect(function(plr)
	warn(`Player {plr} ({plr.UserId}) fired honeypot remote: Admin_GiveMoney`)
	Players:BanAsync({
		UserIds = {plr.UserId},
		Duration = -1,
		DisplayReason = "If you believe this was a mistake, please contact us through our server.",
		PrivateReason = "Exploiting, fired honeypot remote 'Admin_GiveMoney'.",
		ExcludeAltAccounts = false,
		ApplyToUniverse = true
	})
end)