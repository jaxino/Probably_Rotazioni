-- ProbablyEngine Rotation Packager
-- Created on Oct 20th 2014 1:10 pm
ProbablyEngine.rotation.register_custom(71, "Boxo's Arms", {

-- Pause Rotation
	{ "pause", "modifier.lshift" },

	--Heroic Leap time!
	--Leap to your mouseover with Control!
	{ "Heroic Leap", "modifier.control", "mouseover.ground"},
	--Leap to your target with Alt!
	{ "Heroic Leap", "modifier.alt", "ground"},
  
	--Interrupts
	{ "Pummel", "target.interruptAt(30)" },
	{ "Pummel", { "target.interruptAt(30)", "mouseover.enemy" }, "mouseover" },
	{ "Pummel", { "target.interruptAt(30)", "focus.enemy" }, "focus" },
--	{ "Spell Reflect", "target.interruptAt(30)" }, -- work on for use
	
	-- defensives
	{ "Die by the Sword", "player.health <= 65" },
	
	
	--Self-healing
	{ "Victory Rush", "player.health <= 85" },
	{ "Impending Victory", "player.health <= 85" },
	{ "#5512", "player.health < 40" }, -- Healthstone

-- Ranged
	{ "Heroic Throw", "target.range >= 10" },
  
	{ "Throw", { 
		"target.range >= 10", 
		"!player.moving",
	}},
	
	-- cooldowns
{{
	{ "Recklessness" },
	{ "Bloodbath", { "target.debuff(Rend)", "player.spell(Colossus Smash).cooldown < 5"} },
	{ "Avatar", "player.buff(Recklessness)" },
	{ "Arcane Torrent", "player.spell(Arcane Torrent).exist" }, -- arcane torrent
	{ "26297", "player.spell(26297).exists" }, -- berserking
	{ "33697", "player.spell(33697).exists", }, -- Blood Fury
	
}, { "modifier.cooldowns", "target.range <= 8" } },

	-- multi-target
{{
	{ "Sweeping Strikes" },
	{ "Bladestorm" },
	{ "Rend", "!target.debuff(Rend)" },
	{ "Dragon Roar" },
	{ "Whirlwind" }, 

}, { "modifier.multitarget", "target.range <= 8" } },

-- single target
{{
	{ "Execute", "player.buff(Sudden Death)" },
	{ "Execute", {
		"player.buff(Colossus Smash",
		"target.health < 20",
		"player.rage > 40",
	}},
	{ "Rend", {
		"!target.debuff(Rend)",
		"target.ttd > 4",
	}},
	{ "Rend", {
		"target.debuff(Rend).duration < 5",
		"target.ttd > 4",q
	}},
	{ "Colossus Smash" },
	{ "pause", { "player.rage < 60", "player.spell(Colossus Smash).cooldown < 1" }},
	{ "Execute", "player.rage > 40 " },
	{ "Mortal Strike", "player.health >= 20" },
	{ "Storm Bolt", "player.rage < 90" },
	{ "Dragon Roar", { "player.rage < 90", "!target.debuff(Colossus Smash)" }},
	{ "Whirlwind", {
		"player.rage > 40",
		"player.spell(Colossus Smash).cooldown > 3",
		"player.health >= 20" 
	}},	
}, "target.range <= 8" },
},

-- out of combat
{

	--Heroic Leap time!
	--Leap to your mouseover with Control!
	{ "Heroic Leap", "modifier.control", "mouseover.ground"},
	--Leap to your target with Alt!
	{ "Heroic Leap", "modifier.alt", "ground"},
 	
	
}, function()
ProbablyEngine.toggle.create('md', 'Interface\\Icons\\ability_hunter_misdirection', 'Auto Misdirect', 'Automatially Misdirect when necessary')

end)