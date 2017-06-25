local E, L, V, P, G = unpack(ElvUI);
local S = E:GetModule("Skins");

local function LoadSkin()
	if(not E.private.addOnSkins.Talented) then return end

	local function SkinTalantButtons()
		local icon, rank
		local talantButtons = Talented.template.talents -- CANT FIND THE DAMN BUTTONS XD

		for talentID, talent in pairs(talantButtons) do
			if talantButtons[talentID].id and talent:IsObjectType("Button") then
				icon = talent.texture
				rank = talent.rank

				if talent then
					talent:SetTemplate("Default")
					talent:StyleButton()

					talent:DisableDrawLayer("BACKGROUND")
					talent:SetNormalTexture(nil)
					talent.SetNormalTexture = E.noop

					icon:SetInside(talent)
					icon:SetTexCoord(unpack(E.TexCoords))
					icon:SetDrawLayer("ARTWORK")

					rank:SetFont(E.LSM:Fetch("font", E.db["general"].font), 12, "OUTLINE")
					rank:Point("CENTER", talent, "BOTTOMRIGHT", 2, 0)
					rank.texture:Kill()
				end
			end
		end
	end

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

		E:Delay(0.01, function()
			-- SkinTalantButtons()
		end)

		S:Unhook(Talented, "CreateBaseFrame")
	end)
end

S:AddCallbackForAddon("Talented", "Talented", LoadSkin);