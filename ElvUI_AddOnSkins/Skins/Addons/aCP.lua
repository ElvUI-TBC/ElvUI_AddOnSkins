local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local function LoadSkin()
	if not E.private.addOnSkins.ACP then return; end

	ACP_AddonList:StripTextures()
	ACP_AddonList:SetTemplate("Transparent")
	ACP_AddonList:Height(502)
	ACP_AddonList:SetScale(UIParent:GetScale())

	ACP_AddonList_ScrollFrame:StripTextures()
	ACP_AddonList_ScrollFrame:CreateBackdrop("Default")
	ACP_AddonList_ScrollFrame:Width(590)
	ACP_AddonList_ScrollFrame:Height(412)
	ACP_AddonList_ScrollFrame:Point("TOPLEFT", ACP_AddonList, "TOPLEFT", 20, -53)

	S:HandleDropDownBox(ACP_AddonListSortDropDown, 130)

	S:HandleScrollBar(ACP_AddonList_ScrollFrameScrollBar)

	ACP_AddonListEntry1:Point("TOPLEFT", ACP_AddonList, "TOPLEFT", 47, -62)

	for i = 1, 20 do
		S:HandleButton(_G["ACP_AddonListEntry"..i.."LoadNow"])
		S:HandleCheckBox(_G["ACP_AddonListEntry"..i.."Enabled"])
	end

	S:HandleCheckBox(ACP_AddonList_NoChildren)
	S:HandleCheckBox(ACP_AddonList_NoRecurse)

	S:HandleButton(GameMenuButtonAddOns)

	S:HandleButton(ACP_AddonListDisableAll)
	ACP_AddonListDisableAll:Point("BOTTOMLEFT", ACP_AddonList, "BOTTOMLEFT", 90, 8)

	S:HandleButton(ACP_AddonListEnableAll)
	ACP_AddonListEnableAll:Point("BOTTOMLEFT", ACP_AddonList, "BOTTOMLEFT", 175, 8)

	S:HandleButton(ACP_AddonList_ReloadUI)
	ACP_AddonList_ReloadUI:Point("BOTTOMRIGHT", ACP_AddonList, "BOTTOMRIGHT", -160, 8)
	ACP_AddonList_ReloadUI:ClearAllPoints()
	ACP_AddonList_ReloadUI:HookScript2("OnShow", function()
		this:Point("BOTTOMRIGHT", ACP_AddonList, "BOTTOMRIGHT", -7, 7)
	end)

	S:HandleButton(ACP_AddonListSetButton)
	ACP_AddonListSetButton:Point("BOTTOMLEFT", ACP_AddonList, "BOTTOMLEFT", 20, 8)

	S:HandleCloseButton(ACP_AddonListCloseButton)
	ACP_AddonListCloseButton:Point("TOPRIGHT", ACP_AddonList, "TOPRIGHT", 4, 5)
end

S:AddCallbackForAddon("ACP", "ACP", LoadSkin)