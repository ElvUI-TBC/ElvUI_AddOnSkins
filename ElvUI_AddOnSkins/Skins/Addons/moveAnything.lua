local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G
local unpack = unpack

local function LoadSkin()
	if not E.private.addOnSkins.MoveAnything then return end

	local SPACING = 1 + (E.Spacing*2)

	for i = 1, 20 do
		_G["MoveAnything"..i.."Backdrop"]:SetTemplate("Transparent", nil, nil, true)
		_G["MoveAnything"..i]:HookScript2("OnShow", function()
			_G[this:GetName()..i.."Backdrop"]:SetBackdropBorderColor(unpack(E["media"].rgbvaluecolor))
		end)
		_G["MoveAnything"..i]:SetScript("OnEnter", function()
			_G[this:GetName()..i.."BackdropMovingFrameName"]:SetTextColor(1, 1, 1)
		end)
		_G["MoveAnything"..i]:SetScript("OnLeave", function()
			_G[this:GetName()..i.."BackdropMovingFrameName"]:SetTextColor(unpack(E["media"].rgbvaluecolor))
		end)
	end

	MAOptions:StripTextures()
	MAOptions:SetTemplate("Transparent")
	MAOptions:Size(420, 500 + (16*SPACING))

	S:HandleCheckBox(MAOptionsCharacterSpecific)

	S:HandleButton(MAOptionsResetAll)
	S:HandleButton(MAOptionsClose)

	for i = 1, 10 do
		_G["MAMove"..i.."Backdrop"]:SetTemplate("Default")
		S:HandleCheckBox(_G["MAMove"..i.."Move"])
		S:HandleCheckBox(_G["MAMove"..i.."Hide"])
		S:HandleButton(_G["MAMove"..i.."Reset"])

		if i ~= 1 then
			_G["MAMove"..i]:Point("TOPLEFT", "MAMove"..(i - 1), "BOTTOMLEFT", 0, -SPACING)
		end
	end

	MAScrollFrame:Size(380, 232 + (16 * SPACING))

	S:HandleScrollBar(MAScrollFrameScrollBar)

	MAScrollBorder:StripTextures()

	ResizingNudger:SetTemplate("Transparent")

	S:HandleButton(ResizingNudger_NudgeUp)
	ResizingNudger_NudgeUp:Point("CENTER", 0, 24 + SPACING)

	S:HandleButton(ResizingNudger_CenterMe)
	ResizingNudger_CenterMe:Point("TOP", ResizingNudger_NudgeUp, "BOTTOM", 0, -SPACING)

	S:HandleButton(ResizingNudger_NudgeDown)
	ResizingNudger_NudgeDown:Point("TOP", ResizingNudger_CenterMe, "BOTTOM", 0, -SPACING)

	S:HandleButton(ResizingNudger_NudgeLeft)
	ResizingNudger_NudgeLeft:Point("RIGHT", ResizingNudger_CenterMe, "LEFT", -SPACING, 0)

	S:HandleButton(ResizingNudger_NudgeRight)
	ResizingNudger_NudgeRight:Point("LEFT", ResizingNudger_CenterMe, "RIGHT", SPACING, 0)

	S:HandleButton(ResizingNudger_CenterH)
	S:HandleButton(ResizingNudger_CenterV)
	S:HandleButton(ResizingNudger_MoverPlus)
	S:HandleButton(ResizingNudger_MoverMinus)

	S:HandleButton(GameMenuButtonMoveAnything)
end

S:AddCallbackForAddon("MoveAnything", "MoveAnything", LoadSkin)