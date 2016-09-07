
-- rTooltip: core
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

local unpack, type = unpack, type
local RAID_CLASS_COLORS, FACTION_BAR_COLORS, ICON_LIST = RAID_CLASS_COLORS, FACTION_BAR_COLORS, ICON_LIST
local GameTooltip, GameTooltipStatusBar = GameTooltip, GameTooltipStatusBar
local GameTooltipTextRight1, GameTooltipTextRight2, GameTooltipTextRight3, GameTooltipTextRight4, GameTooltipTextRight5, GameTooltipTextRight6, GameTooltipTextRight7, GameTooltipTextRight8 = GameTooltipTextRight1, GameTooltipTextRight2, GameTooltipTextRight3, GameTooltipTextRight4, GameTooltipTextRight5, GameTooltipTextRight6, GameTooltipTextRight7, GameTooltipTextRight8
local GameTooltipTextLeft1, GameTooltipTextLeft2, GameTooltipTextLeft3, GameTooltipTextLeft4, GameTooltipTextLeft5, GameTooltipTextLeft6, GameTooltipTextLeft7, GameTooltipTextLeft8 = GameTooltipTextLeft1, GameTooltipTextLeft2, GameTooltipTextLeft3, GameTooltipTextLeft4, GameTooltipTextLeft5, GameTooltipTextLeft6, GameTooltipTextLeft7, GameTooltipTextLeft8

local classColorHex, factionColorHex = {}, {}

-----------------------------
-- Config
-----------------------------

local cfg = {}
cfg.textColor = {0.5,0.5,0.5}
cfg.bossColor = {1,0,0}
cfg.eliteColor = {1,0,0.5}
cfg.rareeliteColor = {1,0.5,0}
cfg.rareColor = {1,0.5,0}
cfg.levelColor = {0.8,0.8,0.5}
cfg.deadColor = {0.5,0.5,0.5}
cfg.targetColor = {1,0.5,0.5}
cfg.guildColor = {1,0,1}
cfg.afkColor = {0,1,1}
cfg.scale = 0.95
cfg.fontFamily = STANDARD_TEXT_FONT
cfg.backdrop = { bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",  tiled = false, edgeSize = 16, insets = {left=3, right=3, top=3, bottom=3} }
cfg.backdrop.bgColor = {0.08,0.08,0.1,0.92}
cfg.backdrop.borderColor = {0.3,0.3,0.33,1}

-----------------------------
-- Functions
-----------------------------

local function GetHexColor(color)
  if color.r then
    return ("%.2x%.2x%.2x"):format(color.r*255, color.g*255, color.b*255)
  else
    local r,g,b,a = unpack(color)
    return ("%.2x%.2x%.2x"):format(r*255, g*255, b*255)
  end
end

local function GetTarget(unit)
  if UnitIsUnit(unit, "player") then
    return ("|cffff0000%s|r"):format("<YOU>")
  elseif UnitIsPlayer(unit, "player") then
    local _, class = UnitClass(unit)
    return ("|cff%s%s|r"):format(classColorHex[class], UnitName(unit))
  elseif UnitReaction(unit, "player") then
    return ("|cff%s%s|r"):format(factionColorHex[UnitReaction(unit, "player")], UnitName(unit))
  else
    return ("|cffffffff%s|r"):format(UnitName(unit))
  end
end

local function OnTooltipSetUnit(self)
  local unitName, unit = self:GetUnit()
  if not unit then return end
  --color tooltip textleft2..8
  GameTooltipTextLeft2:SetTextColor(unpack(cfg.textColor))
  GameTooltipTextLeft3:SetTextColor(unpack(cfg.textColor))
  GameTooltipTextLeft4:SetTextColor(unpack(cfg.textColor))
  GameTooltipTextLeft5:SetTextColor(unpack(cfg.textColor))
  GameTooltipTextLeft6:SetTextColor(unpack(cfg.textColor))
  GameTooltipTextLeft7:SetTextColor(unpack(cfg.textColor))
  GameTooltipTextLeft8:SetTextColor(unpack(cfg.textColor))
  --position raidicon
  local raidIconIndex = GetRaidTargetIndex(unit)
  if raidIconIndex then
    --GameTooltipTextLeft1:SetText(("%s %s"):format(ICON_LIST[raidIconIndex].."14|t", unitName))
    --self:AppendText(" "..ICON_LIST[raidIconIndex].."14|t")
    GameTooltipTexture1:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_"..raidIconIndex)
    GameTooltipTexture1:Show()
  end
  if not UnitIsPlayer(unit) then
    --unit is not a player
    --color textleft1 and statusbar by faction color
    local reaction = UnitReaction(unit, "player")
    if reaction then
      local color = FACTION_BAR_COLORS[reaction]
      if color then
        cfg.barColor = color
        GameTooltipStatusBar:SetStatusBarColor(color.r,color.g,color.b)
        GameTooltipTextLeft1:SetTextColor(color.r,color.g,color.b)
      end
    end
    --color textleft2 by classificationcolor
    local unitClassification = UnitClassification(unit)
    if unitClassification == "worldboss" or UnitLevel(unit) == -1 then
      GameTooltipTextLeft2:SetTextColor(unpack(cfg.bossColor))
    elseif unitClassification == "rare" then
      local line = GameTooltipTextLeft2
      if string.find(GameTooltipTextLeft3:GetText(), "%a%s%d") then
        line:SetTextColor(unpack(cfg.guildColor))
        line = GameTooltipTextLeft3
      end
      line:SetTextColor(unpack(cfg.rareColor))
    elseif unitClassification == "rareelite" then
      local line = GameTooltipTextLeft2
      if string.find(GameTooltipTextLeft3:GetText(), "%a%s%d") then
        line:SetTextColor(unpack(cfg.guildColor))
        line = GameTooltipTextLeft3
      end
      line:SetTextColor(unpack(cfg.rareeliteColor))
    elseif unitClassification == "elite" then
      local line = GameTooltipTextLeft2
      if string.find(GameTooltipTextLeft3:GetText(), "%a%s%d") then
        line:SetTextColor(unpack(cfg.guildColor))
        line = GameTooltipTextLeft3
      end
      line:SetTextColor(unpack(cfg.eliteColor))
    else
      local line = GameTooltipTextLeft2
      if string.find(GameTooltipTextLeft3:GetText(), "%a%s%d") then
        line:SetTextColor(unpack(cfg.guildColor))
        line = GameTooltipTextLeft3
      end
      line:SetTextColor(unpack(cfg.levelColor))
    end
  else
    --unit is any player
    local _, unitClass = UnitClass(unit)
    --color textleft1 and statusbar by class color
    local color = RAID_CLASS_COLORS[unitClass]
    cfg.barColor = color
    GameTooltipStatusBar:SetStatusBarColor(color.r,color.g,color.b)
    GameTooltipTextLeft1:SetTextColor(color.r,color.g,color.b)
    --color textleft2 by guildcolor
    local unitGuild = GetGuildInfo(unit)
    if unitGuild then
      GameTooltipTextLeft2:SetText("<"..unitGuild..">")
      GameTooltipTextLeft2:SetTextColor(unpack(cfg.guildColor))
      GameTooltipTextLeft3:SetTextColor(unpack(cfg.levelColor))
    else
      GameTooltipTextLeft2:SetTextColor(unpack(cfg.levelColor))
    end
    --afk?
    if UnitIsAFK(unit) then
      self:AppendText((" |cff%s<AFK>|r"):format(cfg.afkColorHex))
    end
  end
  --dead?
  if UnitIsDeadOrGhost(unit) then
    GameTooltipTextLeft1:SetTextColor(unpack(cfg.deadColor))
  end
  --target line
  if (UnitExists(unit.."target")) then
    GameTooltip:AddDoubleLine(("|cff%s%s|r"):format(cfg.targetColorHex, "Target"),GetTarget(unit.."target") or "Unknown")
  end
end

--TooltipOnShow
local function TooltipOnShow(self)
  --print(self:GetName(),"TooltipOnShow")
  self:SetBackdropColor(unpack(cfg.backdrop.bgColor))
  self:SetBackdropBorderColor(unpack(cfg.backdrop.borderColor))
  local itemName, itemLink = self:GetItem()
  if itemLink then
    local _, _, itemRarity = GetItemInfo(itemLink)
    self:SetBackdropBorderColor(GetItemQualityColor(itemRarity))
  end
end

--TooltipOnHide
local function TooltipOnHide(self)
  --print(self:GetName(),"TooltipOnHide")
  self:SetBackdropColor(unpack(cfg.backdrop.bgColor))
  self:SetBackdropBorderColor(unpack(cfg.backdrop.borderColor))
  GameTooltipTexture1:Hide()
end

--OnTooltipCleared
local function OnTooltipCleared(self)
  --print(self:GetName(),"OnTooltipCleared")
  --fix the blue tooltip background...whatever that is
  self:SetBackdropColor(unpack(cfg.backdrop.bgColor))
  GameTooltipTexture1:Hide()
end

local function FixBarColor(self,r,g,b)
  if not cfg.barColor then return end
  if r == cfg.barColor.r and g == cfg.barColor.g and b == cfg.barColor.b then return end
  self:SetStatusBarColor(cfg.barColor.r,cfg.barColor.g,cfg.barColor.b)
end

-----------------------------
-- Init
-----------------------------

hooksecurefunc(GameTooltipStatusBar,"SetStatusBarColor", FixBarColor)

GameTooltipTexture1:SetTexture("Interface\\Buttons\\WHITE8x8")
--GameTooltipTexture1:SetVertexColor(0,1,1,0.8)
GameTooltipTexture1:SetSize(20,20)
GameTooltipTexture1:ClearAllPoints()
GameTooltipTexture1:SetPoint("BOTTOM",GameTooltip,"TOP",0,2)

--hex class colors
for class, color in next, RAID_CLASS_COLORS do
  classColorHex[class] = GetHexColor(color)
end
--hex reaction colors
--for idx, color in next, FACTION_BAR_COLORS do
for i = 1, #FACTION_BAR_COLORS do
  factionColorHex[i] = GetHexColor(FACTION_BAR_COLORS[i])
end

cfg.targetColorHex = GetHexColor(cfg.targetColor)
cfg.afkColorHex = GetHexColor(cfg.afkColor)

GameTooltipHeaderText:SetFont(cfg.fontFamily, 14, "NONE")
GameTooltipText:SetFont(cfg.fontFamily, 12, "NONE")
Tooltip_Small:SetFont(cfg.fontFamily, 11, "NONE")

--gametooltip statusbar
GameTooltipStatusBar:ClearAllPoints()
GameTooltipStatusBar:SetPoint("LEFT",5,0)
GameTooltipStatusBar:SetPoint("RIGHT",-5,0)
GameTooltipStatusBar:SetPoint("TOP",0,-2.5)
GameTooltipStatusBar:SetHeight(4)
--gametooltip statusbar bg
GameTooltipStatusBar.bg = GameTooltipStatusBar:CreateTexture(nil,"BACKGROUND",nil,-8)
GameTooltipStatusBar.bg:SetAllPoints()
GameTooltipStatusBar.bg:SetColorTexture(1,1,1)
GameTooltipStatusBar.bg:SetVertexColor(0,0,0,0.7)

--OnTooltipSetUnit
GameTooltip:HookScript("OnTooltipSetUnit", OnTooltipSetUnit)
--OnTooltipCleared
GameTooltip:HookScript("OnTooltipCleared", OnTooltipCleared) --bugged when hovering an item, fires way to often

--loop over tooltips
local tooltips = { GameTooltip, ItemRefTooltip, ShoppingTooltip1, ShoppingTooltip2, ShoppingTooltip3, WorldMapTooltip, SmallTextTooltip }
for idx, tooltip in ipairs(tooltips) do
  tooltip:SetBackdrop(cfg.backdrop)
  tooltip:SetScale(cfg.scale)
  tooltip:HookScript("OnShow", TooltipOnShow)
  tooltip:HookScript("OnHide", TooltipOnHide)
end

--loop over menues
local menues = {
  DropDownList1MenuBackdrop,
  DropDownList2MenuBackdrop,
}
for idx, menu in ipairs(menues) do
  menu:SetScale(cfg.scale)
end