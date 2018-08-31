
-- rMinimap: core
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

L.addonName       = A
L.dragFrames      = {}
L.addonColor      = "00FFAA00"
L.addonShortcut   = "rmm"

-----------------------------
-- Config
-----------------------------

local cfg = {
  scale = 1,
  point = { "TOPRIGHT", 0, 0},
}

-----------------------------
-- Init
-----------------------------

--MinimapCluster
MinimapCluster:SetScale(cfg.scale)
MinimapCluster:ClearAllPoints()
MinimapCluster:SetPoint(unpack(cfg.point))

--Minimap
local mediapath = "interface\\addons\\"..A.."\\media\\"
Minimap:SetMaskTexture(mediapath.."mask2")
Minimap:ClearAllPoints()
Minimap:SetPoint("CENTER")
Minimap:SetSize(190,190) --correct the cluster offset

--hide regions
MinimapBackdrop:Hide()
MinimapBorder:Hide()
MinimapZoomIn:Hide()
MinimapZoomOut:Hide()
MinimapBorderTop:Hide()
MiniMapWorldMapButton:Hide()

--zone text
MinimapZoneText:SetPoint("TOP",0,-5)
MinimapZoneText:SetFont(STANDARD_TEXT_FONT,12,"OUTLINE")

--dungeon info
MiniMapInstanceDifficulty:ClearAllPoints()
MiniMapInstanceDifficulty:SetPoint("BOTTOMRIGHT",Minimap,"BOTTOMRIGHT",0,-37)
MiniMapInstanceDifficulty:SetScale(0.8)
GuildInstanceDifficulty:ClearAllPoints()
GuildInstanceDifficulty:SetPoint("BOTTOMRIGHT",Minimap,"BOTTOMRIGHT",0,-37)
GuildInstanceDifficulty:SetScale(0.7)
MiniMapChallengeMode:ClearAllPoints()
MiniMapChallengeMode:SetPoint("BOTTOMRIGHT",Minimap,"BOTTOMRIGHT",0,-42)
MiniMapChallengeMode:SetScale(0.6)
MiniMapChallengeMode:SetAlpha(0.8)
MiniMapInstanceDifficulty:SetAlpha(0.8)
GuildInstanceDifficulty:SetAlpha(0.8)

--QueueStatusMinimapButton (lfi)
QueueStatusMinimapButton:SetParent(Minimap)
QueueStatusMinimapButton:SetScale(1)
QueueStatusMinimapButton:ClearAllPoints()
QueueStatusMinimapButton:SetPoint("BOTTOMLEFT",Minimap,0,0)
QueueStatusMinimapButtonBorder:Hide()
QueueStatusMinimapButton:SetHighlightTexture (nil)
QueueStatusMinimapButton:SetPushedTexture(nil)

--mail
MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetPoint("BOTTOMRIGHT",Minimap,-0,0)
MiniMapMailIcon:SetTexture(mediapath.."mail")
MiniMapMailBorder:SetTexture("Interface\\Calendar\\EventNotificationGlow")
MiniMapMailBorder:SetBlendMode("ADD")
MiniMapMailBorder:ClearAllPoints()
MiniMapMailBorder:SetPoint("CENTER",MiniMapMailFrame,0.5,1.5)
MiniMapMailBorder:SetSize(27,27)
MiniMapMailBorder:SetAlpha(0.5)

--MiniMapTracking
MiniMapTracking:SetParent(Minimap)
MiniMapTracking:SetScale(1)
MiniMapTracking:ClearAllPoints()
MiniMapTracking:SetPoint("TOPLEFT",Minimap,5,-5)
MiniMapTrackingButton:SetHighlightTexture (nil)
MiniMapTrackingButton:SetPushedTexture(nil)
MiniMapTrackingBackground:Hide()
MiniMapTrackingButtonBorder:Hide()

--MiniMapNorthTag
MinimapNorthTag:ClearAllPoints()
MinimapNorthTag:SetPoint("TOP",Minimap,0,-20)

--Blizzard_TimeManager
LoadAddOn("Blizzard_TimeManager")
TimeManagerClockButton:GetRegions():Hide()
TimeManagerClockButton:ClearAllPoints()
TimeManagerClockButton:SetPoint("BOTTOM",0,5)
TimeManagerClockTicker:SetFont(STANDARD_TEXT_FONT,12,"OUTLINE")
TimeManagerClockTicker:SetTextColor(0.8,0.8,0.6,1)

--GameTimeFrame
GameTimeFrame:SetParent(Minimap)
GameTimeFrame:SetScale(0.6)
GameTimeFrame:ClearAllPoints()
GameTimeFrame:SetPoint("TOPRIGHT",Minimap,-18,-18)
GameTimeFrame:SetHitRectInsets(0, 0, 0, 0)
GameTimeFrame:GetNormalTexture():SetTexCoord(0,1,0,1)
GameTimeFrame:SetNormalTexture(mediapath.."calendar")
GameTimeFrame:SetPushedTexture(nil)
GameTimeFrame:SetHighlightTexture (nil)
local fs = GameTimeFrame:GetFontString()
fs:ClearAllPoints()
fs:SetPoint("CENTER",0,-5)
fs:SetFont(STANDARD_TEXT_FONT,20)
fs:SetTextColor(0.2,0.2,0.1,0.9)

--zoom
Minimap:EnableMouseWheel()
local function Zoom(self, direction)
  if(direction > 0) then Minimap_ZoomIn()
  else Minimap_ZoomOut() end
end
Minimap:SetScript("OnMouseWheel", Zoom)

--onenter/show
local function Show()
  GameTimeFrame:SetAlpha(0.9)
  MiniMapTracking:SetAlpha(0.9)
end
Minimap:SetScript("OnEnter", Show)

--onleave/hide
local lasttime = 0
local function Hide()
  if Minimap:IsMouseOver() then return end
  if time() == lasttime then return end
  GameTimeFrame:SetAlpha(0)
  MiniMapTracking:SetAlpha(0)
end
local function SetTimer()
  lasttime = time()
  C_Timer.After(1.5, Hide)
end
Minimap:SetScript("OnLeave", SetTimer)
rLib:RegisterCallback("PLAYER_ENTERING_WORLD", Hide)
Hide(Minimap)

local function numformat(v)
  if v > 1E10 then
    return (floor(v/1E9)).."b"
  elseif v > 1E9 then
    return (floor((v/1E9)*10)/10).."b"
  elseif v > 1E7 then
    return (floor(v/1E6)).."m"
  elseif v > 1E6 then
    return (floor((v/1E6)*10)/10).."m"
  elseif v > 1E4 then
    return (floor(v/1E3)).."k"
  elseif v > 1E3 then
    return (floor((v/1E3)*10)/10).."k"
  else
    return v
  end
end

--fps, latency and coords string
local f1 = CreateFrame("Frame", "rInfoStringsContainer", Minimap)
f1:SetPoint("BOTTOM",Minimap,0,-5)

local t = f1:CreateFontString(nil, "BACKGROUND")
t:SetFont(STANDARD_TEXT_FONT,12,"OUTLINE")
t:SetPoint("CENTER", f1)

f1.text = t;

--experience
local f2 = CreateFrame("Frame", "rExperienceContainer", Minimap)
f2:SetPoint("BOTTOM",Minimap,0,-22)

local t2 = f2:CreateFontString(nil, "BACKGROUND")
t2:SetFont(STANDARD_TEXT_FONT,12,"OUTLINE")
t2:SetPoint("CENTER", f2)

f2.text = t2;



local function rFPS()
  return floor(GetFramerate()).."fps"
end

local function rLatency()
  return select(3, GetNetStats()).."ms"
end

local function rZoneCoords()
  local x, y = C_Map.GetPlayerMapPosition(C_Map.GetBestMapForUnit("player"), "player"):GetXY()
  local coords
  if x and y and x ~= 0 and y ~= 0 then
    coords = format("%.1f, %.1f",x*100,y*100)
  else 
    coords = "--.-, --.-"
  end
  return coords
end

local function rsiExpRep()
  local xp = ""

  if not IsXPUserDisabled() and (UnitLevel("player")<MAX_PLAYER_LEVEL) then
    if GetXPExhaustion() then
      xp = "|c009C907D("..numformat(GetXPExhaustion() or 0)..")|r "
    else 
      xp = ""
    end
    xp = "|c009C907D"..numformat(UnitXP("player")).."/"..numformat(UnitXPMax("player")).." |r"..xp.."| "..string.format("%.0f", (UnitXP("player")/UnitXPMax("player")*100)).."%|r"
  else
    local _, _, minimum, maximum, value = GetWatchedFactionInfo()
    if ((value-minimum)==999) and ((maximum-minimum)==1000) then
      xp = "|c0000FF00MAXED OUT|r"
    else
      xp = "|c0000FF00"..numformat(value-minimum).."/"..numformat(maximum-minimum).." | "..string.format("%.0f", (value-minimum)/(maximum-minimum)*100).."%|r"
    end
  end
  return xp
end

local function rUpdateStrings()
  f1.text:SetText(rZoneCoords().." / ".."|c009C907D"..rLatency().." "..rFPS().."|r")
  f1:SetHeight(f1.text:GetStringHeight())
  f1:SetWidth(f1.text:GetStringWidth())

  f2.text:SetText(rsiExpRep())
  f2:SetHeight(f2.text:GetStringHeight())
  f2:SetWidth(f2.text:GetStringWidth())
end

local startSearch = function(self)
  --timer
  local ag = self:CreateAnimationGroup()
  ag.anim = ag:CreateAnimation()
  ag.anim:SetDuration(1)
  ag:SetLooping("REPEAT")
  ag:SetScript("OnLoop", function(self, event, ...)
    rUpdateStrings()
  end)
  ag:Play()
end

local a = CreateFrame("Frame")
a:RegisterEvent("PLAYER_LOGIN")
a:SetScript("OnEvent", function(self, event, ...)
  if event == "PLAYER_LOGIN" then
    startSearch(self)
  end
end)

--drag frame
rLib:CreateDragFrame(MinimapCluster, L.dragFrames, -2, true)

--create slash commands
rLib:CreateSlashCmd(L.addonName, L.addonShortcut, L.dragFrames, L.addonColor)