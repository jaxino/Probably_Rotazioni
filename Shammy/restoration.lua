ProbablyEngine.library.register('coreHealing', {
  needsHealing = function(percent, count)
    return ProbablyEngine.raid.needsHealing(tonumber(percent)) >= count
  end,
})



-- ProbablyEngine Rotation Packager
-- Created on Oct 21st 2014 1:22 am
ProbablyEngine.rotation.register_custom(264, "Restozor", {
  --------------------
  -- Start Rotation --
  --------------------
  -- 165344 Ascendance Restoration	
  -- 114052	Ascendance Buff
  -- 98008 	Spirit Link Totem
  -- 108280 Healing Tide Totem
  -- 5394	Healing Stream Totem
  -- 79206	Spiritwalker's Grace
  -- 16188	Ancestral Swiftness
  -- 73685	Unleash Life
  -- 77130	Purify Spirit
  -- 57994	Wind Shear
  -- 53390	Tidal Waves 
  -- 61295	Riptide
  -- 1064	Chain Heal
  -- 77472	Healing Wave
  -- 8004	Healing Surge
  -- 73920	Healing Rain
  -- 974	Earth Shield
  -- 52127	Water Shield
  -- 2645	Ghost Wolf
  -- 2008	Ancestral Spirit
  -- 8177	Grounding Totem
  -- 33697	Blood Fury
  -- 370	Purge
  
  ----------------
  -- Ghost Wolf --
  ----------------
  {{
  {"2645",{"player.movingfor >= 2","!player.buff(79206)"} }, 
  {"/cancelaura Ghost Wolf",{"!player.moving","player.buff(2645"}},
  },"toggle.wolf"},
  {"pause", "player.buff(2645)" },
  
  
  -- MOUSEOVER  
  { "77130", { "modifier.lshift", "mouseover.exists", "mouseover.alive", "mouseover.friend", "mouseover.range < 40" }, "mouseover" }, -- Purify Spirit
  { "73920", { "modifier.lcontrol", "!player.buff(114052)"}, "mouseover.ground"}, -- 73920 Healing Rain@mouseover
  { "/focus [target=mouseover]", "modifier.lalt" }, -- Mouseover Focus
  
  -- BUFF
  { "52127",{ "!player.buff(52127)"}}, -- 52127	Water Shield
  { "974",  { "!tank.buff(974)", "tank.range < 40" }, "tank" }, -- 974	Earth Shield on Focus
  
  -- Auto Targets
  { "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
  { "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" } },

  -- INTERRUPT
  { "57994",{ "target.interruptAt(80)", "target.range <= 25", "toggle.interrupt"},"target"}, -- 57994	Wind Shear
  { "8177", { "target.interruptAt(10)", "toggle.interrupt"}}, -- 8177	Grounding Totem
  
  -- PURGE
 {"370",{"purge","toggle.purge"},"target"}, -- Purge
 {"370",{"target.dispellable(Purge)"},"target"}, -- Purge
 
  -- HEALING CDs
	{{
		{ "!16188",{ "lowest.health < 20", "lowest.range < 40" }}, -- 16188	Ancestral Swiftness
		{ "77472" ,{ "player.buff(16188)", "lowest.range < 40"},"lowest"}, -- Healing Wave + Ancestral Swiftness
		
		{ "165344",{ "@coreHealing.needsHealing(60,5)","!player.totem(108280)" }}, -- 165344	Ascendance Restoration
		
		{ "108280",{ "@coreHealing.needsHealing(50,5)","!player.buff(114052)"}}, -- 108280	Healing Tide Totem
		{ "5394",  { "lowest.health < 99", "!player.totem(108280)","!player.buff(114052)"}}, -- 5394 Healing Stream Totem
		
		{"33697"},-- 33697	Blood Fury
	},"toggle.cooldowns"},
	-- Ascendance rotation
	{{
		{ "79206", {"player.movingfor >= 1"} }, -- 79206	Spiritwalker's Grace
		{ "98008", { "player.area(10).friendly >= 5" }}, -- 98008 	Spirit Link Totem
		{ "61295", { "!player.buff(53390)"}, "lowest" }, -- 61295	Riptide & 53390 Tidal Waves Buff
		{ "8004",  { "player.buff(53390)"},"lowest" }, -- 8004	Healing Surge
	},{"lowest.range < 40", "player.buff(114052)"}}, 
	
	
	-- DPS
	{{
		{"3599","player.totem(3599).duration <= 2"}, -- Searing Totem
		{"8050",{"target.debuff(8050).duration <= 8", "target.range <= 25"},"target"}, -- Flame Shock
		{"51505",{ "!player.moving", "target.range <= 30", "target.debuff(8050)"},"target"}, -- Lava Burst
		{"117014",{"target.range <= 30", "!player.moving", "talent(6,3)"},"target"}, -- Elemental Blast
		{"8056",{"target.debuff(8050).duration >= 8", "target.range <= 25"},"target"}, -- Frost Shock
		{"421",{"target.area(10).enemies > 3","target.range < 30"},"target"}, -- Chain Lightning
		{"403",{"target.range <= 30", "!player.moving"},"target"}, -- Lightning Bolt
	},"toggle.dps"},
	 
	{"117014",{"target.range <= 30", "!player.moving", "talent(6,3)"},"target"}, -- Elemental Blast
  
  -- AOE HEALING
	{{
		{{ -- Party
			{ "1064",  {"@coreHealing.needsHealing(90, 3)", "!player.moving"}, "lowest" }, -- 1064 Chain Heal
			{ "73920", {"@coreHealing.needsHealing(70, 4)", "!player.moving"}, "focus.ground"}, -- 73920 Healing Rain
		},{"modifier.party","modifier.members <= 5", "player.mana > 30"}},
		
		{{ -- Raid 6-25
			{ "1064",  {"@coreHealing.needsHealing(80, 4)", "!player.moving"}, "lowest" }, -- 1064 Chain Heal
			{ "73920", {"@coreHealing.needsHealing(70, 6)", "!player.moving"}, "focus.ground"}, -- 73920 Healing Rain
		},{"modifier.raid","modifier.members >= 6","modifier.members <= 25", "player.mana > 30"}},
		
		{{ -- Raid 25+
			{ "1064",  {"@coreHealing.needsHealing(80, 6)", "!player.moving"}, "lowest" }, -- 1064 Chain Heal
			{ "73920", {"@coreHealing.needsHealing(70, 6)", "!player.moving"}, "focus.ground"}, -- 73920 Healing Rain
		},{"modifier.raid","modifier.members > 25", "player.mana > 30"}},
	},{"toggle.multitarget","!player.buff(114052)"}},
  
  -- SINGLE TARGET HEALING
{{	
	{ "61295", { "lowest.health < 99" , "!player.buff(53390)", "!player.buff(73685)" }, "lowest" }, -- 61295	Riptide - 53390 Tidal Waves Buff
	{ "61295", { "lowest.health < 99" , "!lowest.buff(61295)", "!player.buff(73685)" , "toggle.riptide" }, "lowest" },  -- 61295 Riptide
	{ "73685", { "lowest.health < 100" }, "lowest" },  -- 73685	Unleash Life
	{ "77472", { "lowest.health < 85", "player.buff(73685)" }, "lowest" }, -- 77472	Healing Wave + 73685 Unleash Life
	{ "8004",  { "lowest.health < 50", "player.buff(53390)", "!player.buff(73685)" }, "lowest" }, -- 8004	Healing Surge + 53390 Tidal Waves Buff
	{ "77472", { "lowest.health < 85", "player.buff(53390)" }, "lowest" }, -- 77472	Healing Wave + 53390 Tidal Waves Buff	
},{ "lowest.range < 40", "!player.moving"}},
  ------------------
  -- End Rotation --
  ------------------
  
  }, {

  ---------------
  -- OOC Begin --
  ---------------
  
  ----------------
  -- Ghost Wolf --
  ----------------
  {{
  {"2645",{"player.movingfor >= 3","!player.buff(79206)", "!player.buff(2645)"} }, 
  {"/cancelaura Ghost Wolf",{"!player.moving", "player.buff(2645)"} }, 
  },"toggle.wolf"},
  {"pause", "player.buff(2645)" },
  
  { "/focus [target=mouseover]", "modifier.lalt" }, -- Mouseover Focus
  { "77130", { "modifier.lshift", "mouseover.exists", "mouseover.alive", "mouseover.friend", "mouseover.range < 40" }, "mouseover" }, -- Purify Spirit
  { "52127", {"!player.buff(52127)"} }, -- 52127	Water Shield
  { "974",  { "!tank.buff(974)", "tank.range < 40" }, "tank" }, -- 974	Earth Shield on Focus
  { "61295", { "lowest.health < 90", "!lowest.buff(61295)", "lowest.range < 40" }, "lowest" },  -- 61295 Riptide

  -------------
  -- OOC End --
  -------------
  
},
function()
	ProbablyEngine.toggle.create('riptide', 'Interface\\Icons\\spell_nature_riptide', 'Riptide Spam', '')
	ProbablyEngine.toggle.create('purge', 'Interface\\Icons\\spell_nature_purge', 'ByShamanBePurged', 'TEST')
	ProbablyEngine.toggle.create('dps', 'Interface\\Icons\\spell_nature_lightning', 'DPS MODE','Toggle on for DPS')
	ProbablyEngine.toggle.create('wolf', 'Interface\\Icons\\spell_nature_spiritwolf', 'Auto Ghost Wolf','')
end

)

