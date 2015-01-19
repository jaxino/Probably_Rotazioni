-- SPEC ID 73
ProbablyEngine.rotation.register_custom(73, "Boxo's Protection", {

--Utilities

	-- Pause Rotation
	{ "pause", "modifier.lshift" },

	-- Leap
	{ "Heroic Leap", "modifier.control", "mouseover.ground" },
	
	-- Banner
	{ "Mocking Banner", "modifier.lalt", "mouseover.ground" },

-- Survival
	-- antifear
	{ "55694", "player.state.fear" }, --Berserker Rage
	
	-- self heals
	{ "Victory Rush", "player.health <= 85" },
	{ "Impending Victory", "player.health < 70" },
	{ "Enraged Regeneration", "player.health <= 70" },
	{ "#5512", "player.health < 40" }, -- Healthstone
	
	-- effective health
	{ "Rallying Cry", "player.health < 10" },
	{ "Last Stand", "player.health < 20" },
	
	-- defensives
	{ "Shield Wall", "player.health < 30" },
	{ "Demoralizing Shout", "player.area(10).enemies >= 3" },
	{ "Vigilance", "player.health < 50" },
	
	-- active mitigation
	{"2565",{"!player.buff(132404)","player.rage >= 60","!toggle.barrier","toggle.block"}, "player" }, -- Shield Block
	{"112048",{"player.rage >= 60", "!player.buff(112048)", "toggle.barrier", "!toggle.block"},"player" }, -- Shield Barrier
	
	{"2565",{"!player.buff(132404)","player.rage >= 60","toggle.barrier","toggle.block"}, "player" },
	{"112048",{"player.spell(2565).charges = 0", "player.rage >= 60", "!player.buff(112048)", "toggle.barrier", "toggle.block"},"player" },
	
-- Interrupts
	{{
		{ "6552", {"target.interruptsAt(20)", "target.range < 8"}, "target" }, -- Pumml
		{ "5246", {"target.interruptsAt(60)", "target.range < 8"}, "target" }, -- Intimidating Shout
		{ "114028", {"target.interruptsAt(80)", "target.range <= 20"}, "target" }, -- Mass Spell Reflection
	},"modifier.interrupts"},

-- Ranged
	{ "Heroic Throw", "target.range >= 10" },

-- Cooldowns
{{
	{ "Bloodbath" },
	{ "Avatar" },
	{ "Recklessness" },
	{ "20572" }, -- Bloodfury
},  { "toggle.cooldowns", "target.range <= 8" } },

-- Auto Target
    { "/cleartarget", (function() return UnitIsFriend("player","target") end) },
    { "/TargetNearestEnemy", "!target.exists", "toggle.autotarget"},
    { "/TargetNearestEnemy", { "target.exists", "target.dead", "toggle.autotarget" } },
	
-- Threat Control w/ Toggle
    { "Taunt", "toggle.tc", "target.threat < 100" },
  	{ "Taunt", "toggle.tc", "mouseover.threat < 100", "mouseover" },

-- Smart AoE
{{
	{ "Shockwave" },
	{ "Dragon Roar" },
	{ "Thunder Clap", "!target.debuff(Deep Wounds)" },
	{ "Bladestorm" },
},  { "player.area(10).enemies >= 3", "toggle.smartae"}},

-- Single target
{{
	{ "Heroic Strike", "player.buff(122510).count = 6"},
	{ "Execute", "player.buff(Sudden Death)" },
	{ "Execute", "player.rage > 80" },
	{ "Shield Slam" },
	{ "Revenge" },
	{ "Storm Bolt" },
	{ "Devastate" },
	{ "Heroic Strike", "player.rage > 90" },
}, "target.range <= 8" },
	
}, {
  ---------------
  -- OOC Begin --
  ---------------

	{ "Heroic Leap", "modifier.control", "mouseover.ground"},
	{"6673",{"!player.buffs.attackpower", "toggle.buffs"}, nil}, -- Battle Shout
	{"469",{"!player.buff(6673)","player.buffs.attackpower","!player.buffs.stamina", "toggle.buffs"}, nil}, -- Commanding Shout
	
  -------------
  -- OOC End --
  -------------
},
 function ()
	ProbablyEngine.toggle.create('smartae', 'Interface\\Icons\\ability_warrior_cleave', 'AoE', 'Auto on/off \nBladestorm, DragonRoar, ThunderClap, Shockwave')
	ProbablyEngine.toggle.create('block', 'Interface\\Icons\\ability_defend', 'Shield Block', 'Auto on/off')
	ProbablyEngine.toggle.create('barrier', 'Interface\\Icons\\inv_shield_07', 'Shield Barrier', 'Auto on/off')
	ProbablyEngine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automaticaly target the nearest enemy when target dies or does not exist.')
	ProbablyEngine.toggle.create('tc', 'Interface\\Icons\\ability_warlock_eradication', 'Threat Control', 'Autotaunt')
	ProbablyEngine.toggle.create('buffs', 'Interface\\Icons\\ability_warrior_battleshout', 'Shout', 'Autobuff Shouts')
  end)