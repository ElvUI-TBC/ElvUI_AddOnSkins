local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G
local ipairs, select = ipairs, select
local find = string.find

local hooksecurefunc = hooksecurefunc

-- AckisRecipeList r892

local function LoadSkin()
	if not E.private.addOnSkins.AckisRecipeList then return end

	local addon = LibStub("AceAddon-3.0"):GetAddon("Ackis Recipe List", true)
	if not addon then return end

	local function ExpandCollapseButton(button, minus)
		button:SetNormalTexture("Interface\\AddOns\\ElvUI\\media\\textures\\PlusMinusButton")
		button.SetNormalTexture = E.noop
		button:GetNormalTexture():Size(15)

		button:SetPushedTexture("Interface\\AddOns\\ElvUI\\media\\textures\\PlusMinusButton")
		button.SetPushedTexture = E.noop
		button:GetPushedTexture():Size(15)

		button:SetHighlightTexture("")
		button.SetHighlightTexture = E.noop

		button:SetDisabledTexture("Interface\\AddOns\\ElvUI\\media\\textures\\PlusMinusButton")
		button.SetDisabledTexture = E.noop
		button:GetDisabledTexture():Size(15)
		button:GetDisabledTexture():SetDesaturated(true)

		if minus then
			button:GetNormalTexture():SetTexCoord(0.540, 0.965, 0.085, 0.920)
			button:GetPushedTexture():SetTexCoord(0.540, 0.965, 0.085, 0.920)
			button:GetDisabledTexture():SetTexCoord(0.540, 0.965, 0.085, 0.920)
		else
			button:GetNormalTexture():SetTexCoord(0.040, 0.465, 0.085, 0.920)
			button:GetPushedTexture():SetTexCoord(0.040, 0.465, 0.085, 0.920)
			button:GetDisabledTexture():SetTexCoord(0.040, 0.465, 0.085, 0.920)
		end
	end

	if addon.ScanButton then
		S:HandleButton(addon.ScanButton)
	else
		S:SecureHook(addon, "CreateScanButton", function(self)
			S:HandleButton(self.ScanButton)
			S:Unhook(self, "CreateScanButton")
		end)
	end

	hooksecurefunc(addon, "ShowScanButton", function(self)
		local parent = self.ScanButton:GetParent()
		if parent == TradeSkillFrame or parent == CraftFrame then
			self.ScanButton:SetFrameLevel(parent:GetFrameLevel() + 10)

			local point = select(2, self.ScanButton:GetPoint())
			if point == TradeSkillFrameCloseButton or point == CraftFrameCloseButton then
				self.ScanButton:Point("RIGHT", point, "LEFT", 3, 0)
			end
		end
	end)

	hooksecurefunc(addon, "CreateFrame", function(self)
		if Skillet and Skillet:IsActive() then
			if not CraftIsPetTraining() and SkilletFrame then
				self.Frame:SetPoint("LEFT", SkilletFrame, "RIGHT", 0, 41)
			elseif CraftIsPetTraining() then
				self.Frame:SetPoint("RIGHT", CraftFrame, "RIGHT", 349, 27)
			end
		elseif ATSWFrame and ATSWFrame:IsVisible() then
			self.Frame:SetPoint("RIGHT", ATSWFrame, "RIGHT", 349, 29)
		elseif self.SkillType then
			local point = self.SkillType == "Trade" and TradeSkillFrame or CraftFrame
			if TradeTabs then
				self.Frame:Point("RIGHT", point, "RIGHT", 389, 27)
			else
				self.Frame:Point("RIGHT", point, "RIGHT", 349, 27)
			end
		else
			self.Frame:Point("CENTER", UIParent, "CENTER", 0, 0)
		end

		if not self.db.profile.testgui then
			if not self.Frame.isSkinned then
				self.Frame:SetTemplate("Transparent")
				self.Frame.Header.Texture:Kill()

				S:HandleButton(self.Frame.CloseButton)
				self.Frame.CloseButton:Point("BOTTOMRIGHT", self.Frame, -8, 6)

				ExpandCollapseButton(self.Frame.ExpandAllButton)
				self.Frame.ExpandAllButton:ClearAllPoints()
				self.Frame.ExpandAllButton:Point("TOPLEFT", self.Frame, "TOPLEFT", 11, -27)

				ExpandCollapseButton(self.Frame.CollapseAllButton, true)
				self.Frame.CollapseAllButton:ClearAllPoints()
				self.Frame.CollapseAllButton:Point("LEFT", self.Frame.ExpandAllButton, "RIGHT", 4, 0)

				S:HandleCloseButton(self.Frame.XButton, self.Frame)

				self.Frame.ScrollFrame:CreateBackdrop("Transparent")
				self.Frame.ScrollFrame.backdrop:Point("TOPLEFT", 0, 3)
				self.Frame.ScrollFrame.backdrop:Point("BOTTOMRIGHT", 2, -3)
				S:HandleScrollBar(_G[self.Frame.ScrollFrame:GetName().."ScrollBar"])

				self.Frame.ProgressBarBorder:Kill()
				self.Frame.ProgressBar:StripTextures()
				self.Frame.ProgressBar:CreateBackdrop()
				self.Frame.ProgressBar:Height(22)
				self.Frame.ProgressBar:Point("BOTTOMLEFT", self.Frame, 11, 7)
				self.Frame.ProgressBar:SetStatusBarTexture(E.media.normTex)
				self.Frame.ProgressBar:SetStatusBarColor(0.13, 0.35, 0.80)
				E:RegisterStatusBar(self.Frame.ProgressBar)

				self.Frame.isSkinned = true
			end

			local button
			for i = 1, #self.SortedRecipeIndex do
				button = _G["AckisRecipeListRecipe"..i]

				if button and not button.isSkinned then
					button:SetNormalTexture("Interface\\AddOns\\ElvUI\\media\\textures\\PlusMinusButton")
					button.SetNormalTexture = E.noop
					button:GetNormalTexture():SetTexCoord(0.040, 0.465, 0.085, 0.920)
					button:GetNormalTexture():Size(14)

					button:SetPushedTexture("Interface\\AddOns\\ElvUI\\media\\textures\\PlusMinusButton")
					button.SetPushedTexture = E.noop
					button:GetPushedTexture():Size(14)
					button:GetPushedTexture():SetTexCoord(0.040, 0.465, 0.085, 0.920)

					button:SetHighlightTexture("")
					button.SetHighlightTexture = E.noop

					button:SetDisabledTexture("Interface\\AddOns\\ElvUI\\media\\textures\\PlusMinusButton")
					button.SetDisabledTexture = E.noop
					button:GetDisabledTexture():SetTexCoord(0.040, 0.465, 0.085, 0.920)
					button:GetDisabledTexture():SetDesaturated(true)
					button:GetDisabledTexture():Size(14)

					hooksecurefunc(button, "SetNormalTexture", function(self, texture)
						if find(texture, "MinusButton") then
							self:GetNormalTexture():SetTexCoord(0.540, 0.965, 0.085, 0.920)
							self:GetPushedTexture():SetTexCoord(0.540, 0.965, 0.085, 0.920)
						else
							self:GetNormalTexture():SetTexCoord(0.040, 0.465, 0.085, 0.920)
							self:GetPushedTexture():SetTexCoord(0.040, 0.465, 0.085, 0.920)
						end
					end)

					button.isSkinned = true
				end
			end
		end
	end)

	hooksecurefunc(addon, "DisplayTextDump", function(self)
		ARLCopyFrame:StripTextures()
		ARLCopyFrame:SetTemplate("Transparent")
		S:HandleScrollBar(ARLCopyScrollScrollBar)

		for i = 1, ARLCopyFrame:GetNumChildren() do
			local child = select(i, ARLCopyFrame:GetChildren())
			if child and child:IsObjectType("Button") then
				child:ClearAllPoints()
				child:Point("TOPRIGHT", ARLCopyFrame, "TOPRIGHT", 1, 0)
				S:HandleCloseButton(child)
				break
			end
		end
	end)
end

S:AddCallbackForAddon("AckisRecipeList", "AckisRecipeList", LoadSkin)