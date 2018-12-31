local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")
local AS = E:GetModule("AddOnSkins")

local _G = _G
local select = select

-- Cartographer 2.2

local function LockButtonSkin()
	if not E.private.addOnSkins.Cartographer then return end
	if not Cartographer_LookNFeel then return end

	local function SkinLockButton(button)
		if button.isSkinned then return end

		button:Size(15, 22)
		button:SetTemplate("Transparent")
		button:HookScript2("OnEnter", S.SetModifiedBackdrop)
		button:HookScript2("OnLeave", S.SetOriginalBackdrop)

		local texture = button:GetNormalTexture():GetTexture()
		button:SetPushedTexture(texture)
		button:SetCheckedTexture(texture)
		button:SetHighlightTexture(nil)

		local tex = button:GetNormalTexture()
		tex:SetInside()
		tex:SetTexCoord(0.09375, 0.46875, 0.0625, 0.546875)

		tex = button:GetPushedTexture()
		tex:SetInside()
		tex:SetTexCoord(0.09375, 0.46875, 0.0625, 0.546875)
		local res = tex:SetDesaturated(true)
		if not res then
			tex:SetVertexColor(0.5, 0.5, 0.5)
		end

		tex = button:GetCheckedTexture()
		tex:SetInside()
		tex:SetTexCoord(0.09375, 0.46875, 0.0625, 0.546875)
		res = tex:SetDesaturated(true)
		if not res then
			tex:SetVertexColor(0.5, 0.5, 0.5)
		end

		button.isSkinned = true
	end

	if not Cartographer.db.profile.scale then
		Cartographer.db.profile.scale = 1
	end

	local lockButton = _G["CartographerLookNFeelLockButton"]
	if lockButton then
		SkinLockButton(lockButton)
	else
		S:SecureHook(Cartographer, "AddMapButton", function(self, frame)
			if frame and frame:GetName() == "CartographerLookNFeelLockButton" then
				SkinLockButton(frame)
				S:Unhook(self, "AddMapButton")
			end
		end)
	end

	local bgTextures = {
		"Interface\\WorldMap\\UI-WorldMap-Top1",
		"Interface\\WorldMap\\UI-WorldMap-Top2",
		"Interface\\WorldMap\\UI-WorldMap-Top3",
		"Interface\\WorldMap\\UI-WorldMap-Top4",
		"Interface\\WorldMap\\UI-WorldMap-Middle1",
		"Interface\\WorldMap\\UI-WorldMap-Middle2",
		"Interface\\WorldMap\\UI-WorldMap-Middle3",
		"Interface\\WorldMap\\UI-WorldMap-Middle4",
		"Interface\\WorldMap\\UI-WorldMap-Bottom1",
		"Interface\\WorldMap\\UI-WorldMap-Bottom2",
		"Interface\\WorldMap\\UI-WorldMap-Bottom3",
		"Interface\\WorldMap\\UI-WorldMap-Bottom4"
	}

	S:SecureHook(Cartographer_LookNFeel, "OnEnable", function(self)
		local t
		for i = 1, self.nonOverlayHolder:GetNumRegions() do
			local region = select(i, self.nonOverlayHolder:GetRegions())
			if region and region:IsObjectType("Texture") then
				t = region:GetTexture()

				for j = 1, #bgTextures do
					if t == bgTextures[j] then
						region:Hide()
						break
					end
				end
			end
		end
		CartographerLookNFeelNonOverlayHolder:CreateBackdrop()
	end)

	if E.global.general.smallerWorldMap then
		WorldMapFrame:SetParent(nil)
	end
	if E.private.skins.blizzard.enable and E.private.skins.blizzard.worldmap then
		E:Delay(1, function()
			if WorldMapDetailFrame.backdrop then
				WorldMapDetailFrame.backdrop:Hide()
			end
		end)
	end
end

local function NoteFrameSkin()
	if not E.private.addOnSkins.Cartographer then return end
	if not Cartographer_Notes then return end

	local function SkinNoteFrame()
		local frame = _G["CartographerNotesNewNoteFrame"]
		if frame.isSkinned then return end

		frame:StripTextures()
		frame:SetTemplate("Transparent")

		local editBoxes = {
			frame.xEditBox,
			frame.yEditBox,
			frame.zone,
			frame.title,
			frame.info1,
			frame.info2,
			frame.creator
		}

		for i = 1, #editBoxes do
			editBoxes[i]:DisableDrawLayer("BACKGROUND")
			S:HandleEditBox(editBoxes[i])
		end

		S:HandleDropDownBox(frame.icon)

		S:HandleButton(_G["CartographerNotesNewNoteFrameOkay"])
		S:HandleButton(_G["CartographerNotesNewNoteFrameCancel"])

		frame.isSkinned = true
	end

	S:SecureHook(Cartographer_Notes, "OpenNewNoteFrame", function(self)
		SkinNoteFrame()

		S:Unhook(self, "OpenNewNoteFrame")
		S:Unhook(self, "ShowEditDialog")
	end)
	S:SecureHook(Cartographer_Notes, "ShowEditDialog", function(self)
		SkinNoteFrame()

		S:Unhook(self, "OpenNewNoteFrame")
		S:Unhook(self, "ShowEditDialog")
	end)
end

local function QuestInfoSkin()
	if not E.private.addOnSkins.Cartographer then return end
	if not Cartographer_QuestInfo then return end

	hooksecurefunc(Cartographer_QuestInfo, "CreateCartoButton", function(self)
		local tooltip = _G["CQI_Tooltip"]
		if not tooltip.isSkinned then
			tooltip:StripTextures()
			tooltip:CreateBackdrop("Transparent")
		end

		local button = _G["QuestInfoButton"]
		if not button.isSkinned then
			S:HandleButton(button)
		end
	end)
end

local function LoadSkin()
	if not E.private.addOnSkins.Cartographer then return end

	S:HandleButton(CartographerGoToButton)
	S:HandleButton(CartographerOptionsButton)

	AS:SkinLibrary("Dewdrop-2.0")
	AS:SkinLibrary("Tablet-2.0")
	AS:SkinLibrary("LibRockConfig-1.0")

	if not AS:IsAddonExist("Cartographer_LookNFeel") then
		LockButtonSkin()
	end
	if not AS:IsAddonExist("Cartographer_Notes") then
		NoteFrameSkin()
	end
	if not AS:IsAddonExist("Cartographer_QuestInfo") then
		QuestInfoSkin()
	end
end

S:AddCallbackForAddon("Cartographer", "Cartographer", LoadSkin)

if AS:IsAddonExist("Cartographer_LookNFeel") then
	S:AddCallbackForAddon("Cartographer_LookNFeel", "Cartographer_LookNFeel", LockButtonSkin)
end
if AS:IsAddonExist("Cartographer_Notes") then
	S:AddCallbackForAddon("Cartographer_Notes", "Cartographer_Notes", NoteFrameSkin)
end
if AS:IsAddonExist("Cartographer_QuestInfo") then
	S:AddCallbackForAddon("Cartographer_QuestInfo", "Cartographer_QuestInfo", QuestInfoSkin)
end