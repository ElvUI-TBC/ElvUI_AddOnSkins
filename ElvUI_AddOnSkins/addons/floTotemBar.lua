local E, L, V, P, G, _ = unpack(ElvUI);
local S = E:GetModule("Skins");

local function LoadSkin()
	if(not E.private.addOnSkins.FloTotemBar) then return; end

	local AB = E:GetModule("ActionBars")

	FloBarTRAP:SetTemplate("Default");
	for i = 1, 10 do
		local button = _G["FloBarTRAPButton" .. i];
		AB:StyleButton(button);
	end

	for i = 1, 3 do
		local countdown = _G["FloBarTRAPCountdown" .. i];
		countdown:SetStatusBarTexture(E["media"].normTex);
		E:RegisterStatusBar(countdown);
	end
end

S:AddCallbackForAddon("FloTotemBar", "FloTotemBar", LoadSkin);