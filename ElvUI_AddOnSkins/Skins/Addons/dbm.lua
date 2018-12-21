local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G

-- DBM 1.25

local function LoadSkin()
	if not E.private.addOnSkins.DBM then return; end

	-- DBM Boss Mod Frame
	DBMBossModFrame:StripTextures()
	DBMBossModFrame:CreateBackdrop("Transparent")
	DBMBossModFrame.backdrop:Point("TOPLEFT", 10, -12)
	DBMBossModFrame.backdrop:Point("BOTTOMRIGHT", -31, 75)

	DBMBossModFrameDBMBossModScrollFrame:StripTextures()
	DBMBossModFrameDBMBossModScrollFrame:CreateBackdrop("Default")

	S:HandleScrollBar(DBMBossModFrameDBMBossModScrollFrameScrollBar)

	S:HandleButton(DBMBossModFrameLoadBossModsButton)
	DBMBossModFrameLoadBossModsButton:Point("RIGHT", DBMBossModFrameDropDownLevel, "LEFT", 0, 3)

	S:HandleButton(DBMBossModFrameOptionsButton)

	S:HandleDropDownBox(DBMBossModFrameDropDownLevel)
	DBMBossModFrameDropDownLevel:Point("RIGHT", DBMBossModFrameOptionsButton, "LEFT", -14, -3)

	S:HandleButton(DBMBossModListFrameLoadAddOns)

	for i = 1, 4 do
		S:HandleButton(_G["DBMBossModListFrameButton" .. i])
	end

	S:HandleCloseButton(DBMBossModFrameCloseButton)

	-- DBM Options Frame
	DBMOptionsFrame:StripTextures()
	DBMOptionsFrame:SetTemplate("Transparent")
	DBMOptionsFrame:Point("TOPLEFT", DBMBossModFrame, "TOPRIGHT", -30, -12)

	S:HandleCloseButton(DBMOptionsFrameCloseButton)

	for i = 1, 6 do
		_G["DBMOptionsFramePage"..i]:StripTextures()

		S:HandleTab(_G["DBMOptionsFrameTab"..i])
		S:HandleTab(_G["DBMBossModFrameTab"..i])
	end

	-- General
	S:HandleCheckBox(DBMOptionsFramePage1OptionSyncEnable)
	S:HandleCheckBox(DBMOptionsFramePage1OptionSyncOldEnable)
	S:HandleCheckBox(DBMOptionsFramePage1ButtonEnableAggroAlert)
	S:HandleCheckBox(DBMOptionsFramePage1ButtonSoundAggro)
	S:HandleCheckBox(DBMOptionsFramePage1ButtonFlashAggro)
	S:HandleCheckBox(DBMOptionsFramePage1ButtonShakeAggro)
	S:HandleCheckBox(DBMOptionsFramePage1ButtonSpecialWarningAggro)
	S:HandleCheckBox(DBMOptionsFramePage1ButtonLocalWarningAggro)
	S:HandleCheckBox(DBMOptionsFramePage1ButtonPartyAggro)
	S:HandleCheckBox(DBMOptionsFramePage1OptionMiniMap)

	S:HandleButton(DBMOptionsFramePage1DistanceFrame)
	S:HandleButton(DBMOptionsFramePage1CheckRangeButton)
	S:HandleButton(DBMOptionsFramePage1SyncSystemVersionCheckButton)
	S:HandleButton(DBMOptionsFramePage1ButtonTestAggroAlert)
	S:HandleButton(DBMOptionsFramePage1ButtonResetAggroAlert)

	S:HandleSliderFrame(DBMOptionsFramePage1MiniMapPositionSlider)
	S:HandleSliderFrame(DBMOptionsFramePage1MiniMapRadiusSlider)

	-- Page 1
	S:HandleDropDownBox(DBMOptionsFramePage2StatusBarDesignDropDown)
	DBMOptionsFramePage2StatusBarDesignDropDown:Point("TOPLEFT", 200, -20)

	S:HandleCheckBox(DBMOptionsFramePage2ButtonEnableStatusBars)
	S:HandleCheckBox(DBMOptionsFramePage2ButtonFillUpStatusBars)
	S:HandleCheckBox(DBMOptionsFramePage2ButtonFliptOverStatusBars)
	S:HandleCheckBox(DBMOptionsFramePage2ButtonFlashBarOnEnd)
	S:HandleCheckBox(DBMOptionsFramePage2ButtonAutoColorBars)
	S:HandleCheckBox(DBMOptionsFramePage2ButtonShowIcon)
	S:HandleCheckBox(DBMOptionsFramePage2ButtonShowIconRight)

	S:HandleButton(DBMOptionsFramePage2PizzaTimerStartButton)
	S:HandleButton(DBMOptionsFramePage2ButtonOldDefaults)
	S:HandleButton(DBMOptionsFramePage2ButtonSetToDefaults)
	S:HandleButton(DBMOptionsFramePage2ButtonMoveableBar)

	S:HandleSliderFrame(DBMOptionsFramePage2CSOpacitySlider)
	S:HandleSliderFrame(DBMOptionsFramePage2StatusBarScaleSlider)
	S:HandleSliderFrame(DBMOptionsFramePage2StatusBarWidthSlider)
	DBMOptionsFramePage2StatusBarWidthSlider:Point("TOPLEFT", DBMOptionsFramePage2StatusBarScaleSlider, "BOTTOMLEFT", 0, -7)

	S:HandleSliderFrame(DBMOptionsFramePage2StatusBarTextSizeSlider)
	DBMOptionsFramePage2StatusBarTextSizeSlider:Point("TOPLEFT", DBMOptionsFramePage2StatusBarWidthSlider, "BOTTOMLEFT", 0, -7)

	S:HandleSliderFrame(DBMOptionsFramePage2StatusBarCountSlider)
	DBMOptionsFramePage2StatusBarCountSlider:Point("TOPLEFT", DBMOptionsFramePage2StatusBarTextSizeSlider, "BOTTOMLEFT", 0, -7)

	S:HandleEditBox(DBMOptionsFramePage2PizzaBoxName)
	DBMOptionsFramePage2PizzaBoxName:Height(23)

	S:HandleEditBox(DBMOptionsFramePage2PizzaBoxHour)
	DBMOptionsFramePage2PizzaBoxHour:Height(23)

	S:HandleEditBox(DBMOptionsFramePage2PizzaBoxMin)
	DBMOptionsFramePage2PizzaBoxMin:Height(23)

	S:HandleEditBox(DBMOptionsFramePage2PizzaBoxSec)
	DBMOptionsFramePage2PizzaBoxSec:Height(23)

	-- Page 2
	S:HandleDropDownBox(DBMOptionsFramePage3StatusBarDesignDropDown)
	DBMOptionsFramePage3StatusBarDesignDropDown:Point("TOPRIGHT", -16, -32)

	S:HandleCheckBox(DBMOptionsFramePage3ButtonEnableStatusBars)
	S:HandleCheckBox(DBMOptionsFramePage3ButtonFillUpStatusBars)
	S:HandleCheckBox(DBMOptionsFramePage3ButtonFliptOverStatusBars)
	S:HandleCheckBox(DBMOptionsFramePage3ButtonFlashBarOnEnd)
	S:HandleCheckBox(DBMOptionsFramePage3ButtonAutoColorBars)
	S:HandleCheckBox(DBMOptionsFramePage3ButtonShowIconRight)

	S:HandleButton(DBMOptionsFramePage3ButtonMoveableBar)
	S:HandleButton(DBMOptionsFramePage3ButtonSetToDefaults)

	S:HandleSliderFrame(DBMOptionsFramePage3CSOpacitySlider)
	S:HandleSliderFrame(DBMOptionsFramePage3StatusBarScaleSlider)

	S:HandleSliderFrame(DBMOptionsFramePage3StatusBarWidthSlider)
	DBMOptionsFramePage3StatusBarWidthSlider:Point("TOPLEFT", DBMOptionsFramePage3StatusBarScaleSlider, "TOPLEFT", 0, -16)

	S:HandleSliderFrame(DBMOptionsFramePage3StatusBarTextSizeSlider)
	DBMOptionsFramePage3StatusBarTextSizeSlider:Point("TOPLEFT", DBMOptionsFramePage3StatusBarWidthSlider, "TOPLEFT", 0, -16)

	S:HandleSliderFrame(DBMOptionsFramePage3StatusBarEnlargeAfterSlider)
	S:HandleSliderFrame(DBMOptionsFramePage3StatusBarEnlargeAfterPercentSlider)
	S:HandleSliderFrame(DBMOptionsFramePage3StatusBarEnlargeMaxTimeSlider)

	-- Warnings
	S:HandleDropDownBox(DBMOptionsFramePage4RaidWarningDropDown)
	DBMOptionsFramePage4RaidWarningDropDown:Point("TOPLEFT", 46, -48)
	DBMOptionsFramePage4RaidWarningDropDown:Width(200)

	S:HandleSliderFrame(DBMOptionsFramePage4RaidWarningYSlider)
	DBMOptionsFramePage4RaidWarningYSlider:Width(200)

	S:HandleSliderFrame(DBMOptionsFramePage4RaidWarningXSlider)
	DBMOptionsFramePage4RaidWarningXSlider:Width(200)

	S:HandleSliderFrame(DBMOptionsFramePage4SelfWarningFontSizeSlider)
	S:HandleSliderFrame(DBMOptionsFramePage4tSelfWarningYSlider)
	S:HandleSliderFrame(DBMOptionsFramePage4tSelfWarningXSlider)

	S:HandleButton(DBMOptionsFramePage4TestSoundButton)
	DBMOptionsFramePage4TestSoundButton:ClearAllPoints()
	DBMOptionsFramePage4TestSoundButton:Point("TOPRIGHT", -16, -42)

	S:HandleButton(DBMOptionsFramePage4ShowMessageButton)
	S:HandleButton(DBMOptionsFramePage4ResetButton)
	S:HandleButton(DBMOptionsFramePage4ResetColorButton)

	-- Specials
	S:HandleCheckBox(DBMOptionsFramePage5OptionSpecialWarnings)
	S:HandleCheckBox(DBMOptionsFramePage5OptionShakeScreenEffects)
	S:HandleCheckBox(DBMOptionsFramePage5OptionFlashEffects)
	S:HandleCheckBox(DBMOptionsFramePage5ShowCombatInformations)
	S:HandleCheckBox(DBMOptionsFramePage5ShowCombatSyncInfo)

	S:HandleButton(DBMOptionsFramePage5TestWarningButton)
	S:HandleButton(DBMOptionsFramePage5TestShakeButton)
	S:HandleButton(DBMOptionsFramePage5TestFlashButton)

	S:HandleSliderFrame(DBMOptionsFramePage5DurationSlider)

	S:HandleSliderFrame(DBMOptionsFramePage5FadeTimeSlider)
	DBMOptionsFramePage5FadeTimeSlider:Point("TOPLEFT", DBMOptionsFramePage5DurationSlider, "TOPLEFT", 0, -16)

	S:HandleSliderFrame(DBMOptionsFramePage5TextSizeSlider)
	DBMOptionsFramePage5TextSizeSlider:Point("TOPLEFT", DBMOptionsFramePage5FadeTimeSlider, "TOPLEFT", 0, -16)

	S:HandleSliderFrame(DBMOptionsFramePage5ShakeDurationSlider)

	S:HandleSliderFrame(DBMOptionsFramePage5ShakeIntensitySlider)
	DBMOptionsFramePage5ShakeIntensitySlider:Point("TOPLEFT", DBMOptionsFramePage5ShakeDurationSlider, "TOPLEFT", 0, -16)

	S:HandleSliderFrame(DBMOptionsFramePage5FlashDurationSlider)

	S:HandleSliderFrame(DBMOptionsFramePage5FlashesSlider)
	DBMOptionsFramePage5FlashesSlider:Point("TOPLEFT", DBMOptionsFramePage5FlashDurationSlider, "TOPLEFT", 0, -16)

	-- Misc
	S:HandleCheckBox(DBMOptionsFramePage6AutoRespondEnable)
	S:HandleCheckBox(DBMOptionsFramePage6AutoRespondShowWhispers)
	S:HandleCheckBox(DBMOptionsFramePage6AutoRespondInformUser)
	S:HandleCheckBox(DBMOptionsFramePage6AutoRespondHideReply)
	S:HandleCheckBox(DBMOptionsFramePage6EnableStatusOption)
	S:HandleCheckBox(DBMOptionsFramePage6LoadGUIOnLogin)

	S:HandleEditBox(DBMOptionsFramePage6AutoRespondBusyMessage)
	DBMOptionsFramePage6AutoRespondBusyMessage:Height(23)
end

S:AddCallbackForAddon("DBM_GUI", "DBM_GUI", LoadSkin)