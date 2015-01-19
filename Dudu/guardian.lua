-- SPEC ID 104 DRUID GUARDIAN
ProbablyEngine.rotation.register_custom(104, "Duduguardian",{

	--	1126 GOTW
	--	33917 Mangle
	-- 	80313 Pulverize
	--	33745 Lacerate
	--	77758 Thrash
	--	6807 Maul
	--	135286 Tooth and Claw
	--	22842 Frenzied Regeneraion
	--	62606 Savage Defence
	--	132402 Savage Defence Buff
	--	145162 Dream of Cenarius
	--	5185 Healing Touch
	--	108238 Renewal
	--	61336 Survival Instinct
	--	22812 Barkskin
	--	102355 Faery Swarm
	--	770 Faery Fire
	--	99 Incapacitating Roar
	--	106839 Skull Bash
	--	6795 Growl
	--  5487 Bear Form
	--	50334 Berserk
	
	---------------
	-- IN COMBAT --
	---------------
	
	--Stance
	{ "5487",{"player.form != 1"},"player"}, -- Bear Form
	
	-- Survival
	{{
		{ "22812",{"player.health < 85"},"player"}, -- Barkskin
		{ "108238", {"player.health < 20"},"player"}, -- Renewal
		{ "61336", {"player.health < 30","!player.buff(61336)"},"player"}, -- Survival Instinct
	},"toggle.cooldowns"},
	
	-- Active Mitigation
	{ "5185",{"player.health < 90", "player.buff(145162)"},"player"}, -- Healing Touch + Dream of Cenarius
	
	{"62606",{"!player.buff(132402)","player.rage >= 60","!toggle.regeneration","toggle.savagedefence"}, "player" }, -- Savage Defence
	{"22842",{"player.rage >= 60", "player.health < 80", "toggle.regeneration", "!toggle.savagedefence"},"player" }, -- Frenzied Regeneraion
	
	{"62606",{"!player.buff(132402)","player.rage >= 60","toggle.regeneration","toggle.savagedefence"}, "player" }, -- Savage Defence
	{"22842",{"player.spell(62606).charges = 0", "player.rage >= 60", "player.health < 80", "toggle.regeneration", "toggle.savagedefence"},"player" }, -- Frenzied Regeneraion
	
	-- Auto Target
    { "/cleartarget", (function() return UnitIsFriend("player","target") end) },
    { "/TargetNearestEnemy", "!target.exists", "toggle.autotarget"},
    { "/TargetNearestEnemy", { "target.exists", "target.dead", "toggle.autotarget" } },
	
	-- Threat Control w/ Toggle
    {{
		{ "6795", "target.threat < 100" }, -- Growl
		--{ "6795", "mouseover.threat < 100", "mouseover" }, -- Growl Mouseover
	},"toggle.tc"},
	
	-- Interrupts
	{{
		{ "102355",{"target.interruptsAt(50)","target.range < 35"},"target"}, -- Faery Swarm
		{ "99",{"target.interruptsAt(60)","target.range < 10"},"target"}, -- Incapacitating Roar
		{ "106839",{"target.interruptsAt(30)", "target.range < 13"},"target"}
	},"modifier.interrupts"},
	
	-- Ranged
	{ "770",{"target.range > 10"},"target"},
	
	-- AOE <- it have priority over smart AOE
	{{
		{ "33917",{"player.buff(50334)"},"target"}, -- Mangle
		{ "77758",{"!target.debuff(77758)"},"target"}, -- Thrash
		{ "33745",{"!target.debuff(33745).count = 3"},"target"}, -- Lacerate 3x
		{ "80313",{"target.debuff(33745).count = 3"},"target" }, -- Pulverize
		{ "33917" }, -- Mangle
		{ "6807",{"player.buff(135286)","player.health > 80"},"target"}, -- Maul
		{ "6807",{"player.rage >= 80","player.health > 80"},"target"}, -- Maul
		--{ "6807",{"player.health > 80"},"target"}, -- Maul
	}, "modifier.multitarget"},
	
	-- Smart AOE
	{{
		{ "33917",{"player.buff(50334)"},"target"}, -- Mangle
		{ "77758",{"!target.debuff(77758)"},"target"}, -- Thrash
		{ "33745",{"!target.debuff(33745).count = 3"},"target"}, -- Lacerate 3x
		{ "80313",{"target.debuff(33745).count = 3"},"target" }, -- Pulverize
		{ "33917" }, -- Mangle
		{ "6807",{"player.buff(135286)","player.health > 80"},"target"}, -- Maul
		{ "6807",{"player.rage >= 80","player.health > 80"},"target"}, -- Maul
		--{ "6807",{"player.health > 80"},"target"}, -- Maul
	},{ "player.area(8).enemies >= 3", "toggle.smartae"}},
	
	-- Single Target
	{{
		{ "33917",{"player.buff(50334)"},"target"}, -- Mangle
		{ "77758",{"!target.debuff(77758)"},"target"}, -- Thrash
		{ "33917" }, -- Mangle
		{ "33745",{"!target.debuff(33745).count = 3"},"target"}, -- Lacerate 3x
		{ "80313",{"target.debuff(33745).count = 3"},"target" }, -- Pulverize
		{ "6807",{"player.buff(135286)","player.health > 70"},"target"}, -- Maul
		{ "6807",{"player.rage >= 80","player.health > 70"},"target"}, -- Maul
		--{ "6807",{"player.health > 80"},"target"}, -- Maul
	},"target.range <= 8"},
	
	
	
	},{
	
	-------------------
	-- OUT OF COMBAT --
	-------------------
	
	{{
		{"1126", {"!player.buffs.stats"}, nil}, -- GOTW
		{"1126", {"!player.buffs.versatility"}, nil}, -- GOTW
	},"toggle.buffs"},
	
	},
	function() -- If you add extra toggles
	ProbablyEngine.toggle.create('smartae', 'Interface\\Icons\\spell_druid_thrash', 'AOE', 'Auto on/off')
	ProbablyEngine.toggle.create('tc', 'Interface\\Icons\\ability_physical_taunt', 'Threat Control', 'Autotaunt')
	ProbablyEngine.toggle.create('savagedefence', 'Interface\\Icons\\ability_racial_cannibalize', 'Savage Defence', 'Auto on/off')
	ProbablyEngine.toggle.create('regeneration', 'Interface\\Icons\\ability_bullrush', 'Frenzied Regeneraion', 'Auto on/off')
	ProbablyEngine.toggle.create('buffs', 'Interface\\Icons\\spell_nature_regeneration', 'Buff', 'Auto on/off')
	end
)