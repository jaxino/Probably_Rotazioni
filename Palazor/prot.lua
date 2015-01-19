Dispell = function ()
		if IsSpellInRange('Cleanse', 'player') then
			local debuffName, _, _, _, dispelType, duration, expires, _, _, _, spellID, _, isBossDebuff, _, _, _ = UnitDebuff('player',1)
			if dispelType and dispelType == 'Poison' or dispelType == 'Disease' then
				return true			
			end
		end
	return false
end

ProbablyEngine.rotation.register_custom(66, "Protadin",{

-- 31850	Ardent Defender
-- 31935	Avenger's Shield
-- 4987 	Cleanse
-- 26573 	Consecration
-- 35395 	Crusader Strike
-- 498 		Divine Protection 
-- 105593 	Fist Of Justice
-- 96659 	Guardian of Ancient Kings
-- 53595 	Hammer of the righteous
-- 24275 	Hammer of wrath
-- 1022 	Hand Of Protection
-- 119072 	Holy Wrath
-- 20271 	Judgement
-- 633 		Lay on Hands
-- 114158 	Light's Hammer
-- 96231 	Rebuke
-- 62124 	Reckoning
-- 25780 	Righteous Fury
-- 20925 	Sacred Shield
-- 20165 	Seal Of Insight
-- 53600 	Shield Of the Righteous
-- 85673 	Word of Glory
-- 1044 	Hand Of Freedom
-- 114637 	Bastion Of Glory
-- 132403 	Guardian of Ancient Kings
-- 85416 	Grand Crusader Buff
-- 152262	Seraphim
-- 90174	Divine Purpose buff



---------------
-- IN COMBAT --
---------------
--CDs
{{
{ "#5512", { "player.health <= 30"}, nil }, -- Healthstone
{ "1044", { "player.state.root"},"player"},-- Hand of Freedom
{ "1044", { "player.state.snare"},"player"},-- Hand of Freedom
{ "633", {"player.health <= 15"}, "player" }, -- Lay on Hands
{ "96659",{"player.health <= 50"},"player"}, -- Guardian of Ancient Kings
{ "31850", {"player.health <= 30"}, "player" }, -- Ardent Defender
{ "6940", { "player.health > 60", "lowest.health < 30" }, "lowest" }, -- Hand of Sacrifice
},"toggle.cooldowns"},

--Dispel
{ "4987", { Dispell , "toggle.autodispel"}, nil },	

--Interrupts
{{
{ "105593", {"target.interruptAt(10)","target.range <= 20","!lastcast(96231)","!lastcast(155145)"}, "target" }, -- Fist of Justice
{ "31935", {"target.interruptAt(20)","target.range <= 30"}, "target" }, -- Avenger's Shield
{ "155145", {"target.interruptAt(30)","target.range <= 8","!lastcast(105593)","!lastcast(96231)"}, "target" }, -- Arcane torrent
{ "96231", {"target.interruptAt(80)","!lastcast(105593)","!lastcast(155145)"}, "target" }, -- Rebuke
},"modifier.interrupt"},

--Mitigation
{"!152262",{"!player.buff(152262)","player.holypower = 5"}}, -- Seraphim

{ "498", {"player.health <= 90","!player.buff(152262)" }, "player" }, -- Divine Protection

{ "85673",{"player.buff(90174)","player.health <= 50","player.buff(114637).count = 5"},"player"}, -- WoG + 5 Bastion
{ "53600",{"player.buff(90174)"},"target"}, -- Shield of the Righteous

{ "85673",{"player.holypower >= 3","player.health <= 50","player.buff(114637).count = 5"},"player"}, -- WoG + 5 Bastion
{ "53600",{"player.holypower >= 5"},"target"}, -- Shield of the Righteous

{ "20925",{"!player.buff(20925)"},"player"}, -- Sacred Shield

{ "114158",{"player.health < 80"}, "player.ground"}, -- Light´s Hammer

-- Auto Target
{{
{ "/cleartarget", (function() return UnitIsFriend("player","target") end) },
{ "/TargetNearestEnemy", "!target.exists", "toggle.autotarget"},
{ "/TargetNearestEnemy", { "target.exists", "target.dead", "toggle.autotarget" } },
},"toggle.autotarget"},

-- Threat Control w/ Toggle
{{
{ "62124", {"target.threat < 100"},"target" }, -- Reckoning
},"toggle.tc"},

-- Mouseover
{ "114158", {"modifier.lcontrol"}, "target.ground"}, -- Light´s Hammer
{ "4987", { "modifier.lshift", "mouseover.exists", "mouseover.alive", "mouseover.friend", "mouseover.range < 40" }, "mouseover" }, --Cleanse
{ "1022", { "modifier.lalt", "mouseover.exists", "mouseover.alive", "mouseover.friend", "mouseover.range < 40" }, "mouseover" },  --Hand of Protection

--AutoSeal Switch
{{
{ "20165", {"player.seal != 3","player.health < 90"}, "player"}, -- Seal of Insight
{ "31801", {"player.seal != 1","player.health > 90","!toggle.multitarget"}, "player"}, -- Seal of Truth
{ "20154", {"player.seal != 2","player.health > 90","toggle.multitarget"}, "player"}, -- Seal of Righteous
},"toggle.autoseal"},
 
--AOE
{{
{ "31935",{"target.range <= 30","player.buff(85416)"},"target"}, -- Avenger's Shield + Grand Crusader
{ "53595"}, -- Hammer of the Righteous
{ "20271",{"target.range <= 30"},"target"}, -- Judgement
{ "119072",{"target.range <= 8"},"target"},-- Holy Wrath
{ "31935",{"target.range <= 30"},"target"}, -- Avenger's Shield
{ "26573",{"!player.glyph(159557)","target.range <= 25"},"target.ground"}, -- Consecration
{ "26573",{"player.glyph(159557)","target.range <= 25"},nil}, -- Consecration + Glyph Consecrator
{ "24275",{"target.range <= 30"},"target"}, -- Hammer of Wrath
},"toggle.multitarget"},

--Smart AOE
{{
{ "31935",{"target.range <= 30","player.buff(85416)"},"target"}, -- Avenger's Shield + Grand Crusader
{ "53595"}, -- Hammer of the Righteous
{ "20271",{"target.range <= 30"},"target"}, -- Judgement
{ "119072",{"target.range <= 8"},"target"},-- Holy Wrath
{ "31935",{"target.range <= 30"},"target"}, -- Avenger's Shield
{ "26573",{"!player.glyph(159557)","target.range <= 25"},"target.ground"}, -- Consecration
{ "26573",{"player.glyph(159557)","target.range <= 25"},nil}, -- Consecration + Glyph Consecrator
{ "24275",{"target.range <= 30"},"target"}, -- Hammer of Wrath
},{"target.area(8).enemies >= 3", "target.range <= 5" ,"toggle.smartae"}},

--Single Target
{{
{ "31935",{"target.range <= 30","player.buff(85416)"},"target"}, -- Avenger's Shield + Grand Crusader
{ "35395"}, -- Crusader Strike
{ "20271",{"target.range <= 30"},"target"}, -- Judgement
{ "31935",{"target.range <= 30"},"target"}, -- Avenger's Shield
{ "119072",{"target.range <= 8"},"target"},-- Holy Wrath
{ "24275",{"target.range <= 30"},"target"}, -- Hammer of Wrath
{ "26573",{"!player.glyph(159557)","target.range <= 25"},"target.ground"}, -- Consecration 
{ "26573",{"player.glyph(159557)","target.range <= 25"},nil}, -- Consecration + Glyph Consecrator
},"!toggle.multitarget"},

},{

-----------------
--OUT OF COMBAT--
-----------------

{ "20165", {"player.seal != 3","!toggle.autoseal"}, "player"}, -- Seal of Insight
{ "25780",{"!player.buff(25780)"},"player"}, --Righteous Fury

{{
{"20217", {"!player.buffs.stats"}, nil}, -- Blessing of Kings
{"19740", {"!player.buff(20217)","player.buffs.stats","!player.buffs.mastery"}, nil}, -- Blessing of Might
},"toggle.buffs"},


},
function()
	ProbablyEngine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'AutoTarget', 'Enable/Disable \nAutomaticaly targetenemy')
	ProbablyEngine.toggle.create('tc', 'Interface\\Icons\\spell_holy_unyieldingfaith', 'Auto Taunt', 'Auto on/off')
	ProbablyEngine.toggle.create('buffs', 'Interface\\Icons\\spell_magic_greaterblessingofkings', 'AutoBuff', 'Enable/Disable \nAutomaticaly BoK priority')
	ProbablyEngine.toggle.create('autoseal', 'Interface\\Icons\\spell_holy_righteousnessaura', 'AutoSeals', 'Enable/Disable \nAutomatic Seals')
	ProbablyEngine.toggle.create('autodispel', 'Interface\\Icons\\spell_holy_purify', 'AutoDispell', 'Enable/Disable \n')
	ProbablyEngine.toggle.create('smartae', 'Interface\\Icons\\ability_paladin_hammeroftherighteous', 'AoE', 'Auto AoE if use FireHack \nMulti-Target Toggle Have Priority')	
end
)