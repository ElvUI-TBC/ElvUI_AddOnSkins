local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

-- QuestGuru 0.9.3

local _G = _G
local pairs = pairs
local find = string.find

local function LoadSkin()
	if not E.private.addOnSkins.QuestGuru then return end

	local QUESTGURU_NUMTABS = QUESTGURU_NUMTABS or 5
	local QUESTGURU_QUESTS_DISPLAYED = QUESTGURU_QUESTS_DISPLAYED or 27

	local function QuestObjectiveTextColor()
		local numObjectives = GetNumQuestLeaderBoards()
		local objective, abandon
		local _, type, finished
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

		if quality then
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
			QuestLogListScrollFrame.backdrop:Hide()
			QuestLogDetailScrollFrame.backdrop:Hide()
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

			QuestGuru_QuestAbandonDescriptionTitle:SetTextColor(unpack(titleTextColor))
			QuestGuru_QuestAbandonQuestTitle:SetTextColor(unpack(titleTextColor))
			QuestGuru_QuestAbandonPlayerTitleText:SetTextColor(unpack(titleTextColor))
			QuestGuru_QuestAbandonRewardTitleText:SetTextColor(unpack(titleTextColor))

			QuestGuru_QuestAbandonObjectivesText:SetTextColor(unpack(textColor))
			QuestGuru_QuestAbandonQuestDescription:SetTextColor(unpack(textColor))
			QuestGuru_QuestAbandonItemChooseText:SetTextColor(unpack(textColor))
			QuestGuru_QuestAbandonItemReceiveText:SetTextColor(unpack(textColor))
			QuestGuru_QuestAbandonSpellLearnText:SetTextColor(unpack(textColor))

			if GetQuestLogRequiredMoney() > 0 then
				if GetQuestLogRequiredMoney() > GetMoney() then
					QuestGuru_QuestLogRequiredMoneyText:SetTextColor(0.6, 0.6, 0.6)
					QuestGuru_QuestAbandonRequiredMoneyText:SetTextColor(0.6, 0.6, 0.6)
				else
					QuestGuru_QuestLogRequiredMoneyText:titleTextColor(unpack(textColor))
					QuestGuru_QuestAbandonRequiredMoneyText:titleTextColor(unpack(textColor))
				end
			end

			QuestObjectiveTextColor()

			local numQuestRewards, numQuestChoices = GetNumQuestLogRewards(), GetNumQuestLogChoices()
			local rewardsCount = numQuestChoices + numQuestRewards
			if rewardsCount > 0 then
				local questItem, itemName, link
				for i = 1, rewardsCount do
					questItem = _G["QuestGuru_QuestLogItem"..i]
					itemName = _G["QuestGuru_QuestLogItem"..i.."Name"]
					link = questItem.type and GetQuestLogItemLink(questItem.type, questItem:GetID())

					QuestQualityColors(questItem, itemName, nil, link)
				end
			end
		end)
	else
		hooksecurefunc("QuestFrameItems_Update", function(questState)
			local titleTextColor = {1, 0.80, 0.10}
			local textColor = {1, 1, 1}

			QuestTitleText:SetTextColor(unpack(titleTextColor))
			QuestTitleFont:SetTextColor(unpack(titleTextColor))
			QuestFont:SetTextColor(unpack(textColor))
			QuestFontNormalSmall:SetTextColor(unpack(textColor))
			QuestDescription:SetTextColor(unpack(textColor))
			QuestObjectiveText:SetTextColor(unpack(textColor))

			QuestDetailObjectiveTitleText:SetTextColor(unpack(titleTextColor))
			QuestDetailRewardTitleText:SetTextColor(unpack(titleTextColor))
			QuestDetailItemReceiveText:SetTextColor(unpack(textColor))
			QuestDetailSpellLearnText:SetTextColor(unpack(textColor))
			QuestDetailItemChooseText:SetTextColor(unpack(textColor))

			QuestRewardRewardTitleText:SetTextColor(unpack(titleTextColor))
			QuestRewardTitleText:SetTextColor(unpack(titleTextColor))
			QuestRewardItemChooseText:SetTextColor(unpack(textColor))
			QuestRewardItemReceiveText:SetTextColor(unpack(textColor))
			QuestRewardSpellLearnText:SetTextColor(unpack(textColor))
			QuestRewardText:SetTextColor(unpack(textColor))

			QuestGuru_QuestLogDescriptionTitle:SetTextColor(unpack(titleTextColor))
			QuestGuru_QuestLogQuestTitle:SetTextColor(unpack(titleTextColor))
			QuestGuru_QuestLogPlayerTitleText:SetTextColor(unpack(titleTextColor))
			QuestGuru_QuestLogRewardTitleText:SetTextColor(unpack(titleTextColor))

			QuestGuru_QuestLogObjectivesText:SetTextColor(unpack(textColor))
			QuestGuru_QuestLogQuestDescription:SetTextColor(unpack(textColor))
			QuestGuru_QuestLogItemChooseText:SetTextColor(unpack(textColor))
			QuestGuru_QuestLogItemReceiveText:SetTextColor(unpack(textColor))
			QuestGuru_QuestLogSpellLearnText:SetTextColor(unpack(textColor))

			QuestGuru_QuestAbandonDescriptionTitle:SetTextColor(unpack(titleTextColor))
			QuestGuru_QuestAbandonQuestTitle:SetTextColor(unpack(titleTextColor))
			QuestGuru_QuestAbandonPlayerTitleText:SetTextColor(unpack(titleTextColor))
			QuestGuru_QuestAbandonRewardTitleText:SetTextColor(unpack(titleTextColor))

			QuestGuru_QuestAbandonObjectivesText:SetTextColor(unpack(textColor))
			QuestGuru_QuestAbandonQuestDescription:SetTextColor(unpack(textColor))
			QuestGuru_QuestAbandonItemChooseText:SetTextColor(unpack(textColor))
			QuestGuru_QuestAbandonItemReceiveText:SetTextColor(unpack(textColor))
			QuestGuru_QuestAbandonSpellLearnText:SetTextColor(unpack(textColor))


			if GetQuestLogRequiredMoney() > 0 then
				if GetQuestLogRequiredMoney() > GetMoney() then
					QuestGuru_QuestLogRequiredMoneyText:SetTextColor(0.6, 0.6, 0.6)
					QuestGuru_QuestAbandonRequiredMoneyText:SetTextColor(0.6, 0.6, 0.6)
				else
					QuestGuru_QuestLogRequiredMoneyText:titleTextColor(unpack(textColor))
					QuestGuru_QuestAbandonRequiredMoneyText:titleTextColor(unpack(textColor))
				end
			end

			QuestObjectiveTextColor()

			local numQuestRewards, numQuestChoices = GetNumQuestLogRewards(), GetNumQuestLogChoices()
			local rewardsCount = numQuestChoices + numQuestRewards
			if rewardsCount > 0 then
				local questItem, itemName, link
				for i = 1, rewardsCount do
					questItem = _G["QuestGuru_QuestLogItem"..i]
					itemName = _G["QuestGuru_QuestLogItem"..i.."Name"]
					link = questItem.type and GetQuestLogItemLink(questItem.type, questItem:GetID())

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

	-- QuestGuru Main Frame
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

		tab:StripTextures()
		tab:CreateBackdrop("Default", true)
		tab.backdrop:Point("TOPLEFT", 3, -7)
		tab.backdrop:Point("BOTTOMRIGHT", -2, -1)

		if i == 1 then
			tab:Point("TOPLEFT", 40, -14)
		end

		tab:HookScript2("OnEnter", S.SetModifiedBackdrop)
		tab:HookScript2("OnLeave", S.SetOriginalBackdrop)
	end

	QuestGuru_QuestFrameExpandCollapseButton:StripTextures()
	QuestGuru_QuestFrameExpandCollapseButton:SetNormalTexture("")
	QuestGuru_QuestFrameExpandCollapseButton.SetNormalTexture = E.noop
	QuestGuru_QuestFrameExpandCollapseButton:SetHighlightTexture("")
	QuestGuru_QuestFrameExpandCollapseButton.SetHighlightTexture = E.noop
	QuestGuru_QuestFrameExpandCollapseButton:SetDisabledTexture("")
	QuestGuru_QuestFrameExpandCollapseButton.SetDisabledTexture = E.noop
	QuestGuru_QuestFrameExpandCollapseButton:Point("TOPLEFT", 21, -31)

	local questGuruTitles = {
		"QuestGuru_QuestLogTitle",
		"QuestGuru_QuestHistoryTitle",
		"QuestGuru_QuestAbandonTitle",
	}

	for i = 1, QUESTGURU_QUESTS_DISPLAYED do
		for _, frame in pairs(questGuruTitles) do
			local title = _G[frame..i]
			local highlight = _G[frame..i.."Highlight"]
			local check = _G[frame..i.."Check"]

			title:SetNormalTexture("Interface\\AddOns\\ElvUI\\media\\textures\\PlusMinusButton")
			title.SetNormalTexture = E.noop
			title:GetNormalTexture():Size(14)
			title:GetNormalTexture():Point("LEFT", 3, 0)

			highlight:SetTexture("")
			highlight.SetTexture = E.noop

			if check then
				S:HandleCheckBox(check)
			end

			hooksecurefunc(title, "SetNormalTexture", function(self, texture)
				if find(texture, "MinusButton") then
					self:GetNormalTexture():SetTexCoord(0.540, 0.965, 0.085, 0.920)
				elseif find(texture, "PlusButton") then
					self:GetNormalTexture():SetTexCoord(0.040, 0.465, 0.085, 0.920)
				else
					self:GetNormalTexture():SetTexCoord(0, 0, 0, 0)
				end
			end)
		end
	end

	local questItems = {
		"QuestGuru_QuestLogItem",
		"QuestGuru_QuestHistoryItem",
		"QuestGuru_QuestAbandonItem"
	}

	for _, frame in pairs(questItems) do
		for i = 1, MAX_NUM_ITEMS do
			local item = _G[frame..i]
			local icon = _G[frame..i.."IconTexture"]
			local count = _G[frame..i.."Count"]

			item:StripTextures()
			item:SetTemplate("Default")
			item:StyleButton()
			item:Size(143, 40)
			item:SetFrameLevel(item:GetFrameLevel() + 2)

			icon:Size(E.PixelMode and 38 or 32)
			icon:SetDrawLayer("OVERLAY")
			icon:Point("TOPLEFT", E.PixelMode and 1 or 4, -(E.PixelMode and 1 or 4))
			S:HandleIcon(icon)

			count:SetParent(item.backdrop)
			count:SetDrawLayer("OVERLAY")
		end
	end

	-- QuestGuru Log
	QuestGuru_QuestLogNoQuestsText:ClearAllPoints()
	QuestGuru_QuestLogNoQuestsText:Point("CENTER", QuestGuru_EmptyQuestLogFrame, "CENTER", -45, 65)

	QuestGuru_QuestLogListScrollFrame:StripTextures()
	QuestGuru_QuestLogListScrollFrame:CreateBackdrop("Default", true)
	QuestGuru_QuestLogListScrollFrame:Size(305, 410)

	QuestGuru_QuestLogDetailScrollFrame:StripTextures()
	QuestGuru_QuestLogDetailScrollFrame:CreateBackdrop("Default", true)
	QuestGuru_QuestLogDetailScrollFrame:Size(305, 410)

	S:HandleScrollBar(QuestGuru_QuestLogListScrollFrameScrollBar)
	S:HandleScrollBar(QuestGuru_QuestLogDetailScrollFrameScrollBar)

	S:HandleButton(QuestGuru_QuestLogFrameAbandonButton)
	QuestGuru_QuestLogFrameAbandonButton:Point("BOTTOMLEFT", QuestGuru_QuestLogFrame, "BOTTOMLEFT", 18, 24)
	QuestGuru_QuestLogFrameAbandonButton:Width(101)
	QuestGuru_QuestLogFrameAbandonButton:SetText(L["Abandon"])

	S:HandleButton(QuestGuru_QuestFramePushQuestButton)
	QuestGuru_QuestFramePushQuestButton:ClearAllPoints()
	QuestGuru_QuestFramePushQuestButton:Point("LEFT", QuestGuru_QuestLogFrameAbandonButton, "RIGHT", 2, 0)
	QuestGuru_QuestFramePushQuestButton:Width(101)
	QuestGuru_QuestFramePushQuestButton:SetText(L["Share"])

	S:HandleButton(QuestGuru_QuestFrameOptionsButton)
	QuestGuru_QuestFrameOptionsButton:ClearAllPoints()
	QuestGuru_QuestFrameOptionsButton:Point("LEFT", QuestGuru_QuestFramePushQuestButton, "RIGHT", 2, 0)
	QuestGuru_QuestFrameOptionsButton:Width(101)

	S:HandleButton(QuestGuru_QuestFrameExitButton)
	QuestGuru_QuestFrameExitButton:Point("BOTTOMRIGHT", QuestGuru_QuestLogFrame, "BOTTOMRIGHT", -68, 24)

	-- QuestGuru History
	QuestGuru_QuestHistoryListScrollFrame:StripTextures()
	QuestGuru_QuestHistoryListScrollFrame:CreateBackdrop("Default", true)
	QuestGuru_QuestHistoryListScrollFrame:Size(305, 410)

	QuestGuru_QuestHistoryDetailScrollFrame:StripTextures()
	QuestGuru_QuestHistoryDetailScrollFrame:CreateBackdrop("Default", true)
	QuestGuru_QuestHistoryDetailScrollFrame:Size(305, 410)

	S:HandleScrollBar(QuestGuru_QuestHistoryListScrollFrameScrollBar)
	S:HandleScrollBar(QuestGuru_QuestHistoryDetailScrollFrameScrollBar)

	QuestGuru_QuestHistorySearchText:Point("BOTTOMLEFT", QuestGuru_QuestLogFrame, "BOTTOMLEFT", 20, 28)

	S:HandleEditBox(QuestGuru_QuestHistorySearch)
	QuestGuru_QuestHistorySearch:Size(150, 19)
	QuestGuru_QuestHistorySearch:Point("LEFT", QuestGuru_QuestHistorySearchText, "RIGHT", -3, 0) 

	-- QuestGuru Abandon
	QuestGuru_QuestAbandonListScrollFrame:StripTextures()
	QuestGuru_QuestAbandonListScrollFrame:CreateBackdrop("Default", true)
	QuestGuru_QuestAbandonListScrollFrame:Size(305, 410)

	QuestGuru_QuestAbandonDetailScrollFrame:StripTextures()
	QuestGuru_QuestAbandonDetailScrollFrame:CreateBackdrop("Default", true)
	QuestGuru_QuestAbandonDetailScrollFrame:Size(305, 410)

	S:HandleScrollBar(QuestGuru_QuestAbandonListScrollFrameScrollBar)
	S:HandleScrollBar(QuestGuru_QuestAbandonDetailScrollFrameScrollBar)

	S:HandleButton(QuestGuru_QuestAbandonClearList)
	QuestGuru_QuestAbandonClearList:ClearAllPoints()
	QuestGuru_QuestAbandonClearList:Point("RIGHT", QuestGuru_QuestFrameExitButton, "LEFT", -30, 0)

	QuestGuru_QuestAbandonSearchText:Point("BOTTOMLEFT", QuestGuru_QuestLogFrame, "BOTTOMLEFT", 20, 28)

	S:HandleEditBox(QuestGuru_QuestAbandonSearch)
	QuestGuru_QuestAbandonSearch:Size(150, 19)
	QuestGuru_QuestAbandonSearch:Point("LEFT", QuestGuru_QuestAbandonSearchText, "RIGHT", -3, 0) 

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