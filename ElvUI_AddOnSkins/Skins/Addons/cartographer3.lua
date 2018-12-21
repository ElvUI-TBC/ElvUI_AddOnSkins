local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")
local AS = E:GetModule("AddOnSkins")

local select = select

-- Cartographer3 0.9.1

local function NoteFrameSkin()
	if not E.private.addOnSkins.Cartographer3 then return end

	local Cartographer3_Notes = Cartographer3["Notes"]
	if not Cartographer3_Notes then return end

	S:SecureHook(Cartographer3_Notes, "ShowAddNoteFrame", function()
		Cartographer3_Notes_Popup:StripTextures()
		Cartographer3_Notes_Popup:SetTemplate("Transparent")
		select(1, Cartographer3_Notes_Popup:GetChildren()):StripTextures()

		Cartographer3_Notes_Popup_NameEditBox:DisableDrawLayer("BACKGROUND")
		S:HandleEditBox(Cartographer3_Notes_Popup_NameEditBox)

		Cartographer3_Notes_Popup_DescriptionScrollFrame:SetTemplate("Default")

		S:HandleDropDownBox(Cartographer3_Notes_Popup_IconDropDown)

		S:HandleButton(Cartographer3_Notes_Popup_OkayButton)
		S:HandleButton(Cartographer3_Notes_Popup_CancelButton)

		S:Unhook(Cartographer3_Notes, "ShowAddNoteFrame")
	end)
end

local function LoadSkin()
	if not E.private.addOnSkins.Cartographer3 then return end

	Cartographer3.Data.mapFrame:CreateBackdrop("Transparent")
	Cartographer3.Data.mapFrame.backdrop:SetFrameLevel(Cartographer3.Data.mapHolder:GetFrameLevel())
	Cartographer3.Data.mapFrame.bg:Kill()
	Cartographer3.Data.scrollFrame:CreateBackdrop("Transparent")

	Cartographer_MapFrame_CloseButton:Size(32)
	S:HandleCloseButton(Cartographer_MapFrame_CloseButton, Cartographer3.Data.mapFrame)

	S:HandleButton(Cartographer_MapFrame_Button1, true)
	S:HandleButton(Cartographer_MapFrame_Button2, true)
	S:HandleButton(Cartographer_MapFrame_Button3, true)
	S:HandleButton(Cartographer_MapFrame_Button4, true)
	S:HandleButton(Cartographer_MapFrame_Button5, true)

	if E.private.skins.blizzard.enable and E.private.skins.blizzard.worldmap then
		if WorldMapDetailFrame.backdrop and WorldMapPositioningGuide.backdrop then
			WorldMapDetailFrame.backdrop:Hide()
			WorldMapPositioningGuide.backdrop:Hide()
		else
			E:Delay(1, function()
				WorldMapDetailFrame.backdrop:Hide()
				WorldMapPositioningGuide.backdrop:Hide()
			end)
		end
	end

	S:SecureHookScript(Cartographer_MapFrame_Button5, "OnClick", function(self)
		Cartographer_MapFrame_SliderFrame:SetTemplate("Transparent")
		S:HandleSliderFrame(Cartographer_MapFrame_SliderFrame_Slider)

		S:Unhook(self, "OnClick")
	end)
end

S:AddCallbackForAddon("Cartographer3", "Cartographer3", LoadSkin)
S:AddCallbackForAddon("Cartographer3_Notes", "Cartographer3_Notes", NoteFrameSkin)