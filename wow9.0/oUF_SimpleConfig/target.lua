
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
  size = {272,26},
  point = {"LEFT",UIParent,"CENTER",213,-273},
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
    colorHealth = true,
    colorThreat = true,
    colorThreatInvers = true,
    name = {
      enabled = true,
      points = {
        {"TOPLEFT",2,10},
        {"TOPRIGHT",-2,10},
      },
      size = 16,
      tag = "[oUF_SimpleConfig:classification][difficulty][name]|r",
    },
    health = {
      enabled = true,
      point = {"RIGHT",-2,0},
      size = 15,
      tag = "[oUF_Simple:health]",
    },
    debuffHighlight = false,
  },
  --powerbar
  powerbar = {
    enabled = true,
    size = {272,5},
    point = {"TOP","BOTTOM",0,-4}, --if no relativeTo is given the frame base will be the relativeTo reference
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
    size = {267,28},
    point = {"CENTER",UIParent,"BOTTOM",-16,225},
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
      --noshadow = true,
    },
    icon = {
      enabled = true,
      size = {26,26},
      point = {"LEFT","RIGHT",6,0},
    },
  },
  buffs = {
    enabled = true,
    point = {"BOTTOMRIGHT","TOPRIGHT",0,15},
    num = 32,
    cols = 4,
    size = 30,
    spacing = 4,
    initialAnchor = "BOTTOMRIGHT",
    growthX = "LEFT",
    growthY = "UP",
    disableCooldown = false,
  },
  debuffs = {
    enabled = true,
    point = {"BOTTOMLEFT","TOPLEFT",0,15},
    num = 40,
    cols = 4,
    size = 30,
    spacing = 8,
    initialAnchor = "BOTTOMLEFT",
    growthX = "RIGHT",
    growthY = "UP",
    disableCooldown = false,
    filter = "PLAYER",
  },
}
