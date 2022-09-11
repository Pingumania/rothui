
-- oUF_SimpleConfig: player
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Player Config
-----------------------------

L.C.player = {
  enabled = true,
  size = {266,30},
  point = {"RIGHT",UIParent,"CENTER",-225,-296},
  scale = 1*L.C.globalscale,
  -- frameVisibility = "[combat][mod:shift][@target,exists][@vehicle,exists][overridebar][shapeshift][vehicleui][possessbar] show; hide",
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
    --orientation = "VERTICAL",
    --health and absorb bar cannot be disabled, they match the size of the frame
    colorClass = true,
    colorHealth = true,
    colorThreat = true,
    name = {
      enabled = true,
      points = {
        {"TOPLEFT",2,7},
        {"TOPRIGHT",-2,7},
      },
      outline = "OUTLINE",
      size = 16,
      tag = "[oUF_Simple:leader][oUF_SimpleConfig:status]",
    },
    health = {
      enabled = true,
      point = {"RIGHT",-2,0},
      size = 16,
      tag = "[oUF_Simple:health]",
    },
    debuffHighlight = false,
  },
  --absorbbar
  absorbbar = {
    enabled = true,
  },
  --powerbar
  powerbar = {
    enabled = true,
    size = {266,4},
    point = {"TOP","BOTTOM",0,-3}, --if no relativeTo is given the frame base will be the relativeTo reference
    colorPower = true,
    frequentUpdates = true,
    power = {
      enabled = false,
      mouseover = false,
      point = {"CENTER"},
      size = 14,
      tag = "[curpp]",
    },
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
    point = {"CENTER",UIParent,"BOTTOM",18,200},
    --orientation = "VERTICAL",
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
      point = {"RIGHT","LEFT",-5,0},
    },
  },
  --classbar
  classbar = {
    enabled = true,
    size = {22,4},
    point = {"BOTTOMRIGHT","TOPRIGHT",0,3},
    splits = {
      enabled = true,
      texture = L.C.textures.split,
      size = {5,5},
      color = {0,0,0,1}
    },
  },
  --altpowerbar
  altpowerbar = {
    enabled = true,
    size = {130,5},
    point = {"BOTTOMLEFT","TOPLEFT",0,4},
  },
  --addpowerbar (additional powerbar, like mana if a druid has rage display atm)
  addpowerbar = {
    enabled = true,
    size = {26,35},
    point = {"TOPRIGHT","TOPLEFT",-4,0},
    orientation = "VERTICAL",
    colorPower = true,
  },
  --staggerbar for brewmaster monks
  staggerbar = {
    enabled = true,
    size = {26,35},
    point = {"TOPRIGHT","TOPLEFT",-4,0},
    orientation = "VERTICAL",
  },
}
