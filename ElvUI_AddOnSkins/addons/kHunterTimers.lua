local E, L, V, P, G, _ = unpack(ElvUI);
local S = E:GetModule("Skins");

local function LoadSkin()
	if(not E.private.addOnSkins.KHunterTimers) then return; end

	KHunterTimersAnchor:StripTextures();
	KHunterTimersAnchor:SetTemplate("Transparent");
	KHunterTimersFrame:StripTextures();
	KHunterTimersFrame:CreateBackdrop("Transparent");
	KHunterTimersOptions:StripTextures();
	KHunterTimersOptions:SetTemplate("Transparent");
	KHunterTimersOptionsTimers:StripTextures();
	KHunterTimersOptionsTimers:SetTemplate("Transparent");
	KHunterTimersOptionsBars:StripTextures();
	KHunterTimersOptionsBars:SetTemplate("Transparent");

	S:HandleButton(KHunterTimersOptionsButtonOkay);
	S:HandleButton(KHunterTimersOptionsButtonApply);
	S:HandleButton(KHunterTimersOptionsButtonCancel);

	S:HandleSliderFrame(KHunterTimersOptionsBarsSlider1Slider);
	S:HandleSliderFrame(KHunterTimersOptionsBarsSlider2Slider);
	S:HandleSliderFrame(KHunterTimersOptionsBarsSlider3Slider);
	S:HandleSliderFrame(KHunterTimersOptionsBarsSlider4Slider);
	S:HandleSliderFrame(KHunterTimersOptionsBarsSlider5Slider);
	S:HandleSliderFrame(KHunterTimersOptionsBarsSlider6Slider);
	S:HandleSliderFrame(KHunterTimersOptionsBarsSlider7Slider);

	KHunterTimersOptionsBarsEditBox1:StripTextures();
	KHunterTimersOptionsBarsEditBox1:Height(22);
	S:HandleEditBox(KHunterTimersOptionsBarsEditBox1);

	S:HandleCheckBox(KHunterTimersOptionsBarsCheckButtonOn)

	for i = 1, 11 do
		S:HandleCheckBox(_G["KHunterTimersOptionsBarsCheckButton"..i])
	end

	for i = 1, 33 do
		S:HandleCheckBox(_G["KHunterTimersOptionsTimersCheckButton"..i])
	end
end

S:AddCallbackForAddon("KHunterTimers", "KHunterTimers", LoadSkin);