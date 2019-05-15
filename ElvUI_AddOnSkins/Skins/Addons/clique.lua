local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G
local select, unpack = select, unpack

local hooksecurefunc = hooksecurefunc

-- Supports:
-- Clique r102
-- Clique Enhanced v143.1 (https://github.com/VideoPlayerCode/CliqueEnhancedTBC)

local function LoadSkin()
	if not E.private.addOnSkins.Clique then return end

	CliquePulloutTab:StyleButton(nil, true)
	CliquePulloutTab:SetTemplate("Default", true)
	CliquePulloutTab:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
	CliquePulloutTab:GetNormalTexture():SetInside()
	select(1, CliquePulloutTab:GetRegions()):Hide()

	local function SkinFrame(frame)
		frame:StripTextures()
		frame:SetTemplate("Transparent")

		frame.titleBar:StripTextures()
		frame.titleBar:SetTemplate("Default", true)
		frame.titleBar:Height(20)
		frame.titleBar:Point("TOPLEFT", frame, "TOPLEFT", 0, 0)
		frame.titleBar:Point("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
	end

	local function SkinCheckBox(entry)
		-- Re-skin the checkbox.
		S:HandleCheckBox(entry)

		-- Fix the gray, square backdrop so that it isn't super-wide anymore.
		entry.backdrop:Point("TOPLEFT", 6, -4)
		entry.backdrop:Point("BOTTOMRIGHT", -4, 3)
		entry.backdrop:Point("TOPRIGHT", entry.name, "TOPLEFT", -3, 0)

		-- Disable the ability to change textures on the checkbox. This is important,
		-- because "Clique:TextListScrollUpdate()" will attempt to constantly set
		-- textures based on list-type, which would show up as stretched artifacts.
		entry.SetNormalTexture = E.noop
		entry.SetHighlightTexture = E.noop
		entry.SetCheckedTexture = E.noop
		entry.SetBackdropBorderColor = E.noop
	end

	local function SkinCloseButton(btn)
		S:HandleCloseButton(btn)
		btn:Size(32)
		btn:Point("TOPRIGHT", 5, 5)
	end

	if Clique.ShowBindings then -- Clique Enhanced
		hooksecurefunc(Clique, "ShowBindings", function()
			if CliqueTooltip and not CliqueTooltip.isSkinned then
				CliqueTooltip:SetTemplate("Transparent")
				CliqueTooltip.SetBackdropBorderColor = E.noop -- Prevent color reverting OnHide...
				CliqueTooltip.SetBackdropColor = E.noop -- ...

				if CliqueTooltip.close then
					SkinCloseButton(CliqueTooltip.close)
				end

				CliqueTooltip.isSkinned = true
			end
		end)
	end

	hooksecurefunc(Clique, "CreateOptionsFrame", function()
		SkinFrame(CliqueFrame)

		CliqueFrame:Height(425)
		CliqueFrame:Point("TOPLEFT", SpellBookFrame, "TOPRIGHT", 10, -12)

		for i = 1, 10 do
			local entry = _G["CliqueList"..i]
			entry:Height(32)

			entry:SetTemplate("Default")

			entry.icon:SetPoint("LEFT", 3.5, 0)
			entry.icon:SetTexCoord(unpack(E.TexCoords))

			entry:SetScript("OnEnter", function(self)
				self:SetBackdropBorderColor(unpack(E["media"].rgbvaluecolor))
			end)

			entry:SetScript("OnLeave", function(self)
				local selected = FauxScrollFrame_GetOffset(CliqueListScroll) + self.id
				if selected == self.listSelected then
					self:SetBackdropBorderColor(1, 1, 1)
				else
					self:SetBackdropBorderColor(unpack(E.media.bordercolor))
				end
			end)
		end

		for i = 2, 10 do
			_G["CliqueList"..i]:Point("TOP", _G["CliqueList"..i - 1], "BOTTOM", 0, -2)
		end

		CliqueListScroll:StripTextures()
		S:HandleScrollBar(CliqueListScrollScrollBar)

		SkinFrame(CliqueTextListFrame)

		for i = 1, 12 do
			local entry = _G["CliqueTextList"..i]

			SkinCheckBox(entry)
		end

		CliqueTextListScroll:StripTextures()
		S:HandleScrollBar(CliqueTextListScrollScrollBar)

		if CliqueOptionsFrame then -- Clique Enhanced
			SkinFrame(CliqueOptionsFrame)
			CliqueOptionsFrame:SetWidth(CliqueOptionsFrame:GetWidth() + 10) -- Fit ElvUI's enlarged checkboxes.

			SkinCloseButton(CliqueOptionsButtonClose)

			for i,entry in ipairs({ CliqueOptionsFrame:GetChildren() }) do
				if entry and entry:IsObjectType("CheckButton") and strfind(entry:GetName() or "", "^CliqueOptions") then
					SkinCheckBox(entry)
				end
			end
		end

		S:HandleDropDownBox(CliqueDropDown, 170)
		CliqueDropDown:Point("TOPRIGHT", -1, -25)

		SkinCloseButton(CliqueButtonClose)

		S:HandleButton(CliqueButtonCustom)
		if CliqueButtonFrames then -- Clique Enhanced
			S:HandleButton(CliqueButtonFrames)
		end
		if CliqueButtonPreview then -- Clique Enhanced
			S:HandleButton(CliqueButtonPreview)
		end
		S:HandleButton(CliqueButtonMax)
		S:HandleButton(CliqueButtonProfiles)
		S:HandleButton(CliqueButtonOptions)
		S:HandleButton(CliqueButtonDelete)
		S:HandleButton(CliqueButtonEdit)

		SkinCloseButton(CliqueTextButtonClose)

		if CliqueIconSelectButtonClose then -- Clique Enhanced
			SkinCloseButton(CliqueIconSelectButtonClose)
		end

		S:HandleButton(CliqueButtonDeleteProfile)
		S:HandleButton(CliqueButtonSetProfile)
		S:HandleButton(CliqueButtonNewProfile)

		SkinFrame(CliqueCustomFrame)

		S:HandleButton(CliqueCustomButtonBinding)
		S:HandleButton(CliqueCustomButtonIcon)
		CliqueCustomButtonIcon.icon:SetTexCoord(unpack(E.TexCoords))
		CliqueCustomButtonIcon.icon:SetInside()

		for i = 1, 5 do
			S:HandleEditBox(_G["CliqueCustomArg"..i])
			_G["CliqueCustomArg"..i].backdrop:Point("TOPLEFT", -5, -5)
			_G["CliqueCustomArg"..i].backdrop:Point("BOTTOMRIGHT", -5, 5)
		end

		CliqueMulti:SetBackdrop(nil)
		CliqueMulti:CreateBackdrop("Default")
		CliqueMulti.backdrop:Point("TOPLEFT", 5, -8)
		CliqueMulti.backdrop:Point("BOTTOMRIGHT", -5, 8)
		S:HandleScrollBar(CliqueMultiScrollFrameScrollBar)

		S:HandleButton(CliqueCustomButtonCancel)
		S:HandleButton(CliqueCustomButtonSave)

		SkinFrame(CliqueIconSelectFrame)

		for i = 1, 20 do
			local button = _G["CliqueIcon"..i]
			local buttonIcon = _G["CliqueIcon"..i.."Icon"]

			button:StripTextures()
			button:StyleButton(nil, true)
			button.hover:SetAllPoints()
			button:CreateBackdrop("Default")

			buttonIcon:SetAllPoints()
			buttonIcon:SetTexCoord(unpack(E.TexCoords))
		end

		CliqueIconScrollFrame:StripTextures()
		S:HandleScrollBar(CliqueIconScrollFrameScrollBar)
	end)

	hooksecurefunc(Clique, "ListScrollUpdate", function(self)
		if not CliqueListScroll then return end

		local idx, button
		local clickCasts = self.sortList
		local offset = FauxScrollFrame_GetOffset(CliqueListScroll)

		for i = 1, 10 do
			idx = offset + i
			button = _G["CliqueList"..i]
			if idx <= #clickCasts then
				if idx == self.listSelected then
					button:SetBackdropBorderColor(1, 1, 1)
				else
					button:SetBackdropBorderColor(unpack(E.media.bordercolor))
				end
			end
		end
	end)
end

S:AddCallbackForAddon("Clique", "Clique", LoadSkin)