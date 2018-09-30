local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

-- Auctionator 1.1.1

local select, unpack = select, unpack

local function LoadSkin()
	if not E.private.addOnSkins.Auctionator then return; end

	hooksecurefunc("Auctionator_SetTextureButton", function(elementName, _, itemlink)
		local texture = GetItemIcon(itemlink)
		local textureElement = getglobal(elementName)

		if not textureElement.backdrop then
			textureElement:StyleButton(nil, true)
			textureElement:SetTemplate("Transparent", true)

			textureElement.backdrop = true
		end

		if texture then
			textureElement:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
			textureElement:GetNormalTexture():SetInside()
		end
	end)

	Auctionator_Error_Frame:SetTemplate("Transparent")
	S:HandleButton(select(1, Auctionator_Error_Frame:GetChildren()))

	Auctionator_Confirm_Frame:SetTemplate("Transparent")
	S:HandleButton(Auctionator_Confirm_Cancel)
	S:HandleButton(select(2, Auctionator_Confirm_Frame:GetChildren()))

	-- Options skinning
	AuctionatorOptionsFrame:StripTextures()
	AuctionatorOptionsFrame:CreateBackdrop("Transparent")

	AuctionatorDescriptionFrame:StripTextures()
	AuctionatorDescriptionFrame:CreateBackdrop("Transparent")

	S:HandleCheckBox(AuctionatorOption_Enable_Alt)
	S:HandleCheckBox(AuctionatorOption_Open_First)

	local isSkinned
	hooksecurefunc("Auctionator_OnAuctionHouseShow", function()
		if isSkinned then return end

		S:HandleButton(Auctionator1Button)
		S:HandleButton(AuctionatorOptionsButton_Okay)
		S:HandleButton(AuctionatorOptionsButton_Cancel)
		S:HandleButton(AuctionatorOptionsButton_More)

		S:HandleButton(AuctionsCreateAuctionButton)

		S:HandleButton(Auctionator_BatchButton)
		Auctionator_BatchButton:ClearAllPoints()
		Auctionator_BatchButton:Height(Auctionator1Button:GetHeight())
		Auctionator_BatchButton:Point("TOPLEFT", "Auctionator_Sell_Panel", "BOTTOMLEFT", 7, 32)

		Auctionator_Hilite1:SetTemplate("Transparent", true, true)
		Auctionator_Hilite1:SetBackdropColor(0, 0, 0, 0)

		S:HandleTab(AuctionFrameTab4)

		isSkinned = true
	end)
end

S:AddCallbackForAddon("Auctionator", "Auctionator", LoadSkin)