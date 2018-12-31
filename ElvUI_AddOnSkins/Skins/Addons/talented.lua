local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")
local AS = E:GetModule("AddOnSkins")

local unpack = unpack

-- Talented r291

local function LoadSkin()
	if not E.private.addOnSkins.Talented then return end

	S:SecureHook(Talented, "CreateBaseFrame", function()
		TalentedFrame:StripTextures()
		TalentedFrame:SetTemplate("Transparent")

		S:HandleCloseButton(TalentedFrame.close, TalentedFrame)

		S:HandleButton(TalentedFrame.boptions, true)
		S:HandleButton(TalentedFrame.bmode, true)
		S:HandleButton(TalentedFrame.btemplate, true)

		TalentedFrame.editname:Height(18)
		TalentedFrame.editname:DisableDrawLayer("BACKGROUND")
		S:HandleEditBox(TalentedFrame.editname)

		S:HandleCheckBox(TalentedFrame.checkbox)

		S:Unhook(Talented, "CreateBaseFrame")
	end)

	S:RawHook(Talented, "MakeButton", function(self, parent)
		local button = S.hooks[self].MakeButton(self, parent)

		if not button.isSkinned then
			button:SetTemplate("Default")
			button:StyleButton()

			button:DisableDrawLayer("BACKGROUND")
			button:SetNormalTexture(nil)
			button.SetNormalTexture = E.noop

			button.texture:SetInside(button)
			button.texture:SetTexCoord(unpack(E.TexCoords))
			button.texture:SetDrawLayer("ARTWORK")

			button.rank:SetFont(E.LSM:Fetch("font", E.db.general.font), 12, "OUTLINE")
			button.rank:Point("CENTER", button, "BOTTOMRIGHT", 2, 0)
			button.rank.texture:Kill()

			button.isSkinned = true
		end

		return button
	end)

	S:RawHook(Talented, "GetButtonTarget", function(self, button)
		local target = S.hooks[self].GetButtonTarget(self, button)

		if not target.isSkinned then
			target:SetFont(E.LSM:Fetch("font", E.db.general.font), 12, "OUTLINE")
			target:Point("CENTER", button, "TOPRIGHT", 2, 0)
			target.texture:Kill()

			target.isSkinned = true
		end

		return target
	end)

	AS:SkinLibrary("AceAddon-2.0")
	AS:SkinLibrary("Dewdrop-2.0")
end

S:AddCallbackForAddon("Talented", "Talented", LoadSkin)