local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")
local AS = E:GetModule("AddOnSkins")

local _G = _G
local select, unpack = select, unpack

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc

local function LoadSkin()
	if not E.private.addOnSkins.AtlasLoot then return; end

	AtlasLootTooltip:HookScript2("OnShow", function()
		this:SetTemplate("Transparent")

		local iLink = select(2, this:GetItem())
		local quality = iLink and select(3, GetItemInfo(iLink))
		if quality and quality >= 2 then
			this:SetBackdropBorderColor(GetItemQualityColor(quality))
		else
			this:SetBackdropBorderColor(unpack(E["media"].bordercolor))
		end
	end)

	AtlasLootDefaultFrame:StripTextures()
	AtlasLootDefaultFrame:SetTemplate("Transparent")

	S:HandleCloseButton(AtlasLootDefaultFrame_CloseButton)
	AtlasLootDefaultFrame_CloseButton:Point("TOPRIGHT", 2, 3)

	S:HandleButton(AtlasLootDefaultFrame_LoadModules)
	S:HandleButton(AtlasLootDefaultFrame_Options)
	S:HandleButton(AtlasLootDefaultFrame_Menu)
	S:HandleButton(AtlasLootDefaultFrame_SubMenu)

	AtlasLootDefaultFrame_LootBackground:SetTemplate("Default", nil, true)
	AtlasLootDefaultFrame_LootBackground_Back:SetTexture(0, 0, 0, 0)

	S:HandleButton(AtlasLootDefaultFrame_Preset1)
	S:HandleButton(AtlasLootDefaultFrame_Preset2)
	S:HandleButton(AtlasLootDefaultFrame_Preset3)
	S:HandleButton(AtlasLootDefaultFrame_Preset4)

	S:HandleEditBox(AtlasLootDefaultFrameSearchBox)
	AtlasLootDefaultFrameSearchBox:Point("BOTTOM", AtlasLootDefaultFrame, "BOTTOM", -78, 30)
	AtlasLootDefaultFrameSearchBox:Height(22)

	S:HandleButton(AtlasLootDefaultFrameSearchButton)
	AtlasLootDefaultFrameSearchButton:Point("LEFT", AtlasLootDefaultFrameSearchBox, "RIGHT", 3, 0)
	AtlasLootDefaultFrameSearchButton:Height(24)

	S:HandleNextPrevButton(AtlasLootDefaultFrameSearchOptionsButton)
	AtlasLootDefaultFrameSearchOptionsButton:Point("LEFT", AtlasLootDefaultFrameSearchButton, "RIGHT", 2, 0)
	AtlasLootDefaultFrameSearchOptionsButton:Size(24)

	S:HandleButton(AtlasLootDefaultFrameSearchClearButton)
	AtlasLootDefaultFrameSearchClearButton:Point("LEFT", AtlasLootDefaultFrameSearchOptionsButton, "RIGHT", 2, 0)
	AtlasLootDefaultFrameSearchClearButton:Height(24)

	S:HandleButton(AtlasLootDefaultFrameLastResultButton)
	AtlasLootDefaultFrameLastResultButton:Point("LEFT", AtlasLootDefaultFrameSearchClearButton, "RIGHT", 2, 0)
	AtlasLootDefaultFrameLastResultButton:Height(24)

	S:HandleButton(AtlasLootDefaultFrameWishListButton)
	AtlasLootDefaultFrameWishListButton:Point("RIGHT", AtlasLootDefaultFrameSearchBox, "LEFT", -2, 0)
	AtlasLootDefaultFrameWishListButton:Height(24)

	S:HandleCloseButton(AtlasLootItemsFrame_CloseButton)

	S:HandleButton(AtlasLootInfoHidePanel)

	for i = 1, 30 do
		local item = _G["AtlasLootItem_"..i]
		local icon = _G["AtlasLootItem_"..i.."_Icon"]
		local unsafe = _G["AtlasLootItem_"..i.."_Unsafe"]
		local menuItem = _G["AtlasLootMenuItem_"..i]
		local menuIcon = _G["AtlasLootMenuItem_"..i.."_Icon"]

		item:StyleButton()
		item:GetHighlightTexture():SetInside()

		item.bg = CreateFrame("Frame", nil, item)
		item.bg:SetTemplate()
		item.bg:Size(26)
		item.bg:Point("TOPLEFT", 0, -1)

		icon:SetTexCoord(unpack(E.TexCoords))
		icon:SetInside(item.bg)
		icon:SetParent(item.bg)

		unsafe:SetTexture(1, 0, 0, 0.5)
		unsafe:SetInside(item.bg)
		unsafe:SetParent(item.bg)
		unsafe:SetDrawLayer("OVERLAY")

		menuItem:CreateBackdrop("Default")
		menuItem.backdrop:SetOutside(menuIcon)

		menuIcon:SetTexCoord(unpack(E.TexCoords))
	end

	S:HandleCheckBox(AtlasLootItemsFrame_Heroic)
	S:HandleButton(AtlasLootServerQueryButton)
	S:HandleButton(AtlasLootItemsFrame_BACK)
	AtlasLootItemsFrame_Back:SetTexture(0, 0, 0, 0)

	S:HandleNextPrevButton(AtlasLootItemsFrame_NEXT)
	S:HandleNextPrevButton(AtlasLootQuickLooksButton)
	S:HandleNextPrevButton(AtlasLootItemsFrame_PREV)

	AtlasLootOptionsFrame:StripTextures()
	AtlasLootOptionsFrame:SetTemplate("Transparent")

	S:HandleCheckBox(AtlasLootOptionsFrameDefaultTT)
	S:HandleCheckBox(AtlasLootOptionsFrameLootlinkTT)
	S:HandleCheckBox(AtlasLootOptionsFrameItemSyncTT)
	S:HandleCheckBox(AtlasLootOptionsFrameOpaque)
	S:HandleCheckBox(AtlasLootOptionsFrameItemID)
	S:HandleCheckBox(AtlasLootOptionsFrameLoDStartup)
	S:HandleCheckBox(AtlasLootOptionsFrameSafeLinks)
	S:HandleCheckBox(AtlasLootOptionsFrameAllLinks)
	S:HandleCheckBox(AtlasLootOptionsFrameEquipCompare)
	S:HandleCheckBox(AtlasLootOptionsFrameItemSpam)
	S:HandleCheckBox(AtlasLootOptionsFrameMinimap)
	S:HandleCheckBox(AtlasLootOptionsFrameLoDSpam)
	S:HandleCheckBox(AtlasLootOptionsFrameHidePanel)

	S:HandleButton(AtlasLootOptionsFrameDone)

	AtlasLootPanel:StripTextures()
	AtlasLootPanel:SetTemplate("Transparent")

	S:HandleButton(AtlasLootPanel_WorldEvents)
	AtlasLootPanel_WorldEvents:Point("LEFT", AtlasLootPanel, "LEFT", 7, 29)

	S:HandleButton(AtlasLootPanel_Sets)
	AtlasLootPanel_Sets:Point("LEFT", AtlasLootPanel_WorldEvents, "RIGHT", 2, 0)

	S:HandleButton(AtlasLootPanel_Reputation)
	AtlasLootPanel_Reputation:Point("LEFT", AtlasLootPanel_Sets, "RIGHT", 2, 0)

	S:HandleButton(AtlasLootPanel_PvP)
	AtlasLootPanel_PvP:Point("LEFT", AtlasLootPanel_Reputation, "RIGHT", 2, 0)

	S:HandleButton(AtlasLootPanel_Crafting)
	AtlasLootPanel_Crafting:Point("LEFT", AtlasLootPanel_PvP, "RIGHT", 2, 0)

	S:HandleButton(AtlasLootPanel_WishList)
	AtlasLootPanel_WishList:Point("LEFT", AtlasLootPanel_Crafting, "RIGHT", 2, 0)

	S:HandleButton(AtlasLootPanel_Options)
	S:HandleButton(AtlasLootPanel_LoadModules)
	S:HandleButton(AtlasLootPanel_Preset1)
	S:HandleButton(AtlasLootPanel_Preset2)
	S:HandleButton(AtlasLootPanel_Preset3)
	S:HandleButton(AtlasLootPanel_Preset4)

	S:HandleEditBox(AtlasLootSearchBox)
	AtlasLootSearchBox:Height(20)

	S:HandleButton(AtlasLootSearchButton)
	AtlasLootSearchButton:Height(22)
	AtlasLootSearchButton:Point("LEFT", AtlasLootSearchBox, "RIGHT", 3, 0)

	S:HandleNextPrevButton(AtlasLootSearchOptionsButton)
	AtlasLootSearchOptionsButton:Point("LEFT", AtlasLootSearchButton, "RIGHT", 2, 0)

	S:HandleButton(AtlasLootSearchClearButton)
	AtlasLootSearchClearButton:Height(22)
	AtlasLootSearchClearButton:Point("LEFT", AtlasLootSearchOptionsButton, "RIGHT", 2, 0)

	S:HandleButton(AtlasLootLastResultButton)
	AtlasLootLastResultButton:Height(22)
	AtlasLootLastResultButton:Point("LEFT", AtlasLootSearchClearButton, "RIGHT", 2, 0)

	hooksecurefunc("AtlasLoot_SetupForAtlas", function()
		AtlasLootPanel:ClearAllPoints()
		AtlasLootPanel:SetParent(AtlasFrame)
		AtlasLootPanel:Point("TOP", "AtlasFrame", "BOTTOM", 0, -2)
	end)

	AS:SkinLibrary("AceAddon-2.0")
	AS:SkinLibrary("Dewdrop-2.0")
	AS:SkinLibrary("Tablet-2.0")
end

S:AddCallbackForAddon("AtlasLoot", "AtlasLoot", LoadSkin)