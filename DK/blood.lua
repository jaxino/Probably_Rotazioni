ProbablyEngine.rotation.register_custom(250, "Blood", {
---------------
-- IN COMBAT --
---------------

-- Spell IDs
-- 48263 	Blood Presence
-- 48266 	Frost Presence
-- 48265 	Unholy Presence
-- 50842 	Blood Boil
-- 49998 	Death Strike
-- 47541 	Death Coil
-- 114866 	Soul Reaper
-- 48707 	Anti-Magic Shell
-- 51052 	Anti-Magic Zone
-- 47528 	Mind Freeze
-- 47476 	Strangulate
-- 49576 	Death Grip
-- 43265 	Death and Decay
-- 77575 	Outbreak
-- 45462 	Plague Strike
-- 55078 	Blood Plague
-- 45477 	Frost Strike
-- 55095 	Frost Feever
-- 49222 	Bone Shield
-- 77606 	Dark Simulacrum
-- 45529 	Blood Tap
-- 48982 	Rune Tap
-- 171049	Rune Tap Buff
-- 55233 	Vampiric Blood
-- 49028 	Dancing Rune Weapon
-- 48792 	Icebound Fortitude
-- 47568 	Empower Rune Weapon
-- 42650 	Army of the Dead
-- 61999 	Rise Ally
-- 48743 	Death Pact
-- 56222 	Dark Command
-- 45524 	Chain of Ice
-- 108199 	Gorefiend's Grasp
-- 57330	Horn of Winter
-- 50421 	Shent of Blood
-- 114851 	Blood Charge
-- 77535	Blood Shield
-- 81141 	Crimson Scurge
-- 123693 	Plague Leech
-- 155159	Necrotic Plague debuff
-- 152281	Necrotic Plague talent
-- 96268	Death's Advance
-- 81164	Will of the Necropolis
-- 49039	Lich Born
-- 152280	Defile

-- CDs
{{
{"7744",{"player.state.fear"}}, -- Will of the Forsaken
{"47541",{"player.buff(49039)","player.runicpower >= 30"},"player"}, -- Death Coil in Lich Born
{"48982",{"player.buff(81164)"}}, --- Rune Tap + Will of the Necropolis
{"48743",{"player.health < 20"}}, -- Death Pact
{"48982",{"player.health < 30","!player.buff(171049)"}}, -- Rune Tap
{"48729",{"player.health < 40"}}, -- Icebound Fortitude
{"#5512",{"player.health < 40"},nil}, -- Healthstone
{"49039",{"player.health < 50"}}, -- Lich Born
{"49028",{"player.health < 60","target.range <= 29"},"target"}, -- Dancing Rune Weapon
{"55233",{"player.health < 70"}}, -- Vampiric Blood
{{
{"123693",{"target.debuff(155159)","talent(7, 1)"}}, -- Plague Leech with Necrotic Plague talent
{"123693",{"target.debuff(55095)","target.debuff(55078)","!talent(7, 1)"}}, -- Plague Leech normal
},{"player.runes(unholy).count = 0","player.runes(frost).count = 0","player.runes(death).count = 0"}},
{"96268",{"player.moving"}}, -- Death's Advance
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
{"48707",{"target.interruptAt(60)"}}, -- Anti-Magic Shell
},"modifier.interrupt"},

-- Buffs
{"48263",{"player.seal != 1"}}, -- Blood Presence
{"49222",{"!player.buff(49222)"}}, -- Bone Shield

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
{"43265",{"player.area(8).enemies >= 3","target.range < 30","!talent(7, 2)"},"player.ground"}, -- D&D

-- Single Target Rotation
{"152280",{"talent(7, 2)"},"player.ground"}, -- Defile
{"50842",{"player.buff(81141)","target.range <= 8"} },-- Blood Boil + Crimson Scurge proc
{"47541",{"player.runicpower >= 80","target.range <= 40"},"target"}, -- Death Coil + Runic Power > 80 
{"50842",{"player.runes(blood).count > 0","target.range <= 8","target.health > 35"} }, -- Blood Boil with blood runes
{"114866",{"player.runes(blood).count > 0","target.health <= 35","!target.debuff(114866)"},"target"}, -- Soul Reaper instead of bloodboil
{"49998",{"!lastcast(49998)"},"target"}, -- Death Strike
{"47541",{"player.runes.depleted","target.range <= 40"},"target"}, -- Death Coil all rune depleted


},{
-------------------
-- OUT OF COMBAT --
-------------------

-- Buff
{ "57330", {"!player.buffs.attackpower"}}, -- Horn of Winter
{"49222",{"!player.buff(49222)"}}, -- Bone Shield

-- Mouseover
{"43265",{"modifier.lshift","target.range < 30"},"target.ground"}, -- D&D
{"49576",{"modifier.lcontrol","target.range < 30"},"mouseover"}, -- Death Grip
{"61999",{"modifier.lalt","mouseover.alive"},"mouseover"}, -- Rise Ally

},

function()
	ProbablyEngine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automaticaly target the nearest enemy when target dies or does not exist.')
end
)