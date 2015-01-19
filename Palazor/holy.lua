ProbablyEngine.library.register('coreHealing', {
  needsHealing = function(percent, count)
    return ProbablyEngine.raid.needsHealing(tonumber(percent)) >= count
  end,
})

local function BeaconI()
local prefix = (IsInRaid() and 'raid') or 'party'
	for i = -1, GetNumGroupMembers() - 1 do
	local unit = (i == -1 and 'target') or (i == 0 and 'player') or prefix .. i
		if IsSpellInRange('Beacon of Insight', unit) then
			for j = 1, 40 do
			local BuffName, _, _, _, _, duration, expires, caster, _, _, spellID, _, _, _, _, _ = UnitBuff(unit, j)
				if spellID and spellID == 157007 and caster == 'player' and duration > 2 then
					return false
				end
				if not spellID then
					break
				end
			end
		end
	end
		return true
end

-- Class ID 65 - Paladins Holy
ProbablyEngine.rotation.register_custom(65,"Holydin", {

	-- 148039	Sacred Shield
	-- 65148	Sacred Shield Buff
	-- 85673	Word of Glory  
	-- 114163	Word of Glory
	-- 156322	Eternal Flame Buff
	-- 82327	Holy Radiance
	-- 85222	Light of Dawn
	-- 4987		Cleanse Holy
	-- 498		Divine Protection
	-- 642		Divine Shield
	-- 31842	Avenging Wrath
	-- 31821	Devotion Aura
	-- 633		Lay on Hand
	-- 20473	Holy Shock
	-- 160002	Enhanced Holy Shock
	-- 82326	Holy Light
	-- 19750	Flash of Light
	-- 114165 	Holy Prism
	-- 6940		Hand of Sacrifice
	-- 1022		Hand of Protection
	-- 1044		Hand of Freedom
	-- 53563	Beacon of Light
	-- 20165	Seal of Insight
	-- 54149	Infusion of Light
	-- 88819	Daybreak
	-- 35395	Crusader Strike
	-- 114158	Light Hammer
	-- 157007	Beacon of Insight
	-- 156910	Beacon of Faith
	-- 20271	Judgement
	-- 2812		Denounce
	-- 24275	Hammer of Wrath
	-- 7328 	Redemption
	-- 96231	Rebuke

	--------------------
	-- Start Rotation --
	--------------------

	-- Keybind
	--{ "pause", "modifier.lalt" },
	{ "114158", { "modifier.lcontrol", "talent(6, 2)"}, "target.ground"}, -- Light´s Hammer
	{ "/focus [target=mouseover]", "modifier.lalt" }, -- Mouseover Focus
	{ "4987", { "modifier.lshift", "mouseover.exists", "mouseover.alive", "mouseover.friend", "mouseover.range < 40" }, "mouseover" }, -- Cleanse Holy
	{ "157007", { "modifier.lcontrol", "talent(7, 2)" , "mouseover.exists", "mouseover.alive", "mouseover.friend", "mouseover.range < 40" }, "mouseover" }, -- Beacon of Insight
	{ "157007", { (function() return BeaconI() end), "talent(7, 2)" }, "lowest" }, -- Beacon of Insight
	  
	-- Buff
	{"20217",{"!player.buffs.stats", "toggle.buffs"}, nil}, -- Blessing of Kings
	{"19740",{"!player.buff(20217)","player.buffs.stats","!player.buffs.mastery", "toggle.buffs"}, nil}, -- Blessing of Might
	{ "20165", "player.seal != 2" }, -- Seal of Insight
	  
	-- Auto Targets
	{ "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
	{ "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" } },
	  
	-- CDs
	{{
		{"498",	{"player.health <= 90" }, "player" }, -- Divine Protection
		{"642",	{"player.health <= 10" }, "player" }, -- Divine Shield
		{"!633",	{"tank.health < 15", "tank.range < 40"}, "tank" }, -- Lay on Hands
		{"!633",	{"player.health < 15" }, "player" }, -- Lay on Hands
		{"31842",	{"@coreHealing.needsHealing(75, 4)"}, nil }, -- Avenging Wrath
		{"#trinket1",{"@coreHealing.needsHealing(85, 4)"}, nil }, -- Trinket1
		{"#trinket2",{"@coreHealing.needsHealing(85, 4)"}, nil }, -- Trinket2
		{"31821",	{"@coreHealing.needsHealing(50, 5)"}, nil }, -- Devotion Aura
		{"1044",	{ "player.state.root"},"player"},-- Hand of Freedom
		{"1044",	{ "player.state.snare"},"player"},-- Hand of Freedom
		{"#5512",	{ "player.health < 30" },nil}, -- Healthstone
		{"6940",	{ "tank.health < 30", "tank.range < 40", "tank.range < 40" }, "tank" }, -- Hand of Sacrifice
	},"toggle.cooldowns"},
	  
	-- Interrupts
	{{
		{ "105593", {"target.interruptAt(30)","target.range <= 20","!lastcat(96231)","!lastcat(155145)"}, "target" }, -- Fist of Jiustice
		{ "96231", {"target.interruptAt(50)", "target.range <= 5" ,"!lastcat(105593)","!lastcat(155145)"}, "target" }, -- Rebuke
		{ "155145", {"target.interruptAt(90)","target.range <= 8","!lastcat(105593)","!lastcat(96231)"}, "target" }, -- Arcane torrent
	},"modifier.interrupt"},
	  
	  -- DPS
	{{
		{"2812",  {"target.range < 40","toggle.dps"},"target"}, -- Denounce
		{"24275", {"target.health <= 20","target.range < 30"},"target"}, -- HammerOfWrath
		{"35395", {"target.range < 8"},"target"}, -- CrusaderStrike
		{"20271", {"target.range < 30"},"target"}, -- Judgement
		{"20473", {"target.range < 40"},"target"}, -- HolyShock
		{"2812",  {"target.range < 40"},"target"}, -- Denounce
		{"114165",{"player.area(15).enemies >= 2", "target.range < 40"},"player"}, -- HolyPrism
	},"toggle.dps"},
	  
	-- Single Target Healing
	{{
		{ "20473", { "target.health <= 100", "player.holypower < 5"}, "target"}, -- Holy Shock
		{ "114163",{ "target.health < 95", "!player.moving", "player.holypower >= 1", "!target.buff(156322)"},"target"}, -- Eternal Flame 1HP
		{ "114163",{ "target.health < 95", "!player.moving", "player.holypower >= 3"}, "target"}, -- Eternal Flame 3HP
		{ "82326", { "target.health < 75", "!player.moving", "player.buff(54149)", "target.range < 40" }, "target" }, -- Holy Light + Infusion of Light
		{ "19750", { "target.health < 50", "!player.moving", "target.range < 40" }, "target" }, -- Flash of light
		{ "82326", { "target.health < 90" }, "target" }, -- Holy Light
	},"toggle.focushealing", "target.friend", "target.exists", "target.alive", "target.range < 40"},
	  
	-- TANK (focus)
	{ "53563",  { "!tank.buff(53563)", "tank.spell(53563).range" }, "tank" }, -- Beacon of light
	{ "148039", { "tank.health < 99", "tank.range < 40", "!tank.buff(148039)", "talent(3, 3)", "!talent(3, 2)" }, "tank" }, -- Sacred Shield TANK
	{ "114163", { "player.holypower >= 1", "!tank.buff(156322)", "tank.health <= 95", "tank.range <= 40","!talent(3, 3)", "talent(3, 2)" }, "tank" }, -- Eternal Flame con 1 HP
	{ "114163", { "player.holypower >= 3", "tank.health <= 75", "tank.range <= 40","!talent(3, 3)", "talent(3, 2)" }, "tank" }, -- Eternal Flame con 3 HP anche se ha già L'Eternal Flame
	  
	-- AOE Healing
	{{
	-- Party
		{ "114165",{ "@coreHealing.needsHealing(85, 3)", "talent(6, 1)"}, "target" },  -- Holy Prism
		{ "85222", { "@coreHealing.needsHealing(90, 3)", "player.holypower >= 3", "modifier.party", "lowest.range < 30","player.area(30).friendly >= 3" }, "lowest" }, -- Light of Dawn
		{ "82327", { "@coreHealing.needsHealing(80, 3)", "player.buff(88819).count <= 1", "!player.moving", "modifier.party", "lowest.range < 40", "lowest.area(40).friendly >= 3" }, "lowest" }, -- Holy Radiance
		{ "20473", { "@coreHealing.needsHealing(90, 3)", "player.buff(88819).count = 2", "lowest.range < 40","lowest.area(10).friendly >= 3" }, "lowest" }, -- Holy Shock (2xDAYBREAK)
	-- RAID 5-25
		{ "114165",{ "@coreHealing.needsHealing(85, 4)", "talent(6, 1)"}, "target" },  -- Holy Prism
		{ "85222", { "@coreHealing.needsHealing(90, 5)", "player.holypower >= 3", "modifier.raid", "!modifier.members > 10", "lowest.range < 30" }, "lowest" }, -- Light of Dawn
		{ "82327", { "@coreHealing.needsHealing(90, 5)", "player.buff(88819).count <= 1", "!player.moving", "modifier.raid", "modifier.members > 5", "modifier.members < 25", "lowest.range < 40" }, "lowest" }, -- Holy Radiance
		{ "20473", { "@coreHealing.needsHealing(90, 5)", "player.buff(88819).count = 2", "lowest.range < 40"}, "lowest" }, -- Holy Shock (2xDAYBREAK)
	-- Raid + 25
		{ "114165",{ "@coreHealing.needsHealing(85, 5)", "talent(6, 1)"}, "target" },  -- Holy Prism
		{ "85222", { "@coreHealing.needsHealing(90, 8)", "player.holypower >= 3", "modifier.members > 10", "lowest.range < 30" }, "lowest" }, -- Light of Dawn
		{ "82327", { "@coreHealing.needsHealing(90, 8)", "player.buff(88819).count <= 1", "!player.moving", "modifier.raid", "modifier.members > 25", "lowest.range < 40" }, "lowest" }, -- Holy Radiance
		{ "20473", { "@coreHealing.needsHealing(90, 6)", "player.buff(88819).count = 2", "lowest.range < 40"}, "lowest" }, -- Holy Shock (2xDAYBREAK)
	},{"toggle.multitarget","player.mana > 30"}},
	   
	-- Normal Healing
	{ "20473", { "lowest.health <= 100", "lowest.range < 40", "player.holypower < 5"}, "lowest" }, -- Holy Shock
	{ "82326", { "lowest.health < 75", "!@coreHealing.needsHealing(90, 4)", "!player.moving", "player.buff(54149)", "lowest.range < 40" }, "lowest" }, -- Holy Light + Infusion of Light
	{ "114163",{ "lowest.health < 95", "player.holypower >= 1", "!player.moving", "!lowest.buff(156322)" , "!talent(3, 3)", "talent(3, 2)"}, "lowest" }, -- Eternal Flame 1 HP
	{ "114163",{ "lowest.health < 95", "!player.moving", "player.holypower >= 3"}, "lowest"}, -- Eternal Flame 3HP
	{ "19750", { "lowest.health < 50", "!player.moving", "lowest.range < 40" }, "lowest" }, -- Flash of light
	{ "85673", { "player.holypower >= 3", "lowest.health <= 80", "lowest.range < 40","talent(3, 3)", "!talent(3, 2)" }, "lowest"  }, -- Word of Glory
	{ "148039",{ "player.spell(148039).charges >= 0", "lowest.health < 100", "!lowest.buff(148039)", "lowest.range < 40", "talent(3, 3)", "!talent(3, 2)" }, "lowest" }, -- Sacred Shield
	{ "82326", { "lowest.health < 90", "lowest.range < 40" }, "lowest" }, -- Holy Light
		
	-- Extra HolyPower
	{ "35395", {"target.spell(35395).range", "toggle.extrahp"}, "target" }, -- Crusader Strike
	  
	------------------
	-- End Rotation --
	------------------
	--{ "20473", { "lowest.health <= 100", "lowest.range < 40", "player.holypower < 5"}, {"lowest","lowest.buff(123)"} }, -- Holy Shock
  
},{
	---------------
	-- OOC Begin --
	---------------
	  
	{ "20165", {"player.seal != 2"}, "player"}, -- Seal of Insight
	{"20217",  {"!player.buffs.stats", "toggle.buffs"}, nil}, -- Blessing of Kings
	{"19740",  {"!player.buff(20217)","player.buffs.stats","!player.buffs.mastery", "toggle.buffs"}, nil}, -- Blessing of Might
	{ "4987",  { "modifier.lshift", "mouseover.exists", "mouseover.alive", "mouseover.friend", "mouseover.range < 40" }, "mouseover" }, -- Cleanse Holy
	{"732ii8", "!mouseover.alive"}, -- Redemption
	{ "/focus [target=mouseover]", "modifier.lalt" }, -- Mouseover Focus
	{ "20473", {"lowest.health <= 100", "lowest.range <= 40", "toggle.holyshock", "player.holypower < 5"}, "lowest" }, -- Holy Shock
	{ "53563", { "!tank.buff(53563)", "tank.spell(53563).range" }, "tank" }, -- Beacon of light
	{ "157007",{ "modifier.lcontrol", "talent(7, 2)" , "mouseover.exists", "mouseover.alive", "mouseover.friend", "mouseover.range < 40" }, "mouseover" }, -- Beacon of Insight

	  
	-------------
	-- OOC End --
	-------------
},

function()
	ProbablyEngine.toggle.create('extrahp', 'Interface\\Icons\\spell_holy_crusaderstrike', 'ExtraHP', 'Enable/Disable \nUse CrusaderStrike for Extra HolyPower.')
	ProbablyEngine.toggle.create('buffs', 'Interface\\Icons\\spell_magic_greaterblessingofkings', 'AutoBuff', 'Enable/Disable \nAutomaticaly BoK priority')
	ProbablyEngine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'AutoTarget', 'Enable/Disable \nAutomaticaly targetenemy')
	ProbablyEngine.toggle.create('holyshock', 'Interface\\Icons\\spell_holy_searinglight', 'HolyPower Supercharge', 'Enable/Disable \nCast HolyShock on CD when OOC')
	ProbablyEngine.toggle.create('focushealing', 'Interface\\Icons\\spell_holy_sealofsalvation', 'Heal Prority', 'Enable/Disable \nHeal with hight priority the current target')
	ProbablyEngine.toggle.create('dps', 'Interface\\Icons\\ability_paladin_finalverdict', 'DPS', 'Enable/Disable')
	
end)