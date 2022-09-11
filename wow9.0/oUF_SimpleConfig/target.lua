
-- oUF_SimpleConfig: target
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Target Config
-----------------------------

L.C.target = {
  enabled = true,
  size = {266,30},
  point = {"LEFT",UIParent,"CENTER",225,-296},
  scale = 1*L.C.globalscale,
  --fader via OnShow
  fader = {
    fadeInAlpha = 1,
    fadeInDuration = 0.3,
    fadeInSmooth = "OUT",
    fadeOutAlpha = 0,
    fadeOutDuration = 0.9,
    fadeOutSmooth = "OUT",
    fadeOutDelay = 0,
    trigger = "OnShow",
  },
  --healthbar
  healthbar = {
    --health and absorb bar cannot be disabled, they match the size of the frame
    colorTapping = true,
    colorDisconnected = true,
    colorClass = true,
    colorReaction = true,
    colorHealth = false,
    colorThreat = false,
    colorThreatInvers = true,
    name = {
      enabled = true,
      points = {
        {"TOPLEFT",2,7},
        {"TOPRIGHT",-2,7},
      },
      size = 16,
      tag = "[oUF_SimpleConfig:classification][difficulty][name]|r",
    },
    health = {
      enabled = true,
      point = {"RIGHT",-2,0},
      size = 16,
      tag = "[oUF_Simple:health]",
    },
    debuffHighlight = false,
  },
  --powerbar
  powerbar = {
    enabled = true,
    size = {266,4},
    point = {"TOP","BOTTOM",0,-3}, --if no relativeTo is given the frame base will be the relativeTo reference
    colorPower = true,
  },
  --leader
  leader = {
    enabled = true,
    size = {18,18},
    point = {"BOTTOMRIGHT","TOPRIGHT",0,-6},
  },
  --raidmark
  raidmark = {
    enabled = true,
    size = {18,18},
    point = {"CENTER","TOP",0,4},
  },
  --castbar
  castbar = {
    enabled = true,
    size = {300,32},
    point = {"CENTER",UIParent,"BOTTOM",-18,242},
    name = {
      enabled = true,
      points = {
        {"LEFT",2,0},
        {"RIGHT",-2,0},
      },
      --font = STANDARD_TEXT_FONT,
      size = 16,
      --outline = "",--OUTLINE",
      --align = "CENTER",
      noshadow = true,
    },
    icon = {
      enabled = true,
      size = {31,31},
      point = {"LEFT","RIGHT",5,0},
    },
  },
  buffs = {
    enabled = true,
    point = {"BOTTOMLEFT","TOPLEFT",0,15},
    num = 32,
    cols = 8,
    size = 30,
    spacing = 4,
    initialAnchor = "BOTTOMLEFT",
    growthX = "RIGHT",
    growthY = "UP",
    disableCooldown = false,
    filter = "HELPFUL",
  },
  debuffs = {
    enabled = true,
    point = {"BOTTOMLEFT","TOPLEFT",0,15},
    num = 40,
    cols = 8,
    size = 30,
    spacing = 4,
    initialAnchor = "BOTTOMLEFT",
    growthX = "RIGHT",
    growthY = "UP",
    disableCooldown = false,
    filter = "PLAYER",
  },
  auras = {
    enabled = true,
    point = {"BOTTOMLEFT","TOPLEFT",0,15},
    numBuffs = 32,
    numDebuffs = 40,
    numTotal = 72,
    gap = true,
    cols = 8,
    size = 30,
    spacing = 4,
    initialAnchor = "BOTTOMLEFT",
    growthX = "RIGHT",
    growthY = "UP",
    disableCooldown = false,
    buffFilter = "HELPFUL",
    debuffFilter = "PLAYER",
  },
}
