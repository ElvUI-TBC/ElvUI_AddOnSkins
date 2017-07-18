local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local function LoadSkin()
	if not E.private.addOnSkins.EnergyWatch_v2 then return end

	EnergyWatchBar:StripTextures()

	EnergyWatchSpark:Kill()

	EnergyWatchFrameStatusBar:CreateBackdrop()
	EnergyWatchFrameStatusBar:SetStatusBarTexture(E["media"].normTex)

	EnergyWatchText:ClearAllPoints()
	EnergyWatchText:Point("CENTER", EnergyWatchFrameStatusBar, "CENTER", 0, 1)
end

S:AddCallbackForAddon("EnergyWatch_v2", "EnergyWatch_v2", LoadSkin)