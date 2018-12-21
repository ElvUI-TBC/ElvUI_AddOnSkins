local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

-- TellMeWhen 1.0

local _G = _G
local select, unpack = select, unpack

local hooksecurefunc = hooksecurefunc

local function LoadSkin()
	if not E.private.addOnSkins.TellMeWhen then return end

	TELLMEWHEN_ICONSPACING = E.Border

	local function GroupUpdate(groupID)
		local groupName = "TellMeWhen_Group"..groupID
		local rows = TellMeWhen_Settings["Groups"][groupID]["Rows"]
		local columns = TellMeWhen_Settings["Groups"][groupID]["Columns"]

		for row = 1, rows do
			for column = 1, columns do
				local iconID = (row - 1) * columns + column
				local iconName = groupName.."_Icon"..iconID
				local icon = _G[iconName]

				if icon and not icon.isSkinned then
					icon:SetTemplate("Default")
					icon:StyleButton()

					select(1, icon:GetRegions()):SetTexture("")

					_G[iconName.."Texture"]:SetTexCoord(unpack(E.TexCoords))
					_G[iconName.."Texture"]:SetInside()

					_G[iconName.."Highlight"]:SetTexture(1, 1, 1, 0.3)
					_G[iconName.."Highlight"]:SetInside()

					_G[iconName.."Count"]:FontTemplate()

					icon.isSkinned = true
				end
			end
		end
	end
	hooksecurefunc("TellMeWhen_Group_Update", GroupUpdate)

	for i = 1, 4 do
		local enableButton = _G["InterfaceOptionsTellMeWhenPanelGroup"..i.."EnableButton"]
		local combatButton = _G["InterfaceOptionsTellMeWhenPanelGroup"..i.."OnlyInCombatButton"]
		local columnsLeftButton = _G["InterfaceOptionsTellMeWhenPanelGroup"..i.."ColumnsWidgetLeftButton"]
		local columnsRightButton = _G["InterfaceOptionsTellMeWhenPanelGroup"..i.."ColumnsWidgetRightButton"]
		local rowsLeftButton = _G["InterfaceOptionsTellMeWhenPanelGroup"..i.."RowsWidgetLeftButton"]
		local rowsRightButton = _G["InterfaceOptionsTellMeWhenPanelGroup"..i.."RowsWidgetRightButton"]

		S:HandleCheckBox(enableButton)
		S:HandleCheckBox(combatButton)

		S:HandleNextPrevButton(columnsLeftButton)
		S:HandleNextPrevButton(columnsRightButton)
		S:HandleNextPrevButton(rowsLeftButton)
		S:HandleNextPrevButton(rowsRightButton)
	end

	S:HandleButton(InterfaceOptionsTellMeWhenPanelLockUnlockButton)
end

S:AddCallbackForAddon("TellMeWhen", "TellMeWhen", LoadSkin)