local BadgeService = game:GetService("BadgeService")
local Players = game:GetService("Players")

local Badges = {
	Welcome = 3734777580417179,
	Beta = 2345307690860716,
	["1Win"] = 1244730256532824,
	["5Wins"] = 1035266526280015,
	["10Wins"] = 67565060255828,
	WinBattleRoyale = 3749591981082606
}

Players.PlayerAdded:Connect(function(plr)
	BadgeService:AwardBadge(plr.UserId, Badges.Welcome)
	--BadgeService:AwardBadge(plr.UserId, Badges.Beta)
	
	if BadgeService:UserHasBadgeAsync(plr.UserId, Badges.Beta) then
		plr:SetAttribute("BetaPlayer", true)
	end
	
	plr:GetAttributeChangedSignal("Wins"):Connect(function()
		if plr:GetAttribute("Wins") == 1 then
			BadgeService:AwardBadge(plr.UserId, Badges["1Win"])
		elseif plr:GetAttribute("Wins") == 5 then
			BadgeService:AwardBadge(plr.UserId, Badges["5Wins"])
		elseif plr:GetAttribute("Wins") == 10 then
			BadgeService:AwardBadge(plr.UserId, Badges["10Wins"])
		end
	end)
end)