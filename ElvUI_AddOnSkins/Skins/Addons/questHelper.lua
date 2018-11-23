local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

-- QuestHelper 0.95 (Modern "Wrath" version backported for TBC)
-- https://github.com/VideoPlayerCode/QuestHelperTBC

local function LoadSkin()
	if not E.private.addOnSkins.QuestHelper then return end

	-- Tooltip
	QuestHelper.tooltip:HookScript2("OnShow", function(self)
		self:StripTextures()
		self:SetTemplate("Transparent")
		self:SetScale(UIParent:GetScale())
	end)

	-- World Map Button
	local mapButton = QuestHelper_Pref.map_button
	if mapButton then
		local button = QuestHelperWorldMapButton
		button:StripTextures()
		button:Width(112)
		button:SetTemplate("Default", true)
		button:HookScript2("OnEnter", S.SetModifiedBackdrop)
		button:HookScript2("OnLeave", S.SetOriginalBackdrop)
	end

	hooksecurefunc(QuestHelper, "ShowText", function()
		-- Text Viewer Frame
		QuestHelperTextViewer:StripTextures()
		QuestHelperTextViewer:SetTemplate("Transparent")
		QuestHelperTextViewer:SetScale(UIParent:GetScale())

		-- Both the 0.59 and 0.95 versions are floating around, so we support both below!
		local scrollBar = QuestHelperTextViewer.scrollbar or QuestHelperTextViewer_ScrollFrameScrollBar
		S:HandleScrollBar(scrollBar)

		local closeButton = QuestHelperTextViewer.closebutton or QuestHelperTextViewer_CloseButton
		S:HandleCloseButton(closeButton)
	end)
end

S:AddCallbackForAddon("QuestHelper", "QuestHelper", LoadSkin)