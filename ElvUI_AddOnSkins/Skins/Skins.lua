local E, L, V, P, G = unpack(ElvUI)
local AS = E:GetModule("AddOnSkins")
local S = E:GetModule("Skins")

local select = select

AS.SQUARE_BUTTON_TEXCOORDS = {
	["HELP"]	= {0, 0.125, 0, 0.125};
	["TOP"]		= {0, 0.125, 0.125, 0.25};
	["BOTTOM"]	= {0, 0.125, 0.25, 0.375};
	["FILE"]	= {0, 0.125, 0.375, 0.5};
	["LOCK"]	= {0, 0.125, 0.5, 0.625};
	["CLOSE"]	= {0.125, 0.25, 0, 0.125};
	["UP"]		= {0.125, 0.25, 0.125, 0.25};
	["DOWN"]	= {0.125, 0.25, 0.25, 0.375};
	["PLUS"]	= {0.125, 0.25, 0.375, 0.5};
	["MINUS"]	= {0.125, 0.25, 0.5, 0.625};
	["GEAR"]	= {0.25, 0.375, 0, 0.125};
	["MARK"]	= {0.25, 0.375, 0.125, 0.25};
	["STOP"]	= {0.25, 0.375, 0.25, 0.375};
	["PAUSE"]	= {0.25, 0.375, 0.375, 0.5};
}

function AS:HandleSquareButton(button, name, iconSize, noTemplate)
	button:StripTextures()
	button:SetNormalTexture("")
	button:SetPushedTexture("")
	button:SetHighlightTexture("")
	button:SetDisabledTexture("")

	if not button.icon then
		button.icon = button:CreateTexture(nil, "ARTWORK")
		button.icon:Size(iconSize or 24)
		button.icon:Point("CENTER")
		button.icon:SetTexture([[Interface\AddOns\ElvUI_AddOnSkins\media\SquareButtons]])

		button:SetScript("OnMouseDown", function(self)
			if button:IsEnabled() == 1 then
				self.icon:Point("CENTER", -1, -1)
			end
		end)

		button:SetScript("OnMouseUp", function(self)
			self.icon:Point("CENTER", 0, 0)
		end)

		hooksecurefunc(button, "Disable", function(self)
			SetDesaturation(self.icon, true)
			self.icon:SetAlpha(0.5)
		end)

		hooksecurefunc(button, "Enable", function(self)
			SetDesaturation(self.icon, false)
			self.icon:SetAlpha(1.0)
		end)

		if button:IsEnabled() == 0 then
			SetDesaturation(button.icon, true)
			button.icon:SetAlpha(0.5)
		end

		local coords = AS.SQUARE_BUTTON_TEXCOORDS[strupper(name)]
		if coords then
			button.icon:SetTexCoord(coords[1], coords[2], coords[3], coords[4])
		end
	end

	if not noTemplate then
		button:SetTemplate("Default", true)
		button:HookScript2("OnEnter", S.SetModifiedBackdrop)
		button:HookScript2("OnLeave", S.SetOriginalBackdrop)
	end
end

function AS:Desaturate(frame, point)
	for i = 1, frame:GetNumRegions() do
		local region = select(i, frame:GetRegions())
		if region:IsObjectType("Texture") then
			local Texture = region:GetTexture()
			if type(Texture) == "string" and strlower(Texture) == "interface\\dialogframe\\ui-dialogbox-corner" then
				region:SetTexture(nil)
				region:Kill()
			else
				region:SetDesaturated(true)
			end
		end
	end

	frame:HookScript2("OnUpdate", function(self)
		if self:GetNormalTexture() then
			self:GetNormalTexture():SetDesaturated(true)
		end
		if self:GetPushedTexture() then
			self:GetPushedTexture():SetDesaturated(true)
		end
		if self:GetHighlightTexture() then
			self:GetHighlightTexture():SetDesaturated(true)
		end
	end)
end

function AS:AcceptFrame(MainText, Function)
	if not AcceptFrame then
		AcceptFrame = CreateFrame("Frame", "AcceptFrame", UIParent)
		AcceptFrame:SetTemplate("Transparent")
		AcceptFrame:Point("CENTER", UIParent, "CENTER")
		AcceptFrame:SetFrameStrata("DIALOG")

		AcceptFrame.Text = AcceptFrame:CreateFontString(nil, "OVERLAY")
		AcceptFrame.Text:FontTemplate()
		AcceptFrame.Text:Point("TOP", AcceptFrame, "TOP", 0, -10)

		AcceptFrame.Accept = CreateFrame("Button", nil, AcceptFrame, "OptionsButtonTemplate")
		S:HandleButton(AcceptFrame.Accept)
		AcceptFrame.Accept:Size(70, 25)
		AcceptFrame.Accept:Point("RIGHT", AcceptFrame, "BOTTOM", -10, 20)
		AcceptFrame.Accept:SetFormattedText("|cFFFFFFFF%s|r", YES)

		AcceptFrame.Close = CreateFrame("Button", nil, AcceptFrame, "OptionsButtonTemplate")
		S:HandleButton(AcceptFrame.Close)
		AcceptFrame.Close:Size(70, 25)
		AcceptFrame.Close:Point("LEFT", AcceptFrame, "BOTTOM", 10, 20)
		AcceptFrame.Close:SetScript("OnClick", function(self) self:GetParent():Hide() end)
		AcceptFrame.Close:SetFormattedText("|cFFFFFFFF%s|r", NO)
	end
	AcceptFrame.Text:SetText(MainText)
	AcceptFrame:Size(AcceptFrame.Text:GetStringWidth() + 100, AcceptFrame.Text:GetStringHeight() + 60)
	AcceptFrame.Accept:SetScript("OnClick", Function)
	AcceptFrame:Show()
end