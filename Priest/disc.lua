ProbablyEngine.library.register('coreHealing', {
  needsHealing = function(percent, count)
    return ProbablyEngine.raid.needsHealing(tonumber(percent)) >= count
  end,
  needsDispelled = function(spell)
    for unit,_ in pairs(ProbablyEngine.raid.roster) do
      if UnitDebuff(unit, spell) then
        ProbablyEngine.dsl.parsedTarget = unit
        return true
      end
    end
  end,
})

local ignoreDebuffs = {
	
}

-- Dispell function
local function Dispell()
local prefix = (IsInRaid() and 'raid') or 'party'
	for i = -1, GetNumGroupMembers() - 1 do
	local unit = (i == -1 and 'target') or (i == 0 and 'player') or prefix .. i
		if IsSpellInRange('Purify', unit) then
			for j = 1, 40 do
			local debuffName, _, _, _, dispelType, duration, expires, _, _, _, spellID, _, isBossDebuff, _, _, _ = UnitDebuff(unit, j)
				if dispelType and dispelType == 'Magic' or dispelType == 'Disease' then
				local ignore = false
				for k = 1, #ignoreDebuffs do
					if debuffName == ignoreDebuffs[k] then
						ignore = true
						break
					end
				end
					if not ignore then
						--print("Dispelled: "..debuffName.." on: "..unit)
						ProbablyEngine.dsl.parsedTarget = unit
						return true
					end
				end
				if not debuffName then
					break
				end
			end
		end
	end
		return false
end

--PoM
local function mending()
local prefix = (IsInRaid() and 'raid') or 'party'
	for i = -1, GetNumGroupMembers() - 1 do
	local unit = (i == -1 and 'target') or (i == 0 and 'player') or prefix .. i
		if IsSpellInRange('Beacon of Insight', unit) then
			for j = 1, 40 do
			local BuffName, _, _, _, _, duration, expires, caster, _, _, spellID, _, _, _, _, _ = UnitBuff(unit, j)
				if spellID and spellID == 33076 and caster == 'player' and duration > 2 then
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


ProbablyEngine.rotation.register_custom(256,"DiscoHeal", {
	-----------------
	--- IN COMBAT ---
	-----------------
	
	-- Surge of Light 114255
	-- Empowered Arcangel 172359

	-- Key Binds
	{ "!32375", {"modifier.control"}, "player.ground" }, -- Mass Dispel
	{"!527",{"modifier.lshift"},"mouseover"}, -- Purify
	{ "/focus [target=mouseover]", "modifier.lalt" }, -- Mouseover Focus
	
	-- Survival
	{"!19236", "player.health <= 50" }, -- Desperate Prayer
	{"#5512", {"player.health <= 35"} }, -- Health Stone
	{"586", {"target.threat >= 80"} }, -- Fade
	
	-- Mana management
	{ "10060", "player.mana < 80" },-- Power Infusion
	{ "155145", {"player.mana < 90" }, "player" }, -- Arcane torrent
	{ "123040", {"player.mana < 85", "target.range <= 40"}, "target" },-- Mindbender
	{ "129250", {"target.spell(129250).range","talent(3,3)"}, "target" }, -- PW:Solace
	
	--Dispell
	{{
		{ "!527", (function() return Dispell() end) },-- Dispel Everything
	}, "!player.casting.percent >= 50"},
	
	-- Cooldowns
	{"33206",{"tank.health < 50"},"tank"}, --Pain Suppression				
	  
	-- Buffs
	{ "81700", "player.buff(81661).count = 5" }, -- Archangel
	{ "21562", "!player.buffs.stamina" }, -- Fortitude
	
	{{
		{ "/cleartarget", (function() return UnitIsFriend("player","target") end) },
		{ "/TargetNearestEnemy", "!target.exists", "toggle.autotarget"},
		{ "/TargetNearestEnemy", { "target.exists", "target.dead", "toggle.autotarget" } },
	},"toggle.autotarget"},
	
	-- Interrupts
	{"15487",{"target.interruptAt(80)","target.range < 30","modifier.interrupt"},"target"}, -- Silence
	

	-- Solace
	{ "129250", {"target.infront","target.spell(129250).range"}, "target" }, --PW: Solace
	
	--Tank Heal
	{"17",{"!tank.buff(17)","!tank.debuff(6788)","tank.health <= 99"},"tank"}, -- PW:S
	{"!47540", {"tank.health < 80","!player.casting(2061)","!player.casting.percent >= 50"}, "tank" }, -- Tank: Penance
	{"!2061",{"player.buff(114255)","tank.health < 95"},"tank"}, -- Flash Heal + Surge of Light
	{"2061",{"tank.health < 50"},"tank"}, -- Flash Heal
	{"33076",{(function() return mending() end),"tank.health < 95"},"tank"}, -- PoM
	
	-- AoE Healing
	{{
		{"62618",{"@coreHealing.needsHealing(50,3)","player.area(7).friendly >= 3 "},"player.ground"}, -- Barrier
		{"121135",{"!player.moving", "@coreHealing.needsHealing(95,3)"},"lowest"}, -- Cascade
		{"33076",{"!player.moving", "@coreHealing.needsHealing(90,3)"},"tank"}, -- PoM
		{"596",{"!player.moving", "@coreHealing.needsHealing(90,4)","lowest.area(30).friendly > 4","player.mana > 30"},"lowest"}, -- PoH
		{"132157",{"player.mana > 10","@coreHealing.needsHealing(95,3)","player.area(12).friendly > 3 "},"player"}, -- Holy Nova				
	},"toggle.multitarget"},

	-- Normal Healing
	{ "14914", {"target.infront","player.mana > 20","target.spell(14914).range"}, "target" }, --Holy Fire
		
	--Others Healing
	{"17",{"!lowest.buff(17)","!lowest.debuff(6788)","lowest.health <= 70"},"lowest"}, -- PW:S
	{"!2061",{"player.buff(114255)","lowest.health < 95"},"lowest"}, -- Flash Heal + Surge of Light
	{"!47540", {"lowest.health < 90","!player.casting(2061)","!player.casting.percent >= 50"}, "lowest" }, -- Penance
	{"2061",{"lowest.health < 50"},"lowest"}, -- Flash Heal
	{"2060",{"lowest.health < 90"},"lowest"}, -- Heal
	
	{"34433", {"lowest.health >= 90","target.range <= 40"}, "target" }, --ShadowFiend
	{"585", {"lowest.health >= 90","!player.moving", "target.spell(585).range"}, "target" }, --Smite
		
	------------------
	-- End Rotation --
	------------------	
  
},{
	---------------
	-- OOC Begin --
	---------------
	-- Buffs
	
	{ "21562", {"!player.buffs.stamina","toggle.buffs"} }, -- Fortitude
	{"!47540", {"lowest.health < 90","!player.casting(2061)"}, "lowest" }, -- Penance
	{"2060",{"lowest.health < 90"},"lowest"}, -- Heal
	{"!2061",{"player.buff(114255)","lowest.health < 95"},"lowest"}, -- Flash Heal + Surge of Light
	
	-------------
	-- OOC End --
	-------------
},

function()	
	ProbablyEngine.toggle.create('buffs', 'Interface\\Icons\\spell_holy_wordfortitude', 'AutoBuff', 'Enable/Disable \n')
	ProbablyEngine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'AutoTarget', 'Enable/Disable \nAutomaticaly targetenemy')
	ProbablyEngine.toggle.create('dps', 'Interface\\Icons\\spell_holy_holysmite', 'DPS', 'Enable/Disable')	
end)