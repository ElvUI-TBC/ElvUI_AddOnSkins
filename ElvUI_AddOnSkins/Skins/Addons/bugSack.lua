local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

-- BugSack v2.3.0.70977 (TBC)

local function LoadSkin()
	if not E.private.addOnSkins.BugSack then return; end

	local function BugSack_OpenSack()
		if BugSackFrame.isSkinned then return end
		BugSackFrame:StripTextures()
		BugSackFrame:SetTemplate("Transparent")

		S:HandleButton(BugSackNextButton)
		S:HandleButton(BugSackPrevButton)
		S:HandleButton(BugSackFrameButton)
		S:HandleButton(BugSackFirstButton)
		S:HandleButton(BugSackLastButton)

		local scrollBar = BugSackScrollScrollBar and BugSackScrollScrollBar or BugSackFrameScrollScrollBar
		S:HandleScrollBar(scrollBar)

		BugSackFrame.isSkinned = true
	end
	hooksecurefunc(BugSack, "ShowFrame", BugSack_OpenSack)
end

S:AddCallbackForAddon("BugSack", "BugSack", LoadSkin)