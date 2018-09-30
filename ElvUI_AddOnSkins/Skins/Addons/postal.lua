local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

-- Postal 2.1

local _G = _G
local INBOXITEMS_TO_DISPLAY = INBOXITEMS_TO_DISPLAY

local function LoadSkin()
	if not E.private.addOnSkins.Postal then return end

	S:HandleNextPrevButton(Postal_ModuleMenuButton, true)
	Postal_ModuleMenuButton:SetPoint("TOPRIGHT", MailFrame, -60, -16)

	hooksecurefunc(Postal_Select, "OnEnable", function()
		if PostalSelectOpenButton and not PostalSelectOpenButton.isSkinned then
			S:HandleButton(PostalSelectOpenButton, true)
			PostalSelectOpenButton:Point("RIGHT", InboxFrame, "TOP", -22, -58)

			PostalSelectOpenButton.isSkinned = true
		end

		if PostalSelectReturnButton and not PostalSelectReturnButton.isSkinned then
			S:HandleButton(PostalSelectReturnButton, true)
			PostalSelectReturnButton:Point("LEFT", InboxFrame, "TOP", 13, -58)

			PostalSelectReturnButton.isSkinned = true
		end

		for i = 1, INBOXITEMS_TO_DISPLAY do
			local item = _G["MailItem"..i.."ExpireTime"]
			local checkbox = _G["PostalInboxCB"..i]

			if item and not item.isSkinned then
				item:SetPoint("TOPRIGHT", "MailItem"..i, "TOPRIGHT", -5, -10)
				if item.returnicon then
					item.returnicon:Point("TOPRIGHT", item, "TOPRIGHT", 20, 0)
				end

				item.isSkinned = true
			end

			if checkbox and not checkbox.isSkinned then
				S:HandleCheckBox(_G["PostalInboxCB"..i])

				checkbox.isSkinned = true
			end
		end
	end)

	hooksecurefunc(Postal_OpenAll, "OnEnable", function()
		if PostalOpenAllButton and not PostalOpenAllButton.isSkinned then
			S:HandleButton(PostalOpenAllButton, true)
			PostalOpenAllButton:Point("CENTER", InboxFrame, "TOP", -17, -410)

			PostalOpenAllButton.isSkinned = true
		end

		if Postal_OpenAllMenuButton and not Postal_OpenAllMenuButton.isSkinned then
			S:HandleNextPrevButton(Postal_OpenAllMenuButton, true)
			Postal_OpenAllMenuButton:Point("LEFT", PostalOpenAllButton, "RIGHT", 2, 0)
			
			Postal_OpenAllMenuButton.isSkinned = true
		end
	end)

	hooksecurefunc(Postal_BlackBook, "OnEnable", function()
		if Postal_BlackBookButton and not Postal_BlackBookButton.isSkinned then
			S:HandleNextPrevButton(Postal_BlackBookButton, true)
			Postal_BlackBookButton:Point("LEFT", SendMailNameEditBox, "RIGHT", 6, 0)

			Postal_BlackBookButton.isSkinned = true
		end
	end)

	E:GetModule("AddOnSkins"):SkinLibrary("Dewdrop-2.0")
end

S:AddCallbackForAddon("Postal", "Postal", LoadSkin)