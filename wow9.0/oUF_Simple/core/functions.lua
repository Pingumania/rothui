
-- oUF_Simple: core/functions
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

local floor, unpack = floor, unpack

--functions container
L.F = {}

-----------------------------
-- Functions
-----------------------------

--NumberFormat
local function NumberFormat(v)
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
L.F.NumberFormat = NumberFormat

--CalcFrameSize
local function CalcFrameSize(numButtons,numCols,buttonWidth,buttonHeight,buttonMargin,framePadding)
  local numRows = ceil(numButtons/numCols)
  local frameWidth = numCols*buttonWidth + (numCols-1)*buttonMargin + 2*framePadding
  local frameHeight = numRows*buttonHeight + (numRows-1)*buttonMargin + 2*framePadding
  return frameWidth, frameHeight
end

--SetPoint
local function SetPoint(self,relativeTo,point)
  --adjut the setpoint function to make it possible to reference a relativeTo object that is set on runtime and it not available on config init
  local a,b,c,d,e = unpack(point)
  if not b then
    self:SetPoint(a)
  elseif b and type(b) == "string" and not _G[b] then
    self:SetPoint(a,relativeTo,b,c,d)
  else
    self:SetPoint(a,b,c,d,e)
  end
end

--SetPoints
local function SetPoints(self,relativeTo,points)
  for i, point in next, points do
    SetPoint(self,relativeTo,point)
  end
end

--CreateBackdrop
local function CreateBackdrop(self,relativeTo)
  local backdrop = L.C.backdrop
  local bd = CreateFrame("Frame", nil, self, BackdropTemplateMixin and "BackdropTemplate")
  bd:SetFrameLevel(self:GetFrameLevel()-1 or 0)
  bd:SetPoint("TOPLEFT", relativeTo or self, "TOPLEFT", -backdrop.inset, backdrop.inset)
  bd:SetPoint("BOTTOMRIGHT", relativeTo or self, "BOTTOMRIGHT", backdrop.inset, -backdrop.inset)
  bd:SetBackdrop(backdrop)
  bd:SetBackdropColor(unpack(backdrop.bgColor))
  bd:SetBackdropBorderColor(unpack(backdrop.edgeColor))
  return bd
end

--CreateIcon
local function CreateIcon(self,layer,sublevel,size,point)
  local icon = self:CreateTexture(nil,layer,nil,sublevel)
  icon:SetSize(unpack(size))
  SetPoint(icon,self,point)
  return icon
end

local function ColorHealthbarOnThreat(self,unit)
  if self.colorThreat and self.colorThreatInvers and unit and UnitThreatSituation("player", unit) == 3 then
    self:SetStatusBarColor(unpack(L.C.colors.healthbar.threatInvers))
    self.bg:SetVertexColor(unpack(L.C.colors.healthbar.threatInversBG))
  elseif self.colorThreat and unit and UnitThreatSituation(unit) == 3 then
    self:SetStatusBarColor(unpack(L.C.colors.healthbar.threat))
    self.bg:SetVertexColor(unpack(L.C.colors.healthbar.threatBG))
  end
end

local function SetClassPowerPosition(self, max)
  local parentWidth = floor(self.__owner:GetWidth()+0.5)
  local width = floor((self.__owner.cfg.size[1]/max)-0.5)
  local yOffset = 1
  local maxWidth = (width*max)+(max-1)*yOffset
  local diff = parentWidth-maxWidth

  for i=10,1,-1 do
    if (i > max) then
      self[i].bg:Hide()
    else
      self[i]:ClearAllPoints()
      self[i]:SetPoint("BOTTOMRIGHT", self.__owner, "TOPRIGHT", -((max-i)*(width+yOffset)), self.__owner.cfg.classbar.point[4])
      self[i]:SetWidth(width)
      self[i].bg:Show()
    end
  end

  if diff ~= 0 and (diff < max-1 or diff > -max+1) then
    local newWidth = parentWidth-diff
    local childWidth = (newWidth/2)-2
    self.__owner:SetWidth(newWidth)
    if self.__owner.cfg.size[1] == self.__owner.cfg.powerbar.size[1] then
      self.__owner.Power:SetWidth(newWidth)
    end
    if oUF_SimpleTarget then
      oUF_SimpleTarget:SetWidth(newWidth)
      oUF_SimpleTarget.Power:SetWidth(newWidth)
    end
    if oUF_SimpleTargetTarget then
      oUF_SimpleTargetTarget:SetWidth(childWidth)
    end
    if oUF_SimpleFocus then
      oUF_SimpleFocus:SetWidth(childWidth)
    end
    if oUF_SimplePet then
      oUF_SimplePet:SetWidth(childWidth)
    end
  end

  self.bd:ClearAllPoints()
  self.bd:SetPoint("BOTTOMLEFT", self.__owner, "TOPLEFT", -L.C.backdrop.inset, -self.__owner.cfg.classbar.point[4])
  self.bd:SetPoint("BOTTOMRIGHT", self.__owner, "TOPRIGHT", L.C.backdrop.inset, -self.__owner.cfg.classbar.point[4])
  self.bd:Show()
end

--PostUpdateHealth
local function PostUpdateHealth(self, unit, min, max)
  ColorHealthbarOnThreat(self, unit)
end

--PostUpdatePower
local function PostUpdatePower(self, unit)
  if UnitPowerType(unit) ~= Enum.PowerType.Mana then
    self:Hide()
  else
    self:Show()
  end
end

--PostUpdateClassPower
local function PostUpdateClassPower(self, cur, max, hasMaxChanged, powerType, chargedPoint)
  if not max then
    return
  end
  local color = self.__owner.colors.power[powerType]
  for i=1,10 do
    if (i <= max) then
      local r, g, b = color[1], color[2], color[3]
      local mu = self[i].bg.multiplier or 1
      if i == chargedPoint then
        r, g, b = unpack(L.C.colors.power.kyrian)
      end
      self[i]:SetStatusBarColor(r, g, b)
      self[i].bg:SetVertexColor(r*mu, g*mu, b*mu)
    end
  end
  if hasMaxChanged then
    SetClassPowerPosition(self, max)
  end
end

local function UpdateThreat(self)
  local status
	-- BUG: Non-existent '*target' or '*pet' units cause UnitThreatSituation() errors
	if (UnitExists(self.unit)) then
		status = UnitThreatSituation(self.unit)
	end

  local t = self.ThreatIndicator
	local r, g, b
	if (status and status > 0) then
		r, g, b = unpack(L.C.colors.threat[status])
		if (t.bd.SetBackdropColor) then
      t.bd:SetBackdropColor(r, g, b)
			t.bd:SetBackdropBorderColor(r, g, b)
		end
		t.bd:Show()
	else
		t.bd:Hide()
	end
end
L.F.UpdateThreat = UpdateThreat

--CreateText
local function CreateText(self, font, size, outline, align, noshadow)
  local text = self:CreateFontString(nil, "ARTWORK")
  text:SetFont(font or STANDARD_TEXT_FONT, size or 14, outline or "OUTLINE")
  text:SetJustifyH(align or "LEFT")
  if not noshadow then
    text:SetShadowColor(0,0,0,0.25)
    text:SetShadowOffset(1,-2)
  end
  --fix some wierd bug
  text:SetText("Bugfix")
  text:SetMaxLines(1)
  text:SetHeight(text:GetStringHeight())
  return text
end
L.F.CreateText = CreateText

--AltPowerBarOverride
local function AltPowerBarOverride(self, event, unit, powerType)
  if self.unit ~= unit or powerType ~= "ALTERNATE" then return end
  local ppmax = UnitPowerMax(unit, ALTERNATE_POWER_INDEX, true) or 0
  local ppcur = UnitPower(unit, ALTERNATE_POWER_INDEX, true)
  local _, r, g, b = GetUnitPowerBarTextureInfo(unit, 2)
  local _, ppmin = UnitPowerBarID(unit)
  local el = self.AlternativePower
  el:SetMinMaxValues(ppmin or 0, ppmax)
  el:SetValue(ppcur)
  if b then
    el:SetStatusBarColor(r, g, b)
    if el.bg then
      local mu = el.bg.multiplier or 0.3
      el.bg:SetVertexColor(r*mu, g*mu, b*mu)
    end
  else
    el:SetStatusBarColor(1, 0, 1)
    if el.bg then
      local mu = el.bg.multiplier or 0.3
      el.bg:SetVertexColor(1*mu, 0*mu, 1*mu)
    end
  end
  if self:GetName() == "oUF_SimplePlayer" and self.ClassPower.__isEnabled then
    SetPoint(el,self,{"BOTTOMLEFT","oUF_SimplePlayer","TOPLEFT",0,10})
  else
    SetPoint(el,self,self.cfg.altpowerbar.point)
  end
end

--CreateAltPowerBar
local function CreateAltPowerBar(self)
  if not self.cfg.altpowerbar or not self.cfg.altpowerbar.enabled then return end
  --statusbar
  local s = CreateFrame("StatusBar", nil, self)
  s:SetStatusBarTexture(L.C.textures.statusbar)
  s:SetSize(unpack(self.cfg.altpowerbar.size))
  s:SetOrientation(self.cfg.altpowerbar.orientation or "HORIZONTAL")
  SetPoint(s,self,self.cfg.altpowerbar.point)
  --bg
  local bg = s:CreateTexture(nil, "BACKGROUND")
  bg:SetTexture(L.C.textures.statusbar)
  bg:SetAllPoints()
  s.bg = bg
  --backdrop
  CreateBackdrop(s)
  --attributes
  s.Override = AltPowerBarOverride
  s.bg.multiplier = L.C.colors.bgMultiplier
  return s
end
L.F.CreateAltPowerBar = CreateAltPowerBar

--CreateAbsorbBar
local function CreateAbsorbBar(self)
  --like health the absorb bar cannot be disabled
  --statusbar
  local s = CreateFrame("StatusBar", nil, self.Health)
  s:SetAllPoints()
  s:SetOrientation(self.cfg.healthbar.orientation or "HORIZONTAL")
  s:SetStatusBarTexture(L.C.textures.absorb)
  s:SetStatusBarColor(unpack(L.C.colors.healthbar.absorb))
  s:SetReverseFill(true)
  return s
end
L.F.CreateAbsorbBar = CreateAbsorbBar

--CreateClassBar
local function CreateClassBar(self)
  if not self.cfg.classbar or not self.cfg.classbar.enabled then return end
  --statusbar
  local s = CreateFrame("StatusBar", nil, self)
  s:SetStatusBarTexture(L.C.textures.statusbar)
  s:SetSize(unpack(self.cfg.classbar.size))
  s:SetOrientation(self.cfg.classbar.orientation or "HORIZONTAL")
  SetPoint(s,self,self.cfg.classbar.point)
  --bg
  local bg = s:CreateTexture(nil, "BACKGROUND")
  bg:SetTexture(L.C.textures.statusbar)
  bg:SetAllPoints()
  s.bg = bg
  --backdrop
  CreateBackdrop(s)
  --attributes
  s.bg.multiplier = L.C.colors.bgMultiplier
  return s
end
L.F.CreateClassBar = CreateClassBar

--CreateClassPower
local function CreateClassPower(self)
  if not self.cfg.classbar or not self.cfg.classbar.enabled then return end
  local ClassPower = {}
  --statusbar
  for i=10,1,-1 do
    local s = CreateFrame("StatusBar", nil, self)
    s:SetStatusBarTexture(L.C.textures.statusbar)
    s:SetSize(unpack(self.cfg.classbar.size))
    --bg
    local bg = s:CreateTexture(nil, "BACKGROUND")
    bg:SetTexture(L.C.textures.statusbar)
    bg:SetAllPoints(s)
    bg:SetParent(self)
    bg.multiplier = L.C.colors.bgMultiplier
    s.bg = bg

    ClassPower[i] = s
  end
  -- backdrop
  local bd = CreateBackdrop(self)
  bd:SetHeight(self.cfg.classbar.size[2]+2*L.C.backdrop.inset)
  bd:SetFrameLevel(0)
  bd:Hide()
  ClassPower.bd = bd
  ClassPower.PostUpdate = PostUpdateClassPower
  return ClassPower
end
L.F.CreateClassPower = CreateClassPower

--CreateHealthBar
local function CreateHealthBar(self)
  --disabling the healthbar makes no sense, no check for enabled
  --statusbar
  local s = CreateFrame("StatusBar", nil, self)
  s:SetStatusBarTexture(L.C.textures.statusbar)
  s:SetAllPoints()
  s:SetOrientation(self.cfg.healthbar.orientation or "HORIZONTAL")
  if L.C.colors.healthbar and L.C.colors.healthbar.default then
    s:SetStatusBarColor(unpack(L.C.colors.healthbar.default))
  end
  --bg
  local bg = s:CreateTexture(nil, "BACKGROUND")
  bg:SetTexture(L.C.textures.statusbarBG)
  bg:SetAllPoints()
  if L.C.colors.healthbar and L.C.colors.healthbar.defaultBG then
    bg:SetVertexColor(unpack(L.C.colors.healthbar.defaultBG))
  end
  s.bg = bg
  --backdrop
  s.bdf = CreateBackdrop(s)
  if self.cfg.healthbar.debuffHighlight then
    self.DebuffHighlight = s.bdf
    self.DebuffHighlightBackdropBorder = true
    self.DebuffHighlightAlpha = 1
    self.DebuffHighlightFilter = self.cfg.healthbar.debuffHighlightFilter or false
  end
  --attributes
  s.colorTapping = self.cfg.healthbar.colorTapping
  s.colorDisconnected = self.cfg.healthbar.colorDisconnected
  s.colorReaction = self.cfg.healthbar.colorReaction
  s.colorClass = self.cfg.healthbar.colorClass
  s.colorHealth = self.cfg.healthbar.colorHealth
  s.colorThreat = self.cfg.healthbar.colorThreat
  s.colorThreatInvers = self.cfg.healthbar.colorThreatInvers
  s.bg.multiplier = L.C.colors.bgMultiplier
  s.frequentUpdates = self.cfg.healthbar.frequentUpdates
  --hooks
  s.PostUpdate = PostUpdateHealth
  return s
end
L.F.CreateHealthBar = CreateHealthBar

--CreateHealthPrediction
local function CreateHealthPrediction(self)
  if not self.cfg.absorbbar or not self.cfg.absorbbar.enabled then return end
  local myBar = CreateFrame("StatusBar", nil, self.Health)
  myBar:SetPoint("TOP")
  myBar:SetPoint("BOTTOM")
  myBar:SetPoint("LEFT", self.Health:GetStatusBarTexture(), "RIGHT")
  myBar:SetWidth(200)
  myBar:SetStatusBarTexture(L.C.textures.statusbar)
  myBar:SetStatusBarColor(unpack(L.C.colors.healthbar.own))
  local otherBar = CreateFrame("StatusBar", nil, self.Health)
  otherBar:SetPoint("TOP")
  otherBar:SetPoint("BOTTOM")
  otherBar:SetPoint("LEFT", self.Health:GetStatusBarTexture(), "RIGHT")
  otherBar:SetWidth(200)
  otherBar:SetStatusBarTexture(L.C.textures.statusbar)
  otherBar:SetStatusBarColor(unpack(L.C.colors.healthbar.other))
  local absorbBar = CreateFrame("StatusBar", nil, self.Health)
  absorbBar:SetPoint("TOP")
  absorbBar:SetPoint("BOTTOM")
  absorbBar:SetPoint("LEFT", self.Health:GetStatusBarTexture(), "RIGHT")
  absorbBar:SetWidth(200)
  absorbBar:SetStatusBarTexture(L.C.textures.absorb)
  absorbBar:SetStatusBarColor(unpack(L.C.colors.healthbar.absorb))
  local healAbsorbBar = CreateFrame("StatusBar", nil, self.Health)
  healAbsorbBar:SetPoint("TOP")
  healAbsorbBar:SetPoint("BOTTOM")
  healAbsorbBar:SetPoint("RIGHT", self.Health:GetStatusBarTexture())
  healAbsorbBar:SetWidth(200)
  healAbsorbBar:SetStatusBarTexture(L.C.textures.absorb)
  healAbsorbBar:SetReverseFill(true)
  local overAbsorb = self.Health:CreateTexture(nil, "OVERLAY")
  overAbsorb:SetPoint("TOP")
  overAbsorb:SetPoint("BOTTOM")
  overAbsorb:SetPoint("LEFT", self.Health, "RIGHT")
  overAbsorb:SetWidth(10)
  local overHealAbsorb = self.Health:CreateTexture(nil, "OVERLAY")
  overHealAbsorb:SetPoint("TOP")
  overHealAbsorb:SetPoint("BOTTOM")
  overHealAbsorb:SetPoint("RIGHT", self.Health, "LEFT")
  overHealAbsorb:SetWidth(10)
  -- Register with oUF
  return {
      myBar = myBar,
      otherBar = otherBar,
      absorbBar = absorbBar,
      healAbsorbBar = healAbsorbBar,
      overAbsorb = overAbsorb,
      overHealAbsorb = overHealAbsorb,
      maxOverflow = 1.05,
  }
end
L.F.CreateHealthPrediction = CreateHealthPrediction

--CreateThreatIndicator
local function CreateThreatIndicator(self)
  if self.unit ~= "player" then return end
  local s = CreateFrame("StatusBar", nil, self)
  SetPoints(s,self.Health,{{"TOPLEFT","TOPLEFT",-4,4},{"BOTTOMRIGHT","BOTTOMRIGHT",4,-4}})
  local bd = CreateBackdrop(s)
  bd:SetFrameStrata("BACKGROUND")
  bd:SetPoint("TOPLEFT", s, "TOPLEFT", -3, 3)
  bd:SetPoint("BOTTOMRIGHT", s, "BOTTOMRIGHT", 3, -3)
  s.bd = bd
  s.Override = L.F.UpdateThreat
  return s
end
L.F.CreateThreatIndicator = CreateThreatIndicator

--CreateAdditionalPowerBar
local function CreateAdditionalPowerBar(self)
  if not self.cfg.addpowerbar or not self.cfg.addpowerbar.enabled then return end
  --statusbar
  local s = CreateFrame("StatusBar", nil, self)
  s:SetStatusBarTexture(L.C.textures.statusbar)
  s:SetSize(unpack(self.cfg.addpowerbar.size))
  s:SetOrientation(self.cfg.addpowerbar.orientation or "HORIZONTAL")
  SetPoint(s,self,self.cfg.addpowerbar.point)
  --bg
  local bg = s:CreateTexture(nil, "BACKGROUND")
  bg:SetTexture(L.C.textures.statusbarBG)
  bg:SetAllPoints()
  s.bg = bg
  --backdrop
  CreateBackdrop(s)
  --attributes
  s.colorPower = self.cfg.addpowerbar.colorPower
  s.bg.multiplier = L.C.colors.bgMultiplier
  return s
end
L.F.CreateAdditionalPowerBar = CreateAdditionalPowerBar

--CreateStaggerBar
local function CreateStaggerBar(self)
  if(select(2, UnitClass("player")) ~= "MONK") then return end
  if not self.cfg.staggerbar or not self.cfg.staggerbar.enabled then return end
  --statusbar
  local s = CreateFrame("StatusBar", nil, self)
  s:SetStatusBarTexture(L.C.textures.statusbar)
  s:SetSize(unpack(self.cfg.staggerbar.size))
  s:SetOrientation(self.cfg.staggerbar.orientation or "HORIZONTAL")
  SetPoint(s,self,self.cfg.staggerbar.point)
  --bg
  local bg = s:CreateTexture(nil, "BACKGROUND")
  bg:SetTexture(L.C.textures.statusbarBG)
  bg:SetAllPoints()
  s.bg = bg
  --backdrop
  CreateBackdrop(s)
  --attributes
  s.bg.multiplier = L.C.colors.bgMultiplier
  return s
end
L.F.CreateStaggerBar = CreateStaggerBar

--CreatePowerBar
local function CreatePowerBar(self)
  if not self.cfg.powerbar or not self.cfg.powerbar.enabled then return end
  --statusbar
  local s = CreateFrame("StatusBar", nil, self)
  s:SetStatusBarTexture(L.C.textures.statusbar)
  s:SetSize(unpack(self.cfg.powerbar.size))
  s:SetOrientation(self.cfg.powerbar.orientation or "HORIZONTAL")
  SetPoint(s,self,self.cfg.powerbar.point)
  --bg
  local bg = s:CreateTexture(nil, "BACKGROUND")
  bg:SetTexture(L.C.textures.statusbarBG)
  bg:SetAllPoints()
  s.bg = bg
  --backdrop
  CreateBackdrop(s)
  --attributes
  s.colorPower = self.cfg.powerbar.colorPower
  s.bg.multiplier = L.C.colors.bgMultiplier
  s.frequentUpdates = self.cfg.powerbar.frequentUpdates
  
  if self.cfg.powerbar.onlyMana then
    s.PostUpdate = PostUpdatePower
  end

  return s
end
L.F.CreatePowerBar = CreatePowerBar

local function SetCastBarColorShielded(self)
  self.__owner:SetStatusBarColor(unpack(L.C.colors.castbar.shielded))
  self.__owner.bg:SetVertexColor(unpack(L.C.colors.castbar.shieldedBG))
end

local function SetCastBarColorDefault(self)
  self.__owner:SetStatusBarColor(unpack(L.C.colors.castbar.default))
  self.__owner.bg:SetVertexColor(unpack(L.C.colors.castbar.defaultBG))
end

--CreateCastBar
local function CreateCastBar(self)
  if not self.cfg.castbar or not self.cfg.castbar.enabled then return end
  --statusbar
  local s = CreateFrame("StatusBar", nil, self)
  s:SetStatusBarTexture(L.C.textures.statusbar)
  s:SetFrameStrata("MEDIUM")
  s:SetSize(unpack(self.cfg.castbar.size))
  s:SetOrientation(self.cfg.castbar.orientation or "HORIZONTAL")
  SetPoint(s,self,self.cfg.castbar.point)
  s:SetStatusBarColor(unpack(L.C.colors.castbar.default))
  --bg
  local bg = s:CreateTexture(nil, "BACKGROUND")
  bg:SetTexture(L.C.textures.statusbar)
  bg:SetAllPoints()
  bg:SetVertexColor(unpack(L.C.colors.castbar.defaultBG)) --bg multiplier
  s.bg = bg
  --backdrop
  CreateBackdrop(s)
  --icon for player and target only
  if self.cfg.castbar.icon and self.cfg.castbar.icon.enabled then
    --icon
    local i = s:CreateTexture(nil,"BACKGROUND",nil,-8)
    i:SetSize(unpack(self.cfg.castbar.icon.size))
    SetPoint(i,s,self.cfg.castbar.icon.point)
    if self.cfg.castbar.icon.texCoord then
      i:SetTexCoord(unpack(self.cfg.castbar.icon.texCoord))
    else
      i:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    end
    s.Icon = i
    --backdrop (for the icon)
    CreateBackdrop(s,i)
  end
  --shield
  local shield = s:CreateTexture(nil,"BACKGROUND",nil,-8)
  shield.__owner = s
  s.Shield = shield
  --use a trick here...we use the show/hide on the shield texture to recolor the castbar
  hooksecurefunc(shield,"Show",SetCastBarColorShielded)
  hooksecurefunc(shield,"Hide",SetCastBarColorDefault)
  --text
  if self.cfg.castbar.name and self.cfg.castbar.name.enabled then
    local cfg = self.cfg.castbar.name
    local name = CreateText(s,cfg.font,cfg.size,cfg.outline,cfg.align,cfg.noshadow)
    if cfg.points then
      SetPoints(name,s,cfg.points)
    else
      SetPoint(name,s,cfg.point)
    end
    s.Text = name
  end
  return s
end
L.F.CreateCastBar = CreateCastBar

--RaidTargetIndicator
local function RaidTargetIndicator(self)
  if not self.cfg.raidmark or not self.cfg.raidmark.enabled then return end
  return CreateIcon(self.rAbsorbBar or self.Health,"OVERLAY",-8,self.cfg.raidmark.size,self.cfg.raidmark.point)
end
L.F.RaidTargetIndicator = RaidTargetIndicator

--ReadyCheckIndicator
local function ReadyCheckIndicator(self)
  if not self.cfg.readycheck or not self.cfg.readycheck.enabled then return end
  return CreateIcon(self.rAbsorbBar or self.Health,"OVERLAY",-8,self.cfg.readycheck.size,self.cfg.readycheck.point)
end
L.F.ReadyCheckIndicator = ReadyCheckIndicator

--ResurrectIndicator
local function ResurrectIndicator (self)
  if not self.cfg.resurrect or not self.cfg.resurrect.enabled then return end
  return CreateIcon(self.rAbsorbBar or self.Health,"OVERLAY",-8,self.cfg.resurrect.size,self.cfg.resurrect.point)
end
L.F.ResurrectIndicator  = ResurrectIndicator

--CreateNameText
local function CreateNameText(self)
  if not self.cfg.healthbar or not self.cfg.healthbar.name or not self.cfg.healthbar.name.enabled then return end
  local cfg = self.cfg.healthbar.name
  local text = CreateText(self.rAbsorbBar or self.Health,cfg.font,cfg.size,cfg.outline,cfg.align,cfg.noshadow)
  if cfg.points then
    SetPoints(text,self.rAbsorbBar or self.Health,cfg.points)
  else
    SetPoint(text,self.rAbsorbBar or self.Health,cfg.point)
  end
  self:Tag(text, cfg.tag)
  self.Name = text
end
L.F.CreateNameText = CreateNameText

--CreateHealthText
local function CreateHealthText(self)
  if not self.cfg.healthbar or not self.cfg.healthbar.health or not self.cfg.healthbar.health.enabled then return end
  local cfg = self.cfg.healthbar.health
  local text = CreateText(self.rAbsorbBar or self.Health,cfg.font,cfg.size,cfg.outline,cfg.align,cfg.noshadow)
  if cfg.points then
    SetPoints(text,self.rAbsorbBar or self.Health,cfg.points)
  else
    SetPoint(text,self.rAbsorbBar or self.Health,cfg.point)
  end
  self:Tag(text, cfg.tag)
  self.Health.Text = text
end
L.F.CreateHealthText = CreateHealthText

--CreatePowerText
local function CreatePowerText(self)
  if not self.cfg.powerbar or not self.cfg.powerbar.power or not self.cfg.powerbar.power.enabled then return end
  local cfg = self.cfg.powerbar.power
  local text = CreateText(self.Power,cfg.font,cfg.size,cfg.outline,cfg.align,cfg.noshadow)
  if cfg.points then
    SetPoints(text,self.Power,cfg.points)
  else
    SetPoint(text,self.Power,cfg.point)
  end
  if self.cfg.powerbar.power.mouseover then
    text:Hide()
    self:HookScript("OnEnter", function() text:Show() end)
    self:HookScript("OnLeave", function() text:Hide() end)
    self.Power:HookScript("OnEnter", function() text:Show() end)
    self.Power:HookScript("OnLeave", function() text:Hide() end)
  end
  self:Tag(text, cfg.tag)
  self.Power.Text = text
end
L.F.CreatePowerText = CreatePowerText

--PostCreateAuras
local function PostCreateAuras(self,button)
  local bg = button:CreateTexture(nil,"BACKGROUND",nil,-8)
  bg:SetTexture(L.C.textures.aura)
  bg:SetVertexColor(0,0,0)
  bg:SetPoint("TOPLEFT", -7, 7)
  bg:SetPoint("BOTTOMRIGHT", 7, -7)
  button.bg = bg
  local border = button:CreateTexture(nil,"BACKGROUND")
  border:SetColorTexture(0,0,0)
  border:SetPoint("TOPLEFT", -1, 1)
  border:SetPoint("BOTTOMRIGHT", 1, -1)
  button.border = border
  button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
  button.count:SetFont(STANDARD_TEXT_FONT, self.size/1.65, "OUTLINE")
  button.count:SetShadowColor(0,0,0,0.6)
  button.count:SetShadowOffset(1,-1)
  button.count:ClearAllPoints()
  button.count:SetPoint("BOTTOMRIGHT", self.size/10, -self.size/10)
  button:SetFrameStrata("LOW")
end

--PostUpdateIcon
local function PostUpdateIcon(self,unit,button,index)
  local debuffType = select(4, UnitAura(unit, index, button.filter))
  local color = DebuffTypeColor[debuffType]
  button.bg:Show()
  button.border:Show()
  if button.isDebuff then
    color = color or DebuffTypeColor["none"]
  else
    color = color or L.C.colors.default
  end
  button.border:SetColorTexture(color.r, color.g, color.b)
end

--PostUpdateGapIcon
local function PostUpdateGapIcon(self,unit,button,visibleBuffs)
  button.bg:Hide()
  button.border:Hide()
end

--CreateBuffs
local function CreateBuffs(self)
  if not self.cfg.buffs or not self.cfg.buffs.enabled then return end
  local cfg = self.cfg.buffs
  local frame = CreateFrame("Frame", nil, self)
  SetPoint(frame,self,cfg.point)
  frame.num = cfg.num
  frame.size = cfg.size
  frame.spacing = cfg.spacing
  frame.initialAnchor = cfg.initialAnchor
  frame["growth-x"] = cfg.growthX
  frame["growth-y"] = cfg.growthY
  frame.disableCooldown = cfg.disableCooldown
  frame.filter = cfg.filter
  frame.CustomFilter = cfg.CustomFilter
  frame.PostCreateIcon = cfg.PostCreateAura or PostCreateAuras
  -- frame.PostUpdateIcon = PostUpdateIcon
  frame:SetSize(CalcFrameSize(cfg.num,cfg.cols,cfg.size,cfg.size,cfg.spacing,0))
  -- local t = frame:CreateTexture(nil,"BACKGROUND",nil,-8)
  -- t:SetAllPoints()
  -- t:SetColorTexture(0,1,0,0.2)
  return frame
end
L.F.CreateBuffs = CreateBuffs

--CreateDebuffs
local function CreateDebuffs(self)
  if not self.cfg.debuffs or not self.cfg.debuffs.enabled then return end
  local cfg = self.cfg.debuffs
  local frame = CreateFrame("Frame", nil, self)
  SetPoint(frame,self,cfg.point)
  frame.num = cfg.num
  frame.size = cfg.size
  frame.spacing = cfg.spacing
  frame.initialAnchor = cfg.initialAnchor
  frame["growth-x"] = cfg.growthX
  frame["growth-y"] = cfg.growthY
  frame.disableCooldown = cfg.disableCooldown
  frame.filter = cfg.filter
  frame.CustomFilter = cfg.CustomFilter
  frame.PostCreateIcon = cfg.PostCreateAura or PostCreateAuras
  frame.PostUpdateIcon = PostUpdateIcon
  frame:SetSize(CalcFrameSize(cfg.num,cfg.cols,cfg.size,cfg.size,cfg.spacing,0))
  -- local t = frame:CreateTexture(nil,"BACKGROUND",nil,-8)
  -- t:SetAllPoints()
  -- t:SetColorTexture(1,0,0,0.2)
  return frame
end
L.F.CreateDebuffs = CreateDebuffs

--CreateAuras
local function CreateAuras(self)
  if not self.cfg.auras or not self.cfg.auras.enabled then return end
  local cfg = self.cfg.auras
  local frame = CreateFrame("Frame", nil, self)
  SetPoint(frame,self,cfg.point)
  frame.numBuffs = cfg.numBuffs
  frame.numDebuffs = cfg.numDebuffs
  frame.numTotal = cfg.numTotal
  frame.size = cfg.size
  frame.spacing = cfg.spacing
  frame.gap = cfg.gap
  frame.initialAnchor = cfg.initialAnchor
  frame["growth-x"] = cfg.growthX
  frame["growth-y"] = cfg.growthY
  frame.disableCooldown = cfg.disableCooldown
  frame.buffFilter = cfg.buffFilter
  frame.debuffFilter = cfg.debuffFilter
  frame.CustomFilter = cfg.CustomFilter
  frame.PostCreateIcon = cfg.PostCreateAura or PostCreateAuras
  frame.PostUpdateIcon = PostUpdateIcon
  frame.PostUpdateGapIcon = PostUpdateGapIcon
  frame:SetSize(CalcFrameSize(cfg.numTotal,cfg.cols,cfg.size,cfg.size,cfg.spacing,0))
  -- local t = frame:CreateTexture(nil,"BACKGROUND",nil,-8)
  -- t:SetAllPoints()
  -- t:SetColorTexture(1,0,0,0.2)
  return frame
end
L.F.CreateAuras = CreateAuras

--SetupHeader
local function SetupHeader(self)
  if not self.settings.setupHeader then return end
  self:RegisterForClicks("AnyDown")
  self:SetScript("OnEnter", UnitFrame_OnEnter)
  self:SetScript("OnLeave", UnitFrame_OnLeave)
end
L.F.SetupHeader = SetupHeader

--SetupFrame
local function SetupFrame(self)
  if not self.settings.setupFrame then return end
  self:SetIgnoreParentScale(true)
  self:SetScale(L.C.globalscale)
  self:SetSize(unpack(self.cfg.size))
  self:SetPoint(unpack(self.cfg.point))
end
L.F.SetupFrame = SetupFrame

--CreateDragFrame
local function CreateDragFrame(self)
  if not self.settings.createDrag then return end
  rLib:CreateDragFrame(self, L.dragFrames, -2, true)
end
L.F.CreateDragFrame = CreateDragFrame