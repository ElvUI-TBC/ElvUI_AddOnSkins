local E, L, V, P, G, _ = unpack(ElvUI);
local S = E:GetModule("Skins");

local function LoadSkin()
	if(not E.private.addOnSkins.FlightMap) then return; end

	FlightMapTimesFrame:StripTextures();
	FlightMapTimesFrame:CreateBackdrop("Default");

	FlightMapTimesFrame:SetStatusBarTexture(E.media.glossTex);
	E:RegisterStatusBar(FlightMapTimesFrame);

	FlightMapTimesText:ClearAllPoints();
	FlightMapTimesText:Point("CENTER", FlightMapTimesFrame, "CENTER", 0, 0);
end

S:AddCallbackForAddon("FlightMap", "FlightMap", LoadSkin);