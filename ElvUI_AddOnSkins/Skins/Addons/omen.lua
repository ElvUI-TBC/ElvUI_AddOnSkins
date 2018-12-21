local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local select, unpack = select, unpack

-- Omen 2.0.4

local function LoadSkin()
	if not E.private.addOnSkins.Omen then return end

	hooksecurefunc(Omen, "UpdateDisplay", function(self)
		self.Title:SetTemplate("Default")
		self.BarList:SetTemplate("Default")
		self.ModuleList:SetTemplate("Default")

		self.BarList:ClearAllPoints()
		if Omen.Options["Skin.Title.Hide"] then
			self.BarList:Point("TOPLEFT", self.Title, "TOPLEFT")
			self.BarList:Point("TOPRIGHT", self.Title, "TOPRIGHT")
		else
			self.BarList:Point("TOPLEFT", self.Title, "BOTTOMLEFT", 0, (E.PixelMode and 1 or 3))
			self.BarList:Point("TOPRIGHT", self.Title, "BOTTOMRIGHT", 0, (E.PixelMode and 1 or 3))
		end
		if Omen.Options["Skin.Modules.Hide"] then
			self.BarList:Point("BOTTOMRIGHT", self.ModuleList, "BOTTOMRIGHT")
		else
			self.BarList:Point("BOTTOMLEFT", self.ModuleList, "TOPLEFT", 0, -(E.PixelMode and 1 or 3))
			self.BarList:Point("BOTTOMRIGHT", self.ModuleList, "TOPRIGHT", 0, -(E.PixelMode and 1 or 3))
		end

		if self.activeModule then
			self.activeModule:UpdateLayout()
		end
		self:ResizeBars()
	end)

	Omen:UpdateDisplay()

	for i = 1, OmenModuleButtons:GetNumChildren() do
		local child = select(i, OmenModuleButtons:GetChildren())
		if child and child:IsObjectType("Button") then
			child:SetTemplate("Default")
			child:StyleButton(nil, true)
			child:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
			child:GetNormalTexture():SetInside()
		end
	end
end

S:AddCallbackForAddon("Omen", "Omen", LoadSkin)
