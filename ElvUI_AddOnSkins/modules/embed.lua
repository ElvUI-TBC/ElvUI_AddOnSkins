local E, L, V, P, G = unpack(ElvUI);
local module = E:NewModule("EmbedSystem");
local addon = E:GetModule("AddOnSkins");

local _G = _G;
local pairs, tonumber = pairs, tonumber;
local format, lower, floor = string.format, string.lower, math.floor;
local tinsert = table.insert;

local hooksecurefunc = hooksecurefunc;
local NUM_CHAT_WINDOWS = NUM_CHAT_WINDOWS;

function module:GetChatWindowInfo()
	local chatTabInfo = {["NONE"] = NONE};
	for i = 1, NUM_CHAT_WINDOWS do
		chatTabInfo["ChatFrame"..i] = _G["ChatFrame"..i.."Tab"]:GetText();
	end
	return chatTabInfo;
end

function module:ToggleChatFrame(hide)
	local chatFrame = E.db.addOnSkins.embed.hideChat;
	if(chatFrame == "NONE") then return; end
	if(hide) then
		_G[chatFrame].originalParent = _G[chatFrame]:GetParent();
		_G[chatFrame]:SetParent(E.HiddenFrame);

		_G[chatFrame.."Tab"].originalParent = _G[chatFrame.."Tab"]:GetParent();
		_G[chatFrame.."Tab"]:SetParent(E.HiddenFrame);
	else
		if(_G[chatFrame].originalParent) then
			_G[chatFrame]:SetParent(_G[chatFrame].originalParent);
			_G[chatFrame.."Tab"]:SetParent(_G[chatFrame.."Tab"].originalParent);
		end
	end
end

function module:Show()
	if(E.db.addOnSkins.embed.embedType == "SINGLE") then
		if(_G[module.left.frameName]) then
			_G[module.left.frameName]:Show();
		end
	end

	if(E.db.addOnSkins.embed.embedType == "DOUBLE") then
		if(_G[module.left.frameName]) then
			_G[module.left.frameName]:Show();
		end
		if(_G[module.right.frameName]) then
			_G[module.right.frameName]:Show();
		end
	end
	module:ToggleChatFrame(true);
	module.switchButton:SetAlpha(1);
	E.db.addOnSkins.embed.isShow = true;
end

function module:Hide()
	if(E.db.addOnSkins.embed.embedType == "SINGLE") then
		if(_G[module.left.frameName]) then
			_G[module.left.frameName]:Hide();
		end
	end

	if(E.db.addOnSkins.embed.embedType == "DOUBLE") then
		if(_G[module.left.frameName]) then
			_G[module.left.frameName]:Hide()
		end
		if(_G[module.right.frameName]) then
			_G[module.right.frameName]:Hide();
		end
	end
	module:ToggleChatFrame(false);
	module.switchButton:SetAlpha(0.6);

	if not E.global.afkEnabled then
		E.db.addOnSkins.embed.isShow = false
	end
end

function module:CheckAddOn(addOn)
	local left, right, embed = lower(E.db.addOnSkins.embed.left), lower(E.db.addOnSkins.embed.right), lower(addOn);
	if(addon:CheckAddOn(addOn) and ((E.db.addOnSkins.embed.embedType == "SINGLE" and strmatch(left, embed)) or E.db.addOnSkins.embed.embedType == "DOUBLE" and (strmatch(left, embed) or strmatch(right, embed)))) then
		return true;
	else
		return false;
	end
end

function module:Check()
	if(E.db.addOnSkins.embed.embedType == "DISABLE") then return; end
	if(not self.embedCreated) then
		self:Init();
	end
	self:Toggle();
	self:WindowResize();

	if(self:CheckAddOn("Omen")) then self:Omen(); end
	if(self:CheckAddOn("Recount")) then self:Recount(); end
end

function module:Toggle()
	self.left.frameName = nil;
	self.right.frameName = nil;

	if(E.db.addOnSkins.embed.embedType == "SINGLE") then
		local left = lower(E.db.addOnSkins.embed.left);
		if(left ~= "omen" and left ~= "recount") then
			self.left.frameName = self.db.left;
		end
	end

	if(E.db.addOnSkins.embed.embedType == "DOUBLE") then
		local right = lower(E.db.addOnSkins.embed.right);
		if(right ~= "omen" and right ~= "recount") then
			self.right.frameName = self.db.right;
		end
	end

	if(self.left.frameName ~= nil) then
		local frame = _G[self.left.frameName];
		if(frame and frame:IsObjectType("Frame") and not frame:IsProtected()) then
			frame:ClearAllPoints();
			frame:SetParent(self.left);
			frame:SetInside(self.left, 0, 0);
		end
	end

	if(self.right.frameName ~= nil) then
		local frame = _G[self.right.frameName];
		if(frame and frame:IsObjectType("Frame") and not frame:IsProtected()) then
			frame:ClearAllPoints();
			frame:SetParent(self.right);
			frame:SetInside(self.right, 0, 0);
		end
	end

	if(E.db.addOnSkins.embed.isShow) then
		self.left:Show();
	else
		self.left:Hide();
	end
end

if(addon:CheckAddOn("Recount")) then
	function module:Recount()
		local parent = self.left;
		if(E.db.addOnSkins.embed.embedType == "DOUBLE") then
			parent = self.db.right == "Recount" and self.right or self.left;
		end
		parent.frameName = "Recount_MainWindow";

		Recount.db.profile.Locked = true
		Recount.db.profile.Scaling = 1
		Recount:LockWindows(true)
		Recount:ScaleWindows(1)

		Recount_MainWindow:SetParent(parent);
		Recount_MainWindow:ClearAllPoints();
		Recount_MainWindow:SetPoint("TOPLEFT", parent, "TOPLEFT", E.PixelMode and -1 or 0, E.PixelMode and 8 or 7);
		Recount_MainWindow:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", E.PixelMode and 1 or 0, E.PixelMode and -1 or 0);

		Recount_MainWindow:StartSizing("BOTTOMLEFT")
		Recount_MainWindow:StopMovingOrSizing()
		Recount:ResizeMainWindow()
	end
end

if(addon:CheckAddOn("Omen")) then
	function module:Omen()
		local parent = self.left;
		if(E.db.addOnSkins.embed.embedType == "DOUBLE") then
			parent = self.db.right == "Omen" and self.right or self.left;
		end
		parent.frameName = "OmenAnchor";

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

function module:Hooks()
	local function ChatPanelLeft_OnFade()
		LeftChatPanel:Hide();
		_G["ElvUI_AddOnSkins_Embed_SwitchButton"]:Hide();
	end

	local function ChatPanelRight_OnFade()
		RightChatPanel:Hide();
		_G["ElvUI_AddOnSkins_Embed_SwitchButton"]:Hide();
	end

	LeftChatPanel.fadeFunc = ChatPanelLeft_OnFade;
	RightChatPanel.fadeFunc = ChatPanelRight_OnFade;

	RightChatToggleButton:RegisterForClicks("AnyDown");
	RightChatToggleButton:SetScript("OnClick", function(self, btn)
		if(btn == "RightButton") then
			if(E.db.addOnSkins.embed.rightChat) then
				if(module.left:IsShown()) then
					module.left:Hide();
				else
					module.left:Show();
				end
			end
		else
			if(E.db[self.parent:GetName().."Faded"]) then
				E.db[self.parent:GetName().."Faded"] = nil;
				UIFrameFadeIn(self.parent, 0.2, self.parent:GetAlpha(), 1);
				UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1);
			else
				E.db[self.parent:GetName().."Faded"] = true;
				UIFrameFadeOut(self.parent, 0.2, self.parent:GetAlpha(), 0);
				UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0);
				self.parent.fadeInfo.finishedFunc = self.parent.fadeFunc;
			end
		end
		module:UpdateSwitchButton();
	end);

	RightChatToggleButton:HookScript("OnEnter", function()
		if(E.db.addOnSkins.embed.rightChat) then
			GameTooltip:AddDoubleLine(L["Right Click:"], L["Toggle Embedded Addon"], 1, 1, 1);
			GameTooltip:Show();
			module:UpdateSwitchButton();
		end
	end);

	LeftChatToggleButton:RegisterForClicks("AnyDown");
	LeftChatToggleButton:SetScript("OnClick", function(self, btn)
		if(btn == "RightButton") then
			if(not E.db.addOnSkins.embed.rightChat) then
				if(module.left:IsShown()) then
					module.left:Hide();
				else
					module.left:Show();
				end
			end
		else
			if(E.db[self.parent:GetName().."Faded"]) then
				E.db[self.parent:GetName().."Faded"] = nil;
				UIFrameFadeIn(self.parent, 0.2, self.parent:GetAlpha(), 1);
				UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1);
			else
				E.db[self.parent:GetName().."Faded"] = true;
				UIFrameFadeOut(self.parent, 0.2, self.parent:GetAlpha(), 0);
				UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0);
				self.parent.fadeInfo.finishedFunc = self.parent.fadeFunc;
			end
		end
		module:UpdateSwitchButton();
	end);

	LeftChatToggleButton:HookScript("OnEnter", function()
		if(not E.db.addOnSkins.embed.rightChat) then
			GameTooltip:AddDoubleLine(L["Right Click:"], L["Toggle Embedded Addon"], 1, 1, 1);
			GameTooltip:Show();
			module:UpdateSwitchButton();
		end
	end);

	function HideLeftChat()
		LeftChatToggleButton:Click();
	end

	function HideRightChat()
		RightChatToggleButton:Click();
	end

	function HideBothChat()
		LeftChatToggleButton:Click();
		RightChatToggleButton:Click();
	end
end

function module:UpdateSwitchButton()
	local chatPanel = E.db.addOnSkins.embed.rightChat and RightChatPanel or LeftChatPanel;
	local chatTab = E.db.addOnSkins.embed.rightChat and RightChatTab or LeftChatTab;
	local isDouble = E.db.addOnSkins.embed.embedType == "DOUBLE";

	self.switchButton:SetParent(chatPanel);

	if(E.db.addOnSkins.embed.belowTop and chatPanel:IsShown()) then
		self.switchButton:Show();
		self.switchButton.text:SetText(isDouble and E.db.addOnSkins.embed.left .. " / " .. E.db.addOnSkins.embed.right or E.db.addOnSkins.embed.left);
		self.switchButton:ClearAllPoints();
		if(E.Chat.RightChatWindowID and _G["ChatFrame" .. E.Chat.RightChatWindowID .. "Tab"]:IsVisible()) then
			self.switchButton:Point("LEFT", _G["ChatFrame" .. E.Chat.RightChatWindowID .. "Tab"], "RIGHT", 0, 0);
		else
			self.switchButton:Point(E.db.addOnSkins.embed.rightChat and "LEFT" or "RIGHT", chatTab, 5, 4);
		end
	elseif(self.switchButton:IsShown()) then
		self.switchButton:Hide();
	end
end

function module:WindowResize()
	if(not self.embedCreated) then return; end

	local SPACING = E.Border + E.Spacing;
	local chatPanel = E.db.addOnSkins.embed.rightChat and RightChatPanel or LeftChatPanel;
	local chatTab = E.db.addOnSkins.embed.rightChat and RightChatTab or LeftChatTab;
	local chatData = E.db.addOnSkins.embed.rightChat and RightChatDataPanel or LeftChatToggleButton;
	local topRight = chatData == RightChatDataPanel and (E.db.datatexts.rightChatPanel and "TOPLEFT" or "BOTTOMLEFT") or chatData == LeftChatToggleButton and (E.db.datatexts.leftChatPanel and "TOPLEFT" or "BOTTOMLEFT");
	local yOffset = (chatData == RightChatDataPanel and E.db.datatexts.rightChatPanel and SPACING) or (chatData == LeftChatToggleButton and E.db.datatexts.leftChatPanel and SPACING) or 0;
	local xOffset = (E.db.chat.panelBackdrop == "RIGHT" and E.db.addOnSkins.embed.rightChat and 0) or (E.db.chat.panelBackdrop == "LEFT" and not E.db.addOnSkins.embed.rightChat and 0) or (E.db.chat.panelBackdrop == "SHOWBOTH" and 0) or E.Border*3 - E.Spacing;
	local isDouble = E.db.addOnSkins.embed.embedType == "DOUBLE";

	self.left:SetParent(chatPanel);
	self.left:ClearAllPoints();
	self.left:SetPoint(isDouble and "BOTTOMRIGHT" or "BOTTOMLEFT", chatData, topRight, isDouble and E.db.addOnSkins.embed.leftWidth -SPACING or 0, yOffset);
	self.left:SetPoint(isDouble and "TOPLEFT" or "TOPRIGHT", chatTab, isDouble and (E.db.addOnSkins.embed.belowTop and "BOTTOMLEFT" or "TOPLEFT") or (E.db.addOnSkins.embed.belowTop and "BOTTOMRIGHT" or "TOPRIGHT"), E.db.addOnSkins.embed.embedType == "SINGLE" and xOffset or -xOffset, E.db.addOnSkins.embed.belowTop and -SPACING or 0);

	self:UpdateSwitchButton();

	if(isDouble) then
		self.right:ClearAllPoints();
		self.right:SetPoint("BOTTOMLEFT", chatData, topRight, E.db.addOnSkins.embed.leftWidth, yOffset);
		self.right:SetPoint("TOPRIGHT", chatTab, E.db.addOnSkins.embed.belowTop and "BOTTOMRIGHT" or "TOPRIGHT", xOffset, E.db.addOnSkins.embed.belowTop and -SPACING or 0);
	end

	if(IsAddOnLoaded("ElvUI_Config")) then
		E.Options.args.addOnSkins.args.embed.args.leftWidth.min = floor(chatPanel:GetWidth() * .25);
		E.Options.args.addOnSkins.args.embed.args.leftWidth.max = floor(chatPanel:GetWidth() * .75);
	end
end

function module:Init()
	if(not self.embedCreated) then
		self.left = CreateFrame("Frame", "ElvUI_AddOnSkins_Embed_LeftWindow", UIParent);
		self.right = CreateFrame("Frame", "ElvUI_AddOnSkins_Embed_RightWindow", self.left);

		self.switchButton = CreateFrame("Button", "ElvUI_AddOnSkins_Embed_SwitchButton", UIParent);
		self.switchButton:RegisterForClicks("AnyUp");
		self.switchButton:Size(120, 32);
		self.switchButton.text = self.switchButton:CreateFontString(nil, "OVERLAY");
		self.switchButton.text:FontTemplate(E.LSM:Fetch("font", E.db.chat.tabFont), E.db.chat.tabFontSize, E.db.chat.tabFontOutline);
		self.switchButton.text:SetTextColor(unpack(E["media"].rgbvaluecolor));
		self.switchButton.text:SetPoint("LEFT", 16, -5);
		self.switchButton:SetScript("OnClick", function(self, button)
			if(module.left:IsShown()) then
				module.left:Hide();
				self:SetAlpha(0.6);
			else
				module.left:Show();
				self:SetAlpha(1);
			end
			module:UpdateSwitchButton();
		end);
		self.switchButton:SetScript("OnMouseDown", function(self) self.text:SetPoint("LEFT", 18, -7); end);
		self.switchButton:SetScript("OnMouseUp", function(self) self.text:SetPoint("LEFT", 16, -5); end);

		self.embedCreated = true;

		self:Hooks();

		hooksecurefunc(E:GetModule("Chat"), "PositionChat", function(self, override)
			if(override) then
				module:Check();
			end
		end);
		hooksecurefunc(E:GetModule("Layout"), "ToggleChatPanels", function() module:Check(); end);

		self:ToggleChatFrame(false);
		self:Check();

		self.left:SetScript("OnShow", self.Show);
		self.left:SetScript("OnHide", self.Hide);
	end
end

function module:Initialize()
	self.db = E.db.addOnSkins.embed;

	if(E.db.addOnSkins.embed.embedType ~= "DISABLE") then
		self:Init();
	end
end

local function InitializeCallback()
	module:Initialize()
end

E:RegisterModule(module:GetName(), InitializeCallback)