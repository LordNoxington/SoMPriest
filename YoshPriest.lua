
local Tinkr = ...
local wowex = {}
local Routine = Tinkr.Routine
local Util = Tinkr.Util
local Draw = Tinkr.Util.Draw:New()
local OM = Tinkr.Util.ObjectManager
local lastdebugmsg = ""
local lastdebugtime = 0
local bufftimer = 0 
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
  local targetmana = (UnitPower("target") / UnitPowerMax("target")) * 100
  local inInstance, instanceType = IsInInstance()
  local targetclass = UnitClass("target")
  local race = UnitRace("player")

  function isProtected(unit)
    if buff(1020,unit) or debuff(12826,unit) or buff(45438,unit) or buff(642,unit) or buff(1022,unit) or debuff(33786,unit) then 
      return true 
    end
  end

  function isReflecting(unit)
    if buff(23132,unit) then
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

  if UnitIsDeadOrGhost("player") or isProtected("target") or isReflecting("target") or IsEatingOrDrinking("player") or UnitIsDeadOrGhost("target") then return end
  
  if wowex.wowexStorage.read("alwaysface") then
    if instanceType == "pvp" and UnitExists("target") and distance("player","target") <= 30 and cansee("player","target") then
      FaceObject("target")
    end
  end

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

  local function isMagicBuff(unit)
  unit = unit or "player"
  for i=1,30 do
    local buff,_,_,bufftype = UnitBuff(unit,i)
    if not buff then break end
      if bufftype == "Magic" then
        return buff
      end
    end
  end

  local function SpellCooldown(spellID)
  start, duration, enabled = GetSpellCooldown(spellID)
    return duration
  end

  local function isCasting(Unit)
    local name = UnitCastingInfo(Unit);    
    if name then
      return true
    else return false
    end
  end

  local function isChanneling(Unit)
    local name = UnitChannelInfo(Unit);    
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


    if subevent == "SPELL_CAST_SUCCESS" then
      local spellId, spellName, _, _, _, _, _, _, _, _, _, _, _ = select(12, ...)
      local myname = UnitName("player")
      if spellName == "Nature's Swiftness" then
        for object in OM:Objects(OM.Types.Player) do
          if castable(Silence,object) and distance(object,"player") <= 20 and not debuff(15487,"target") then
            Eval('RunMacroText("/stopcasting")', 'player')
            return cast(Silence,object)
          end
        end
      end
      --if spellName == "Summon Water Elemental" and instanceType ~= "arena" and wowex.wowexStorage.read("fap") then
      --  for object in OM:Objects(OM.Types.Player) do
      --    if sourceName == ObjectName(object) then
      --      if distance("player",object) <= 30 and UnitCanAttack("player",object) and GetItemCooldown(5634) == 0 and UnitTargetingUnit(object,"player") and not buff(6615,"player") and not buff(Stealth,"player") and not mounted() then
      --        Eval('RunMacroText("/use Free Action Potion")', 'player')
      --      end
      --    end
      --  end
      --end
    end

    if subevent == "SPELL_CAST_START" then
      local spellId, spellName, _, _, _, _, _, _, _, _, _, _, _ = select(12, ...)
      if spellName == "Fear" or spellName == "Polymorph" or spellName == "Regrowth" or spellName == "Cyclone" or spellName == "Greater Heal" or spellName == "Flash Heal" or spellname == "Healing Wave" or spellname == "Binding Heal" or spellName == "Mana Burn" or spellName == "Drain Mana" or spellName == "Holy Light" then
        --if health("target") <= 80 then
          for object in OM:Objects(OM.Types.Player) do
            if sourceName == ObjectName(object) then
              if UnitCanAttack("player",object) then
                if distance("player",object) > 8 then
                  if castable(Silence) and SpellCooldown(Silence) == 0 and distance("player",object) <= 25 --[[and not UnitTargetingUnit("player",object)]] and not debuff(15487,"target") then
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
        --end
      end
      if spellName == "Entangling Roots" and destName == myname and instanceType ~= "arena" and wowex.wowexStorage.read("fap") then
        if GetItemCooldown(5634) == 0 and not buff(6615,"player") and not mounted() then
          return Eval('RunMacroText("/use Free Action Potion")', 'player')
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
          if distance("player",hunter) <= 30 then
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
    if wowex.wowexStorage.read('autoloot') and not UnitAffectingCombat("player") and not IsEatingOrDrinking("player") then
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

  local function Interrupt()
    if UnitAffectingCombat("player") and not IsEatingOrDrinking("player") and not mounted() then
    if instanceType == "pvp" then
      for object in OM:Objects(OM.Types.Player) do
        if UnitCanAttack("player",object) then
          local kickclass, _, _ = UnitClass(object)
          if isCasting(object) and kickclass ~= "Hunter" then
            if castable(Silence) and not UnitTargetingUnit("player",object) and not isProtected(object) and not debuff(15487,"target") then
              FaceObject(object)
              Debug("Silence off-target instantly ",38768)
              return cast(Silence,object)
            elseif castable(Silence) and UnitTargetingUnit("player",object) and not isProtected(object) and not debuff(15487,"target") then
              local _, _, _, _, endTime, _, _, _ = UnitCastingInfo(object);
              local finish = endTime/1000 - GetTime()
              if finish <= 0.5 and castable(Silence,object) then
                FaceObject(object)
                Debug("Silence " .. UnitName(object) .. " at " .. finish,38768)
                return cast(Silence,object)
              end
            end  
          elseif castable(Silence,object) and isChanneling(object) and kickclass ~= "Hunter" and not debuff(15487,"target") then
            FaceObject(object)
            Debug("Silence " .. UnitName(object) .. " fast ",38768)
            return cast(Silence,object)
          end
        end
      end
    elseif instanceType ~= "pvp" then
      for object in OM:Objects(OM.Types.Unit) do
        if UnitCanAttack("player",object) then
          local kickclass, _, _ = UnitClass(object)
          if isCasting(object) and kickclass ~= "Hunter" then
            if castable(Silence) and not UnitTargetingUnit("player",object) and not isProtected(object) and not debuff(15487,"target") then
              FaceObject(object)
              Debug("Silence off-target instantly ",38768)              
              return cast(Silence,object)
            elseif castable(Silence) and UnitTargetingUnit("player",object) and not isProtected(object) and not debuff(15487,"target") then
              local _, _, _, _, endTime, _, _, _ = UnitCastingInfo(object);
              local finish = endTime/1000 - GetTime()
              if finish <= 0.5 and castable(Silence,object) then
                FaceObject(object)
                Debug("Silence " .. UnitName(object) .. " at " .. finish,38768)
                return cast(Silence,object)
              end
            end  
          elseif castable(Silence) and isChanneling(object) and kickclass ~= "Hunter" and not debuff(15487,"target") then
            FaceObject(object)
            Debug("Silence " .. UnitName(object) .. " fast ",38768)
            return cast(Silence)
          end
        end
      end
    end
    end
  end 

  local function Opener()
    if UnitCanAttack("player","target") and distance("player","target") <= 36 and not UnitIsDeadOrGhost("target") and not IsEatingOrDrinking("player") then
      if castable(MindBlast,"target") and not moving() and cansee("player","target") and not IsStealthed("target") then
        if instanceType ~= "pvp" and castable(InnerFocus,"player") then
          Eval('RunMacroText("/cast Inner Focus")', 'player')
        end
        return cast(MindBlast,"target")
      end
      if castable(ShadowWordPain,"target") and moving() and UnitIsPlayer("target") then
        if (instanceType == "raid" or instanceType == "party") then
          if not UnitAffectingCombat("target") then
            return cast(ShadowWordPain,"target")
          end
        else return cast(ShadowWordPain,"target")
        end
      end
    end
  end

  local function Dot() -- off-target dotting
    if wowex.wowexStorage.read('dotallplayers') then
      if UnitAffectingCombat("player") and not mounted() and not UnitIsDeadOrGhost("target") then
        for object in OM:Objects(OM.Types.Player) do
          if UnitCanAttack("player",object) and distance("player",object) <= 36 and not UnitTargetingUnit("player",object) then
            --if IsAutoRepeatAction(1) then 
            --  Debug(8092,"Stopping wand to DOT")
            --  Eval('RunMacroText("/stopcasting")', 'player')
            --end
            if castable(ShadowWordPain,object) and not debuff(ShadowWordPain,object) and health(object) >= 10 and not IsAutoRepeatAction(1) then
              return cast(ShadowWordPain,object)
            end
          end
        end
      end
    end
    if wowex.wowexStorage.read('multidot') then
      if UnitAffectingCombat("player") and not mounted() and not UnitIsDeadOrGhost("target") then
        for object in OM:Objects(OM.Types.Player) do
          if UnitCanAttack("player",object) and UnitTargetingUnit(object,"player") and distance("player",object) <= 36 and not UnitTargetingUnit("player",object) then
            if IsAutoRepeatAction(1) then 
              Debug(8092,"Stopping wand to DOT")
              Eval('RunMacroText("/stopcasting")', 'player')
            end
            if castable(ShadowWordPain,object) and not debuff(ShadowWordPain,object) and health(object) >= 10 and not IsAutoRepeatAction(1) then
              return cast(ShadowWordPain,object)
            end
          end
        end
      end
    end
    if wowex.wowexStorage.read('multidotunits') then
      if UnitAffectingCombat("player") and not mounted() and not UnitIsDeadOrGhost("target") then
        for object in OM:Objects(OM.Types.Unit) do
          if UnitCanAttack("player",object) and UnitTargetingUnit(object,"player") and distance("player",object) <= 36 and not UnitTargetingUnit("player",object) and not UnitIsPlayer(object) then
            --if IsAutoRepeatAction(1) and not debuff(ShadowWordPain,object) and health(object) >= 10 then 
            --  Debug(8092,"Stopping wand to DOT")
            --  Eval('RunMacroText("/stopcasting")', 'player')
            --end
            if castable(ShadowWordPain,object) and not debuff(ShadowWordPain,object) and health(object) >= 10 then
              return cast(ShadowWordPain,object)
            end
          end
        end
      end
    end
  end

  local function Cooldowns()
    if UnitExists("target") and UnitCanAttack("player","target") and UnitAffectingCombat("player") and not IsEatingOrDrinking("player") and not mounted() then
      if castable(PsychicScream) and (enemiesAround("player", 8) >= 2 or (UnitIsPlayer("target") and health() <= 50 and distance("player","target") <= 8)) and instanceType ~= "party" then
        for object in OM:Objects(OM.Types.Player) do
          if distance("player",object) <= 8 and not buff(18499,object) and not debuff(Silence,object) and not debuff(15269,object) then
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
      if castable(Silence,"target") and not debuff(15487,"target") and health("target") <= 70 and not debuff(PsychicScream,"target") and (targetclass == "Warlock" or targetclass == "Priest" or targetclass == "Paladin" or targetclass == "Mage" or targetclass == "Druid" or targetclass == "Shaman" or (targetclass == "Hunter" and distance("player","target") <= 7)) then
        return cast(Silence,"target")
      end
      if castable(Fade,"player") and not buff(Fade,"player") and (instanceType == "party" or instanceType == "raid" or instanceType == "pvp") then
        for object in OM:Objects(OM.Types.Units) do
          if UnitCanAttack("player",object) and UnitCreatureType(object) ~= "Critter" and not UnitIsPlayer(object) and not UnitIsDeadOrGhost(object) then
            local isTanking, status, threatpct, rawthreatpct, threatvalue = UnitDetailedThreatSituation("player", object)
            if isTanking then
              return cast(Fade,"player")
            end
          end
        end
      end
    end
  end

  local function Healing()
    if wowex.wowexStorage.read("CombatHeals") then
      --In combat healing
      if UnitAffectingCombat("player") and not IsEatingOrDrinking("player") and health("target") >= 10 and not mounted() then -- in combat
        for object in OM:Objects(OM.Types) do
          if not UnitCanAttack("player",object) and UnitIsPlayer(object) and distance("player",object) <= 40 and not UnitIsDeadOrGhost(object) and (UnitInParty(object) or Object("player") == object) then -- if friendly party player in range
          -- priotise tank
            if instanceType == "party" then
              if castable(PowerWordShield,tank()) and not debuff(6788,tank()) and not buff(PowerWordShield,tank()) and health(tank()) <= 70 then
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
              if castable(596,tank()) and partyhealth(tank(), 30) < 75 and partyMembersAround(tank(), 30) >= 3 and not moving() and not isCasting("player") then -- prayer of healing
                return cast(596,tank())
              end
              --if isDiseased(tank()) and castable(CureDisease,tank()) then
              --  return cast(CureDisease,tank())
              --end
              -- then heal rest of group
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
              if castable(596,object) and partyhealth(object, 30) < 75 and partyMembersAround(object, 30) >= 3 and not moving() and not isCasting("player") then -- prayer of healing
                return cast(596,object)
              end
              if wowex.wowexStorage.read("useabolish") then
                if isDiseased(object) and castable(AbolishDisease,object) and not UnitIsDeadOrGhost(object) then
                  return cast(AbolishDisease,object)
                end
              end
            else -- in combat but not in a instance
              if health() <= 45 and IsAutoRepeatAction(1) and ((UnitPower("player") >= manacost(PowerWordShield)) or (UnitPower("player") >= manacost(Renew)) or (UnitPower("player") >= manacost(FlashHeal))) then
                Debug(8092,"Stopping wand to heal")
                Eval('RunMacroText("/stopcasting")', 'player')
              end
              if castable(PowerWordShield,object) and not debuff(6788,object) and not buff(PowerWordShield,object) and health(object) <= 90 and not IsAutoRepeatAction(1) and UnitTargetingUnit("target",object)  then
                return cast(PowerWordShield,object)
              end
              if castable(Renew,object) and not buff(Renew,object) and health(object) <= 60 and not IsAutoRepeatAction(1) then
                return cast(Renew,object)
              end
              if castable(FlashHeal,object) and health(object) <= 40 and not moving() and not isCasting("player") and not IsAutoRepeatAction(1) then
                return cast(FlashHeal,object)
              end
              --if castable(Heal,object) and health(object) <= 60 and not moving() and not isCasting("player") then
              --  return cast(Heal,object)
              --end
              --if castable(LesserHeal,object) and health(object) <= 70 and not moving() and not isCasting("player") then
              --  return cast(LesserHeal,object)
              --end
              if wowex.wowexStorage.read("useabolish") then
                if isDiseased(object) and castable(AbolishDisease,object) and not UnitIsDeadOrGhost(object) then
                  return cast(AbolishDisease,object)
                end
              end
            end
          end
        end
      end
      if not UnitAffectingCombat("player") and not IsEatingOrDrinking("player") and not mounted() then -- if not in combat, heal everyone
        for object in OM:Objects(OM.Types) do
          if not UnitCanAttack("player",object) and UnitIsPlayer(object) and distance("player",object) <= 40 and not isCasting("player") and (UnitInParty(object) or Object("player") == object) then -- if friendly player in range
            if UnitIsDeadOrGhost(object) and not UnitAffectingCombat("player") then
              return cast(Resurrection,object)
            end
            if castable(Renew,object) and not buff(Renew,object) and health(object) <= 70 and not UnitIsDeadOrGhost(object) then
              return cast(Renew,object)
            end
            --if castable(Heal,object) and health() <= 30 and not moving() and not UnitIsDeadOrGhost(object) then
            --  return cast(Heal,object)
            --end
            if castable(Heal,object) and health() <= 60 and not moving() and not isCasting("player") and not UnitIsDeadOrGhost(object) then
              return cast(Heal,object)
            end
            if wowex.wowexStorage.read("useabolish") then
              if isDiseased(object) and castable(AbolishDisease,object) and not UnitIsDeadOrGhost(object) then
                return cast(AbolishDisease,object)
              end
            end
          end
        end
      end
    elseif wowex.wowexStorage.read("CombatHeals") == nil then
      -- in combat
      if UnitAffectingCombat("player") and not IsEatingOrDrinking("player") and not mounted() then -- in combat
        if health() <= 80 and SpellCooldown(ShadowWordPain) > 2 then -- if spell locked on shadow
          if castable(FlashHeal,"player") and not moving() and not isCasting("player") then
            return cast(FlashHeal,"player")
          end
          if castable(Renew,"player") and not buff(Renew,"player") and moving() then
            return cast(Renew,"player")
          end
        elseif health() >= 80 and SpellCooldown(ShadowWordPain) > 3 and enemiesAround("player", 10) < 2 and not isCasting("player") then
          if castable(Smite,"target") then
            return cast(Smite,"target")
          end
        end
        for object in OM:Objects(OM.Types) do
          if not UnitCanAttack("player",object) and UnitIsPlayer(object) and UnitIsPlayer(object) and distance("player",object) <= 40 and not UnitIsDeadOrGhost(object) and UnitInParty(object) then -- if friendly party player in range
            if castable(PowerWordShield,object) and not debuff(6788,object) and not buff(PowerWordShield,object) and health(object) <= 15 then
              return cast(PowerWordShield,object)
            end
          end
        end
        if castable(PowerWordShield,"player") and UnitTargetingUnit("target","player") and (debuffduration(6788,"player") <= 1.5 or not debuff(6788,"player")) and not buff(PowerWordShield,"player") and instanceType ~= "party" and health("player") <= 98 and not IsAutoRepeatAction(1) then
          return cast(PowerWordShield,"player")
        end
      -- out of combat
      elseif not UnitAffectingCombat("player") and not IsEatingOrDrinking("player") and not mounted() then -- if not in combat, heal everyone
        for person in OM:Objects(OM.Types) do
          if not UnitCanAttack("player",person) and UnitIsPlayer(person) and distance("player",person) <= 40 and not isCasting("player") and (UnitInParty(person) or (Object("player") == person)) then -- if friendly player in range
            --if UnitIsDeadOrGhost(object) and not UnitAffectingCombat("player") then
            --  return cast(Resurrection,object)
            --end
            if castable(Renew,person) and not buff(Renew,person) and health(person) <= 70 and not UnitIsDeadOrGhost(person) and instanceType ~= "party" and Object("player") == person then
              return cast(Renew,person)
            end
            --if castable(Heal,object) and health() <= 30 and not moving() and not UnitIsDeadOrGhost(object) then
            --  return cast(Heal,object)
            --end
            if castable(Heal,person) and health() <= 60 and not moving() and not isCasting("player") and not UnitIsDeadOrGhost(person) and instanceType ~= "party" and Object("player") == person then
              return cast(Heal,person)
            end
            if wowex.wowexStorage.read("useabolish") then
              if isDiseased(person) and castable(AbolishDisease,person) and not UnitIsDeadOrGhost(person) then
                return cast(AbolishDisease,person) 
              end
            end
          end
        end
      end
    end
  end

  local function Consumables()
    if UnitAffectingCombat("player") and not IsEatingOrDrinking("player") and not mounted() then -- in combat
      if wowex.wowexStorage.read('majorhealth') then
        if health() <= 50 and enemiesAround("player", 20) <= 2 then
          Eval('RunMacroText("/use Major Healing Potion")', 'player')
        end
      end
      if wowex.wowexStorage.read('majormana') then
        if mana <= 50 then
          Eval('RunMacroText("/use Major Mana Potion")', 'player')
        end
      end
      if partyMembersAround("player", 30) >= 4 and enemiesAround("player", 30) >= 3 and cooldown(18607) == 0 then
        Eval('RunMacroText("/use Horde Battle Standard")', 'player') 
      end
    end
  end

  local function Dps()
    if UnitAffectingCombat("player") and UnitCanAttack("player","target") and not UnitIsDeadOrGhost("target") and not IsEatingOrDrinking("player") then
      if (((SpellCooldown(MindBlast) <= wowex.wowexStorage.read("wandspeed") and (health("target") >= 70 or isElite("target"))) or (not debuff(ShadowWordPain,"target") and (health("target") >= 20 or isElite("target")))) and IsAutoRepeatAction(1)) and (UnitPower("player") >= manacost(MindBlast)) then
        Debug(8092,"Stopping wand to mind blast")
        Eval('RunMacroText("/stopcasting")', 'player')
      end
      if castable(Shadowform,"player") and not buff(Shadowform,"player") then -- Shadowform
        return cast(Shadowform,"player")
      end
      if castable(ShadowWordPain,"target") and not debuff(ShadowWordPain,"target") and health("target") >= 10 and not IsAutoRepeatAction(1) and targetclass ~= "Paladin" and targetclass ~= "Priest" then   
        return cast(ShadowWordPain,"target")
      end
      if castable(VampiricEmbrace,"target") and debuff(ShadowWordPain,"target") and not debuff(VampiricEmbrace,"target") and (health() <= 98 or moving() or ((instanceType == "party" or instanceType == "raid") and partyhealth("player", 30) < 80) or (isElite("target") and solo())) and not IsAutoRepeatAction(1) and (health("target") >= 50 or instanceType == "party") and (UnitTargetingUnit("target","player") or instanceType == "party") and ((UnitPower("player") >= (manacost(MindBlast) + manacost(VampiricEmbrace)) and not moving()) or (UnitPower("player") >= (manacost(ShadowWordPain) + manacost(VampiricEmbrace))) or (UnitPower("player") >= (manacost(MindFlay) + manacost(VampiricEmbrace)) and not moving())) then
        return cast(VampiricEmbrace,"target")
      end
      if castable(MindBlast,"target") and not moving() and not IsAutoRepeatAction(1) and ((not debuff(ShadowWordPain,"target") or health("target") >= 10) or (UnitIsPlayer("target") and (not melee() or buff(14743,"player") or buff(PowerWordShield,"player")))) then
        return cast(MindBlast,"target")
      end
      if castable(DevouringPlague,"target") and not debuff(DevouringPlague,"target") and (((UnitIsPlayer("target") or health() <= 80 or isElite("target")) and (instanceType ~= "party" or instanceType ~= "raid")) or IsDungeonBoss("target")) and not IsAutoRepeatAction(1) and (health("target") >= 60 or enemiesAround("player",30) <= 2) and targetclass ~= "Priest" and targetclass ~= "Paladin" then      
        if castable(InnerFocus,"player") then
          Eval('RunMacroText("/cast Inner Focus")', 'player')
        end
        return cast(DevouringPlague,"target")
      end
      --if castable(ManaBurn,"target") and not moving() and UnitIsPlayer("target") and not isCasting("target") and (targetclass == "Priest" or targetclass == "Mage") and targetmana >= 10 then
      --  return cast(ManaBurn,"target")
      --end
      if castable(589,"target") and not debuff(589,"target") and not debuff(ShadowWordPain,"target") and health("target") >= 10 and not IsAutoRepeatAction(1) and moving() and moving("target") then   
        return cast(589,"target")
      end
      if castable(MindFlay,"target") and not moving() and (UnitIsPlayer("target") or not wowex.wowexStorage.read("useWand")) and not isChanneling("player") then     
        return cast(MindFlay,"target")
      end
    end
  end

  local function Buff()
    if not UnitAffectingCombat("player") and not IsEatingOrDrinking("player") and not mounted() then
      if wowex.wowexStorage.read("buffothers") then
        for object in OM:Objects(OM.Types.Player) do
          if not UnitCanAttack("player",object) and UnitIsPlayer(object) and distance("player",object) <= 40 and UnitInParty(object) then -- if friendly player in range
            if castable(21564,object) and partyMembersAround(object, 30) >= 5 and not buff(21562,object) and not buff(21564,object) and not buff(PowerWordFortitude,object) and ((buff(2479,"player") and instanceType == "pvp") or instanceType == "party" or instanceType == "raid") then
              return cast(21564,object)
            end
            if castable(27683,object) and partyMembersAround(object, 30) >= 5 and not buff(27683,object) and not buff(ShadowProtection,object) and ((buff(2479,"player") and instanceType == "pvp") or instanceType == "party" or instanceType == "raid") then
              return cast(27683,object)
            end
            if castable(PowerWordFortitude,object) and not buff(PowerWordFortitude,object) and not buff(21564,object) and not buff(21562,object) and instanceType ~= "pvp" then
              return cast(PowerWordFortitude,object)
            end
            if castable(ShadowProtection,object) and not buff(ShadowProtection,object) and not buff(27683,object) and instanceType ~= "pvp" then
              return cast(ShadowProtection,object)
            end
          end
        end
      end
      if castable(PowerWordFortitude,"player") and not buff(PowerWordFortitude,"player") and not buff(21564,"player") and not buff(21562,"player") then
        return cast(PowerWordFortitude,"player")
      end
      if castable(ShadowProtection,"player") and not buff(ShadowProtection,"player") and not buff(27683,"player") then
        return cast(ShadowProtection,"player")
      end
      if not buff(Shadowform,"player") and health() > 70 then
        return cast(Shadowform,"player")
      end
      if castable(InnerFire,"player") and not buff(InnerFire,"player") then
        return cast(InnerFire,"player")
      end
      if castable(2652,"player") and not buff(InnerFocus,"player") and not buff(2652,"player") and (instanceType == "pvp" or (UnitExists("target") and UnitIsPlayer("target"))) then -- touch of weakness Rank 1
        return cast(2652,"player")
      end
    end
  end
    
  local function FriendlyBuffer()
    if wowex.wowexStorage.read("buffothers") then
      if not UnitAffectingCombat("player") and not IsEatingOrDrinking("player") and not mounted() and instanceType ~= "pvp" and not buff(2479,"player") then
        for object in OM:Objects(OM.Types.Player) do
          if not UnitCanAttack("player",object) and UnitIsPlayer(object) and distance("player",object) <= 40 then
            if bufftimer < GetTime() then
              if castable(PowerWordFortitude,object) and (UnitClass(object) ~= "priest")and not buff(PowerWordFortitude,object) and not buff(21564,object) and not buff(21562,object) then
                bufftimer = GetTime() + 60
                return cast(PowerWordFortitude,object)
              end
            end
          end
        end
      end
    end
  end

  local function pvp()
    if race == "Undead" then
      if debuff(5782,"player") or debuff(6213,"player") or debuff(6215,"player") or debuff(5484,"player") or debuff(17928,"player") or debuff(10888,"player") or debuff(6789,"player") or debuff(10890,"player") or debuff(5246,"player") then
        return cast(7744,"player") -- Will of Forsaken
      end
    end

    if (SpellCooldown(7744) > 2 and (debuff(5782,"player") or debuff(5246,"player"))) or debuff(6213,"player") or debuff(6215,"player") or debuff(5484,"player") or debuff(17928,"player") or debuff(10888,"player") or debuff(6789,"player") or debuff(8122,"player") or debuff(10890,"player") or debuff(8643,"player") or debuff(118,"player") or debuff(12826,"player") or debuff(28272,"player") or debuff(10308,"player") or debuff(28272,"player") then
      Eval('RunMacroText("/use 14")', 'player')
    end

    for object in OM:Objects(OM.Types.Player) do
      if distance("player",object) <= 30 and buff(Stealth,object) then
        if UnitCanAttack("player",object) and not UnitIsDeadOrGhost(object) and castable(ShadowWordPain,object) then
          TargetUnit(object)
          FaceObject(object)
          Eval('RunMacroText("/stopcasting")', 'player')
          Debug("GET STEALTHY".." "..UnitName(object),11297)
          return cast(ShadowWordPain,object)
        end 
      end
    end

    --if IsFalling("player") and not buff(Levitate,"player") then
    --  return cast(Levitate,"player")
    --end
--[[
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
    ]]
  end
  local function DefensiveDispel()
    if wowex.wowexStorage.read("useDefensiveDispel") then
      if wowex.wowexStorage.read('importantdefdispel') then
        if not IsEatingOrDrinking("player") and not mounted() then
          if isMagic("player") and castable(DispelMagic,"player") then
            for i=1,40 do
            local importantdebuff = UnitDebuff("player",i)
              if importantdebuff == "Shadow Word: Pain" or (importantdebuff == "Corruption" and not UnitAffectingCombat("player")) or (importantdebuff == "Immolate" and not UnitAffectingCombat("player")) or importantdebuff == "Fear" or importantdebuff == "Death Coil" or importantdebuff == "Howl of Terror" or importantdebuff == "Frost Nova" or importantdebuff == "Frostbite" or (importantdebuff == "Frost Bolt" and not UnitAffectingCombat("player")) or (importantdebuff == "Hunter's Mark" and not UnitAffectingCombat("player")) or importantdebuff == "Polymorph" or importantdebuff == "Hibernate" or importantdebuff == "Hammer of Justice" or importantdebuff == "Entangling Roots" then
                return cast(DispelMagic,"player")
              else break end
            end
          end
        end
      elseif not wowex.wowexStorage.read('importantdefdispel') then
        if not IsEatingOrDrinking("player") and not mounted() then
          if isMagic("player") and castable(DispelMagic,"player") then
            return cast(DispelMagic,"player")
          end
        end            
      end
    end  
  end

  local function DispelFriendly()
    if wowex.wowexStorage.read("useDefensiveDispel") then
      if wowex.wowexStorage.read("friendlydispel") then
        if wowex.wowexStorage.read('importantdefdispel') then
          for object in OM:Objects(OM.Types.Player) do
            if not UnitCanAttack("player",object) and not IsEatingOrDrinking("player") and not UnitIsDeadOrGhost(object) and not mounted() then
              if isMagic(object) and castable(DispelMagic,object) then
                for i=1,40 do
                local name = UnitDebuff(object,i)
                  if name == "Shadow Word: Pain" or name == "Corruption" or name == "Immolate" or name == "Fear" or name == "Death Coil" or name == "Howl of Terror" or name == "Frost Nova" or name == "Frost Bolt" or name == "Hunter's Mark" or name == "Polymorph" or name == "Hibernate" or name == "Hammer of Justice" or name == "Entangling Roots" then
                    return cast(DispelMagic,object)
                  else break end
                end
              end
            end
          end
        elseif not wowex.wowexStorage.read('importantdefdispel') then
          for object in OM:Objects(OM.Types.Player) do
            if not UnitCanAttack("player",object) and not IsEatingOrDrinking("player") and not UnitIsDeadOrGhost(object) and not mounted() then
              if isMagic(object) and castable(DispelMagic,object) then
                return cast(DispelMagic,object)
              end
            end
          end
        end            
      end
    end  
  end

  local function OffensiveDispel()
    if wowex.wowexStorage.read("useOffensiveDispel") then
      for object in OM:Objects(OM.Types.Player) do
        if wowex.wowexStorage.read('importantoffdispel') then
          if isMagicBuff(object) and castable(DispelMagic,object) and UnitTargetingUnit(object,"player") and UnitCanAttack("player",object) and UnitAffectingCombat("player") and not UnitIsDeadOrGhost(object) and not mounted() then
            for i=1,40 do
              local name = UnitBuff(object,i)
              if name == "Arcane Power" or name == "Innervate" or name == "Ghost Wolf" or name == "Sacrifice" or name == "Fear Ward" or name == "Power Word: Fortitude" or name == "Power Word: Shield" or name == "Shadow Ward" or name == "Mana Shield" or name == "Presence of Mind" or name == "Ice Barrier" or name == "Nature's Swiftness" or name == "Dampen Magic" or name == "Major Spellstone" or name == "Shadow Ward" or name == "Free Action Potion" then
                return cast(DispelMagic,object)
              else break end
            end
          end
        elseif not wowex.wowexStorage.read('importantoffdispel') then
          if isMagicBuff(object) and castable(DispelMagic,object) and UnitTargetingUnit(object,"player") and UnitCanAttack("player",object) and UnitAffectingCombat("player") and not UnitIsDeadOrGhost(object) and not mounted() then
            return cast(DispelMagic,object)
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
    if UnitExists("target") and instanceType ~= "party" and not IsEatingOrDrinking("player") and distance("player","target") <= 60 and not mounted() and not UnitIsDeadOrGhost("target") and not UnitAffectingCombat("player") and UnitCanAttack("player","target") and not melee() and not (buff(301089,"target") or buff(301091,"target") or buff(34976,"target")) then
      if not buff(Shadowform,"player") then -- Shadowform
        return cast(Shadowform,"player")
      end      
      if castable(PowerWordShield,"player") and not debuff(6788,"player") and not buff(PowerWordShield,"player") and not IsStealthed("target") then
        return cast(PowerWordShield,"player")
      end
      if castable(2652,"player") and not buff(2652,"player") and not buff(InnerFocus,"player") then -- touch of weakness Rank 1
        return cast(2652,"player")
      end
    end
  end

  local function wand()
    if wowex.wowexStorage.read("useWand") then
      if UnitAffectingCombat("player") and UnitCanAttack("player","target") and not UnitIsDeadOrGhost("target") and not mounted() then
        if UnitHealth("target") <= 5 and not IsAutoRepeatAction(1) then
          FaceObject("target")
          Debug(8092,"STARTING wand")
          return cast(5019,"target")
        end
        if (SpellCooldown(MindBlast) >= (wowex.wowexStorage.read("wandspeed") + 0.2) or health("target") <= 10) and (debuff(ShadowWordPain,"target") or health("target") <= 20) and (debuff(VampiricEmbrace,"target") or health() > 95 or SpellCooldown(VampiricEmbrace) >= (wowex.wowexStorage.read("wandspeed") + 0.1)) and not IsAutoRepeatAction(1) and not (isCasting("player") or isChanneling("player")) and distance("player","target") <= 30 and not moving() and not UnitIsPlayer("target") then
          FaceObject("target")
          Debug(8092,"STARTING wand")
          return cast(5019,"target")
          --return Eval('RunMacroText("/cast !Shoot")', 'player')
        elseif ((UnitPower("player") <= manacost(MindBlast)) and (UnitPower("player") <= manacost(ShadowWordPain))) and ((health() >= 60) or ((UnitPower("player") <= manacost(PowerWordShield)) and (UnitPower("player") <= manacost(Renew)) and (UnitPower("player") <= manacost(FlashHeal)))) and not IsAutoRepeatAction(1) and not (isCasting("player") or isChanneling("player")) and distance("player","target") <= 30 and not moving() then
          FaceObject("target")
          Debug(8092,"NOTHING TO DO, STARTING wand") 
          return cast(5019,"target")     
          --return Eval('RunMacroText("/cast !Shoot")', 'player')
        end
      end
    elseif ((UnitPower("player") <= manacost(MindBlast)) and (UnitPower("player") <= manacost(ShadowWordPain))) and ((health() >= 60) or ((UnitPower("player") <= manacost(PowerWordShield)) and (UnitPower("player") <= manacost(Renew)) and (UnitPower("player") <= manacost(FlashHeal)))) and not IsAutoRepeatAction(1) and not (isCasting("player") or isChanneling("player")) and distance("player","target") <= 30 and not moving() then
      FaceObject("target")
      Debug(8092,"NOTHING TO DO, STARTING wand") 
      return cast(5019,"target")     
      --return Eval('RunMacroText("/cast !Shoot")', 'player')
    end
  end

  local function OutOfCombat()
    if not UnitAffectingCombat("player") then
      if Queue() then return true end
      if Loot() then return true end
      if Healing() then return true end
      if Buff() then return true end
      if FriendlyBuffer() then return true end
      if PreCombat() then return true end
      if Opener() then return true end
      if pvp() then return true end
      if DefensiveDispel() then return true end
      if DispelFriendly() then return true end
      if Dismounter() then return true end
    end
    return false
  end
  local function Incombat()
    if UnitAffectingCombat("player") then
      if Queue() then return true end
      if Interrupt() then return true end
      if Consumables() then return true end
      if Cooldowns() then return true end     
      if Healing() then return true end
      if Dps() then return true end
      if Dot() then return true end
      if pvp() then return true end
      if OffensiveDispel() then return true end
      if DefensiveDispel() then return true end
      if DispelFriendly() then return true end
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

local button_example = {
  {
    key = "CombatHeals",
    buttonname = "CombatHeals",
    texture = "spell_holy_flashheal",
    tooltip = "Use Heals in Combat",
    text = "Use Heals in Combat",
    setx = "TOP",
    parent = "settings",
    sety = "TOPRIGHT"
  },
  {
    key = "useDefensiveDispel",
    buttonname = "useDefensiveDispel",
    texture = "spell_holy_dispelmagic",
    tooltip = "Use Defensive Dispels",
    text = "Use Defensive Dispels",
    setx = "TOP",
    parent = "CombatHeals",
    sety = "TOPRIGHT"
  },  
  {
    key = "useOffensiveDispel",
    buttonname = "useOffensiveDispel",
    texture = "spell_nature_purge",
    tooltip = "Use Offensive Dispels",
    text = "Use Offensive Dispels",
    setx = "TOP",
    parent = "useDefensiveDispel",
    sety = "TOPRIGHT"
  },
  {
    key = "useWand",
    buttonname = "useWand",
    texture = "ability_shootwand",
    tooltip = "Use Wand on Monsters",
    text = "Use Wand on Monsters",
    setx = "TOP",
    parent = "useOffensiveDispel",
    sety = "TOPRIGHT"
  },  
}
wowex.button_factory(button_example)

local mytable = {
  key = "cromulon_config",
  name = "Yosh Priest SoM",
  height = 650,
  width = 400,
  panels = 
  {
    { 
      name = "General",
      items = 
      {        
        { key = "heading", type = "heading", color = 'FF7C0A', text = "Wand" },
        { key = "wandspeed", label = "Wand Speed", text = wowex.wowexStorage.read("wandspeed"), type = "slider", min = 1, max = 2, step = 0.1},
        { key = "alwaysface",  type = "checkbox", text = "Always Face Target Players?", desc = "Always face target players in BGs (For AFK)" },
        { key = "heading", type = "heading", color = 'FF7C0A', text = "Loot" },
        { key = "autoloot",  type = "checkbox", text = "Auto Loot", desc = "" },
        { key = "heading", type = "heading", color = 'FF7C0A', text = "Dispels" },
        { key = "buffothers",  type = "checkbox", text = "Buff Other Players?", desc = "" },
        { key = "friendlydispel",  type = "checkbox", text = "Dispel Friendly Players?", desc = "" },
        { key = "importantoffdispel",  type = "checkbox", text = "Only Dispel Important Buffs", desc = "" },
        { key = "importantdefdispel",  type = "checkbox", text = "Only Dispel Important Debuffs", desc = "" },
        { key = "useabolish",  type = "checkbox", text = "Use Abolish Disease?", desc = "" },
        { key = "heading", type = "heading", color = 'FF7C0A', text = "DoTs" },
        { key = "multidot",  type = "checkbox", text = "DoT all Players Targeting Player", desc = "" },
        { key = "multidotunits",  type = "checkbox", text = "DoT all Monsters Targeting Player", desc = "" },
        { key = "dotallplayers",  type = "checkbox", text = "DoT all Nearby Players", desc = "" }
      }
    },
    { 
      name = "Consumables",
      items = 
      {        
        { key = "heading", type = "heading", color = 'FF7C0A', text = "Cheap Consumes" },
        { key = "majorhealth",  type = "checkbox", text = "Use Major Health Potions" },
        { key = "majormana",  type = "checkbox", text = "Use Major Mana Potions" },        
      }
    },
  },
  
  tabgroup = 
  {
    {text = "General", value = "one"},
    {text = "Consumables", value = "two"},  
  }
}
Draw:Enable()
wowex.createpanels(mytable)
wowex.panel:Hide()     