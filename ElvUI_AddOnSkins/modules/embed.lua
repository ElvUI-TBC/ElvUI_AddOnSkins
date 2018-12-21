local E, L, V, P, G = unpack(ElvUI)
local EMB = E:NewModule("EmbedSystem")
local AS = E:GetModule("AddOnSkins")

local _G = _G
local pairs, tonumber = pairs, tonumber
local floor = math.floor
local format, lower, match = string.format, string.lower, string.match
local tinsert = table.insert

local hooksecurefunc = hooksecurefunc
local NUM_CHAT_WINDOWS = NUM_CHAT_WINDOWS

function EMB:GetChatWindowInfo()
	local chatTabInfo = {["NONE"] = "NONE"}
	for i = 1, NUM_CHAT_WINDOWS do
		chatTabInfo["ChatFrame"..i] = _G["ChatFrame"..i.."Tab"]:GetText()
	end
	return chatTabInfo
end

function EMB:ToggleChatFrame(hide)
	local chatFrame = E.db.addOnSkins.embed.hideChat
	if chatFrame == "NONE" then return end

	if hide then
		_G[chatFrame].originalParent = _G[chatFrame]:GetParent()
		_G[chatFrame]:SetParent(E.HiddenFrame)

		_G[chatFrame.."Tab"].originalParent = _G[chatFrame.."Tab"]:GetParent()
		_G[chatFrame.."Tab"]:SetParent(E.HiddenFrame)
	else
		if _G[chatFrame].originalParent then
			_G[chatFrame]:SetParent(_G[chatFrame].originalParent)
			_G[chatFrame.."Tab"]:SetParent(_G[chatFrame.."Tab"].originalParent)
		end
	end
end

function EMB:EmbedShow()
	if _G[self.leftFrame.frameName] then
		_G[self.leftFrame.frameName]:Show()
	end

	if E.db.addOnSkins.embed.embedType == "DOUBLE" then
		if _G[self.rightFrame.frameName] then
			_G[self.rightFrame.frameName]:Show()
		end
	end

	self:ToggleChatFrame(true)
	self.switchButton:SetAlpha(1)
end

function EMB:EmbedHide()
	if _G[self.leftFrame.frameName] then
		_G[self.leftFrame.frameName]:Hide()
	end

	if E.db.addOnSkins.embed.embedType == "DOUBLE" then
		if _G[self.rightFrame.frameName] then
			_G[self.rightFrame.frameName]:Hide()
		end
	end

	self:ToggleChatFrame(false)
	self.switchButton:SetAlpha(0.6)
end

function EMB:CheckEmbed(addon)
	local db = E.db.addOnSkins.embed
	local left, right, embed = lower(db.leftWindow), lower(db.rightWindow), lower(addon)

	if AS:CheckAddOn(addon) and ((db.embedType == "SINGLE" and match(left, embed)) or db.embedType == "DOUBLE" and (match(left, embed) or match(right, embed))) then
		return true
	else
		return false
	end
end

function EMB:EmbedUpdate()
	if E.db.addOnSkins.embed.embedType == "DISABLE" then return end

	if not self.embedCreated then
		self:EmbedCreate()
	end

	self:WindowResize()

	if self:CheckEmbed("Omen") then self:EmbedOmen() end
	if self:CheckEmbed("Recount") then self:EmbedRecount() end
end

function EMB:SetHooks()
	hooksecurefunc(E:GetModule("Chat"), "PositionChat", function(self, override)
		if override then
			EMB:EmbedUpdate()
		end
	end)
	hooksecurefunc(E:GetModule("Layout"), "ToggleChatPanels", function() EMB:EmbedUpdate() end)

	hooksecurefunc(LeftChatPanel, "fadeFunc", function()
		LeftChatPanel:Hide()
		if not E.db.addOnSkins.embed.rightChatPanel then
			EMB.switchButton:Hide()
		end
	end)
	hooksecurefunc(RightChatPanel, "fadeFunc", function()
		RightChatPanel:Hide()
		if E.db.addOnSkins.embed.rightChatPanel then
			EMB.switchButton:Hide()
		end
	end)

	RightChatToggleButton:RegisterForClicks("AnyDown")
	RightChatToggleButton:SetScript("OnClick", function(self, btn)
		if btn == "RightButton" then
			if E.db.addOnSkins.embed.rightChatPanel then
				if EMB.mainFrame:IsShown() then
					EMB.mainFrame:Hide()
				else
					EMB.mainFrame:Show()
				end
			end
		else
			if E.db[self.parent:GetName().."Faded"] then
				E.db[self.parent:GetName().."Faded"] = nil
				UIFrameFadeIn(self.parent, 0.2, self.parent:GetAlpha(), 1)
				UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1)
			else
				E.db[self.parent:GetName().."Faded"] = true
				UIFrameFadeOut(self.parent, 0.2, self.parent:GetAlpha(), 0)
				UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0)
				self.parent.fadeInfo.finishedFunc = self.parent.fadeFunc
			end
		end
		EMB:UpdateSwitchButton()
	end)

	RightChatToggleButton:HookScript2("OnEnter", function()
		if E.db.addOnSkins.embed.rightChatPanel then
			GameTooltip:AddDoubleLine(L["Right Click:"], L["Toggle Embedded Addon"], 1, 1, 1)
			GameTooltip:Show()
			EMB:UpdateSwitchButton()
		end
	end)

	LeftChatToggleButton:RegisterForClicks("AnyDown")
	LeftChatToggleButton:SetScript("OnClick", function(self, btn)
		if btn == "RightButton" then
			if not E.db.addOnSkins.embed.rightChatPanel then
				if EMB.mainFrame:IsShown() then
					EMB.mainFrame:Hide()
				else
					EMB.mainFrame:Show()
				end
			end
		else
			if E.db[self.parent:GetName().."Faded"] then
				E.db[self.parent:GetName().."Faded"] = nil
				UIFrameFadeIn(self.parent, 0.2, self.parent:GetAlpha(), 1)
				UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1)
			else
				E.db[self.parent:GetName().."Faded"] = true
				UIFrameFadeOut(self.parent, 0.2, self.parent:GetAlpha(), 0)
				UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0)
				self.parent.fadeInfo.finishedFunc = self.parent.fadeFunc
			end
		end
		EMB:UpdateSwitchButton()
	end)

	LeftChatToggleButton:HookScript2("OnEnter", function()
		if not E.db.addOnSkins.embed.rightChatPanel then
			GameTooltip:AddDoubleLine(L["Right Click:"], L["Toggle Embedded Addon"], 1, 1, 1)
			GameTooltip:Show()
			EMB:UpdateSwitchButton()
		end
	end)

	function HideLeftChat()
		LeftChatToggleButton:Click()
	end

	function HideRightChat()
		RightChatToggleButton:Click()
	end

	function HideBothChat()
		LeftChatToggleButton:Click()
		RightChatToggleButton:Click()
	end
end

function EMB:WindowResize()
	if not self.embedCreated then return end

	local db = E.db.addOnSkins.embed
	local SPACING = E.Border + E.Spacing
	local chatPanel = db.rightChatPanel and RightChatPanel or LeftChatPanel
	local chatTab = db.rightChatPanel and RightChatTab or LeftChatTab
	local chatData = db.rightChatPanel and RightChatDataPanel or LeftChatToggleButton
	local topRight = chatData == RightChatDataPanel and (E.db.datatexts.rightChatPanel and "TOPLEFT" or "BOTTOMLEFT") or chatData == LeftChatToggleButton and (E.db.datatexts.leftChatPanel and "TOPLEFT" or "BOTTOMLEFT")
	local yOffset = (chatData == RightChatDataPanel and E.db.datatexts.rightChatPanel and SPACING) or (chatData == LeftChatToggleButton and E.db.datatexts.leftChatPanel and SPACING) or 0
	local xOffset = (E.db.chat.panelBackdrop == "RIGHT" and db.rightChatPanel and 0) or (E.db.chat.panelBackdrop == "LEFT" and not db.rightChatPanel and 0) or (E.db.chat.panelBackdrop == "SHOWBOTH" and 0) or E.Border*3 - E.Spacing
	local isDouble = db.embedType == "DOUBLE"

	self.mainFrame:SetParent(chatPanel)
	self.mainFrame:ClearAllPoints()

	self.mainFrame:Point("BOTTOMLEFT", chatData, topRight, 0, yOffset)
	self.mainFrame:Point("TOPRIGHT", chatTab, db.belowTopTab and "BOTTOMRIGHT" or "TOPRIGHT", xOffset, db.belowTopTab and -SPACING or 0)

	-- Ensure that the embed-frame is always rendered *above* the chatwindow text to avoid clipping.
	-- NOTE: "SetFrameStrata" MUST be executed AFTER the "SetParent" call (above), since re-parenting always inherits parent's strata!
	self.mainFrame:SetFrameStrata("MEDIUM")

	if isDouble then
		self.leftFrame:ClearAllPoints()
		self.leftFrame:Point("TOPLEFT", self.mainFrame)
		self.leftFrame:Point("BOTTOMRIGHT", self.mainFrame, "BOTTOMRIGHT", -(self.mainFrame:GetWidth() - db.leftWindowWidth + SPACING), 0)

		self.rightFrame:ClearAllPoints()
		self.rightFrame:Point("TOPLEFT", self.leftFrame, "TOPRIGHT", SPACING, 0)
		self.rightFrame:Point("BOTTOMRIGHT", self.mainFrame)
	else
		self.leftFrame:ClearAllPoints()
		self.leftFrame:Point("TOPLEFT", self.mainFrame)
		self.leftFrame:Point("BOTTOMRIGHT", self.mainFrame)
	end

	self:UpdateSwitchButton()

	if IsAddOnLoaded("ElvUI_Config") then
		E.Options.args.elvuiPlugins.args.addOnSkins.args.embed.args.leftWindowWidth.min = floor(chatPanel:GetWidth() * .25)
		E.Options.args.elvuiPlugins.args.addOnSkins.args.embed.args.leftWindowWidth.max = floor(chatPanel:GetWidth() * .75)
	end
end

function EMB:UpdateSwitchButton()
	local db = E.db.addOnSkins.embed
	local chatPanel = db.rightChatPanel and RightChatPanel or LeftChatPanel
	local chatTab = db.rightChatPanel and RightChatTab or LeftChatTab
	local isDouble = db.embedType == "DOUBLE"

	self.switchButton:SetParent(chatPanel)

	if db.belowTopTab and chatPanel:IsShown() then
		self.switchButton:Show()
		self.switchButton.text:SetText(isDouble and db.leftWindow.." / "..db.rightWindow or db.leftWindow)
		self.switchButton:ClearAllPoints()

		if E.Chat.RightChatWindowID and _G["ChatFrame"..E.Chat.RightChatWindowID.."Tab"]:IsVisible() then
			self.switchButton:Point("LEFT", _G["ChatFrame"..E.Chat.RightChatWindowID.."Tab"], "RIGHT", 0, 0)
		else
			self.switchButton:Point(db.rightChatPanel and "LEFT" or "RIGHT", chatTab, 5, 4)
		end
	elseif self.switchButton:IsShown() then
		self.switchButton:Hide()
	end
end

function EMB:EmbedCreate()
	if self.embedCreated then return end

	self.mainFrame = CreateFrame("Frame", "ElvUI_AddOnSkins_Embed_MainWindow", UIParent)
	self.leftFrame = CreateFrame("Frame", "ElvUI_AddOnSkins_Embed_LeftWindow", self.mainFrame)
	self.rightFrame = CreateFrame("Frame", "ElvUI_AddOnSkins_Embed_RightWindow", self.mainFrame)

	self.switchButton = CreateFrame("Button", "ElvUI_AddOnSkins_Embed_SwitchButton", UIParent)
	self.switchButton:Size(120, 32)
	self.switchButton:RegisterForClicks("AnyUp")

	self.switchButton.text = self.switchButton:CreateFontString(nil, "OVERLAY")
	self.switchButton.text:FontTemplate(E.LSM:Fetch("font", E.db.chat.tabFont), E.db.chat.tabFontSize, E.db.chat.tabFontOutline)
	self.switchButton.text:SetTextColor(unpack(E["media"].rgbvaluecolor))
	self.switchButton.text:SetPoint("LEFT", 16, -5)

	self.switchButton:SetScript("OnClick", function(self, button)
		if EMB.mainFrame:IsShown() then
			EMB.mainFrame:Hide()
			self:SetAlpha(0.6)
		else
			EMB.mainFrame:Show()
			self:SetAlpha(1)
		end
		EMB:UpdateSwitchButton()
	end)

	self.switchButton:SetScript("OnMouseDown", function(self) self.text:Point("LEFT", 18, -7) end)
	self.switchButton:SetScript("OnMouseUp", function(self) self.text:Point("LEFT", 16, -5) end)

	self.mainFrame:SetScript("OnShow", function() EMB:EmbedShow() end)
	self.mainFrame:SetScript("OnHide", function() EMB:EmbedHide() end)

	self.embedCreated = true

	self:SetHooks()
	self:ToggleChatFrame(false)
	self:EmbedUpdate()
end

if AS:CheckAddOn("Recount") then
	function EMB:EmbedRecount()
		local parent = self.leftFrame
		if E.db.addOnSkins.embed.embedType == "DOUBLE" then
			parent = E.db.addOnSkins.embed.rightWindow == "Recount" and self.rightFrame or self.leftFrame
		end
		parent.frameName = "Recount_MainWindow"

		Recount.db.profile.Locked = true
		Recount.db.profile.Scaling = 1
		Recount:LockWindows(true)
		Recount:ScaleWindows(1)

		Recount_MainWindow:SetParent(parent)
		Recount_MainWindow:ClearAllPoints()
		Recount_MainWindow:SetPoint("TOPLEFT", parent, "TOPLEFT", E.PixelMode and -1 or 0, E.PixelMode and 8 or 7)
		Recount_MainWindow:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", E.PixelMode and 1 or 0, E.PixelMode and -1 or 0)

		Recount_MainWindow:StartSizing("BOTTOMLEFT")
		Recount_MainWindow:StopMovingOrSizing()
		Recount:ResizeMainWindow()
	end
end

if AS:CheckAddOn("Omen") then
	function EMB:EmbedOmen()
		local parent = self.leftFrame
		if E.db.addOnSkins.embed.embedType == "DOUBLE" then
			parent = E.db.addOnSkins.embed.rightWindow == "Omen" and self.rightFrame or self.leftFrame
		end
		parent.frameName = "OmenAnchor"

		local db = Omen.Options
		db["Skin.Scale"] = 100
		db["Lock"] = true

		OmenAnchor:SetParent(parent)
		OmenAnchor:ClearAllPoints()
		OmenAnchor:SetAllPoints()

		Omen:UpdateDisplay()

		hooksecurefunc(Omen, "SetAnchors", function(self, useDB)
			self.Anchor:SetParent(parent)
			self.Anchor:SetInside(parent, 0, 0)

			if Omen.activeModule then
				Omen.activeModule:UpdateLayout()
			end
			Omen:ResizeBars()
		end)
	end
end

function EMB:Initialize()
	if E.db.addOnSkins.embed.embedType == "DISABLE" then return end

	self:EmbedCreate()
end

local function InitializeCallback()
	EMB:Initialize()
end

E:RegisterModule(EMB:GetName(), InitializeCallback)