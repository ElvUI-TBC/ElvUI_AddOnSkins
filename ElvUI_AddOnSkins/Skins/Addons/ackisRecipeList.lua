local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local ipairs = ipairs
local select = select
local hooksecurefunc = hooksecurefunc

-- AckisRecipeList r888

local function LoadSkin()
	if not E.private.addOnSkins.AckisRecipeList then return end

	local addon = LibStub("AceAddon-3.0"):GetAddon("Ackis Recipe List", true)
	if not addon then return end

	local function ExpandCollapseButton(button, text)
		S:HandleButton(button)
		button:Size(17)

		if not button.text then
			button.text = button:CreateFontString(nil, "OVERLAY")
			button.text:SetFont("Interface\\AddOns\\ElvUI\\media\\fonts\\PT_Sans_Narrow.ttf", 16, "OUTLINE")
			button.text:SetText(text)
			button.text:SetJustifyH("CENTER")
			button.text:SetPoint("CENTER", button)
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
			self.ScanButton:SetFrameLevel(TradeSkillFrame:GetFrameLevel() + 10)

			local point = select(2, self.ScanButton:GetPoint())
			if point == TradeSkillFrameCloseButton or point == CraftFrameCloseButton then
				self.ScanButton:Point("RIGHT", point, "LEFT", 3, 0)
			end
		end
	end)

	hooksecurefunc(addon, "CreateFrame", function(self)
		local point = select(2, self.Frame:GetPoint())
		if point == TradeSkillFrame or point == CraftFrame then
			if TradeTabs then
				self.Frame:Point("RIGHT", point, "RIGHT", 389, 27)
			else
				self.Frame:Point("RIGHT", point, "RIGHT", 349, 27)
			end
		end

		if not self.db.profile.testgui then
			if not self.Frame.isSkinned then
				self.Frame:SetTemplate("Transparent")
				self.Frame.Header.Texture:Kill()

				S:HandleButton(self.Frame.CloseButton)
				self.Frame.CloseButton:SetPoint("BOTTOMRIGHT", self.Frame, -8, 6)

				-- HandleCloseButton for easy text creation
				ExpandCollapseButton(self.Frame.ExpandAllButton, "+")
				ExpandCollapseButton(self.Frame.CollapseAllButton, "-")
				self.Frame.ExpandAllButton:SetPoint("TOPRIGHT", self.Frame, "TOPRIGHT", -28, -26)
				self.Frame.CollapseAllButton:ClearAllPoints()
				self.Frame.CollapseAllButton:SetPoint("RIGHT", self.Frame.ExpandAllButton, "LEFT", -4, 0)

				S:HandleCloseButton(self.Frame.XButton, self.Frame)

				self.Frame.ScrollFrame:CreateBackdrop("Transparent")
				self.Frame.ScrollFrame.backdrop:Point("TOPLEFT", 0, 3)
				self.Frame.ScrollFrame.backdrop:Point("BOTTOMRIGHT", 2, -3)
				S:HandleScrollBar(_G[self.Frame.ScrollFrame:GetName().."ScrollBar"])

				self.Frame.ProgressBarBorder:Kill()
				self.Frame.ProgressBar:StripTextures()
				self.Frame.ProgressBar:CreateBackdrop()
				self.Frame.ProgressBar:Height(22)
				self.Frame.ProgressBar:SetPoint("BOTTOMLEFT", self.Frame, 11, 7)
				self.Frame.ProgressBar:SetStatusBarTexture(E["media"].normTex)
				self.Frame.ProgressBar:SetStatusBarColor(0.13, 0.35, 0.80)
				E:RegisterStatusBar(self.Frame.ProgressBar)

				self.Frame.isSkinned = true
			end

			local button
			for i = 1, #self.SortedRecipeIndex do
				button = _G["AckisRecipeListRecipe"..i]

				if button and not button.isSkinned then
					button:SetNormalTexture("")
					button.SetNormalTexture = E.noop
					button:SetPushedTexture("")
					button.SetPushedTexture = E.noop
					button:SetHighlightTexture("")
					button.SetHighlightTexture = E.noop
					button:SetDisabledTexture("")
					button.SetDisabledTexture = E.noop

					button.text = button:CreateFontString(nil, "OVERLAY")
					button.text:FontTemplate(nil, 22)
					button.text:Point("RIGHT", -5, 0)
					button.text:SetText("+")

					hooksecurefunc(button, "SetNormalTexture", function(self, texture)
						if string.find(texture, "MinusButton") then
							self.text:SetText("-")
						else
							self.text:SetText("+")
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