
local Tinkr = ...
local wowex = {}
local Routine = Tinkr.Routine
local Util = Tinkr.Util
local Draw = Tinkr.Util.Draw:New()
local OM = Tinkr.Util.ObjectManager
local lastdebugmsg = ""
local lastdebugtime = 0
_G.PriestSpellQueue = {}
Tinkr:require('scripts.cromulon.libs.Libdraw.Libs.LibStub.LibStub', wowex) --! If you are loading from disk your rotaiton. 
Tinkr:require('scripts.cromulon.libs.Libdraw.LibDraw', wowex) 
Tinkr:require('scripts.cromulon.libs.AceGUI30.AceGUI30', wowex)
Tinkr:require('scripts.wowex.libs.AceAddon30.AceAddon30' , wowex)
Tinkr:require('scripts.wowex.libs.AceConsole30.AceConsole30' , wowex)
Tinkr:require('scripts.wowex.libs.AceDB30.AceDB30' , wowex)
Tinkr:require('scripts.cromulon.system.init' , wowex)
Tinkr:require('scripts.cromulon.system.configs' , wowex)
Tinkr:require('scripts.cromulon.system.storage' , wowex)
Tinkr:require('scripts.cromulon.libs.libCh0tFqRg.libCh0tFqRg' , wowex)
Tinkr:require('scripts.cromulon.libs.libNekSv2Ip.libNekSv2Ip' , wowex)
Tinkr:require('scripts.cromulon.libs.CallbackHandler10.CallbackHandler10' , wowex)
Tinkr:require('scripts.cromulon.libs.HereBeDragons.HereBeDragons-20' , wowex)
Tinkr:require('scripts.cromulon.libs.HereBeDragons.HereBeDragons-pins-20' , wowex)
Tinkr:require('scripts.cromulon.interface.uibuilder' , wowex)
Tinkr:require('scripts.cromulon.interface.buttons' , wowex)
Tinkr:require('scripts.cromulon.interface.panels' , wowex)
Tinkr:require('scripts.cromulon.interface.minimap' , wowex)


function distanceto(object)
  local X1, Y1, Z1 = ObjectPosition('player')
  local X2, Y2, Z2 = ObjectPosition(object)
  if X1 and Y1 and X2 and Y2 and Z1 and Z2 then
    return math.sqrt(((X2 - X1) ^ 2) + ((Y2 - Y1) ^ 2) + ((Z2 - Z1) ^ 2))
  end
end

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

function UnitTargetingUnit(unit1,unit2)
  if UnitIsVisible(UnitTarget(unit1)) and UnitIsVisible(unit2) then
    if UnitGUID(UnitTarget(unit1)) == UnitGUID(unit2) then
      return true
    end
  end
end

Draw:Sync(function(draw)
  px, py, pz = ObjectPosition("player")
  tx, ty, tz = ObjectPosition("target")
  local playerHeight = ObjectHeight("player")
  local playerRadius = ObjectBoundingRadius("player")
  local targetRadius = ObjectBoundingRadius("target")
  local targetReach = ObjectCombatReach("target")
  local combatReach = ObjectCombatReach("player")
  local drawclass = UnitClass("target") 
  --draw:SetColor(draw.colors.white)
  --draw:Circle(px, py, pz, playerRadius)
  --draw:Circle(px, py, pz, combatReach)

  local rotation = ObjectRotation("player")
  --local rx, ry, rz = RotateVector(px, py, pz, rotation, playerRadius);

  --draw:Line(px, py, pz, rx, ry, rz)

  if UnitExists("target") and UnitCanAttack("player","target") and not UnitIsDeadOrGhost("target") then
    local targetrotation = ObjectRotation("target")
    local fx, fy, fz = RotateVector(tx, ty, tz, (targetrotation+math.pi), 2)
    local xx, xy, xz = RotateVector(tx, ty, tz, (targetrotation+math.pi/2), 1)
    local vx, vy, vz = RotateVector(tx, ty, tz, (targetrotation-math.pi/2), 1)
    draw:SetColor(draw.colors.blue)
    draw:Line(tx, ty, tz, xx, xy, xz)
    draw:Line(tx, ty, tz, vx, vy, vz)
    draw:SetColor(draw.colors.yellow)
    draw:Line(tx, ty, tz, fx, fy, fz)
  end

  if UnitExists("target") and drawclass == "Warrior" and UnitCanAttack("player","target") and not UnitIsDeadOrGhost("target") then
    draw:Circle(tx, ty, tz, 5)
    draw:SetColor(draw.colors.red)
    draw:Circle(tx, ty, tz, 8)
  end

  for object in OM:Objects(OM.Types.Player) do
    if UnitCanAttack("player",object) then
      if UnitTargetingUnit(object,"player") then
        ObjectTargetingMe = Object(object)
        local ix, iy, iz = ObjectPosition(object)
        if distanceto(object) <= 8 then
          draw:SetColor(0,255,0)
        end
        if distanceto(object) >= 8 and distanceto(object) <= 30 then
          draw:SetColor(199,206,0)            
        end
        if distanceto(object) >= 30 then
          draw:SetColor(255,0,0)
        end 
        draw:Line(px,py,pz,ix,iy,iz,4,55)  
      end
    end
  --end

  --for object in OM:Objects(OM.Types.Player) do
    if UnitCanAttack("player",object) then
    local tx, ty, tz = ObjectPosition(object)
    local dist = distanceto(object)
    local health = UnitHealth(object)
    local class = UnitClass(object)
    if distanceto(object) <= 8 then
      draw:SetColor(0,255,0)
    end
    if distanceto(object) >= 8 and distanceto(object) <= 30 then
      draw:SetColor(199,206,0)            
    end
    if distanceto(object) >= 30 then
      draw:SetColor(255,0,0)
    end  

    Draw:Text(round(dist).."y".." ","GameFontNormalSmall", tx, ty+2, tz+3)
    if UnitHealth(object) >= 70 then
      draw:SetColor(0,255,0)
    end
    if UnitHealth(object) >= 30 and UnitHealth(object) <= 70 then
      draw:SetColor(199,206,0)
    end
    if UnitHealth(object) <= 30 then
      draw:SetColor(255,0,0)
    end

    Draw:Text(health.."%","GameFontNormalSmall", tx, ty+2, tz+2)
      if UnitClass(object) == "Warrior" then
        Draw:SetColor(198,155,109)
        Draw:Text(class,"GameFontNormalSmall", tx, ty+2, tz+1)
      elseif UnitClass(object) == "Warlock" then
        Draw:SetColor(135,136,238)
        Draw:Text(class,"GameFontNormalSmall", tx, ty+2, tz+1)
      elseif UnitClass(object) == "Shaman" then
        Draw:SetColor(0,112,221 )
        Draw:Text(class,"GameFontNormalSmall", tx, ty+2, tz+1)
      elseif UnitClass(object) == "Priest" then
        Draw:SetColor(255,255,255)
        Draw:Text(class,"GameFontNormalSmall", tx, ty+2, tz+1)
      elseif UnitClass(object) == "Mage" then
        Draw:SetColor(63,199,235)
        Draw:Text(class,"GameFontNormalSmall", tx, ty+2, tz+1)
      elseif UnitClass(object) == "Hunter" then
        Draw:SetColor(170,211,114)
        Draw:Text(class,"GameFontNormalSmall", tx, ty+2, tz+1)
      elseif UnitClass(object) == "Paladin" then
        Draw:SetColor(244,140,186 )
        Draw:Text(class,"GameFontNormalSmall", tx, ty+2, tz+1)
      elseif UnitClass(object) == "Rogue" then
        Draw:SetColor(255,244,104)
        Draw:Text(class,"GameFontNormalSmall", tx, ty+2, tz+1)
      elseif UnitClass(object) == "Druid" then
        Draw:SetColor(255,124,10)
        Draw:Text(class,"GameFontNormalSmall", tx, ty+2, tz+1)
      end
    end
  end
end)

local function Debug(spellid,text)
  if (lastdebugmsg ~= message or lastdebugtime < GetTime()) then
    local _, _, icon = GetSpellInfo(spellid)
    lastdebugmsg = message
    lastdebugtime = GetTime() + 2
    RaidNotice_AddMessage(RaidWarningFrame, "|T"..":0|t"..text, ChatTypeInfo["RAID_WARNING"],1)
    return true
  end
  return false
end

local playerGUID = UnitGUID("player")
local f = CreateFrame("Frame")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
f:SetScript("OnEvent", function(self, event)
  self:COMBAT_LOG_EVENT_UNFILTERED(CombatLogGetCurrentEventInfo())
  end)

local t = CreateFrame("Frame")
t:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
t:RegisterEvent("PLAYER_TARGET_CHANGED")

local function LogEvent(self, event, ...)
  if event == "COMBAT_LOG_EVENT_UNFILTERED" or event == "COMBAT_LOG_EVENT" then
    self:LogEvent_Original(event, CombatLogGetCurrentEventInfo())
  elseif event == "COMBAT_TEXT_UPDATE" then
    self:LogEvent_Original(event, (...), GetCurrentCombatTextEventInfo())
  else
    self:LogEvent_Original(event, ...)
  end
end

local function OnEventTraceLoaded()
  EventTrace.LogEvent_Original = EventTrace.LogEvent
  EventTrace.LogEvent = LogEvent
end

if EventTrace then
  OnEventTraceLoaded()
else
  local frame = CreateFrame("Frame")
  frame:RegisterEvent("ADDON_LOADED")
  frame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" and (...) == "Blizzard_EventTrace" then
      OnEventTraceLoaded()
      self:UnregisterAllEvents()
    end
  end)
end

Routine:RegisterRoutine(function()
  local mana = (UnitPower("player") / UnitPowerMax("player")) * 100
  local inInstance, instanceType = IsInInstance()

  function isProtected(unit)
    if buff(1020,unit) or debuff(12826,unit) or buff(45438,unit) or buff(642,unit) or buff(1022,unit) or debuff(33786,unit) then 
      return true 
    end
  end

  function isNova(unit)
  if debuff(122,unit) or debuff(33395,unit) or debuff(12494,unit) or debuff(27088,unit) then
    return true end
  end

  function isRooted(unit)
    if debuff(26989,unit) then
      return true end
    end

  --if gcd() > (latency()*5) then return end

  if UnitIsDeadOrGhost("player") or isProtected("target") then return end
  
  _G.QueuePriestCast = function(_spell, _target)
    table.insert(_G.PriestSpellQueue, {spell=_spell, target=_target})
  end

  local function GetAggroRange(unit)
    local range = 0
    local playerlvl = UnitLevel("player")
    local targetlvl = UnitLevel(unit)
    range = 20 - (playerlvl - targetlvl) * 1
    if range <= 5 then
      range = 10
    elseif range >= 45 then
      range = 45
    elseif UnitReaction("player", unit) >= 4 then
      range = 10
    end
    return range +2
  end
  function AoeHasDebuff(spell,range)
    local count = 0
    for object in OM:Objects(OM.Types.Units) do
      if UnitAffectingCombat(object) and UnitCanAttack("player",object) and not UnitIsDeadOrGhost(object) and ObjectDistance("player",object) <= range then
        local isTanking, status, threatpct, rawthreatpct, threatvalue = UnitDetailedThreatSituation("player", object)
        if threatvalue and threatvalue > 0 then
          if debuff(spell,object) then
            count = count + 1
          end
        end
      end
    end
    return count
  end
  local function GetFinisherMaxDamage(ID)
    local function GetStringSpace(x, y)
      for i = 1, 7 do
        if string.sub(x, y + i, y + i) then
          if string.sub(x, y + i, y + i) == " " then
            return i
          end
        end
      end
    end
    local f = GetSpellDescription(ID)
    local _, a, b, c, d, e = strsplit("\n", f)
    local aa, bb, cc, dd, ee = string.find(a, "%-"), string.find(b, "%-"), string.find(c, "%-"), string.find(d, "%-"), string.find(e, "%-")
    return tonumber(string.sub(a, aa + 1, aa + GetStringSpace(a, aa))), tonumber(string.sub(b, bb + 1, bb + GetStringSpace(b, bb))), tonumber(string.sub(c, cc + 1, cc + GetStringSpace(c, cc))), tonumber(string.sub(d, dd + 1, dd + GetStringSpace(d, dd))), tonumber(string.sub(e, ee + 1, ee + GetStringSpace(e, ee)))
  end

  local function manacost(spellname)
    if not spellname then
      return 0
    else
      local costTable = GetSpellPowerCost(spellname)
      if costTable == nil then
        return 0
      end
      for _, costInfo in pairs(costTable) do
        if costInfo.type == 0 then
          return costInfo.cost
        end
      end
    end
  end

  local function GetSpellEffect(spellID)
    local spell_effect_cache = {}
    if not spellID then return end
    if spell_effect_cache[spellID] then return spell_effect_cache[spellID] end
    local desc = GetSpellDescription(spellID);
    local blocks = {};
    for n in desc:gmatch("%S+") do
      table.insert(blocks,n);
    end
    local good = {}
    for i=1,#blocks do
      local s = string.gsub(blocks[i],",","");
      table.insert(good,s);
    end
    local reallygood={};
    for i=1,#good do if tonumber(good[i]) then table.insert(reallygood,tonumber(good[i])); end end
    table.sort(reallygood, function(x,y) return x > y end)
    spell_effect_cache[spellID] = reallygood[1]
    return reallygood[1]
  end
  local function IsFacing(Unit, Other)
    local SelfX, SelfY, SelfZ = ObjectPosition(Unit)
    local SelfFacing = ObjectRotation(Unit)
    local OtherX, OtherY, OtherZ = ObjectPosition(Other)
    local Angle = SelfX and SelfY and OtherX and OtherY and SelfFacing and ((SelfX - OtherX) * math.cos(-SelfFacing)) - ((SelfY - OtherY) * math.sin(-SelfFacing)) or 0
    return Angle < 0
  end
  local function IsBehind(Unit, Other)
    if not IsFacing(Unit, Other) then
      return true
    else return false
    end
  end
  local function IsPoisoned(unit)
    unit = unit or "player"
    for i=1,30 do
      local debuff,_,_,debufftype = UnitDebuff(unit,i)
      if not debuff then break end
      if debufftype == "Poison" then
        return debuff
      end
    end
  end

  local function isDotted(unit)
  unit = unit or "player"
  for i=1,30 do
    local debuff,_,_,debufftype = UnitDebuff(unit,i)
    if not debuff then break end
      if debufftype == "Disease" or debufftype == "Curse" or debufftype == "Bleed" or debufftype == "Magic" then
        return debuff
      end
    end
  end

  local function isCursed(unit)
  unit = unit or "player"
  for i=1,30 do
    local debuff,_,_,debufftype = UnitDebuff(unit,i)
    if not debuff then break end
      if debufftype == "Curse" then
        return debuff
      end
    end
  end

  local function isDiseased(unit)
  unit = unit or "player"
  for i=1,30 do
    local debuff,_,_,debufftype = UnitDebuff(unit,i)
    if not debuff then break end
      if debufftype == "Disease" then
        return debuff
      end
    end
  end

  local function isMagic(unit)
  unit = unit or "player"
  for i=1,30 do
    local debuff,_,_,debufftype = UnitDebuff(unit,i)
    if not debuff then break end
      if debufftype == "Magic" then
        return debuff
      end
    end
  end

  local function isCasting(Unit)
    local name  = UnitCastingInfo(Unit);    
    if name then
      return true
    else return false
    end
  end

  local function isChanneling(Unit)
    local name  = UnitChannelInfo(Unit);    
    if name then
      return true
    end
  end

  local function UnitTargetingUnit(unit1,unit2)
    if UnitIsVisible(UnitTarget(unit1)) and UnitIsVisible(unit2) then
      if UnitGUID(UnitTarget(unit1)) == UnitGUID(unit2) then
        return true
      end
    end
  end

  local function isElite(unit)
    local classification = UnitClassification(unit)
    if classification == "elite" or classification == "rareelite" or classification == "worldboss" then
      return true
    end
  end


  local function Queue()
    if #_G.PriestSpellQueue > 0 then
      local current_spell = _G.PriestSpellQueue[1]
      table.remove(_G.PriestSpellQueue, 1)
      if UnitExists(current_spell.target) and not UnitIsDeadOrGhost(current_spell.target) and distancecheck(current_spell.target, current_spell.spell) and not isProtected(current_spell.target) then
        print("doing manual override spells")        
        return cast(current_spell.spell, current_spell.target)
      else
        print("manual cast was on invalid target. skipped")
      end
    end
  end

  function f:COMBAT_LOG_EVENT_UNFILTERED(...)
    local timestamp, subevent, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _ = ...
    local spellId, spellName, spellSchool
    --local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand

--[[
    if subevent == "SPELL_CAST_SUCCESS" then
      local spellId, spellName, _, _, _, _, _, _, _, _, _, _, _ = select(12, ...)
      local myname = UnitName("player")
      if spellName == "Vanish" and (sourceName ~= myname) then
        for object in OM:Objects(OM.Types.Player) do
          if castable(DireBearForm) and not castable(Prowl,"player") and not buff(Prowl,"player") and distance(object,"player") <= 20 then
            Debug(1856,"Bearform to avoid Rogue opener")
            return return cast(DireBearForm)
          end
        end
      end
      if spellName == "Summon Water Elemental" and instanceType ~= "arena" and wowex.wowexStorage.read("fap") then
        for object in OM:Objects(OM.Types.Player) do
          if sourceName == ObjectName(object) then
            if distance("player",object) <= 30 and UnitCanAttack("player",object) and GetItemCooldown(5634) == 0 and UnitTargetingUnit(object,"player") and not buff(6615,"player") and not buff(Stealth,"player") and not mounted() then
              Eval('RunMacroText("/use Free Action Potion")', 'player')
            end
          end
        end
      end
    end
]]
    if subevent == "SPELL_CAST_START" then
      local spellId, spellName, _, _, _, _, _, _, _, _, _, _, _ = select(12, ...)
      if spellName == "Fear" or spellName == "Polymorph" or spellName == "Regrowth" or spellName == "Cyclone" or spellName == "Greater Heal" or spellName == "Flash Heal" or spellname == "Healing Wave" or spellname == "Binding Heal" or spellName == "Mana Burn" or spellName == "Drain Mana" or spellName == "Holy Light" then
          if health("target") <= 80 then
            for object in OM:Objects(OM.Types.Player) do
              if sourceName == ObjectName(object) then
                if UnitCanAttack("player",object) then
                  if distance("player",object) > 8 then
                    if castable(Silence,object) and cooldown(Silence) == 0 and distance("player",object) <= 25 and not UnitTargetingUnit("player",object) then
                      if not isProtected(object) then
                        silencetarget = Object(object)
                        FaceObject(object)
                        Debug(38768,"Silence on " .. ObjectName(object))
                        return cast(Silence,"player")
                      end
                    end
                  end
                end
              end
            end
          end
      end
      if spellName == "Entangling Roots" and destName == myname and instanceType ~= "arena" and wowex.wowexStorage.read("fap") then
        if GetItemCooldown(5634) == 0 and not buff(6615,"player") and not mounted() then
          Eval('RunMacroText("/use Free Action Potion")', 'player')
        end
      end
    end
  end

  function t:UNIT_SPELLCAST_SUCCEEDED()
    t:SetScript("OnEvent", function(self, event, arg1, arg2, arg3)
      trinketUsedBy = nil
      if event == "UNIT_SPELLCAST_SUCCEEDED" then
        if arg3 == 42292 then
          if UnitCanAttack("player",arg1) and distance("player",arg1) <= 20 then
            trinketUsedBy = Object(arg1)
            Debug(42292,"Trinket used by " .. ObjectName(trinketUsedBy))
          end
        end
      end
      if event == "PLAYER_TARGET_CHANGED" and UnitAffectingCombat("player") then 
        for hunter in OM:Objects(OM.Types.Player) do
          if distance("player",hunter) <= 10 then
            if UnitClass(hunter) == "Hunter" then
              if UnitCanAttack("player",hunter) then
                if buff(5384,hunter) then
                  FaceObject(hunter)
                  TargetUnit(hunter)
                  Debug(5384,"Re-targeting Huntard")
                  break
                end
              end
            end
          end
        end
      end
    end)
  end

  local function Loot()
    if wowex.wowexStorage.read('autoloot') then
      for i, object in ipairs(Objects()) do
        if ObjectLootable(object) and ObjectDistance("player",object) < 5 and ObjectType(object) == 3 then
          ObjectInteract(object)
        end
      end
      for i = GetNumLootItems(), 1, -1 do
        LootSlot(i)
      end
    end
    return false
  end

  local function IsDungeonBoss(unit)
    unit = unit or "target"
    if IsInInstance() or IsInRaid() then
      local _, _, encountersTotal = GetInstanceLockTimeRemaining()
      for i = 1, encountersTotal do
        local boss = GetInstanceLockTimeRemainingEncounter(i)
        local name = UnitName(unit)
        if name == boss then            
          return true
        end
      end
      return false
    end
  end

  local function Interrupt()
    if UnitAffectingCombat("player") and cooldown(Silence) == 0 then
      for object in OM:Objects(OM.Types.Player) do
        if UnitCanAttack("player",object) then
          local kickclass, _, _ = UnitClass(object)
          if isCasting(object) and kickclass ~= "Hunter" then
            if castable(Silence,object) and not isProtected(object) and (distance("player",object) >= 8 and distance("player",object) <= 25) then
              local _, _, _, _, endTime, _, _, _ = UnitCastingInfo(object);
              local finish = endTime/1000 - GetTime()
              if finish <= 1.5 then
                FaceObject(object)
                Debug(9634, "Silence on " .. UnitName(object) .. " at " .. finish)
                return cast(Silence,object)
              end
            end  
          elseif isChanneling(object) and kickclass ~= "Hunter" then
            if castable(Silence,object) and not isProtected(object) and (distance("player",object) >= 8 and distance("player",object) <= 25) then
              FaceObject(object)
              Debug(9634, "Silence on  " .. UnitName(object) .. " fast ")
              return cast(Silence,object)
            end
          end
        end
      end
    end
  end 

  local function Opener()
    if UnitCanAttack("player","target") and distance("player","target") <= 34 and not UnitIsDeadOrGhost("target") then
      if castable(MindBlast,"target") then
        return cast(MindBlast,"target")
      end
    end
  end

  local function Dot() -- off-target dotting
    if UnitAffectingCombat("player") and not mounted() and not UnitIsDeadOrGhost("target") and mana >= 50 then
      for object in OM:Objects(OM.Types.Units) do
        if UnitCanAttack("player",object) and UnitTargetingUnit(object,"player") and distance("player",object) <= 30 and not UnitTargetingUnit("player",object) then
          if IsAutoRepeatAction(1) then 
            Debug(8092,"Stopping wand to DOT")
            Eval('RunMacroText("/stopcasting")', 'player')
          end
          if castable(ShadowWordPain,"target") and not debuff(ShadowWordPain,"target") and health("target") >= 10 and not IsAutoRepeatAction(1) then
            return cast(ShadowWordPain,"target")
          end
          if castable(DevouringPlague,"target") and not debuff(DevouringPlague,"target") and not IsAutoRepeatAction(1) and not immune("target",DevouringPlague) and health("target") >= 50 then
            return cast(DevouringPlague,"target")
          end
        end
      end
    end
  end

  local function Cooldowns()
    if UnitExists("target") and UnitCanAttack("player","target") and UnitAffectingCombat("player") and not mounted() then
      if castable(PsychicScream) and (enemiesAround("player", 10) >= 3 or (UnitIsPlayer("target") and distance("player","target") <= 8)) and instanceType ~= "party" then
        if IsAutoRepeatAction(1) then 
          Debug(8092,"Stopping wand to scream")
          Eval('RunMacroText("/stopcasting")', 'player')
          return cast(PsychicScream,"target")
        else
          return cast(PsychicScream,"target")
        end
      end
    end
  end

  local function Healing()
      --*ic
      --[[if UnitAffectingCombat("player") and (health("target") >= 30 or health() <= 30) and instanceType ~= "party" and not IsEatingOrDrinking("player") then
        if health() <= 60 and IsAutoRepeatAction(1) and ((UnitPower("player") >= manacost(PowerWordShield)) or (UnitPower("player") >= manacost(Renew)) or (UnitPower("player") >= manacost(FlashHeal))) then
          Debug(8092,"Stopping wand to heal")
          Eval('RunMacroText("/stopcasting")', 'player')
        end
        if health() <= 50 then
          Eval('RunMacroText("/use Healing Potion")', 'player')
        end
        if castable(PowerWordShield,"player") and health() <= 90 and not debuff(WeakenedSoul,"player") and not buff(PowerWordShield,"player") and not IsAutoRepeatAction(1) and UnitTargetingUnit("target","player") then
          return cast(PowerWordShield,"player")
        end
        if castable(Renew,"player") and not buff(Renew,"player") and health() <= 60 then
          return cast(Renew,"player")
        end
        if castable(FlashHeal,"player") and health() <= 60 and not moving() and not isCasting("player") then
          return cast(FlashHeal,"player")
        end
      ]]
      if UnitAffectingCombat("player") and not IsEatingOrDrinking("player") and health("target") >= 20 then -- in combat
        for object in OM:Objects(OM.Types.Players) do
          if not UnitCanAttack("player",object) and UnitIsPlayer(object) and distance("player",object) <= 40 and UnitInParty(object) then -- if friendly party player in range
          -- priotise tank
            if instanceType == "party" then
              if castable(PowerWordShield,tank()) and not debuff(WeakenedSoul,tank()) and not buff(PowerWordShield,tank()) and health(tank()) <= 90 then
                return cast(PowerWordShield,tank())
              end
              if castable(Renew,tank()) and not buff(Renew,tank()) and health(tank()) <= 85 then
                return cast(Renew,tank())
              end
              if castable(FlashHeal,tank()) and health(tank()) <= 40 and not moving() and not isCasting("player") then
                return cast(FlashHeal,tank())
              end
              if castable(Heal,tank()) and health(tank()) <= 60 and not moving() and not isCasting("player") then
                return cast(Heal,tank())
              end
              if castable(LesserHeal,tank()) and health(tank()) <= 70 and not moving() and not isCasting("player") then
                return cast(LesserHeal,tank())
              end
              if castable(596,tank()) and partyhealth(tank(), 30) < 80 and partyMembersAround(tank(), 30) >= 3 and not moving() and not isCasting("player") then -- prayer of healing
                return cast(596,tank())
              end
              if isDiseased(tank()) and castable(CureDisease,tank()) then
                return cast(CureDisease,tank())
              end
              if isMagic(tank()) and castable(DispelMagic,tank()) then
                return cast(DispelMagic,tank())
              end
              if castable(PowerWordShield,object) and not debuff(WeakenedSoul,object) and not buff(PowerWordShield,object) and health(object) <= 90 then
                return cast(PowerWordShield,object)
              end
              if castable(Renew,object) and not buff(Renew,object) and health(object) <= 85 then
                return cast(Renew,object)
              end
              if castable(FlashHeal,object) and health(object) <= 40 and not moving() and not isCasting("player") then
                return cast(FlashHeal,object)
              end
              if castable(Heal,object) and health(object) <= 60 and not moving() and not isCasting("player") then
                return cast(Heal,object)
              end
              if castable(LesserHeal,object) and health(object) <= 70 and not moving() and not isCasting("player") then
                return cast(LesserHeal,object)
              end
              if castable(596,object) and partyhealth(object, 30) < 80 and partyMembersAround(object, 30) >= 3 and not moving() and not isCasting("player") then -- prayer of healing
                return cast(596,object)
              end
              if isDiseased(object) and castable(CureDisease,object) then
                return cast(CureDisease,object)
              end
              if isMagic(object) and castable(DispelMagic,object) then
                return cast(DispelMagic,object)
              end
            else -- not in a dungeon
              if health() <= 60 and IsAutoRepeatAction(1) and ((UnitPower("player") >= manacost(PowerWordShield)) or (UnitPower("player") >= manacost(Renew)) or (UnitPower("player") >= manacost(FlashHeal))) then
                Debug(8092,"Stopping wand to heal")
                Eval('RunMacroText("/stopcasting")', 'player')
              end
              if health() <= 50 then
                Eval('RunMacroText("/use Healing Potion")', 'player')
              end
              if castable(PowerWordShield,object) and not debuff(WeakenedSoul,object) and not buff(PowerWordShield,object) and health(object) <= 90 and not IsAutoRepeatAction(1) and UnitTargetingUnit("target",object) then
                return cast(PowerWordShield,object)
              end
              if castable(Renew,object) and not buff(Renew,object) and health(object) <= 85 then
                return cast(Renew,object)
              end
              if castable(FlashHeal,object) and health(object) <= 40 and not moving() and not isCasting("player") then
                return cast(FlashHeal,object)
              end
              if castable(Heal,object) and health(object) <= 60 and not moving() and not isCasting("player") then
                return cast(Heal,object)
              end
              if castable(LesserHeal,object) and health(object) <= 70 and not moving() and not isCasting("player") then
                return cast(LesserHeal,object)
              end
              if isDiseased(object) and castable(CureDisease,object) then
                return cast(CureDisease,object)
              end
              if isMagic(object) and castable(DispelMagic,object) then
                return cast(DispelMagic,object)
              end
            end
          end
        end
      end
      --*ooc
      if not UnitAffectingCombat("player") and not IsEatingOrDrinking("player") then -- if not in combat, heal everyone
        for object in OM:Objects(OM.Types.Players) do
          if not UnitCanAttack("player",object) and UnitIsPlayer(object) and distance("player",object) <= 40 and not isCasting("player") then -- if friendly player in range
            if UnitIsDeadOrGhost(object) then
              return cast(Resurrection,object)
            end
            if castable(Renew,object) and not buff(Renew,object) and health(object) <= 80 then
              return cast(Renew,object)
            end
            if castable(Heal,object) and health() <= 30 and not moving() then
              return cast(Heal,object)
            end
            if castable(LesserHeal,object) and health() <= 60 and not moving() then
              return cast(LesserHeal,object)
            end
            if isDiseased(object) and castable(AbolishDisease,object) then
              return cast(AbolishDisease,object)
            end
            if isMagic(object) and castable(DispelMagic,object) then
              return cast(DispelMagic,object)
            end
          end
        end
      end
  end
  local function Dps()
    if UnitAffectingCombat("player") and UnitCanAttack("player","target") and not UnitIsDeadOrGhost("target") then
      if (cooldown(MindBlast) <= 1.5 and IsAutoRepeatAction(1) and health("target") >= 65) and (UnitPower("player") >= manacost(MindBlast) or UnitPower("player") >= manacost(ShadowWordPain)) then
        Debug(8092,"Stopping wand to mind blast")
        Eval('RunMacroText("/stopcasting")', 'player')
      end
      if castable(MindBlast,"target") and not moving() and not IsAutoRepeatAction(1) then
        return cast(MindBlast,"target")
      end
      if castable(DevouringPlague,"target") and not debuff(DevouringPlague,"target") and (health() <= 95 or UnitIsPlayer("target")) and not IsAutoRepeatAction(1) and not immune("target", DevouringPlague) and health("target") >= 50 then
        return cast(DevouringPlague,"target")
      end
      if castable(VampiricEmbrace,"target") and not buff(VampiricEmbrace,"target") --[[and (health() <= 95 or UnitIsPlayer("target"))]] and not IsAutoRepeatAction(1) and health("target") >= 50 and UnitTargetingUnit("target","player") then
        return cast(VampiricEmbrace,"target")
      end
      if castable(ShadowWordPain,"target") and not debuff(ShadowWordPain,"target") and health("target") >= 10 and not IsAutoRepeatAction(1) then
        return cast(ShadowWordPain,"target")
      end
      if castable(MindFlay,"target") and not moving() and UnitIsPlayer("target") and not isChanneling("player") then
        return cast(MindFlay,"target")
      end
    end
  end

  local function Buff()
    if not UnitAffectingCombat("player") and not IsEatingOrDrinking("player") then
      for object in OM:Objects(OM.Types.Players) do
        if not UnitCanAttack("player",object) and UnitIsPlayer(object) and distance("player",object) <= 40 --[[and (mana >= 50 or UnitInParty(object))]] then -- if friendly player in range
          if castable(PowerWordFortitude,object) and not buff(PowerWordFortitude,object) then
            return cast(PowerWordFortitude,object)
          end
          if castable(ShadowProtection,object) and not buff(ShadowProtection,object) then
            return cast(ShadowProtection,object)
          end
          if castable(InnerFire,"player") and not buff(InnerFire,"player") then
            return cast(InnerFire,"player")
          end
          if castable(2652,"player") and not buff(2652,"player") and mana >= 90 then -- touch of weakness Rank 1
            return cast(2652,"player")
          end
        end
      end
    end
  end

  local function pvp()

    if IsFalling("player") then
      return cast(Levitate,"player")
    end

    if instanceType == "pvp" then
      for flag in OM:Objects(OM.Types.GameObject) do
        if ObjectID(flag) == 328418 or ObjectID(flag) == 328416 or ObjectID(flag) == 367128 then
          if distance("player",flag) <= 5 then  
            InteractUnit(flag)
          end
        elseif ObjectID(flag) == 183511 then
          if GetItemCount(22103) == 0 then
            if distance("player",flag) <= 5 then
              InteractUnit(flag)
            end
          end
        elseif ObjectID(flag) == 183512 then
          if GetItemCount(22104) == 0 then 
            if distance("player",flag) <= 5 then
              InteractUnit(flag)
            end 
          end
        elseif ObjectID(flag) == 181621 then
          if GetItemCount(22105) == 0 then 
            if distance("player",flag) <= 5 then
              InteractUnit(flag)
            end
          end
        end
      end
    end
  end

  local function healthstone()
    local healthstonelist = {22103, 22104, 22105, 5511}
    if health() <= 40 and UnitAffectingCombat("player") then
      for i = 1, #healthstonelist do
        if GetItemCount(healthstonelist[i]) >= 1 and GetItemCooldown(healthstonelist[i]) == 0 then
          local healthstonename = GetItemInfo(healthstonelist[i])
          Eval('RunMacroText("/use ' .. healthstonename .. '")', 'player')
          Debug(22103,"Healthstone used!!")
        end
      end
    end
  end

  local function Dismounter()
    if UnitIsPlayer(ObjectTargetingMe) and distance("player",ObjectTargetingMe) <= 45 and not (buff(301089,"target") or buff(301091,"target") or buff(34976,"target")) then
      Dismount()
    end
  end

  local function PreCombat()
    if UnitExists("target") and not IsEatingOrDrinking("player") and distance("player","target") <= 45 and not UnitIsDeadOrGhost("target") and not UnitAffectingCombat("player") and UnitCanAttack("player","target") and not melee() and not (buff(301089,"target") or buff(301091,"target") or buff(34976,"target")) then
      if castable(PowerWordShield,"player") and not debuff(WeakenedSoul,"player") and not buff(PowerWordShield,"player") then
        return cast(PowerWordShield,"player")
      end
      if castable(2652,"player") and not buff(2652,"player") then -- touch of weakness Rank 1
        return cast(2652,"player")
      end
    end
  end

  local function wand()
    if UnitAffectingCombat("player") and UnitCanAttack("player","target") and not UnitIsDeadOrGhost("target") and instanceType ~= "party" then
      if cooldown(MindBlast) >= 1.5 and (debuff(ShadowWordPain,"target") or health("target") <= 20) and health() >= 60 and not IsAutoRepeatAction(1) and not isCasting("player") and distance("player","target") <= 30 and not moving() and not UnitIsPlayer("target") then
        FaceObject("target")
        Debug(8092,"STARTING wand")
        return cast(5019,"target")
        --return Eval('RunMacroText("/cast !Shoot")', 'player')
      elseif ((UnitPower("player") <= manacost(MindBlast)) and (UnitPower("player") <= manacost(ShadowWordPain))) and ((health() >= 60) or ((UnitPower("player") <= manacost(PowerWordShield)) and (UnitPower("player") <= manacost(Renew)) and (UnitPower("player") <= manacost(LesserHeal)))) and not IsAutoRepeatAction(1) and not isCasting("player") and distance("player","target") <= 30 and not moving() then
        Debug(8092,"NOTHING TO DO, STARTING wand") 
        return cast(5019,"target")     
        --return Eval('RunMacroText("/cast !Shoot")', 'player')
      end
    end
  end

  local function OutOfCombat()
    if not UnitAffectingCombat("player") then
      if Queue() then return true end
      --if Loot() then return true end
      if Healing() then return true end
      if Buff() then return true end
      if PreCombat() then return true end
      if Opener() then return true end
      if pvp() then return true end
      if Dismounter() then return true end
    end
    return false
  end
  local function Incombat()
    if UnitAffectingCombat("player") then
      if Queue() then return true end
      if Cooldowns() then return true end     
      if Healing() then return true end
      if Dps() then return true end
      if Interrupt() then return true end
      if Dot() then return true end
      if pvp() then return true end
      if healthstone() then return true end
      if Dismounter() then return true end
      if wand() then return true end
      if f:COMBAT_LOG_EVENT_UNFILTERED() then return true end
      if t:UNIT_SPELLCAST_SUCCEEDED() then return true end
    end
    return false
  end  
  if OutOfCombat() then return true end
  if Incombat() then return true end
  
end, Routine.Classes.Priest, Routine.Specs.Priest)
Routine:LoadRoutine(Routine.Specs.Priest)

local mytable = {
  key = "cromulon_config",
  name = "Rebecca Feral Tbc",
  height = 650,
  width = 400,
  panels = 
  {
    { 
      name = "Offensive",
      items = 
      {
        { key = "heading", type = "text", color = 'FF7C0A', text = "Multiplier = Eviscerate=Attack Power * (Number of Combo Points used * 0.03) * abitrary multiplier to account for Auto Attacks while pooling Recommendation : <= 60 == 1.6 >= 60 == 1.4" },
        
        { key = "heading", type = "heading", color = 'FF7C0A', text = "Execute" },
        { key = "personalmultiplier", type = "slider", text = "Execute Multiplier", label = "Execute Multiplier", min = 1, max = 3, step = 0.1 },
        { key = "heading", type = "heading", color = 'FF7C0A', text = "Opener" },
        { key = "openerfrontal", width = 175, label = "Frontal", text = wowex.wowexStorage.read("openerfrontal"), type = "dropdown",
        options = {"Pounce", "None",} },
        { key = "openerbehind", width = 175, label = "Behind", text = wowex.wowexStorage.read("openerbehind"), type = "dropdown",
        options = {"Ravage", "Pounce","None"} },
        --{ key = "pershealwavepercent", type = "slider", text = "Healing Wave", label = "Healing Wave at", min = 1, max = 100, step = 1 },
        
      },
    },
    { 
      name = "Defensives",
      items = 
      {
        { key = "heading", type = "heading", color = 'FF7C0A', text = "In Combat Healing" },
        { key = "heading", type = "heading", color = 'FF7C0A', text = "Rejuvenation" },
        { key = "rejuvichp", type = "slider", text = "", label = "Rejuvenation at", min = 1, max = 100, step = 1 },
        { key = "heading", type = "heading", color = 'FF7C0A', text = "Healing Touch" },
        { key = "healingtouchichp", type = "slider", text = "", label = "Healing Touch at", min = 0, max = 100, step = 1 },
        { key = "heading", type = "heading", color = 'FF7C0A', text = "Regrowth" },
        { key = "regrowthichp", type = "slider", text = "", label = "Regrowth at", min = 0, max = 100, step = 1 },
        { key = "heading", type = "heading", color = 'FF7C0A', text = "Out of Combat Healing" },
        { key = "heading", type = "heading", color = 'FF7C0A', text = "Rejuvenation" },
        { key = "rejuvoochp", type = "slider", text = "", label = "Rejuvenation at", min = 1, max = 100, step = 1 },
        { key = "heading", type = "heading", color = 'FF7C0A', text = "Healing Touch" },
        { key = "healingtouchoochp", type = "slider", text = "", label = "Healing Touch at", min = 0, max = 100, step = 1 },
        { key = "heading", type = "heading", color = 'FF7C0A', text = "Regrowth" },
        { key = "regrowthoochp", type = "slider", text = "", label = "Regrowth at", min = 0, max = 100, step = 1 },
        
      }
    },
    { 
      name = "General",
      items = 
      {
        { key = "heading", type = "heading", color = 'FF7C0A', text = "Stealth" },
        {type = "text", text = "DynOM = Scans the area around you for NPC aggro ranges and puts you into stealth when you get close to them.", color = 'FF7C0A'},
        {type = "text", text = "DynTarget = Stealthes you when you're near your TARGET's aggro range.", color = 'FF7C0A'},       
        { key = "stealthmode", width = 175, label = "Stealth Mode", text = wowex.wowexStorage.read("stealthmode"), type = "dropdown",
        options = {"DynOM", "DynTarget",} },
        
        { key = "heading", type = "heading", color = 'FF7C0A', text = "Other" },
        { key = "autoloot",  type = "checkbox", text = "Auto Loot", desc = "" },
        
      }
    },
    { 
      name = "Draw",
      items = 
      {
        --  { key = "bladeflurrydraw",  type = "checkbox", text = "BladeFlurry Range", desc = "" },
        --  { key = "targetingusdraw",  type = "checkbox", text = "Players targeting us", desc = "" },
        --  {type = "text", text = "Red: >= 30y yellow: <= 30y green: <= 8y", color = 'FFF468'},
        { key = "pvpdraw",  type = "checkbox", text = "PvP Radar", desc = "" },
        
      }
    },
  },
  
  tabgroup = 
  {
    {text = "Offensive", value = "one"},
    {text = "Defensives", value = "two"},
    {text = "General", value = "three"},
    {text = "Draw", value = "four"}
    
  }
}
Draw:Enable()
wowex.createpanels(mytable)
wowex.panel:Hide()     