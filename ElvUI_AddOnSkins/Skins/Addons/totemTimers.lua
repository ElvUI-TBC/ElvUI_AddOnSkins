local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G
local ipairs, unpack = ipairs, unpack

local hooksecurefunc = hooksecurefunc

-- TotemTimers 8.1d

local function LoadSkin()
	if not E.private.addOnSkins.TotemTimers then return end
	if E.myclass ~= "SHAMAN" then return end

	local trackers = {
		"TotemTimers_Ankh",
		"TotemTimers_Shield",
		"TotemTimers_MainHand",
		"TotemTimers_EarthShield"
	}

	local totemTimers = {
		"TotemTimers_EarthElemental",
		"TotemTimers_FireElemental",
		"TotemTimers_ManaTide",
		"TotemTimers_ManaTrinket"
	}

	local function SkinButton(button, isSlave)
		if not button.isSkinned then return end

		button:StyleButton(nil, nil, true)
		button:CreateBackdrop("Default")
		button.backdrop:SetAllPoints()

		if not button.icon then
			button.icon = _G[button:GetName().."Icon"]
		end
		button.icon:SetInside()
		button.icon:SetTexCoord(unpack(E.TexCoords))

		if not button.flash and _G[button:GetName().."Flash"] then
			button.flash = _G[button:GetName().."Flash"]
		end
		if button.flash then
			button.flash:SetInside()
			button.flash:SetTexCoord(unpack(E.TexCoords))
		end

		if button.spellIcon then
			button.spellIcon:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 1)
			button.spellIcon:SetTexCoord(unpack(E.TexCoords))
		end

		button.isSkinned = true
	end

	hooksecurefunc("TotemTimers_SetupGlobals", function()
		for i, button in ipairs(TotemTimers_Buttons) do
			SkinButton(button)

			for j = 1, #TotemTimers_ActiveOrder[i] do
				SkinButton(_G[i.."SlaveButton"..j])
			end
		end

		for _, button in ipairs(totemTimers) do
			SkinButton(_G[button])
		end

		for i, button in ipairs(trackers) do
			button = _G[button]

			if not button.isSkinned then
				if i ~= 1 then
					button:StyleButton(nil, nil, true)
				end

				button:CreateBackdrop("Default")
				button.backdrop:SetAllPoints()

				button.icon = _G[button:GetName().."Icon"]
				button.icon:SetInside()

				button.flash = _G[button:GetName().."Flash"]
				button.flash:SetInside()
				button.flash:SetTexCoord(unpack(E.TexCoords))

				if i ~= 3 then
					button.icon:SetTexCoord(unpack(E.TexCoords))
				else
					local icon2frame = _G[button:GetName().."Icon2Frame"]
					icon2frame:SetFrameStrata("MEDIUM")
					icon2frame:SetWidth(icon2frame:GetWidth() + 1)
					button.icon2 = _G[button:GetName().."Icon2"]
					button.icon2:SetInside()

					button.icon1Frame = CreateFrame("Frame", "TotemTimers_MainHandIcon1Frame", button)
					button.icon1Frame:SetSize(16, 30)
					button.icon1Frame:Point("LEFT")

					button.icon1 = button.icon1Frame:CreateTexture(nil, "MEDIUM")
					button.icon1:SetInside()
					button.icon1:SetTexture(button.icon:GetTexture())
					button.icon1:SetAlpha(button.icon:GetAlpha())

					_G[button:GetName().."Cooldown"]:SetFrameLevel(button.icon1Frame:GetFrameLevel() + 1)

					button.icon:Hide()
					hooksecurefunc(button.icon, "SetTexture", function(_, texture)
						button.icon1:SetTexture(texture)
					end)
					hooksecurefunc(button.icon, "SetAlpha", function(_, alpha)
						button.icon1:SetAlpha(alpha)
					end)

					if button.icon:GetTexCoordModifiesRect() then
						button.icon1:SetTexCoord(.08, .5, .08, .92)
					else
						button.icon1:SetTexCoord(.08, .92, .08, .92)
					end
					button.icon2:SetTexCoord(.5, .92, .08, .92)

					hooksecurefunc(button.icon, "SetTexCoord", function(self, arg1, arg2)
						if arg2 == 0.5 and arg1 == 0 then
							button.icon1:SetTexCoord(.08, .5, .08, .92)
						elseif arg2 == 1 then
							button.icon1:SetTexCoord(.08, .92, .08, .92)
						end
					end)
					hooksecurefunc(button.icon2, "SetTexCoord", function(self, arg1, arg2)
						if arg2 == 1 then
							self:SetTexCoord(.5, .92, .08, .92)
						end
					end)
				end

				button.isSkinned = true
			end
		end
	end)
end

S:AddCallbackForAddon("TotemTimers", "TotemTimers", LoadSkin)