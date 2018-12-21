local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G

-- CallToArms r13

local function LoadSkin()
	if not E.private.addOnSkins.CallToArms then return end

	CTA_MainFrame:StripTextures()
	CTA_MainFrame:SetTemplate("Transparent")
	CTA_MainFrame:Height(CTA_MainFrame:GetHeight() + 20)

	CTA_SearchFrame_Filters_PlayerInternalFrame:StripTextures()
	CTA_SearchFrame_Filters_PlayerInternalFrame:SetTemplate("Transparent")

	CTA_SearchFrame_Filters_GroupInternalFrame:StripTextures()
	CTA_SearchFrame_Filters_GroupInternalFrame:SetTemplate("Transparent")

	CTA_SettingsFrameMinimapSettings:StripTextures()
	CTA_SettingsFrameMinimapSettings:SetTemplate("Transparent")

	CTA_SettingsFrameLFxSettings:StripTextures()
	CTA_SettingsFrameLFxSettings:SetTemplate("Transparent")

	CTA_LogFrameInternalFrame:StripTextures()
	CTA_LogFrameInternalFrame:SetTemplate("Transparent")

	CTA_GreyListItemEditFrame:StripTextures()
	CTA_GreyListItemEditFrame:SetTemplate("Transparent")

	for i = 0, 8 do
		local frame = _G["CTA_Acid"..i.."barBorder"]

		frame:StripTextures()
		frame:SetTemplate("Transparent")
	end

	CTA_AcidEditDialog:StripTextures()
	CTA_AcidEditDialog:SetTemplate("Default")

	S:HandleDropDownBox(CTA_SearchDropDown)
	S:HandleDropDownBox(CTA_PlayerClassDropDown)
	S:HandleDropDownBox(CTA_RoleplayDropDown)

	S:HandleCloseButton(CTA_MainFrameCloseButton)

	S:HandleNextPrevButton(CTA_SearchFrame_ResultsPrev)
	S:HandleNextPrevButton(CTA_SearchFrame_ResultsNext)
	S:HandleNextPrevButton(CTA_GreyListFramePrev)
	S:HandleNextPrevButton(CTA_GreyListFrameNext)
	S:HandleNextPrevButton(CTA_LogUpButton)
	S:HandleNextPrevButton(CTA_LogDownButton, true)
	S:HandleNextPrevButton(CTA_LogBottomButton, true)

	local callToArmsTabs = {
		"CTA_ShowSearchButton",
		"CTA_ShowMyRaidButton",
		"CTA_ShowMFFButton",
		"CTA_ShowLFGButton"
	}

	for i = 1, #callToArmsTabs do
		S:HandleTab(_G[callToArmsTabs[i]])
		_G[callToArmsTabs[i].."Text"]:Point("CENTER", 0, 1)
	end

	CTA_ShowResultsButton:StripTextures()
	S:HandleButton(CTA_ShowResultsButton)

	CTA_ShowOptionsButton:StripTextures()
	S:HandleButton(CTA_ShowOptionsButton)

	S:HandleButton(CTA_SearchButton)
	S:HandleButton(CTA_RequestInviteButton)

	CTA_ShowBlacklistButton:StripTextures()
	S:HandleButton(CTA_ShowBlacklistButton)

	CTA_SettingsFrameButton:StripTextures()
	S:HandleButton(CTA_SettingsFrameButton)

	CTA_LogFrameButton:StripTextures()
	S:HandleButton(CTA_LogFrameButton)

	S:HandleButton(CTA_GreyListItemEditFrameDeleteButton)
	S:HandleButton(CTA_GreyListItemEditFrameCloseButton)
	S:HandleButton(CTA_GreyListItemEditFrameEditButton)
	S:HandleButton(CTA_AddPlayerButton)
	S:HandleButton(CTA_AnnounceToLFGButton)
	S:HandleButton(CTA_AnnounceToLFGButton2)
	S:HandleButton(CTA_StopHostingButton)
	S:HandleButton(CTA_ToggleViewableButton)
	S:HandleButton(CTA_StartAPartyButton)
	S:HandleButton(CTA_StartARaidButton)
	S:HandleButton(CTA_Acid1DeleteButton)
	S:HandleButton(CTA_Acid2DeleteButton)
	S:HandleButton(CTA_Acid3DeleteButton)
	S:HandleButton(CTA_Acid4DeleteButton)
	S:HandleButton(CTA_Acid5DeleteButton)
	S:HandleButton(CTA_Acid6DeleteButton)
	S:HandleButton(CTA_Acid7DeleteButton)
	S:HandleButton(CTA_Acid8DeleteButton)
	S:HandleButton(CTA_AcidEditDialogCloseButton)
	S:HandleButton(CTA_AcidEditDialogOkButton)

	CTA_SearchFrameDescriptionEditBox:StripTextures()
	S:HandleEditBox(CTA_SearchFrameDescriptionEditBox)

	CTA_GreyListItemEditFrameEditBox:StripTextures()
	S:HandleEditBox(CTA_GreyListItemEditFrameEditBox)

	CTA_PlayerMinLevelEditBox:StripTextures()
	S:HandleEditBox(CTA_PlayerMinLevelEditBox)

	CTA_PlayerMaxLevelEditBox:StripTextures()
	S:HandleEditBox(CTA_PlayerMaxLevelEditBox)

	CTA_ChatFrameNumberEditBox:StripTextures()
	S:HandleEditBox(CTA_ChatFrameNumberEditBox)

	CTA_MyRaidFrameDescriptionEditBox:StripTextures()
	S:HandleEditBox(CTA_MyRaidFrameDescriptionEditBox)

	CTA_MyRaidFrameMaxSizeEditBox:StripTextures()
	S:HandleEditBox(CTA_MyRaidFrameMaxSizeEditBox)

	CTA_MyRaidFrameMinLevelEditBox:StripTextures()
	S:HandleEditBox(CTA_MyRaidFrameMinLevelEditBox)

	CTA_MyRaidFramePasswordEditBox:StripTextures()
	S:HandleEditBox(CTA_MyRaidFramePasswordEditBox)

	CTA_LFGDescriptionEditBox:StripTextures()
	S:HandleEditBox(CTA_LFGDescriptionEditBox)

	S:HandleSliderFrame(CTA_MinimapArcSlider)
	S:HandleSliderFrame(CTA_MinimapRadiusSlider)
	S:HandleSliderFrame(CTA_MinimapMsgArcSlider)
	S:HandleSliderFrame(CTA_MinimapMsgRadiusSlider)
	S:HandleSliderFrame(CTA_FrameTransparencySlider)
	S:HandleSliderFrame(CTA_FilterLevelSlider)

	CTA_ShowSearchButton:StripTextures()
	CTA_ShowSearchButton:ClearAllPoints()
	CTA_ShowSearchButton:SetFrameLevel(CTA_MainFrame:GetFrameLevel() + 20)
	CTA_ShowSearchButton:Point("BOTTOMLEFT", 0, -30)

	CTA_ShowMyRaidButton:StripTextures()
	CTA_ShowMyRaidButton:ClearAllPoints()
	CTA_ShowMyRaidButton:SetFrameLevel(CTA_MainFrame:GetFrameLevel() + 20)
	CTA_ShowMyRaidButton:Point("LEFT", CTA_ShowSearchButton, "RIGHT", 0, 0)

	CTA_ShowLFGButton:StripTextures()
	CTA_ShowLFGButton:ClearAllPoints()
	CTA_ShowLFGButton:SetFrameLevel(CTA_MainFrame:GetFrameLevel() + 20)
	CTA_ShowLFGButton:Point("LEFT", CTA_ShowMyRaidButton, "RIGHT", 0, 0)

	CTA_ShowMFFButton:StripTextures()
	CTA_ShowMFFButton:ClearAllPoints()
	CTA_ShowMFFButton:SetFrameLevel(CTA_MainFrame:GetFrameLevel() + 20)
	CTA_ShowMFFButton:Point("BOTTOMRIGHT", 0, -30)

	local callToArmsConfigCheck = {
		"CTA_MuteLFGChannelCheckButton",
		"CTA_ShowFilteredMessagesInChatCheckButton",
		"CTA_ShowOnMinimapCheckButton",
		"CTA_PlaySoundOnNewResultCheckButton",
		"CTA_MyRaidFramePVPCheckButton",
		"CTA_MyRaidFramePVECheckButton",
		"CTA_LFGCheckButton",
		"CTA_AcidClassCheckButton1",
		"CTA_AcidClassCheckButton2",
		"CTA_AcidClassCheckButton3",
		"CTA_AcidClassCheckButton4",
		"CTA_AcidClassCheckButton5",
		"CTA_AcidClassCheckButton6",
		"CTA_AcidClassCheckButton7",
		"CTA_AcidClassCheckButton8"
	}

	for i = 1, #callToArmsConfigCheck do
		S:HandleCheckBox(_G[callToArmsConfigCheck[i]])
	end
end

S:AddCallbackForAddon("CallToArms", "CallToArms", LoadSkin)