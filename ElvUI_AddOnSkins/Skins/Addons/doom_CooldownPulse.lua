local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")
local AS = E:GetModule("AddOnSkins")

-- Doom_CooldownPulse 1.1.3

local select, unpack = select, unpack

local function LoadSkin()
	if not E.private.addOnSkins.Doom_CooldownPulse then return end

	local frame = AS:FindFrameByPoint("CENTER", UIParent, "BOTTOMLEFT", DCP_Saved.x, DCP_Saved.y)
	if not frame then return end

	Doom_CooldownPulse = frame
	frame:SetTemplate()
	frame.icon = select(1, frame:GetRegions())

	frame.icon:SetParent(frame)
	frame.icon:SetDrawLayer("ARTWORK")
	frame.icon:SetInside()
	frame.icon:SetTexCoord(unpack(E.TexCoords))

	hooksecurefunc(frame.icon, "SetTexture", function(self)
		if not self:GetTexture() then
			self:GetParent():SetAlpha(0)
		end
	end)

	hooksecurefunc(frame, "CreateOptionsFrame", function()
		DCP_OptionsFrame:SetScale(GetCVar("uiScale"))

		DCP_OptionsFrame:StripTextures()
		DCP_OptionsFrame:SetTemplate("Transparent")

		S:HandleSliderFrame(DCP_OptionsFrameSlider1)
		S:HandleSliderFrame(DCP_OptionsFrameSlider2)
		S:HandleSliderFrame(DCP_OptionsFrameSlider3)
		S:HandleSliderFrame(DCP_OptionsFrameSlider4)
		S:HandleSliderFrame(DCP_OptionsFrameSlider5)
		S:HandleSliderFrame(DCP_OptionsFrameSlider6)

		S:HandleButton(DCP_OptionsFrameButton1)
		S:HandleButton(DCP_OptionsFrameButton2)
		S:HandleButton(DCP_OptionsFrameButton3)
		S:HandleButton(DCP_OptionsFrameButton4)
	end)
end

S:AddCallbackForAddon("Doom_CooldownPulse", "Doom_CooldownPulse", LoadSkin)