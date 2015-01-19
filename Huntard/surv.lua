--[[
Questo è da aggiungere a Probably.system.condition.core.lua

ProbablyEngine.condition.register("tranquilizing", function(target, spell)
	local buff,_,_,_, dispelType = UnitAura(target, spell)
    if buff and dispelType == '' or dispelType == 'Magic' then
    return true
    end
    return false
end)

]]

ProbablyEngine.rotation.register_custom(255, "Survival", {
-- IN COMBAT --

-- 3674		Black Arrow
-- 53301	Explosive Shot
-- 7767		Cobra Shot
-- 3044		Arcane Shot
-- 2643		Multi-Shot
-- 3447		Misdirection
-- 34720	Thrill of the Hunt
-- 147362	Counter Shot
-- 82941	Ice Trap
-- 82939	Explosive Trap
-- 60192	Freezing Trap
-- 77769	Trap Launcer
-- 120360	Barrage
-- 168980	Lock and Load
-- 118253	Serpent Sting
-- 131894	A Murder of Crows
-- 19801	Tranquilizing Shot
-- 117050	Glaive Toss

-- Racials
{"33697"},-- Blood Fury

	-- Auto Target
		{ "/cleartarget", {
			"toggle.autotarget", 
			(function() return UnitIsFriend("player","target") end)
		}},
		{ "/target [target=focustarget, harm, nodead]", "target.range > 40" },
		{ "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" }},
   		{ "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" }},

-- Interrupts
{"!147362",{"target.interruptAt(20)","modifier.interrupt"},"target"}, -- Counter Shot

-- Aggro
{"5384", "player.aggro >= 100" }, -- Feing Death
-- Pause if fake death
{ "pause","player.buff(5384)" }, -- Pause for Feign Death

-- Traps
--{"82939",{"modifier.lshift","player.buff(77769)"},"target.ground"}, -- Explosive Trap
--{"60192",{"modifier.lcontrol","player.buff(77769)"},"target.ground"}, -- Freezing Trap
{"82939",{"modifier.lalt","player.buff(77769)"},"mouseover.ground"}, -- Ice Trap

-- Movement
{"!781",{"modifier.lshift"}},

{"!19801",{"dispellable(19801)","toggle.dispell","target.state.purge"},"target"}, --Tranquilizing Shot

-- AoE
{{
	{"82939",{"player.buff(77769)"},"target.ground"}, -- Explosive Trap
	{"3674"}, -- Black Arrow
	{"53301"}, -- Explosive Shot
	{"53301",{"player.buff(168980)"},"target"}, -- Explosive Shot
	{"131894"}, -- A Murder of Crows
	{"!120360"}, -- Barrage
	{"117050"}, -- Glaive Toss
	{"2643",{"!target.debuff(118253)","target.debuff(118253).duration <= 4"},"target"}, -- Multi-Shot -> Serpent Sting
	{{	
		{"2643",{"player.buff(34720)","player.focus > 15"},"target"}, -- Multi-Shot + Thrill of the Hunt
		{"2643",{"player.focus > 70"},"target"}, -- Multi-Shot dump focus
	},{"talent(6,3)","player.spell(120360).cooldown > 5"}},
	{{	
		{"2643",{"player.buff(34720)","player.focus > 15"},"target"}, -- Multi-Shot + Thrill of the Hunt
		{"2643",{"player.focus > 70"},"target"}, -- Multi-Shot dump focus
	},"talent(6,1)"},
	{"77767",{"player.focus < 70"},"target"}, -- Cobra Shot
	{"77767"}, -- Cobra Shot
},"target.area(20).enemies = 3"},

{{
	{"!19801",{"tranquilizing"},"target"},
	{"!19801",{"dispellable(19801)","toggle.dispell"},"target"}, --Tranquilizing Shot
	{"82939",{"player.buff(77769)"},"target.ground"}, -- Explosive Trap
	{"3674"}, -- Black Arrow
	{"53301",{"player.buff(168980)"},"target"}, -- Explosive Shot
	{"131894",}, -- A Murder of Crows
	{"!120360"}, -- Barrage
	{"117050"}, -- Glaive Toss
	{"2643",{"!target.debuff(118253)","target.debuff(118253).duration <= 4"},"target"}, -- Multi-Shot -> Serpent Sting
	{{	
		{"2643",{"player.buff(34720)","player.focus > 15"},"target"}, -- Multi-Shot + Thrill of the Hunt
		{"2643",{"player.focus > 70"},"target"}, -- Multi-Shot dump focus
	},{"talent(6,3)","player.spell(120360).cooldown > 5"}},
	{{	
		{"2643",{"player.buff(34720)","player.focus > 15"},"target"}, -- Multi-Shot + Thrill of the Hunt
		{"2643",{"player.focus > 70"},"target"}, -- Multi-Shot dump focus
	},"talent(6,1)"},
	{"77767",{"player.focus < 70"},"target"}, -- Cobra Shot
},"target.area(20).enemies > 3"},

-- Single Target
{"3674"}, -- Black Arrow
{"53301"}, -- Explosive Shot
{"53301",{"player.buff(168980)"},"target"}, -- Explosive Shot
{"131894"}, -- A Murder of Crows
{"120360"}, -- Barrage
{"117050"}, -- Glaive Toss
{"3044",{"!target.debuff(118253)","target.debuff(118253).duration <= 4"},"target"}, -- Arcane Shot -> Serpent Sting
{{
	{"82939",{"player.buff(77769)"},"target.ground"}, -- Explosive Trap
	{"3044",{"player.buff(34720)","player.focus > 15"},"target"}, -- Arcane Shot + Thrill of the Hunt
	{"3044",{"player.focus > 70"},"target"}, -- Arcane Shot dump focus
},{"talent(6,3)","player.spell(120360).cooldown > 5"}},
{{
	{"82939",{"player.buff(77769)"},"target.ground"}, -- Explosive Trap
	{"3044",{"player.buff(34720)","player.focus > 15"},"target"}, -- Arcane Shot + Thrill of the Hunt
	{"3044",{"player.focus > 70"},"target"}, -- Arcane Shot dump focus
},"talent(6,1)"},
{"77767",{"player.focus < 70"},"target"}, -- Cobra Shot


},{
-------------------
-- OUT OF COMBAT --
-------------------

-- buffs
		{"77769", "!player.buff(77769)"}, -- trap launcher


},

function()
	ProbablyEngine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'AutoTarget', 'Enable/Disable \nAutomaticaly targetenemy')
	ProbablyEngine.toggle.create('dispell', 'Interface\\Icons\\spell_nature_drowsy', 'Auto Dispell', '')
end
)
