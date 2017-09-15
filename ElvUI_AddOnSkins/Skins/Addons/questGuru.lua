local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

-- QuestGuru 0.9.3

local function LoadSkin()
	if not E.private.addOnSkins.QuestGuru then return end

	local QUESTGURU_NUMTABS = QUESTGURU_NUMTABS or 5
	local QUESTGURU_QUESTS_DISPLAYED = QUESTGURU_QUESTS_DISPLAYED or 27

	local function SkinItemFrame(frameName)
		if not frameName then return end

		local item = _G[frameName]
		local icon = _G[frameName.."IconTexture"]
		local count = _G[frameName.."Count"]

		item:StripTextures()
		item:SetTemplate("Default")
		item:StyleButton()
		item:Width(item:GetWidth() - 4)
		item:SetFrameLevel(item:GetFrameLevel() + 2)

		icon:SetDrawLayer("OVERLAY")
		icon:Size(icon:GetWidth() -(E.Spacing*2), icon:GetHeight() -(E.Spacing*2))
		icon:Point("TOPLEFT", E.Border, -E.Border)
		S:HandleIcon(icon)

		count:SetParent(item.backdrop)
		count:SetDrawLayer("OVERLAY")
	end

	local function QuestObjectiveTextColor()
		local numObjectives = GetNumQuestLeaderBoards()
		local objective
		local _, type, finished;
		local numVisibleObjectives = 0
		for i = 1, numObjectives do
			_, type, finished = GetQuestLogLeaderBoard(i)
			if type ~= "spell" then
				numVisibleObjectives = numVisibleObjectives + 1
				objective = _G["QuestGuru_QuestLogObjective"..numVisibleObjectives]
				if finished then
					objective:SetTextColor(1, 0.80, 0.10)
				else
					objective:SetTextColor(0.6, 0.6, 0.6)
				end
			end
		end
	end

	local function QuestQualityColors(frame, text, quality, link)
		if link and not quality then
			quality = select(3, GetItemInfo(link))
		end

		if quality and quality > 1 then
			if frame then
				frame:SetBackdropBorderColor(GetItemQualityColor(quality))
				frame.backdrop:SetBackdropBorderColor(GetItemQualityColor(quality))
			end
			text:SetTextColor(GetItemQualityColor(quality))
		else
			if frame then
				frame:SetBackdropBorderColor(unpack(E["media"].bordercolor))
				frame.backdrop:SetBackdropBorderColor(unpack(E["media"].bordercolor))
			end
			text:SetTextColor(1, 1, 1)
		end
	end

	if E.private.skins.blizzard.enable and E.private.skins.blizzard.quest then
		-- In case QuestLog skin loads after QuestGuru
		E:Delay(0.5, function()
			QuestLogFrame:Size(730, 512)
			QuestLogFrame.backdrop:Hide()
			QuestTrack:Hide()

			QuestGuru_QuestLogListScrollFrame:Size(305, 410)
			QuestGuru_QuestLogDetailScrollFrame:Size(305, 410)
		end)

		hooksecurefunc("QuestFrameItems_Update", function(questState)
			local titleTextColor = {1, 0.80, 0.10}
			local textColor = {1, 1, 1}

			QuestGuru_QuestLogDescriptionTitle:SetTextColor(unpack(titleTextColor))
			QuestGuru_QuestLogQuestTitle:SetTextColor(unpack(titleTextColor))
			QuestGuru_QuestLogPlayerTitleText:SetTextColor(unpack(titleTextColor))
			QuestGuru_QuestLogRewardTitleText:SetTextColor(unpack(titleTextColor))

			QuestGuru_QuestLogObjectivesText:SetTextColor(unpack(textColor))
			QuestGuru_QuestLogQuestDescription:SetTextColor(unpack(textColor))
			QuestGuru_QuestLogItemChooseText:SetTextColor(unpack(textColor))
			QuestGuru_QuestLogItemReceiveText:SetTextColor(unpack(textColor))
			QuestGuru_QuestLogSpellLearnText:SetTextColor(unpack(textColor))

			QuestObjectiveTextColor()

			local numQuestRewards, numQuestChoices
			if questState == "QuestLog" then
				numQuestRewards, numQuestChoices = GetNumQuestLogRewards(), GetNumQuestLogChoices()
			else
				numQuestRewards, numQuestChoices = GetNumQuestRewards(), GetNumQuestChoices()
			end

			local rewardsCount = numQuestChoices + numQuestRewards
			if rewardsCount > 0 then
				local questItem, itemName, link
				local questItemName = questState.."Item"

				for i = 1, rewardsCount do
					questItem = _G["QuestGuru_"..questItemName..i]
					itemName = _G["QuestGuru_"..questItemName..i.."Name"]
					link = questItem.type and (questState == "QuestLog" and GetQuestLogItemLink or GetQuestItemLink)(questItem.type, questItem:GetID())

					QuestQualityColors(questItem, itemName, nil, link)
				end
			end
		end)
	else
		hooksecurefunc("QuestFrameItems_Update", function(questState)
			local titleTextColor = {1, 0.80, 0.10}
			local textColor = {1, 1, 1}

			QuestDetailObjectiveTitleText:SetTextColor(unpack(titleTextColor))
			QuestDetailRewardTitleText:SetTextColor(unpack(titleTextColor))
			QuestGuru_QuestLogDescriptionTitle:SetTextColor(unpack(titleTextColor))
			QuestGuru_QuestLogQuestTitle:SetTextColor(unpack(titleTextColor))
			QuestGuru_QuestLogPlayerTitleText:SetTextColor(unpack(titleTextColor))
			QuestGuru_QuestLogRewardTitleText:SetTextColor(unpack(titleTextColor))
			QuestRewardRewardTitleText:SetTextColor(unpack(titleTextColor))
			QuestRewardTitleText:SetTextColor(unpack(titleTextColor))
			QuestTitleText:SetTextColor(unpack(titleTextColor))
			QuestTitleFont:SetTextColor(unpack(titleTextColor))
			QuestTitleFont:SetFont("Fonts\\MORPHEUS.TTF", E.db.general.fontSize + 6)
			QuestTitleFont.SetFont = E.noop

			QuestDescription:SetTextColor(unpack(textColor))
			QuestDetailItemReceiveText:SetTextColor(unpack(textColor))
			QuestDetailSpellLearnText:SetTextColor(unpack(textColor))
			QuestDetailItemChooseText:SetTextColor(unpack(textColor))
			QuestFont:SetTextColor(unpack(textColor))
			QuestFontNormalSmall:SetTextColor(unpack(textColor))
			QuestGuru_QuestLogObjectivesText:SetTextColor(unpack(textColor))
			QuestGuru_QuestLogQuestDescription:SetTextColor(unpack(textColor))
			QuestGuru_QuestLogItemChooseText:SetTextColor(unpack(textColor))
			QuestGuru_QuestLogItemReceiveText:SetTextColor(unpack(textColor))
			QuestGuru_QuestLogSpellLearnText:SetTextColor(unpack(textColor))
			QuestObjectiveText:SetTextColor(unpack(textColor))
			QuestRewardItemChooseText:SetTextColor(unpack(textColor))
			QuestRewardItemReceiveText:SetTextColor(unpack(textColor))
			QuestRewardSpellLearnText:SetTextColor(unpack(textColor))
			QuestRewardText:SetTextColor(unpack(textColor))

			QuestObjectiveTextColor()

			local numQuestRewards, numQuestChoices
			if questState == "QuestLog" then
				numQuestRewards, numQuestChoices = GetNumQuestLogRewards(), GetNumQuestLogChoices()
			else
				numQuestRewards, numQuestChoices = GetNumQuestRewards(), GetNumQuestChoices()
			end

			local rewardsCount = numQuestChoices + numQuestRewards
			if rewardsCount > 0 then
				local questItem, itemName, link
				local questItemName = questState.."Item"

				for i = 1, rewardsCount do
					questItem = _G["QuestGuru_"..questItemName..i]
					itemName = _G["QuestGuru_"..questItemName..i.."Name"]
					link = questItem.type and (questState == "QuestLog" and GetQuestLogItemLink or GetQuestItemLink)(questItem.type, questItem:GetID())

					QuestQualityColors(questItem, itemName, nil, link)
				end
			end
		end)
	end

	hooksecurefunc("QuestLog_UpdateQuestDetails", function()
		local requiredMoney = GetQuestLogRequiredMoney()
		if requiredMoney > 0 then
			if requiredMoney > GetMoney() then
				QuestGuru_QuestLogRequiredMoneyText:SetTextColor(0.6, 0.6, 0.6)
			else
				QuestGuru_QuestLogRequiredMoneyText:SetTextColor(1, 0.80, 0.10)
			end
		end
	end)

	QuestGuru_QuestLogFrame:StripTextures(true)
	QuestGuru_QuestLogFrame:CreateBackdrop("Transparent")
	QuestGuru_QuestLogFrame.backdrop:Point("TOPLEFT", 10, -12)
	QuestGuru_QuestLogFrame.backdrop:Point("BOTTOMRIGHT", -39, 18)

	S:HandleCloseButton(QuestGuru_QuestLogFrameCloseButton, QuestGuru_QuestLogFrame.backdrop)

	QuestGuru_QuestLogTrack:Hide()
	QuestGuru_QuestLogCount:StripTextures(true)

	QuestGuru_QuestLogTimerText:SetTextColor(1, 1, 1)

	for i = 1, QUESTGURU_NUMTABS do
		local tab = _G["QuestGuru_QuestLogFrameTab"..i]
		S:HandleTab(tab)
		tab.backdrop:ClearAllPoints()
		tab.backdrop:Point("TOPLEFT", 10, E.PixelMode and -7 or -10)
		tab.backdrop:Point("BOTTOMRIGHT", -10, -3)
	end

	QuestGuru_QuestFrameExpandCollapseButton:StripTextures()
	QuestGuru_QuestFrameExpandCollapseButton:SetNormalTexture("")
	QuestGuru_QuestFrameExpandCollapseButton.SetNormalTexture = E.noop
	QuestGuru_QuestFrameExpandCollapseButton:SetHighlightTexture("")
	QuestGuru_QuestFrameExpandCollapseButton.SetHighlightTexture = E.noop
	QuestGuru_QuestFrameExpandCollapseButton:SetDisabledTexture("")
	QuestGuru_QuestFrameExpandCollapseButton.SetDisabledTexture = E.noop
	QuestGuru_QuestFrameExpandCollapseButton:Point("TOPLEFT", 21, -31)

	QuestGuru_QuestFrameExpandCollapseButton.Text = QuestGuru_QuestFrameExpandCollapseButton:CreateFontString(nil, "OVERLAY")
	QuestGuru_QuestFrameExpandCollapseButton.Text:FontTemplate(nil, 22)
	QuestGuru_QuestFrameExpandCollapseButton.Text:Point("LEFT", 3, 0)
	QuestGuru_QuestFrameExpandCollapseButton.Text:SetText("+")

	QuestGuru_QuestLogNoQuestsText:ClearAllPoints()
	QuestGuru_QuestLogNoQuestsText:Point("CENTER", QuestGuru_EmptyQuestLogFrame, "CENTER", -45, 65)

	S:HandleScrollBar(QuestGuru_QuestLogListScrollFrameScrollBar)
	S:HandleScrollBar(QuestGuru_QuestLogDetailScrollFrameScrollBar)

	QuestGuru_QuestLogListScrollFrame:StripTextures()
	QuestGuru_QuestLogListScrollFrame:CreateBackdrop("Default", true)
	QuestGuru_QuestLogListScrollFrame:Size(305, 410)

	QuestGuru_QuestLogDetailScrollFrame:StripTextures()
	QuestGuru_QuestLogDetailScrollFrame:CreateBackdrop("Default", true)
	QuestGuru_QuestLogDetailScrollFrame:Size(305, 410)

	for i = 1, QUESTGURU_QUESTS_DISPLAYED do
		local title = _G["QuestGuru_QuestLogTitle"..i]
		title:SetNormalTexture("")
		title.SetNormalTexture = E.noop

		S:HandleCheckBox(_G["QuestGuru_QuestLogTitle"..i.."Check"])

		_G["QuestGuru_QuestLogTitle"..i.."Highlight"]:SetTexture("")
		_G["QuestGuru_QuestLogTitle"..i.."Highlight"].SetTexture = E.noop

		title.Text = title:CreateFontString(nil, "OVERLAY")
		title.Text:FontTemplate(nil, 22)
		title.Text:Point("LEFT", 3, 0)
		title.Text:SetText("+")

		hooksecurefunc(title, "SetNormalTexture", function(self, texture)
			if string.find(texture, "MinusButton") then
				self.Text:SetText("-")
			elseif string.find(texture, "PlusButton") then
				self.Text:SetText("+")
			else
				self.Text:SetText("")
			end
		end)
	end

	for i = 1, MAX_NUM_ITEMS do
		SkinItemFrame("QuestGuru_QuestLogItem"..i)
		SkinItemFrame("QuestGuru_QuestLogObjectiveItem"..i)
	end

	S:HandleButton(QuestGuru_QuestLogFrameAbandonButton)
	QuestGuru_QuestLogFrameAbandonButton:Point("BOTTOMLEFT", QuestGuru_QuestLogFrame, "BOTTOMLEFT", 18, 24)

	S:HandleButton(QuestGuru_QuestFramePushQuestButton)
	QuestGuru_QuestFramePushQuestButton:Point("LEFT", QuestGuru_QuestLogFrameAbandonButton, "RIGHT", 80, 0)

	S:HandleButton(QuestGuru_QuestFrameExitButton)
	QuestGuru_QuestFrameExitButton:Point("BOTTOMRIGHT", QuestGuru_QuestLogFrame, "BOTTOMRIGHT", -68, 24)

	S:HandleButton(QuestGuru_QuestFrameOptionsButton)
	QuestGuru_QuestFrameOptionsButton:Point("RIGHT", QuestGuru_QuestFrameExitButton, "LEFT", -130, 0)

	S:HandleEditBox(QuestGuru_QuestHistorySearch)
	S:HandleButton(QuestGuru_QuestAbandonClearList)

	QuestGuru_QuestStartInfoFrame:SetTemplate("Transparent")
	QuestGuru_QuestStartInfoBG:Hide()
	QuestGuru_QuestFinishInfoFrame:SetTemplate("Transparent")
	QuestGuru_QuestFinishInfoBG:Hide()

	-- WatchFrame
	QuestGuru_SetWatchBorder = E.noop
	QuestGuru_QuestWatchFrame:SetTemplate("Transparent")
	QuestGuru_QuestWatchFrameTitleBackground:Hide()

	S:HandleButton(QuestGuru_QuestWatchFrameOptions)
	QuestGuru_QuestWatchFrameOptions:Size(17)

	S:HandleButton(QuestGuru_QuestWatchFrameMinimize)
	QuestGuru_QuestWatchFrameMinimize:Size(17)
	QuestGuru_QuestWatchFrameMinimize:SetPoint("RIGHT", QuestGuru_QuestWatchFrameOptions, "LEFT", -2, 0)

	S:HandleSliderFrame(QuestGuru_QuestWatchFrameSlider)

	local TT = E:GetModule("Tooltip")
	QuestGuru_QuestWatchTooltip:HookScript2("OnShow", function(self)
		TT:SetStyle(self)
	end)
end

S:AddCallbackForAddon("QuestGuru", "QuestGuru", LoadSkin)