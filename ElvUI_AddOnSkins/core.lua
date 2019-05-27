local E, L, V, P, G = unpack(ElvUI)
local EP = LibStub("LibElvUIPlugin-1.0", true)
local AS = E:NewModule("AddOnSkins")

local pairs, select = pairs, select
local find, format, lower, match, trim = string.find, string.format, string.lower, string.match, string.trim

local GetAddOnInfo = GetAddOnInfo
local GetNumAddOns = GetNumAddOns
local IsAddOnLoaded = IsAddOnLoaded

local addonList = {
	"AckisRecipeList",
	"ACP",
	"AdvancedTradeSkillWindow",
	"Atlas",
	"AtlasLoot",
	"Auctionator",
	"BindPad",
	"BlackList",
	"BugSack",
	"BuyEmAll",
	"CallToArms",
	"Cartographer",
	"Cartographer3",
	"Clique",
	"DBM",
	"Doom_CooldownPulse",
	"EqCompare",
	"Factionizer",
	"FishingBuddy",
	"FlightMap",
	"MoveAnything",
	"Omen",
	"Outfitter",
	"PAB",
	"PallyPower",
	"Postal",
	"QuestGuru",
	"QuestHelper",
	"Recount",
	"Skillet",
	"Spy",
	"Talented",
	"TellMeWhen",
	"TinyBook",
	"TotemTimers",
	"TrinketMenu",
	"ZOMGBuffs",
}

local function ColorizeVersion(name, version)
	return format("%s |cffff7d0a%s|r", name, version)
end
local SUPPORTED_ADDONS_STRING = ""

local SUPPORTED_ADDONS = {
	ColorizeVersion("AckisRecipeList",			"r8.9.2"),
	ColorizeVersion("AddonControlPanel",		"2.4.3"),
	ColorizeVersion("AdvancedTradeSkillWindow", "0.6.9"),
	ColorizeVersion("Atlas",					"1.12.0"),
	ColorizeVersion("AtlasLoot",				"4.06.04"),
	ColorizeVersion("Auctionator",				"1.1.1"),
	ColorizeVersion("BindPad",					"1.8.6"),
	ColorizeVersion("BlackList",				"1.2.3"),
	ColorizeVersion("BugSack",					"2.3.0.70977"),
	ColorizeVersion("BuyEmAll",					"2.8"),
	ColorizeVersion("CallToArms",				"r13"),
	ColorizeVersion("Cartographer",				"2.2"),
	ColorizeVersion("Cartographer 3.0",			"0.9.1"),
	ColorizeVersion("Clique",					"r102 & Clique Enhanced v143.1"),
	ColorizeVersion("DeadlyBossMods",			"1.25"),
	ColorizeVersion("Doom_CooldownPulse",		"1.1.3"),
	ColorizeVersion("EqCompare",				"1.4 r71243"),
	ColorizeVersion("Factionizer",				"20400.7"),
	ColorizeVersion("FishingBuddy",				"0.9.4m"),
	ColorizeVersion("FlightMap",				"2.4-1"),
	ColorizeVersion("MoveAnything",				"2.66"),
	ColorizeVersion("Omen",						"2.0.4"),
	ColorizeVersion("Outfitter",				"4.2.6"),
	ColorizeVersion("PartyAbilityBars",			"2.4.3"),
	ColorizeVersion("PallyPower",				"2.01.00"),
	ColorizeVersion("Postal",					"2.1-r82138"),
	ColorizeVersion("QuestGuru",				"0.9.3"),
	ColorizeVersion("QuestHelper",				"0.59 & 0.95-Backport"),
	ColorizeVersion("Recount",					"r924"),
	ColorizeVersion("Skillet",					"1.10 r81029.6"),
	ColorizeVersion("Spy",						"1.0-Backport"),
	ColorizeVersion("Talented",					"r291"),
	ColorizeVersion("TellMeWhen",				"1.0"),
	ColorizeVersion("TinyBook",					"1.2.0"),
	ColorizeVersion("TotemTimers",				"8.1d"),
	ColorizeVersion("TrinketMenu",				"3.71"),
	ColorizeVersion("ZOMGBuffs",				"r18"),
}
for _, supportedAddOn in pairs(SUPPORTED_ADDONS) do
	SUPPORTED_ADDONS_STRING = SUPPORTED_ADDONS_STRING.."\n"..supportedAddOn
end

AS.addOns = {}

for i = 1, GetNumAddOns() do
	local name, _, _, enabled = GetAddOnInfo(i)
	AS.addOns[lower(name)] = enabled ~= nil
end

function AS:CheckAddOn(addon)
	return self.addOns[lower(addon)] or false
end

function AS:IsAddonExist(addon)
	return self.addOns[lower(addon)] ~= nil
end

function AS:RegisterAddonOption(AddonName, options)
	if select(6, GetAddOnInfo(AddonName)) == "MISSING" then return end

	options.args.skins.args.addOns.args[AddonName] = {
		type = "toggle",
		name = AddonName,
		desc = L["TOGGLESKIN_DESC"],
		hidden = function() return not self:CheckAddOn(AddonName) end
	}
end

local function ColorizeSettingName(settingName)
	return format("|cff1784d1%s|r", settingName)
end

local positionValues = {
	TOPLEFT = "TOPLEFT",
	LEFT = "LEFT",
	BOTTOMLEFT = "BOTTOMLEFT",
	RIGHT = "RIGHT",
	TOPRIGHT = "TOPRIGHT",
	BOTTOMRIGHT = "BOTTOMRIGHT",
	CENTER = "CENTER",
	TOP = "TOP",
	BOTTOM = "BOTTOM"
}

local function getOptions()
	if not E.Options.args.elvuiPlugins then
		E.Options.args.elvuiPlugins = {
			order = 50,
			type = "group",
			name = "|cff00b30bE|r|cffC4C4C4lvUI_|r|cff00b30bP|r|cffC4C4C4lugins|r",
			args = {
				header = {
					order = 0,
					type = "header",
					name = "|cff00b30bE|r|cffC4C4C4lvUI_|r|cff00b30bP|r|cffC4C4C4lugins|r"
				},
				addOnSkinsShortcut = {
					type = "execute",
					name = ColorizeSettingName(L["AddOn Skins"]),
					func = function()
						if IsAddOnLoaded("ElvUI_Config") then
							local ACD = LibStub("AceConfigDialog-3.0-ElvUI")
							ACD:SelectGroup("ElvUI", "elvuiPlugins", "addOnSkins", "addOns")
						end
					end
				}
			}
		}
	elseif not E.Options.args.elvuiPlugins.args.addOnSkinsShortcut then
		E.Options.args.elvuiPlugins.args.addOnSkinsShortcut = {
			type = "execute",
			name = ColorizeSettingName(L["AddOn Skins"]),
			func = function()
				if IsAddOnLoaded("ElvUI_Config") then
					local ACD = LibStub("AceConfigDialog-3.0-ElvUI")
					ACD:SelectGroup("ElvUI", "elvuiPlugins", "addOnSkins", "addOns")
				end
			end
		}
	end

	local options = {
		type = "group",
		name = ColorizeSettingName(L["AddOn Skins"]),
		childGroups = "tab",
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["AddOn Skins"]
			},
			skins = {
				order = 2,
				type = "group",
				name = L["Skins"],
				childGroups = "tab",
				args = {
					header = {
						order = 1,
						type = "header",
						name = L["Skins"]
					},
					addOns = {
						order = 1,
						type = "group",
						name = L["AddOn Skins"],
						get = function(info) return E.private.addOnSkins[info[#info]] end,
						set = function(info, value) E.private.addOnSkins[info[#info]] = value E:StaticPopup_Show("PRIVATE_RL") end,
						args = {
							header = {
								order = 1,
								type = "header",
								name = L["AddOn Skins"]
							}
						}
					},
					blizzard = {
						order = 2,
						type = "group",
						name = L["Blizzard Skins"],
						get = function(info) return E.private.addOnSkins[info[#info]] end,
						set = function(info, value) E.private.addOnSkins[info[#info]] = value E:StaticPopup_Show("PRIVATE_RL") end,
						args = {
							header = {
								order = 1,
								type = "header",
								name = L["Blizzard Skins"]
							},
							Blizzard_WorldStateFrame = {
								type = "toggle",
								name = L["WorldState Frame"],
								desc = L["TOGGLESKIN_DESC"]
							}
						}
					}
				}
			},
			misc = {
				order = 3,
				type = "group",
				name = L["Misc Options"],
				childGroups = "tab",
				args = {
					header = {
						order = 1,
						type = "header",
						name = L["Misc Options"],
					},
					dbmGroup = {
						order = 2,
						type = "group",
						name = "DBM",
						get = function(info) return E.db.addOnSkins[info[#info]] end,
						set = function(info, value) E.db.addOnSkins[info[#info]] = value DBM.Bars:ApplyStyle() DBM.BossHealth:UpdateSettings() end,
						disabled = function() return not AS:CheckAddOn("DBM_API") end,
						args = {
							dbmBarHeight = {
								order = 1,
								type = "range",
								name = L["Bar Height"],
								min = 6, max = 60, step = 1
							},
							spacer = {
								order = 2,
								type = "description",
								name = ""
							},
							dbmFont = {
								order = 3,
								type = "select",
								dialogControl = "LSM30_Font",
								name = L["Font"],
								values = AceGUIWidgetLSMlists.font
							},
							dbmFontSize = {
								order = 4,
								type = "range",
								name = L["Font Size"],
								min = 6, max = 22, step = 1
							},
							dbmFontOutline = {
								order = 5,
								type = "select",
								name = L["Font Outline"],
								values = {
									["NONE"] = L["None"],
									["OUTLINE"] = "OUTLINE",
									["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE",
									["THICKOUTLINE"] = "THICKOUTLINE"
								}
							}
						}
					}
				}
			},
			embed = {
				order = 4,
				type = "group",
				name = L["Embed Settings"],
				get = function(info) return E.db.addOnSkins.embed[info[#info]] end,
				set = function(info, value) E.db.addOnSkins.embed[info[#info]] = value E:GetModule("EmbedSystem"):EmbedUpdate() end,
				args = {
					header = {
						order = 1,
						type = "header",
						name = L["Embed Settings"]
					},
					desc = {
						order = 2,
						type = "description",
						name = "Settings to control Embedded AddOns: Available Embeds: Recount | Omen"
					},
					embedType = {
						order = 3,
						type = "select",
						name = L["Embed Type"],
						values = {
							["DISABLE"] = L["Disable"],
							["SINGLE"] = L["Single"],
							["DOUBLE"] = L["Double"]
						}
					},
					leftWindow = {
						order = 4,
						type = "select",
						name = L["Left Panel"],
						values = {
							["Recount"] = "Recount",
							["Omen"] = "Omen"
						},
						disabled = function() return E.db.addOnSkins.embed.embedType == "DISABLE" end
					},
					rightWindow = {
						order = 5,
						type = "select",
						name = L["Right Panel"],
						values = {
							["Recount"] = "Recount",
							["Omen"] = "Omen"
						},
						disabled = function() return E.db.addOnSkins.embed.embedType ~= "DOUBLE" end
					},
					leftWindowWidth = {
						order = 6,
						type = "range",
						name = L["Left Window Width"],
						min = 100, max = 300, step = 1
					},
					hideChat = {
						order = 7,
						type = "select",
						name = L["Hide Chat Frame"],
						values = E:GetModule("EmbedSystem"):GetChatWindowInfo(),
						disabled = function() return E.db.addOnSkins.embed.embedType == "DISABLE" end
					},
					rightChatPanel = {
						order = 8,
						type = "toggle",
						name = L["Embed into Right Chat Panel"]
					},
					belowTopTab = {
						order = 9,
						type = "toggle",
						name = L["Embed Below Top Tab"]
					}
				}
			},
			supportedAddOns = {
				order = 7,
				type = "group",
				name = L["Supported AddOns"],
				args = {
					header = {
						order = 1,
						type = "header",
						name = L["Supported AddOns"]
					},
					text = {
						order = 2,
						type = "description",
						name = SUPPORTED_ADDONS_STRING
					}
				}
			}
		}
	}

	for _, addonName in pairs(addonList) do
		AS:RegisterAddonOption(addonName, options)
	end

	E.Options.args.elvuiPlugins.args.addOnSkins = options
end

function AS:Initialize()
	EP:RegisterPlugin("ElvUI_AddOnSkins", getOptions)

	if E.db.addOnSkins.embed.left then
		E.db.addOnSkins.embed.leftWindow = E.db.addOnSkins.embed.left
		E.db.addOnSkins.embed.left = nil
	end
	if E.db.addOnSkins.embed.right then
		E.db.addOnSkins.embed.rightWindow = E.db.addOnSkins.embed.right
		E.db.addOnSkins.embed.right = nil
	end
	if E.db.addOnSkins.embed.leftWidth then
		E.db.addOnSkins.embed.leftWindowWidth = E.db.addOnSkins.embed.leftWidth
		E.db.addOnSkins.embed.leftWidth = nil
	end
	if type(E.db.addOnSkins.embed.rightChat) == "boolean" then
		E.db.addOnSkins.embed.rightChatPanel = E.db.addOnSkins.embed.rightChat
		E.db.addOnSkins.embed.rightChat = nil
	end
	if type(E.db.addOnSkins.embed.belowTop) == "boolean" then
		E.db.addOnSkins.embed.belowTopTab = E.db.addOnSkins.embed.belowTop
		E.db.addOnSkins.embed.belowTop = nil
	end
	E.db.addOnSkins.embed.isShow = nil
end

local function InitializeCallback()
	AS:Initialize()
end

E:RegisterModule(AS:GetName(), InitializeCallback)