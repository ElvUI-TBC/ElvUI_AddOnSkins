local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G
local pairs, unpack = pairs, unpack

local function LoadSkin()
	if not E.private.addOnSkins.TrinketMenu then return end

	-- Main Frame
	TrinketMenu_MainFrame:StripTextures()
	TrinketMenu_MainFrame:CreateBackdrop("Transparent")
	TrinketMenu_MainFrame.backdrop:Point("TOPLEFT", 5, -5)
	TrinketMenu_MainFrame.backdrop:Point("BOTTOMRIGHT", -5, 5)

	TrinketMenu_MainResizeButton:SetNormalTexture("")

	-- Menu frame
	TrinketMenu_MenuFrame:StripTextures()
	TrinketMenu_MenuFrame:CreateBackdrop("Transparent")
	TrinketMenu_MenuFrame.backdrop:Point("TOPLEFT", 5, -5)
	TrinketMenu_MenuFrame.backdrop:Point("BOTTOMRIGHT", -5, 5)

	TrinketMenu_MenuResizeButton:SetNormalTexture("")

	for i = 0, 1 do
		local item = _G["TrinketMenu_Trinket"..i]
		local icon = _G["TrinketMenu_Trinket"..i.."Icon"]
		local cooldown = _G["TrinketMenu_Trinket"..i.."Cooldown"]

		item:StripTextures()
		item:SetTemplate()
		item:StyleButton()
		item:SetBackdropColor(0, 0, 0, 0)

		icon:SetTexCoord(unpack(E.TexCoords))
		icon:SetInside()

		E:RegisterCooldown(cooldown)

		item:HookScript2("OnUpdate", function(self)
			local link = i == 0 and GetInventoryItemLink("player", 13) or GetInventoryItemLink("player", 14)

			if link then
				local quality = select(3, GetItemInfo(link))

				self:SetBackdropBorderColor(GetItemQualityColor(quality))
			end
		end)
	end

	for i = 1, 30 do
		local item = _G["TrinketMenu_Menu"..i]
		local icon = _G["TrinketMenu_Menu"..i.."Icon"]
		local cooldown = _G["TrinketMenu_Menu"..i.."Cooldown"]

		item:StripTextures()
		item:SetTemplate()
		item:StyleButton()
		item:SetBackdropColor(0, 0, 0, 0)

		icon:SetTexCoord(unpack(E.TexCoords))
		icon:SetInside()

		E:RegisterCooldown(cooldown)
	end

	-- Options Frame
	TrinketMenu_OptFrame:StripTextures()
	TrinketMenu_OptFrame:CreateBackdrop("Transparent")

	TrinketMenu_SubOptFrame:StripTextures()
	TrinketMenu_SubOptFrame:CreateBackdrop("Transparent")

	S:HandleButton(TrinketMenu_Tab1)
	TrinketMenu_Tab1:Point("TOPRIGHT", -7, -22)
	TrinketMenu_Tab1:Size(94, 24)

	S:HandleButton(TrinketMenu_Tab2)
	TrinketMenu_Tab2:Point("TOPRIGHT", TrinketMenu_Tab1, "TOPLEFT", -2, 0)
	TrinketMenu_Tab2:Size(94, 24)

	S:HandleButton(TrinketMenu_Tab3)
	TrinketMenu_Tab3:Point("TOPRIGHT", TrinketMenu_Tab2, "TOPLEFT", -2, 0)
	TrinketMenu_Tab3:Size(94, 24)

	S:HandleButton(TrinketMenu_OptBindButton)

	local checkboxes = {
		TrinketMenu_Trinket0Check,
		TrinketMenu_Trinket1Check,
		TrinketMenu_OptLocked,
		TrinketMenu_OptShowIcon,
		TrinketMenu_OptDisableToggle,
		TrinketMenu_OptSquareMinimap,
		TrinketMenu_OptCooldownCount,
		TrinketMenu_OptLargeCooldown,
		TrinketMenu_OptShowTooltips,
		TrinketMenu_OptTooltipFollow,
		TrinketMenu_OptTinyTooltips,
		TrinketMenu_OptShowHotKeys,
		TrinketMenu_OptStopOnSwap,
		TrinketMenu_OptRedRange,
		TrinketMenu_OptKeepDocked,
		TrinketMenu_OptKeepOpen,
		TrinketMenu_OptMenuOnShift,
		TrinketMenu_OptMenuOnRight,
		TrinketMenu_OptNotify,
		TrinketMenu_OptNotifyThirty,
		TrinketMenu_OptNotifyChatAlso,
		TrinketMenu_OptSetColumns,
		TrinketMenu_SortPriority,
		TrinketMenu_SortKeepEquipped,
		TrinketMenu_OptHideOnLoad
	}

	for _, checkbox in pairs(checkboxes) do
		S:HandleCheckBox(checkbox)
	end

	S:HandleSliderFrame(TrinketMenu_OptColumnsSlider)

	TrinketMenu_LockButton:Hide()

	S:HandleCloseButton(TrinketMenu_CloseButton)
	TrinketMenu_CloseButton:Size(32)
	TrinketMenu_CloseButton:Point("TOPRIGHT", 6, 6)

	TrinketMenu_SubQueueFrame:StripTextures()
	TrinketMenu_SortListFrame:StripTextures()

	TrinketMenu_SortScroll:StripTextures()
	TrinketMenu_SortScroll:CreateBackdrop("Transparent")

	S:HandleScrollBar(TrinketMenu_SortScrollScrollBar)

	TrinketMenu_SortDelay:StripTextures()
	S:HandleEditBox(TrinketMenu_SortDelay)

	for i = 1, 9 do
		local item = _G["TrinketMenu_Sort"..i]
		local icon = _G["TrinketMenu_Sort"..i.."Icon"]
		local highlight = _G["TrinketMenu_Sort"..i.."Highlight"]

		item:CreateBackdrop()
		item.backdrop:SetOutside(icon)

		icon:SetTexCoord(unpack(E.TexCoords))

		highlight:SetTexture(1, 1, 1, 0.3)
		highlight:SetInside()
	end

	S:HandleNextPrevButton(TrinketMenu_MoveUp)
	S:SquareButton_SetIcon(TrinketMenu_MoveUp, "UP")

	S:HandleNextPrevButton(TrinketMenu_MoveDown)
	S:SquareButton_SetIcon(TrinketMenu_MoveDown, "DOWN")

	S:HandleNextPrevButton(TrinketMenu_Delete)
	S:SquareButton_SetIcon(TrinketMenu_Delete, "DELETE")

	TrinketMenu_ProfilesFrame:StripTextures()

	TrinketMenu_ProfilesListFrame:StripTextures()
	TrinketMenu_ProfilesListFrame:CreateBackdrop("Transparent")

	TrinketMenu_ProfileName:StripTextures()
	S:HandleEditBox(TrinketMenu_ProfileName)

	S:HandleButton(TrinketMenu_ProfilesDelete)
	S:HandleButton(TrinketMenu_ProfilesLoad)
	S:HandleButton(TrinketMenu_ProfilesSave)
	S:HandleButton(TrinketMenu_ProfilesCancel)

	for i = 1, 7 do
		local item = _G["TrinketMenu_Profile"..i]

		S:HandleButtonHighlight(item)
	end

	S:HandleScrollBar(TrinketMenu_ProfileScrollScrollBar)
end

S:AddCallbackForAddon("TrinketMenu", "TrinketMenu", LoadSkin)