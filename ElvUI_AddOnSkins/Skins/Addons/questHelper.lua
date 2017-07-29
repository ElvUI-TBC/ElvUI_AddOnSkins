local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

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
		-- Slash Commands
		QuestHelperTextViewer:StripTextures()
		QuestHelperTextViewer:SetTemplate("Transparent")
		QuestHelperTextViewer:SetScale(0.7)

		-- ScrollBar
		QuestHelperTextViewer_ScrollFrameScrollBar:StripTextures()
		S:HandleScrollBar(QuestHelperTextViewer_ScrollFrameScrollBar)

		-- Close Button
		S:HandleCloseButton(QuestHelperTextViewer_CloseButton)
	end)
end

S:AddCallbackForAddon("QuestHelper", "QuestHelper", LoadSkin)
