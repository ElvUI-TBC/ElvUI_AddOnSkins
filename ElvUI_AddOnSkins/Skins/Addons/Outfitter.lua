local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G
local pairs, select, unpack = pairs, select, unpack
local find = string.find

local function LoadSkin()
	if not E.private.addOnSkins.Outfitter then return end

	S:HandleButton(OutfitterButton)
	OutfitterButton:Size(40, 22)
	OutfitterButton:Point("TOPRIGHT", -40, -40)
	OutfitterButton:SetNormalTexture("Interface\\Addons\\Outfitter\\Textures\\Outfitter-Button")
	OutfitterButton:GetNormalTexture():SetTexCoord(0.25, 0.75, 0.15, 0.4)
	OutfitterButton:GetNormalTexture():SetInside()

	S:HandleButton(OutfitterEnableNone)
	OutfitterEnableNone:ClearAllPoints()
	OutfitterEnableNone:Point("TOPLEFT", PaperDollFrame, 16, -20)

	S:HandleButton(OutfitterEnableAll)
	OutfitterEnableAll:ClearAllPoints()
	OutfitterEnableAll:Point("BOTTOM", OutfitterEnableNone, 0, -20)

	local slots = {
		"HeadSlot",
		"NeckSlot",
		"ShoulderSlot",
		"BackSlot",
		"ChestSlot",
		"ShirtSlot",
		"TabardSlot",
		"WristSlot",
		"HandsSlot",
		"WaistSlot",
		"LegsSlot",
		"FeetSlot",
		"Finger0Slot",
		"Finger1Slot",
		"Trinket0Slot",
		"Trinket1Slot",
		"MainHandSlot",
		"SecondaryHandSlot",
		"RangedSlot",
		"AmmoSlot"
	}

	for _, slot in pairs(slots) do
		local check = _G["OutfitterEnable"..slot]

		S:HandleCheckBox(check)
		check:Size(22)
		check:SetFrameLevel(check:GetFrameLevel() + 2)
	end

	-- Quickslots
	local function SkinQuickSlots()
		OutfitterQuickSlots:StripTextures()
		if not OutfitterQuickSlots.backdrop then
			OutfitterQuickSlots:CreateBackdrop("Transparent")
			OutfitterQuickSlots.backdrop:Point("TOPLEFT", 4, -3)
			OutfitterQuickSlots.backdrop:Point("BOTTOMRIGHT", -6, 7)
		end
		OutfitterQuickSlots:SetFrameStrata("DIALOG")
	end
	hooksecurefunc(Outfitter._QuickSlots, "Open", SkinQuickSlots)

	local function SkinQuickSlotButtons()
		for i = 0, 30 do
			local item = _G["OutfitterQuickSlotsButton"..i.."Item1"]
			local icon = _G["OutfitterQuickSlotsButton"..i.."Item1IconTexture"]
			local normal = _G["OutfitterQuickSlotsButton"..i.."Item1NormalTexture"]

			if item then
				item:SetTemplate("Default", true)
				item:StyleButton()

				icon:SetTexCoord(unpack(E.TexCoords))
				icon:SetInside()

				normal:SetAlpha(0)
			end
		end
	end
	hooksecurefunc(Outfitter._QuickSlotButton, "Construct", SkinQuickSlotButtons)

	-- Main Frame
	hooksecurefunc(Outfitter, "OnShow", function()
		if not OutfitterFrame.isSkinned then
			OutfitterFrame:StripTextures()

			OutfitterFrame.isSkinned = true
		end
	end)

	OutfitterMainFrame:StripTextures()
	OutfitterMainFrame:SetTemplate("Transparent")

	-- Tabs
	for i = 1, 3 do
		local tab = _G["OutfitterFrameTab"..i]

		tab:StripTextures()
		tab:SetTemplate()
		tab:Size(60, 25)
		tab.SetWidth = E.noop

		tab:ClearAllPoints()
		if i == 1 then
			tab:Point("TOPLEFT", OutfitterFrame, "BOTTOMRIGHT", -65, 1)
		elseif i == 2 then
			tab:Point("LEFT", OutfitterFrameTab1, "LEFT", -65, 0)
		else
			tab:Point("LEFT", OutfitterFrameTab2, "LEFT", -65, 0)
		end
	end

	for i = 0, 13 do
		local item = _G["OutfitterItem"..i.."Item"]
		local checkbox = _G["OutfitterItem"..i.."OutfitSelected"]
		local menu = _G["OutfitterItem"..i.."OutfitMenu"]
		local expand = _G["OutfitterItem"..i.."CategoryExpand"]

		checkbox:StripTextures()
		checkbox:SetTemplate()
		checkbox:Size(16)
		checkbox:Point("BOTTOMLEFT", 5, 1)
		checkbox:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")

		S:HandleNextPrevButton(menu)
		S:SquareButton_SetIcon(menu, "DOWN")
		menu:Size(16)

		expand:SetNormalTexture("Interface\\AddOns\\ElvUI\\media\\textures\\PlusMinusButton")
		expand.SetNormalTexture = E.noop
		expand:GetNormalTexture():Size(12)
		expand:SetHighlightTexture(nil)

		hooksecurefunc(expand, "SetNormalTexture", function(self, texture)
			if find(texture, "MinusButton") then
				self:GetNormalTexture():SetTexCoord(0.545, 0.975, 0.085, 0.925)
			else
				self:GetNormalTexture():SetTexCoord(0.045, 0.475, 0.085, 0.925)
			end
		end)
	end

	OutfitterMainFrameScrollbarTrench:StripTextures()
	S:HandleScrollBar(OutfitterMainFrameScrollFrameScrollBar)

	S:HandleButton(OutfitterNewButton)

	S:HandleCloseButton(OutfitterCloseButton)
	if OutfitterCloseButton.text then
		OutfitterCloseButton.text:SetParent(OutfitterCloseButton.backdrop)
	end

	-- Options Frame
	OutfitterOptionsFrame:StripTextures()
	OutfitterOptionsFrame:SetTemplate("Transparent")

	local checkboxes = {
		"OutfitterAutoSwitch",
		"OutfitterShowOutfitBar",
		"OutfitterShowMinimapButton",
		"OutfitterShowHotkeyMessages",
		"OutfitterTooltipInfo"
	}

	for _, checkbox in pairs(checkboxes) do
		local item = _G[checkbox]

		item:StripTextures()
		item:SetTemplate()
		item:Size(24)
		item:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
	end

	-- About Frame
	OutfitterAboutFrame:StripTextures()
	OutfitterAboutFrame:SetTemplate("Transparent")

	-- PopUp Frame
	OutfitterNameOutfitDialog:StripTextures()
	OutfitterNameOutfitDialog:SetTemplate("Transparent")
	OutfitterNameOutfitDialog:Point("TOPLEFT", OutfitterMainFrame, "TOPRIGHT", 2, 0)

	OutfitterNameOutfitDialogName:StripTextures()
	S:HandleEditBox(OutfitterNameOutfitDialogName)

	S:HandleDropDownBox(OutfitterNameOutfitDialogAutomation)
	S:HandleDropDownBox(OutfitterNameOutfitDialogCreateUsing)

	S:HandleButton(OutfitterNameOutfitDialogCancelButton)
	S:HandleButton(OutfitterNameOutfitDialogDoneButton)

	-- Choose Icon Dialog
	OutfitterChooseIconDialog:StripTextures()
	OutfitterChooseIconDialog:SetTemplate("Transparent")

	S:HandleDropDownBox(OutfitterChooseIconDialogIconSetMenu)

	OutfitterChooseIconDialogFilterEditBox:StripTextures()
	S:HandleEditBox(OutfitterChooseIconDialogFilterEditBox)

	S:HandleButton(OutfitterChooseIconDialogOKButton)
	S:HandleButton(OutfitterChooseIconDialogCancelButton)

	S:HandleScrollBar(OutfitterChooseIconDialogScrollFrameScrollBar)

--[[
	local function test()
		for i = 1, 30 do
			local button = _G["OutfitterChooseIconDialogButton"..i]
			local icon = _G["OutfitterChooseIconDialogButton"..i.."Icon"]
			local border = _G["OutfitterChooseIconDialogButton"..i.."Border"]
			local normal = _G["OutfitterChooseIconDialogButton"..i.."NormalTexture"]

			button:StripTextures()
			button:SetTemplate("Default")
			button:StyleButton(nil, true)

			icon:SetInside()
			icon:SetTexCoord(unpack(E.TexCoords))

			normal:SetAlpha(0)
			border:SetAlpha(0)
		end
	end
	hooksecurefunc(Outfitter.OutfitBar._ChooseIconDialog, "UpdateIcons", test)
]]

	-- Outfiter Bar
	local function SkinSettingsDialog()
		OutfitBarSettingsDialog:SetTemplate("Transparent")

		for i = 1, 3 do
			local slider = _G["OutfitBarSettingsDialogSlider"..i]
			local check = _G["OutfitBarSettingsDialogCheckbuttom"..i]

			S:HandleSliderFrame(slider)
			S:HandleCheckBox(check)
		end
	end
	hooksecurefunc(Outfitter.OutfitBar._SettingsDialog, "Construct", SkinSettingsDialog)

	local function SkinBars()
		for i = 1, 2 do
			local bar = _G["OutfitterOutfitBar"..i]
			if bar then
				bar:StripTextures()

				if not bar.backdrop then
					bar:CreateBackdrop()
					bar.backdrop:Point("TOPLEFT", 3, -2)
					bar.backdrop:Point("BOTTOMRIGHT", -5, 6)
				end

				for j = 0, 100 do
					local button = _G["OutfitterOutfitBar"..i.."Button"..j]
					local icon = _G["OutfitterOutfitBar"..i.."Button"..j.."IconTexture"]
					local normal = _G["OutfitterOutfitBar"..i.."Button"..j.."NormalTexture"]

					if button and not button.isSkinned then
						button:SetTemplate()
						button:StyleButton()
						button:GetHighlightTexture():SetInside(button.backdrop)
						button:GetPushedTexture():SetInside(button.backdrop)

						icon:SetTexCoord(unpack(E.TexCoords))
						icon:SetInside(button)

						normal:SetAlpha(0)

						for k = 1, button:GetNumRegions() do
							local region = select(k, button:GetRegions())
							if region:GetObjectType() == "Texture" and region:GetTexture() == "Interface\\Addons\\Outfitter\\Textures\\IconButtonHighlight" then
								region:SetTexture(1, 1, 1, 0.3)
								region:SetVertexColor(1, 1, 1)
								region:SetInside(button)
							end
						end

						button.isSkinned = true
					end
				end

				Outfitter.OutfitBar["DragBar"..i]:StripTextures()

				if not Outfitter.OutfitBar["DragBar"..i].isSkinned then
					Outfitter.OutfitBar["DragBar"..i]:CreateBackdrop("Default", true)
					Outfitter.OutfitBar["DragBar"..i].backdrop:Point("TOPLEFT", 0, -2)
					Outfitter.OutfitBar["DragBar"..i].backdrop:Point("BOTTOMRIGHT", 0, 6)
					Outfitter.OutfitBar["DragBar"..i]:SetHitRectInsets(0, 0, 2, 6)
					Outfitter.OutfitBar["DragBar"..i]:HookScript2("OnEnter", S.SetModifiedBackdrop)
					Outfitter.OutfitBar["DragBar"..i]:HookScript2("OnLeave", S.SetOriginalBackdrop)

					Outfitter.OutfitBar["DragBar"..i].isSkinned = true
				end
			end
		end
	end
	hooksecurefunc(Outfitter.OutfitBar, "UpdateBars2", SkinBars)
end

S:AddCallbackForAddon("Outfitter", "Outfitter", LoadSkin)