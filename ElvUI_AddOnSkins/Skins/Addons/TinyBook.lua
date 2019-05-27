local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")
local AS = E:GetModule("AddOnSkins")

local _G = _G
local select, unpack = select, unpack

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc

-- TinyBook v1.2.0 (by VideoPlayerCode)
-- Website: https://github.com/VideoPlayerCode/TinyBook
--
-- ElvUI Skin By: VideoPlayerCode
--
-- Important:
-- All design decisions (button styles, spacing, etc) are based on the built-in "ElvUI/modules/skins/blizzard/spellbook.lua"
-- skin for the default Blizzard spellbook, so that the transition back/forth between the spellbook types looks seamless.

local function SkinButton(button, isMainButton)
	if button.isSkinned then return end

	local name = button:GetName()
	local iconTexture = _G[name.."IconTexture"]
	local highlight = _G[name.."Highlight"]
	local cooldown = _G[name.."Cooldown"]

	-- Remove all textures except the "iconTexture", to avoid clearing the current spell icon.
	local iconTexturePath = iconTexture and iconTexture:GetTexture()
	button:StripTextures()
	if iconTexturePath then
		iconTexture:SetTexture(iconTexturePath)
	end

	-- Make the icon borderless.
	if iconTexture then
		iconTexture:SetTexCoord(unpack(E.TexCoords))

		if not button.backdrop then
			button:CreateBackdrop("Default", true)
		end
	end

	-- Since we've cleared all textures, there's no "highlight". Set that texture to a transparent white color.
	-- NOTE: This would need re-applying after every "TSB_SpellButton_UpdateButton", but we disable SetTexture to keep our highlight style forever.
	-- NOTE: Forcing a highlight style this way gets rid of TinyBook's intelligent highlighting, which normally refuses to highlight when you hover
	-- over "uncastable" (passive) spells, to indicate the fact that they cannot be cast. But after enforcing a style here, ALL spells will ALWAYS highlight.
	-- However, this change matches the behavior of ElvUI's Blizzard spellbook skin, which likewise breaks the "passive" style, so we do it for consistency!
	if highlight then
		highlight:SetTexture(1, 1, 1, 0.3)
		highlight.SetTexture = E.noop
	end

	if isMainButton then -- Main spellbook buttons.
		-- Colorize the spell name and rank/passive substring, and disable color changes (to avoid "TSB_SpellButton_UpdateButton" changing it again).
		local spellName = _G[name.."SpellName"]
		local subSpellName = _G[name.."SubSpellName"]
		spellName:SetTextColor(1, 0.80, 0.10)
		subSpellName:SetTextColor(1, 1, 1)
		spellName.SetTextColor = E.noop
		subSpellName.SetTextColor = E.noop

		-- Add a large, rectangular, darkened background behind the button and its spell name/rank text.
		button.bg = CreateFrame("Frame", nil, button)
		button.bg:SetTemplate("Transparent")
		button.bg:Point("TOPLEFT", -6, 6)
		button.bg:Point("BOTTOMRIGHT", 115, -6)
		button.bg:SetFrameLevel(button.bg:GetFrameLevel() - 2)

		-- Register a nice "ElvUI" cooldown for the button, so that the player sees countdown text on top of the icon.
		-- NOTE: We do NOT register these for the "rank flyout" buttons, since timer-text on EVERY rank-button would be extremely messy and cluttered!
		-- NOTE: There's a known "flickering" issue if you hover over a spell that's currently on-cooldown and has ranks. In that case, the rank buttons
		-- sometimes flicker. It has nothing to do with this skin, and exists in plain TinyBook too. It's caused by Blizzard's "button.UpdateTooltip" handling,
		-- which redraws the tooltip repeatedly to display the constantly shrinking cooldown. That clashes with Blizzard's "cooldown overlay" rendering,
		-- and **SOMETIMES** causes flickering. It isn't fixable by TinyBook or ElvUI, and it's a rare and small issue, so there's nothing to do about it...
		-- Running "/run GetMouseFocus().UpdateTooltip = nil" while hovering the main button will stop the flickering, which confirms it's Blizzard's fault.
		if cooldown then
			E:RegisterCooldown(cooldown)
		end
	else -- Rank flyout buttons.
		-- Colorize the rank number, and disable color changes (to avoid anything ever changing it again).
		local rankName = _G[name.."RankName"]
		rankName:SetTextColor(1, 1, 1)
		rankName.SetTextColor = E.noop
	end

	button.isSkinned = true
end

local function LoadSkin()
	if not E.private.addOnSkins.TinyBook then return end

	-- Main frame.
	local TSB_SpellBookFrame = _G["TSB_SpellBookFrame"]
	TSB_SpellBookFrame:StripTextures(true)
	TSB_SpellBookFrame:CreateBackdrop("Transparent")
	TSB_SpellBookFrame.backdrop:Point("TOPLEFT", 10, -12)
	TSB_SpellBookFrame.backdrop:Point("BOTTOMRIGHT", -31, 75)

	-- Bottom tabs.
	local tabs = {
		"TSB_SpellBookFrameTabButton1",
		"TSB_SpellBookFrameTabButton2",
		"TSB_SpellBookFrameTabButton3",
		"TSB_SpellBookFrameTabButton4", -- Switch to "Regular Book".
		"SpellBookFrameTabButton4", -- Switch to "TinyBook".
	}
	for i,tabName in ipairs(tabs) do
		local tab = _G[tabName]

		tab:GetNormalTexture():SetTexture(nil)
		tab:GetDisabledTexture():SetTexture(nil)

		S:HandleTab(tab)

		tab.backdrop:Point("TOPLEFT", 14, E.PixelMode and -17 or -19)
		tab.backdrop:Point("BOTTOMRIGHT", -14, 19)
	end

	-- Next and previous page navigation.
	S:HandleNextPrevButton(TSB_SpellBookPrevPageButton)
	S:HandleNextPrevButton(TSB_SpellBookNextPageButton)

	-- Main frame's close button.
	S:HandleCloseButton(TSB_SpellBookCloseButton)

	-- Skin the main spell buttons.
	for i = 1, TSB_SPELLS_PER_PAGE do
		local button = _G["TSB_SpellButton"..i]
		SkinButton(button, true)
	end

	-- Side tabs (spell school selection).
	for i = 1, TSB_MAX_SKILLLINE_TABS do
		local tab = _G["TSB_SpellBookSkillLineTab"..i]

		tab:StripTextures()
		tab:StyleButton(nil, true)
		tab:SetTemplate("Default", true)

		tab:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
		tab:GetNormalTexture():SetInside()
	end

	-- Move the spell buttons into nicer, more spaced-out and airy locations.
	TSB_SpellButton1:Point("TOPLEFT", TSB_SpellBookFrame, "TOPLEFT", 25, -75)
	TSB_SpellButton2:Point("TOPLEFT", TSB_SpellButton1, "TOPLEFT", 167, 0)
	TSB_SpellButton3:Point("TOPLEFT", TSB_SpellButton1, "BOTTOMLEFT", 0, -17)
	TSB_SpellButton4:Point("TOPLEFT", TSB_SpellButton3, "TOPLEFT", 167, 0)
	TSB_SpellButton5:Point("TOPLEFT", TSB_SpellButton3, "BOTTOMLEFT", 0, -17)
	TSB_SpellButton6:Point("TOPLEFT", TSB_SpellButton5, "TOPLEFT", 167, 0)
	TSB_SpellButton7:Point("TOPLEFT", TSB_SpellButton5, "BOTTOMLEFT", 0, -17)
	TSB_SpellButton8:Point("TOPLEFT", TSB_SpellButton7, "TOPLEFT", 167, 0)
	TSB_SpellButton9:Point("TOPLEFT", TSB_SpellButton7, "BOTTOMLEFT", 0, -17)
	TSB_SpellButton10:Point("TOPLEFT", TSB_SpellButton9, "TOPLEFT", 167, 0)
	TSB_SpellButton11:Point("TOPLEFT", TSB_SpellButton9, "BOTTOMLEFT", 0, -17)
	TSB_SpellButton12:Point("TOPLEFT", TSB_SpellButton11, "TOPLEFT", 167, 0)

	-- Move the next and previous buttons into nicer locations.
	TSB_SpellBookPrevPageButton:Point("CENTER", TSB_SpellBookFrame, "BOTTOMLEFT", 30, 100)
	TSB_SpellBookNextPageButton:Point("CENTER", TSB_SpellBookFrame, "BOTTOMLEFT", 330, 100)

	-- Give the "page number" text a white color and move it into a nicer location.
	TSB_SpellBookPageText:SetTextColor(1, 1, 1)
	TSB_SpellBookPageText:Point("CENTER", TSB_SpellBookFrame, "BOTTOMLEFT", 185, 0)

	-- Skin and reposition the "Macros" and "Clique" (if enabled) buttons.
	S:HandleButton(TSB_SpellBookMacrosButton)
	S:HandleButton(TSB_SpellBookCliqueButton)
	TSB_SpellBookMacrosButton:Point("BOTTOMLEFT", TSB_SpellButton1.bg, "TOPLEFT", 0, 7) -- Moves ALL buttons, since they're relative.

	-- Install a post-hook which runs *after* each "rank flyout" button is dynamically created, and skins them...
	S:SecureHook("TSB_SpellRankButton_OnLoad", function(button)
		SkinButton(button, false)
	end)
end

S:AddCallbackForAddon("TinyBook", "TinyBook", LoadSkin)
