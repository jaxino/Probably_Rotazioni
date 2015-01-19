ProbablyEngine.rotation.register_custom(252, "unholy", {
---------------
-- IN COMBAT --
---------------

-- Spell IDs
-- 48268 	Blood Presence
-- 48266 	Frost Presence
-- 48265 	Unholy Presence
-- 50842 	Blood Boil
-- 49998 	Death Strike
-- 47541 	Death Coil
-- 130736 	Soul Reaper
-- 48707 	Anti-Magic Shell
-- 51052 	Anti-Magic Zone
-- 47528 	Mind Freeze
-- 47476 	Strangulate
-- 49576 	Death Grip
-- 43265 	Death and Decay
-- 108200	Defile
-- 77575 	Outbreak
-- 45462 	Plague Strike
-- 55078 	Blood Plague
-- 45477 	Frost Strike
-- 55095 	Frost Feever
-- 77606 	Dark Simulacrum
-- 48792 	Icebound Fortitude
-- 47568 	Empower Rune Weapon
-- 42650 	Army of the Dead
-- 61999 	Rise Ally
-- 48743 	Death Pact
-- 45524 	Chain of Ice
-- 108199 	Gorefiend's Grasp
-- 108200	Remorseless Winter
-- 57330	Horn of Winter
-- 123693 	Plague Leech
-- 155159	Necrotic Plague debuff
-- 152281	Necrotic Plague talent
-- 96268	Death's Advance
-- 49039	Lich Born
-- 63560	Dark Transformation
-- 91342	Shadow Infusion buff
-- 85948	Festering Strike
-- 55090	Scourge Strike
-- 49206	Summon Gargolye
-- 46584	Raise Dead
-- 81340	Sudden Doom proc

-- CDs
{{
	{"49039",{"player.health < 50"}}, -- Lich Born
	{"47541",{"player.buff(49039)","player.runicpower >= 30"},"player"}, -- Death Coil in Lich Born
	{"48743",{"player.health < 20"}}, -- Death Pact
	{"48729",{"player.health < 40"}}, -- Icebound Fortitude
	{"#5512",{"player.health < 40"},nil}, -- Healthstone
	{{
		{"123693",{"target.debuff(155159)","talent(7, 1)"}}, -- Plague Leech with Necrotic Plague talent
		{"123693",{"target.debuff(55095)","target.debuff(55078)","!talent(7, 1)"}}, -- Plague Leech normal
	},{"player.runes(blood).count = 0","player.runes(frost).count = 0","player.runes(death).count = 0"}},
	{"96268",{"player.moving"}}, -- Death's Advance
	{"48707",{"player.health < 90"}}, -- Anti-Magic Shell
	{"49206", "boss"},
},"toggle.cooldowns"},

-- Auto Targets
{{
{ "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
{ "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" } },
},"toggle.autotarget"},

-- Interrupts
{{
{"47528",{"target.interruptAt(20)"},"target"}, -- Mind Freeze
{"77606",{"target.interruptAt(80)", "target.range < 40"},"target"}, -- Dark Simulacrum
},"modifier.interrupt"},

-- Buffs
{"48263",{"player.seal != 3"}}, -- Blood Presence
{"46584", "!pet.exists"}, -- Raise Dead

-- Mouseover
{"61999",{"modifier.lalt","mouseover.alive"},"mouseover"}, -- Rise Ally
{"43265",{"modifier.lshift","target.range < 30"},"target.ground"}, -- D&D
{"152280",{"modifier.lshift","target.range < 30"},"target.ground"}, -- Defile
{"49576",{"modifier.lcontrol","target.range < 30"},"mouseover"}, -- Death Grip

-- Desease
{{
{"77575",{"!target.debuff(55078)","!target.debuff(55095)"},"target"}, -- Outbreak
{"45462",{"!target.debuff(55078)"},"target"}, -- Plague Strike
{"45477",{"!target.debuff(55095)"},"target"}, -- Frost Strike
},"!talent(7, 1)"},
{"77575",{"!target.debuff(155159)","talent(7, 1)"},"target"}, -- Outbreak

-- AOE smart
{"43265",{"player.area(8).enemies >= 3","target.range < 30","!talent(7, 2)"},"target.ground"}, -- D&D
{"50842",{"player.area(8).enemies >= 3","target.range < 8","target.debuff(55078)","target.debuff(55095)"}}, -- BB
{"85948",{"player.area(8).enemies >= 3","player.runes(blood) >= 1","player.runes(frost) >= 1"},"target"}, -- Festering Strike

-- Single Target Rotation
{"130736",{"player.runes(blood).count > 0","target.health <= 45","!target.debuff(130736)"},"target"}, -- Soul Reaper instead of bloodboil
{"152280",{"talent(7, 2)"},"target.ground"}, -- Defile
{"63560",{"player.buff(91342).count = 5"}}, -- Dark Transformation + Shadow Infusion x5
{"47541",{"player.runicpower >= 80","target.range <= 40"},"target"}, -- Death Coil + Runic Power > 90
{"47541",{"!pet.buff(63560)","target.range <= 40"},"target"}, -- Death Coil - Dark Transformation
{"55090",{"player.runes(unholy) >= 1","player.runes(death) >= 1"},"target"}, -- Scourge Strike
{"85948",{"player.runes(blood) >= 1","player.runes(frost) >= 1"},"target"}, -- Festering Strike
{"47541",{"player.buff(81340)","target.range <= 40"},"target"}, -- Death Coil + Sudden Doom proc

{"47541",{"player.runes.depleted","target.range <= 40"},"target"}, -- Death Coil all rune depleted


},{
-------------------
-- OUT OF COMBAT --
-------------------

-- Buff
{ "57330", {"!player.buffs.attackpower"}}, -- Horn of Winter
{ "46584", "!pet.exists" }, -- Raise Dead

-- Mouseover
{"49576",{"modifier.lcontrol","target.range < 30"},"mouseover"}, -- Death Grip
{"61999",{"modifier.lalt","mouseover.alive"},"mouseover"}, -- Rise Ally

},

function()
	ProbablyEngine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automaticaly target the nearest enemy when target dies or does not exist.')
end
)