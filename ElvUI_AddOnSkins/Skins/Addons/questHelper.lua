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
		self:SetScale(0.7)
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
		QuestHelperTextViewer:SetScale(0.7)

		-- Both the 0.59 and 0.95 versions are floating around, so we support both below!

		-- ScrollBar
		local scrollBar
		if QuestHelperTextViewer.scrollbar then -- (0.95, final TBC backport)
			scrollBar = QuestHelperTextViewer.scrollbar
		elseif QuestHelperTextViewer_ScrollFrameScrollBar then -- (0.59, old version of QH for TBC)
			scrollBar = QuestHelperTextViewer_ScrollFrameScrollBar
		end
		if scrollBar then
			scrollBar:StripTextures()
			S:HandleScrollBar(scrollBar)
		end

		-- Close Button
		local closeButton
		if QuestHelperTextViewer.closebutton then -- (0.95, final TBC backport)
			closeButton = QuestHelperTextViewer.closebutton
		elseif QuestHelperTextViewer_CloseButton then -- (0.59, old version of QH for TBC)
			closeButton = QuestHelperTextViewer_CloseButton
		end
		if closeButton then
			S:HandleCloseButton(closeButton)
		end
	end)
end

S:AddCallbackForAddon("QuestHelper", "QuestHelper", LoadSkin)
