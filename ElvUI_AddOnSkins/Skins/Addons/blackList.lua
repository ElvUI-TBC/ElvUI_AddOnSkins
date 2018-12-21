local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G

-- BlackList 1.2.3

local function LoadSkin()
	if not E.private.addOnSkins.BlackList then return; end

	S:HandleButton(FriendsFrameOptionsButton)
	S:HandleButton(FriendsFrameShareListButton)
	S:HandleButton(FriendsFrameRemovePlayerButton)
	S:HandleButton(FriendsFrameBlacklistPlayerButton)

	FriendFrameToggleTab4:StripTextures()
	FriendFrameToggleTab4:Size(60, 25)
	S:HandleButton(FriendFrameToggleTab4)

	IgnoreFrameToggleTab4:StripTextures()
	IgnoreFrameToggleTab4:Size(60, 25)
	S:HandleButton(IgnoreFrameToggleTab4)

	for i = 1, 4 do
		local tab = _G["BlackListFrameToggleTab"..i]
		local muteTab = _G["MutedFrameToggleTab"..i]

		tab:StripTextures()
		tab:CreateBackdrop("Default", true)
		tab.backdrop:Point("TOPLEFT", 3, -7)
		tab.backdrop:Point("BOTTOMRIGHT", -2, -1)

		tab:HookScript2("OnEnter", S.SetModifiedBackdrop)
		tab:HookScript2("OnLeave", S.SetOriginalBackdrop)

		muteTab:StripTextures()
		muteTab:CreateBackdrop("Default", true)
		muteTab.backdrop:Point("TOPLEFT", 3, -7)
		muteTab.backdrop:Point("BOTTOMRIGHT", -2, -1)

		muteTab:HookScript2("OnEnter", S.SetModifiedBackdrop)
		muteTab:HookScript2("OnLeave", S.SetOriginalBackdrop)
	end

	S:HandleCloseButton(BlackListDetailsCloseButton)

	BlackListDetailsFrame:StripTextures()
	BlackListDetailsFrame:SetTemplate("Transparent")

	BlackListDetailsFrameReasonTextBackground:StripTextures()
	BlackListDetailsFrameReasonTextBackground:CreateBackdrop("Default")

	S:HandleButton(BlackListDetailsEditButton)

	S:HandleCheckBox(BlackListDetailsFrameCheckButton1)
	S:HandleCheckBox(BlackListDetailsFrameCheckButton2)

	S:HandleScrollBar(BlackListDetailsFrameScrollFrameScrollBar)

	BlackListEditDetailsFrame:StripTextures()
	BlackListEditDetailsFrame:SetTemplate("Transparent")

	BlackListEditDetailsFrameLevelBackground:StripTextures()
	BlackListEditDetailsFrameLevelBackground:CreateBackdrop("Default")
	BlackListEditDetailsFrameLevelBackground.backdrop:Point("TOPLEFT", 5, -3)
	BlackListEditDetailsFrameLevelBackground.backdrop:Point("BOTTOMRIGHT", -5, 5)

	S:HandleButton(FriendsFrameMutedPlayerButton)
	S:HandleButton(FriendsFrameUnmuteButton)

	S:HandleButton(BlackListEditDetailsFrameSaveButton)
	S:HandleButton(BlackListEditDetailsFrameCancelButton)

	S:HandleDropDownBox(BlackListEditDetailsFrameClassDropDown)
	S:HandleDropDownBox(BlackListEditDetailsFrameRaceDropDown)

	BlackListOptionsFrame:StripTextures()
	BlackListOptionsFrame:SetTemplate("Transparent")

	S:HandleCheckBox(BlackListOptionsFrameCombatCheckButton)
	S:HandleCheckBox(BlackListOptionsFrameStealthCheckButton)
	S:HandleCheckBox(BlackListOptionsFrameOtherCheckButton)
	S:HandleCheckBox(BlackListOptionsFrameIgnoreCheckButton)

	S:HandleButton(BlackListOptionsFrameClose)
end

S:AddCallbackForAddon("BlackList", "BlackList", LoadSkin)