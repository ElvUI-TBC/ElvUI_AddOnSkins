local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local function LoadSkin()
	if not E.private.addOnSkins.EQCompare then return end

	EQCompareTooltip1:SetTemplate("Transparent")
	EQCompareTooltip2:SetTemplate("Transparent")
end

S:AddCallbackForAddon("EQCompare", "EQCompare", LoadSkin)