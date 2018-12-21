local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

-- QuestGuru 0.9.3

local _G = _G
local ipairs, pairs, unpack, select = ipairs, pairs, unpack, select
local find = string.find

local hooksecurefunc = hooksecurefunc
local HONOR_POINTS = HONOR_POINTS

local function LoadSkin()
	if not E.private.addOnSkins.QuestGuru then return end

	local QUESTGURU_NUMTABS = QUESTGURU_NUMTABS or 5
	local QUESTGURU_QUESTS_DISPLAYED = QUESTGURU_QUESTS_DISPLAYED or 27

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

	local questHonorFrames = {
		"QuestGuru_QuestLogHonorFrame",
		"QuestGuru_QuestHistoryHonorFrame",
		"QuestGuru_QuestAbandonHonorFrame"
	}

	for _, frame in pairs(questHonorFrames) do
		local honor = _G[frame]
		local icon = _G[frame.."Icon"]
		local points = _G[frame.."Points"]
		local text = _G[frame.."HonorReceiveText"]

		honor:SetTemplate("Default")
		honor:Size(143, 40)

		icon.backdrop = CreateFrame("Frame", nil, honor)
		icon.backdrop:SetFrameLevel(honor:GetFrameLevel() - 1)
		icon.backdrop:SetTemplate("Default")
		icon.backdrop:SetOutside(icon)

		icon:SetTexture("Interface\\AddOns\\ElvUI\\media\\textures\\PVPCurrency-Honor-"..E.myfaction)
		icon.SetTexture = E.noop
		icon:SetTexCoord(unpack(E.TexCoords))
		icon:SetDrawLayer("OVERLAY")
		icon:Size(E.PixelMode and 38 or 32)
		icon:ClearAllPoints()
		icon:Point("TOPLEFT", E.PixelMode and 1 or 4, -(E.PixelMode and 1 or 4))
		icon:SetParent(icon.backdrop)

		points:ClearAllPoints()
		points:Point("BOTTOMRIGHT", icon, "BOTTOMRIGHT", -2, 2)
		points:SetParent(icon.backdrop)
		points:SetDrawLayer("OVERLAY")
		points:FontTemplate(nil, nil, "OUTLINE")

		text:Point("LEFT", honor, "LEFT", 44, 0)
		text:SetText(HONOR_POINTS)
	end

	local function QuestObjectiveTextColor()
		local numObjectives = GetNumQuestLeaderBoards()
		local objective
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

	-- QuestGuru History Hooks
	hooksecurefunc("QuestLog_UpdateQuestHistoryDetails", function()
		for i = 1, 10 do
			_G["QuestGuru_QuestHistoryObjective"..i]:SetTextColor(1, 0.80, 0.10)
		end
	end)

	hooksecurefunc("QuestGuru_QuestHistoryFrameItems_Update", function()
		local questHistory
		local scrollOffset = FauxScrollFrame_GetOffset(QuestGuru_QuestHistoryListScrollFrame)
		local qID = _G["QuestGuru_QuestHistoryTitle"..QuestGuru_currHistory - scrollOffset].qID

		for i, qH in ipairs(QuestGuru_History) do
			if qH.qID == qID then
				questHistory = qH
				questFound = true
				break
			end
		end
		if not questFound then return end

		local item, name, link
		local index, baseIndex
		local rewardsCount = 0

		local numQuestChoices = questHistory.Choices
		local numQuestRewards = questHistory.Rewards
		local numQuestSpellRewards = questHistory.SpellRewards
		local money = questHistory.RewardMoney
		local honor = questHistory.Honor
		local totalRewards = numQuestRewards + numQuestChoices + numQuestSpellRewards
		local questItemName = "QuestGuru_QuestHistoryItem"

		if numQuestChoices > 0 then
			baseIndex = rewardsCount

			for i = 1, numQuestChoices, 1 do
				index = i + baseIndex

				item = _G[questItemName..index]
				name = _G[questItemName..index.."Name"]
				link = questHistory.Choice[i].Link

				QuestQualityColors(item, name, nil, link)
			end
		end

		if numQuestRewards > 0 then
			baseIndex = rewardsCount

			for i = 1, numQuestRewards, 1 do
				index = i + baseIndex

				item = _G[questItemName..index]
				name = _G[questItemName..index.."Name"]
				link = questHistory.Reward[i].Link

				QuestQualityColors(item, name, nil, link)
			end
		end

		if money == 0 and honor > 0 and (numQuestRewards > 0 or numQuestChoices > 0 or numQuestSpellRewards) then
			local honorFrame = _G["QuestGuru_QuestHistoryHonorFrame"]
			local questItemReceiveText = _G["QuestGuru_QuestHistoryItemReceiveText"]
			local spacerFrame = QuestGuru_QuestHistorySpacerFrame

			honorFrame:ClearAllPoints()
			if numQuestRewards > 0 then
				honorFrame:Point("TOPLEFT", questItemName..totalRewards, "BOTTOMLEFT", 0, -3)
				QuestFrame_SetAsLastShown("QuestGuru_QuestHistoryHonorFrame", spacerFrame)
			else
				honorFrame:Point("TOPLEFT", questItemReceiveText, "BOTTOMLEFT", -3, -6)

				if numQuestSpellRewards > 0 then
					questItemReceiveText:SetText(REWARD_ITEMS)
					questItemReceiveText:Point("TOPLEFT", questItemName..totalRewards, "BOTTOMLEFT", 3, 15)
				elseif numQuestChoices > 0 then
					questItemReceiveText:SetText(REWARD_ITEMS)
					index = numQuestChoices
					if mod(index, 2) == 0 then
						index = index - 1
					end

					questItemReceiveText:Point("TOPLEFT", questItemName..index, "BOTTOMLEFT", 3, 15)
				else
					questItemReceiveText:SetText(REWARD_ITEMS_ONLY)
					questItemReceiveText:Point("TOPLEFT", QuestGuru_QuestHistoryRewardTitleText, "BOTTOMLEFT", 3, 15)
				end

				QuestFrame_SetAsLastShown(questItemReceiveText, spacerFrame)
			end
		end
	end)

	hooksecurefunc("QuestGuru_QuestHistoryFrameItems_Update", function()
		if not QuestHistoryItemHighlight.isSkinned then
			QuestHistoryItemHighlight:StripTextures()

			QuestHistoryItemHighlight.bg = CreateFrame("Frame", nil, QuestHistoryItemHighlight)
			QuestHistoryItemHighlight.bg:SetTemplate()
			QuestHistoryItemHighlight.bg:SetBackdropColor(0, 0, 0, 0)
			QuestHistoryItemHighlight.bg:SetBackdropBorderColor(1, 1, 0)
			QuestHistoryItemHighlight.bg:Point("TOPLEFT", 8, -7)
			QuestHistoryItemHighlight.bg:Point("BOTTOMRIGHT", -105, 17)

			QuestHistoryItemHighlight.isSkinned = true
		end
	end)

	-- QuestGuru Abandon Hooks
	hooksecurefunc("QuestLog_UpdateQuestAbandonDetails", function()
		for i = 1, 10 do
			_G["QuestGuru_QuestAbandonObjective"..i]:SetTextColor(0.6, 0.6, 0.6)
		end
	end)

	hooksecurefunc("QuestGuru_QuestAbandonFrameItems_Update", function()
		local questAbandon
		local questFound = false
		local scrollOffset = FauxScrollFrame_GetOffset(QuestGuru_QuestAbandonListScrollFrame)
		local qID = _G["QuestGuru_QuestAbandonTitle"..QuestGuru_currAbandon - scrollOffset].qID

		for i, qH in ipairs(QuestGuru_Abandon) do
			if qH.qID == qID then
				questAbandon = qH
				questFound = true
				break
			end
		end
		if not questFound then return end

		local item, name, link
		local index, baseIndex
		local rewardsCount = 0

		local numQuestChoices = questAbandon.Choices
		local numQuestRewards = questAbandon.Rewards
		local numQuestSpellRewards = questAbandon.SpellRewards
		local money = questAbandon.RewardMoney
		local honor = questAbandon.Honor
		local totalRewards = numQuestRewards + numQuestChoices + numQuestSpellRewards
		local questItemName = "QuestGuru_QuestAbandonItem"

		if numQuestChoices > 0 then
			baseIndex = rewardsCount

			for i = 1, numQuestChoices, 1 do
				index = i + baseIndex

				item = _G[questItemName..index]
				name = _G[questItemName..index.."Name"]
				link = questAbandon.Choice[i].Link

				QuestQualityColors(item, name, nil, link)

				rewardsCount = rewardsCount + 1
			end
		end

		if numQuestRewards > 0 then
			baseIndex = rewardsCount

			for i = 1, numQuestRewards, 1 do
				index = i + baseIndex

				item = _G[questItemName..index]
				name = _G[questItemName..index.."Name"]
				link = questAbandon.Reward[i].Link

				QuestQualityColors(item, name, nil, link)

				rewardsCount = rewardsCount + 1
			end
		end

		if money == 0 and honor > 0 and (numQuestRewards > 0 or numQuestChoices > 0 or numQuestSpellRewards) then
			local honorFrame = _G["QuestGuru_QuestAbandonHonorFrame"]
			local questItemReceiveText = _G["QuestGuru_QuestAbandonItemReceiveText"]
			local spacerFrame = QuestGuru_QuestAbandonSpacerFrame

			honorFrame:ClearAllPoints()
			if numQuestRewards > 0 then
				honorFrame:Point("TOPLEFT", questItemName..totalRewards, "BOTTOMLEFT", 0, -3)
				QuestFrame_SetAsLastShown("QuestGuru_QuestAbandonHonorFrame", spacerFrame)
			else
				honorFrame:Point("TOPLEFT", questItemReceiveText, "BOTTOMLEFT", -3, -6)
				questItemReceiveText:ClearAllPoints()
				if numQuestSpellRewards > 0 then
					questItemReceiveText:SetText(REWARD_ITEMS)
					questItemReceiveText:Point("TOPLEFT", questItemName..totalRewards, "BOTTOMLEFT", 3, 15)
				elseif numQuestChoices > 0 then
					questItemReceiveText:SetText(REWARD_ITEMS)
					index = numQuestChoices
					if mod(index, 2) == 0 then
						index = index - 1
					end
					questItemReceiveText:Point("TOPLEFT", questItemName..index, "BOTTOMLEFT", 3, 15)
				else
					questItemReceiveText:SetText(REWARD_ITEMS_ONLY)
					questItemReceiveText:Point("TOPLEFT", QuestGuru_QuestAbandonRewardTitleText, "BOTTOMLEFT", 3, 15)
				end
				QuestFrame_SetAsLastShown(questItemReceiveText, spacerFrame)
			end
		end
	end)

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
	end

	hooksecurefunc("QuestFrameItems_Update", function()
		local titleTextColor = {1, 0.80, 0.10}
		local textColor = {1, 1, 1}

		-- Quest Log
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

		-- QuestGuru Log Text
		QuestGuru_QuestLogDescriptionTitle:SetTextColor(unpack(titleTextColor))
		QuestGuru_QuestLogQuestTitle:SetTextColor(unpack(titleTextColor))
		QuestGuru_QuestLogPlayerTitleText:SetTextColor(unpack(titleTextColor))
		QuestGuru_QuestLogRewardTitleText:SetTextColor(unpack(titleTextColor))

		QuestGuru_QuestLogObjectivesText:SetTextColor(unpack(textColor))
		QuestGuru_QuestLogQuestDescription:SetTextColor(unpack(textColor))
		QuestGuru_QuestLogItemChooseText:SetTextColor(unpack(textColor))
		QuestGuru_QuestLogItemReceiveText:SetTextColor(unpack(textColor))
		QuestGuru_QuestLogSpellLearnText:SetTextColor(unpack(textColor))

		-- QuestGuru History Text
		QuestGuru_QuestHistoryDescriptionTitle:SetTextColor(unpack(titleTextColor))
		QuestGuru_QuestHistoryDescriptionTitle.SetTextColor = E.noop
		QuestGuru_QuestHistoryQuestTitle:SetTextColor(unpack(titleTextColor))
		QuestGuru_QuestHistoryQuestTitle.SetTextColor = E.noop
		QuestGuru_QuestHistoryPlayerTitleText:SetTextColor(unpack(titleTextColor))
		QuestGuru_QuestHistoryPlayerTitleText.SetTextColor = E.noop
		QuestGuru_QuestHistoryRewardTitleText:SetTextColor(unpack(titleTextColor))
		QuestGuru_QuestHistoryRewardTitleText.SetTextColor = E.noop

		QuestGuru_QuestHistoryObjectivesText:SetTextColor(unpack(textColor))
		QuestGuru_QuestHistoryObjectivesText.SetTextColor = E.noop
		QuestGuru_QuestHistoryQuestDescription:SetTextColor(unpack(textColor))
		QuestGuru_QuestHistoryQuestDescription.SetTextColor = E.noop
		QuestGuru_QuestHistoryItemChooseText:SetTextColor(unpack(textColor))
		QuestGuru_QuestHistoryItemChooseText.SetTextColor = E.noop
		QuestGuru_QuestHistoryItemReceiveText:SetTextColor(unpack(textColor))
		QuestGuru_QuestHistoryItemReceiveText.SetTextColor = E.noop
		QuestGuru_QuestHistorySpellLearnText:SetTextColor(unpack(textColor))
		QuestGuru_QuestHistorySpellLearnText.SetTextColor = E.noop

		-- QuestGuru Abandon Text
		QuestGuru_QuestAbandonDescriptionTitle:SetTextColor(unpack(titleTextColor))
		QuestGuru_QuestAbandonDescriptionTitle.SetTextColor = E.noop
		QuestGuru_QuestAbandonQuestTitle:SetTextColor(unpack(titleTextColor))
		QuestGuru_QuestAbandonQuestTitle.SetTextColor = E.noop
		QuestGuru_QuestAbandonPlayerTitleText:SetTextColor(unpack(titleTextColor))
		QuestGuru_QuestAbandonPlayerTitleText.SetTextColor = E.noop
		QuestGuru_QuestAbandonRewardTitleText:SetTextColor(unpack(titleTextColor))
		QuestGuru_QuestAbandonRewardTitleText.SetTextColor = E.noop

		QuestGuru_QuestAbandonObjectivesText:SetTextColor(unpack(textColor))
		QuestGuru_QuestAbandonObjectivesText.SetTextColor = E.noop
		QuestGuru_QuestAbandonQuestDescription:SetTextColor(unpack(textColor))
		QuestGuru_QuestAbandonQuestDescription.SetTextColor = E.noop
		QuestGuru_QuestAbandonItemChooseText:SetTextColor(unpack(textColor))
		QuestGuru_QuestAbandonItemChooseText.SetTextColor = E.noop
		QuestGuru_QuestAbandonItemReceiveText:SetTextColor(unpack(textColor))
		QuestGuru_QuestAbandonItemReceiveText.SetTextColor = E.noop
		QuestGuru_QuestAbandonSpellLearnText:SetTextColor(unpack(textColor))
		QuestGuru_QuestAbandonSpellLearnText.SetTextColor = E.noop

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

		local numQuestSpellRewards = 0
		local numQuestRewards, numQuestChoices = GetNumQuestLogRewards(), GetNumQuestLogChoices()
		if GetQuestLogRewardSpell() then
			numQuestSpellRewards = 1
		end
		local money = GetQuestLogRewardMoney()
		local honor = GetQuestLogRewardHonor()
		local rewardsCount = numQuestChoices + numQuestRewards + numQuestSpellRewards

		local questItemName = "QuestGuru_QuestLogItem"

		if rewardsCount > 0 then
			local questItem, itemName, link
			for i = 1, rewardsCount do
				questItem = _G[questItemName..i]
				itemName = _G[questItemName..i.."Name"]
				link = questItem.type and GetQuestLogItemLink(questItem.type, questItem:GetID())

				QuestQualityColors(questItem, itemName, nil, link)
			end
		end

		if money == 0 and honor > 0 and (numQuestRewards > 0 or numQuestChoices > 0 or numQuestSpellRewards) then
			local honorFrame = _G["QuestGuru_QuestLogHonorFrame"]
			local questItemReceiveText = _G["QuestGuru_QuestLogItemReceiveText"]
			local spacerFrame = QuestLogSpacerFrame

			honorFrame:ClearAllPoints()
			if numQuestRewards > 0 then
				honorFrame:Point("TOPLEFT", questItemName..rewardsCount, "BOTTOMLEFT", 0, -3)
				QuestFrame_SetAsLastShown("QuestGuru_QuestLogHonorFrame", spacerFrame)
			else
				honorFrame:Point("TOPLEFT", questItemReceiveText, "BOTTOMLEFT", -3, -6)

				if numQuestSpellRewards > 0 then
					questItemReceiveText:SetText(REWARD_ITEMS)
					questItemReceiveText:Point("TOPLEFT", questItemName..rewardsCount, "BOTTOMLEFT", 3, 15)
				elseif numQuestChoices > 0 then
					questItemReceiveText:SetText(REWARD_ITEMS)
					local index = numQuestChoices
					if mod(index, 2) == 0 then
						index = index - 1
					end

					questItemReceiveText:Point("TOPLEFT", questItemName..index, "BOTTOMLEFT", 3, 15)
				else
					questItemReceiveText:SetText(REWARD_ITEMS_ONLY)
					questItemReceiveText:Point("TOPLEFT", QuestGuru_QuestLogRewardTitleText, "BOTTOMLEFT", 3, 15)
				end

				QuestFrame_SetAsLastShown(questItemReceiveText, spacerFrame)
			end
		end
	end)

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
	QuestGuru_QuestLogTitleText:SetText("")

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

	-- Expand / Collapse All Button
	QuestGuru_QuestFrameExpandCollapseButton:StripTextures()
	QuestGuru_QuestFrameExpandCollapseButton:SetText("")
	QuestGuru_QuestFrameExpandCollapseButton:SetNormalTexture("Interface\\AddOns\\ElvUI\\media\\textures\\PlusMinusButton")
	QuestGuru_QuestFrameExpandCollapseButton.SetNormalTexture = E.noop
	QuestGuru_QuestFrameExpandCollapseButton:GetNormalTexture():SetTexCoord(0.040, 0.465, 0.085, 0.920)
	QuestGuru_QuestFrameExpandCollapseButton:GetNormalTexture().SetTexCoord = E.noop
	QuestGuru_QuestFrameExpandCollapseButton:SetPushedTexture("Interface\\AddOns\\ElvUI\\media\\textures\\PlusMinusButton")
	QuestGuru_QuestFrameExpandCollapseButton.SetPushedTexture = E.noop
	QuestGuru_QuestFrameExpandCollapseButton:GetPushedTexture():SetTexCoord(0.040, 0.465, 0.085, 0.920)
	QuestGuru_QuestFrameExpandCollapseButton:GetPushedTexture().SetTexCoord = E.noop
	QuestGuru_QuestFrameExpandCollapseButton:SetHighlightTexture("")
	QuestGuru_QuestFrameExpandCollapseButton.SetHighlightTexture = E.noop
	QuestGuru_QuestFrameExpandCollapseButton:SetDisabledTexture("")
	QuestGuru_QuestFrameExpandCollapseButton.SetDisabledTexture = E.noop
	QuestGuru_QuestFrameExpandCollapseButton:Point("TOPLEFT", 21, -31)

	-- Expand / Collapse Buttons
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

	-- QuestGuru Log
	QuestGuru_QuestLogNoQuestsText:ClearAllPoints()
	QuestGuru_QuestLogNoQuestsText:Point("CENTER", QuestGuru_EmptyQuestLogFrame, "CENTER", -45, 65)

	QuestGuru_QuestLogListScrollFrame:StripTextures()
	QuestGuru_QuestLogListScrollFrame:CreateBackdrop("Default", true)
	QuestGuru_QuestLogListScrollFrame:Size(305, 410)
	QuestGuru_QuestLogListScrollFrame:Show()
	QuestGuru_QuestLogListScrollFrame.Hide = E.noop

	QuestGuru_QuestLogDetailScrollFrame:StripTextures()
	QuestGuru_QuestLogDetailScrollFrame:CreateBackdrop("Default", true)
	QuestGuru_QuestLogDetailScrollFrame:Size(305, 410)
	QuestGuru_QuestLogDetailScrollFrame:SetHitRectInsets(0, 0, 0, 2)

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
	QuestGuru_QuestFrameExitButton:Width(105)

	-- QuestGuru History
	QuestGuru_QuestHistoryListScrollFrame:StripTextures()
	QuestGuru_QuestHistoryListScrollFrame:CreateBackdrop("Default", true)
	QuestGuru_QuestHistoryListScrollFrame:Size(305, 410)
	QuestGuru_QuestHistoryListScrollFrame:Show()
	QuestGuru_QuestHistoryListScrollFrame.Hide = E.noop

	QuestGuru_QuestHistoryDetailScrollFrame:StripTextures()
	QuestGuru_QuestHistoryDetailScrollFrame:CreateBackdrop("Default", true)
	QuestGuru_QuestHistoryDetailScrollFrame:Size(305, 410)
	QuestGuru_QuestHistoryDetailScrollFrame:SetHitRectInsets(0, 0, 0, 2)

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
	QuestGuru_QuestAbandonListScrollFrame:Show()
	QuestGuru_QuestAbandonListScrollFrame.Hide = E.noop

	QuestGuru_QuestAbandonDetailScrollFrame:StripTextures()
	QuestGuru_QuestAbandonDetailScrollFrame:CreateBackdrop("Default", true)
	QuestGuru_QuestAbandonDetailScrollFrame:Size(305, 410)
	QuestGuru_QuestAbandonDetailScrollFrame:SetHitRectInsets(0, 0, 0, 2)

	S:HandleScrollBar(QuestGuru_QuestAbandonListScrollFrameScrollBar)
	S:HandleScrollBar(QuestGuru_QuestAbandonDetailScrollFrameScrollBar)

	S:HandleButton(QuestGuru_QuestAbandonClearList)
	QuestGuru_QuestAbandonClearList:ClearAllPoints()
	QuestGuru_QuestAbandonClearList:Point("RIGHT", QuestGuru_QuestFrameExitButton, "LEFT", -2, 0)

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

	-- QuestGuru Main Options
	S:HandleCheckBox(QuestGuru_OptionsFrameColorizePlayerNameToggle)
	S:HandleCheckBox(QuestGuru_OptionsFrameColorizeAreaNamesToggle)
	S:HandleCheckBox(QuestGuru_OptionsFrameColorizeNPCNamesToggle)
	S:HandleCheckBox(QuestGuru_OptionsFrameShowTooltipTextToggle)
	S:HandleCheckBox(QuestGuru_OptionsFrameAutoCompleteToggle)
	S:HandleCheckBox(QuestGuru_OptionsFrameAltStatusToggle)
	S:HandleCheckBox(QuestGuru_OptionsFrameGuildStatusToggle)
	S:HandleCheckBox(QuestGuru_OptionsFrameSimpleGuildStatusToggle)
	S:HandleCheckBox(QuestGuru_OptionsFrameShowObjItemIconsToggle)
	S:HandleCheckBox(QuestGuru_OptionsFrameDisableCommToggle)
	S:HandleCheckBox(QuestGuru_OptionsFrameShowLevelsQuestLogToggle)
	S:HandleCheckBox(QuestGuru_OptionsFrameShowLevelsHistoryToggle)
	S:HandleCheckBox(QuestGuru_OptionsFrameShowLevelsAbandonToggle)

	-- QuestGuru Tracker Options
	S:HandleCheckBox(QuestGuru_OptionsFrameTrackerEnabledToggle)
	S:HandleCheckBox(QuestGuru_OptionsFrameTrackerBorderToggle)
	S:HandleCheckBox(QuestGuru_OptionsFrameTrackerClickThroughToggle)
	S:HandleCheckBox(QuestGuru_OptionsFrameTrackerAutoTrackToggle)
	S:HandleCheckBox(QuestGuru_OptionsFrameTrackerAutoTrackToggle)
	S:HandleCheckBox(QuestGuru_OptionsFrameTrackerShowCompletedObjToggle)
	S:HandleCheckBox(QuestGuru_OptionsFrameTrackerColorizeObjToggle)
	S:HandleCheckBox(QuestGuru_OptionsFrameTrackerHeadersToggle)
	S:HandleCheckBox(QuestGuru_OptionsFrameTrackerShowLevelsToggle)
	S:HandleCheckBox(QuestGuru_OptionsFrameTrackerQuestTooltipsToggle)
	S:HandleCheckBox(QuestGuru_OptionsFrameTrackerPartyTooltipsToggle)
	S:HandleCheckBox(QuestGuru_OptionsFrameTrackerQuestPercentToggle)
	S:HandleCheckBox(QuestGuru_OptionsFrameTrackerExpandUpToggle)
	S:HandleCheckBox(QuestGuru_OptionsFrameTrackerAutoUnTrackToggle)

	S:HandleSliderFrame(QuestGuru_OptionsFrameTrackerLines)
	S:HandleSliderFrame(QuestGuru_OptionsFrameTrackerScale)
	S:HandleSliderFrame(QuestGuru_OptionsFrameTrackerAlpha)

	-- QuestGuru Sound Options
	S:HandleCheckBox(QuestGuru_OptionsFrameSoundToggle)
	S:HandleCheckBox(QuestGuru_OptionsFrameSoundProgressToggle)
	S:HandleCheckBox(QuestGuru_OptionsFrameSoundObjCompleteToggle)
	S:HandleCheckBox(QuestGuru_OptionsFrameSoundQuestCompleteToggle)

	S:HandleDropDownBox(QuestGuru_OptionsFrameSoundProgressButton, 300)
	S:HandleDropDownBox(QuestGuru_OptionsFrameSoundObjCompleteButton, 300)
	S:HandleDropDownBox(QuestGuru_OptionsFrameSoundQuestCompleteButton, 300)

	-- QuestGuru Announcer Options
	S:HandleCheckBox(QuestGuru_AnnounceFrameAnnounceToggle)
	S:HandleCheckBox(QuestGuru_AnnounceFrameChannelSayToggle)
	S:HandleCheckBox(QuestGuru_AnnounceFrameChannelPartyToggle)
	S:HandleCheckBox(QuestGuru_AnnounceFrameChannelGuildToggle)
	S:HandleCheckBox(QuestGuru_AnnounceFrameChannelWhisperToggle)
	S:HandleCheckBox(QuestGuru_AnnounceFrameMessageItemToggle)
	S:HandleCheckBox(QuestGuru_AnnounceFrameMessageMonsterToggle)
	S:HandleCheckBox(QuestGuru_AnnounceFrameMessageEventToggle)
	S:HandleCheckBox(QuestGuru_AnnounceFrameMessageQuestToggle)

	S:HandleEditBox(QuestGuru_AnnounceFrameChannelWhisperTo)
	S:HandleEditBox(QuestGuru_AnnounceFrameMessageItem)
	S:HandleEditBox(QuestGuru_AnnounceFrameMessageMonster)
	S:HandleEditBox(QuestGuru_AnnounceFrameMessageEvent)
	S:HandleEditBox(QuestGuru_AnnounceFrameMessageQuest)
	
	S:HandleButton(QuestGuru_AnnounceFrameMessageHelpButton)
end

S:AddCallbackForAddon("QuestGuru", "QuestGuru", LoadSkin)