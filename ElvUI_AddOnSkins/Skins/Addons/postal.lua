local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")
local AS = E:GetModule("AddOnSkins")

-- Postal 2.1-r82138

local _G = _G
local INBOXITEMS_TO_DISPLAY = INBOXITEMS_TO_DISPLAY

local function LoadSkin()
	if not E.private.addOnSkins.Postal then return end

	S:HandleNextPrevButton(Postal_ModuleMenuButton, true)
	Postal_ModuleMenuButton:SetPoint("TOPRIGHT", MailFrame, -60, -16)

	if PostalSelectOpenButton then
		S:HandleButton(PostalSelectOpenButton, true)
		PostalSelectOpenButton:Point("RIGHT", InboxFrame, "TOP", -22, -58)
	end

	if PostalSelectReturnButton then
		S:HandleButton(PostalSelectReturnButton, true)
		PostalSelectReturnButton:Point("LEFT", InboxFrame, "TOP", 13, -58)
	end

	for i = 1, INBOXITEMS_TO_DISPLAY do
		local item = _G["MailItem"..i.."ExpireTime"]
		local checkbox = _G["PostalInboxCB"..i]

		if item then
			item:SetPoint("TOPRIGHT", "MailItem"..i, "TOPRIGHT", -5, -10)
			if item.returnicon then
				item.returnicon:Point("TOPRIGHT", item, "TOPRIGHT", 20, 0)
			end
		end

		if checkbox then
			S:HandleCheckBox(_G["PostalInboxCB"..i])
		end
	end

	if PostalOpenAllButton then
		S:HandleButton(PostalOpenAllButton, true)
		PostalOpenAllButton:Point("CENTER", InboxFrame, "TOP", -17, -410)
	end

	if Postal_OpenAllMenuButton then
		S:HandleNextPrevButton(Postal_OpenAllMenuButton, true)
		Postal_OpenAllMenuButton:Point("LEFT", PostalOpenAllButton, "RIGHT", 2, 0)
		Postal_OpenAllMenuButton:Height(25)
	end

	if Postal_BlackBookButton then
		S:HandleNextPrevButton(Postal_BlackBookButton, true)
		Postal_BlackBookButton:Point("LEFT", SendMailNameEditBox, "RIGHT", 6, 0)
	end

	InboxPrevPageButton:Point("CENTER", InboxFrame, "BOTTOMLEFT", 62, 104)
	InboxPrevPageButton.SetPoint = E.noop

	InboxNextPageButton:Point("CENTER", InboxFrame, "BOTTOMLEFT", 313, 104)
	InboxNextPageButton.SetPoint = E.noop

	AS:SkinLibrary("Dewdrop-2.0")
end

S:AddCallbackForAddon("Postal", "Postal", LoadSkin)