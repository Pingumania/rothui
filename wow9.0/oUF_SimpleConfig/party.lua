
-- oUF_SimpleConfig: party
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

local character = UnitName("player")

-----------------------------
-- Party Config
-----------------------------

L.C.party = {
  enabled = false,
  size = {178,22},
  point = { "BOTTOMRIGHT", "oUF_SimplePlayer", "TOPLEFT", -55, 135 },
  scale = 1*L.C.globalscale,
  --healthbar
  healthbar = {
    --health and absorb bar cannot be disabled, they match the size of the frame
    colorDisconnected = true,
    colorClass = true,
    colorReaction = true,
    colorHealth = true,
    colorThreat = true,
    name = {
      enabled = true,
      points = {
        {"TOPLEFT",2,10},
        {"TOPRIGHT",-2,10},
      },
      size = 14,
      tag = "[name][oUF_Simple:leader][oUF_Simple:role]",
    },
    health = {
      enabled = true,
      point = {"RIGHT",-2,0},
      size = 14,
      tag = "[oUF_Simple:health]",
    },
    debuffHighlight = true,
  },
  --powerbar
  powerbar = {
    enabled = true,
    size = {178,4},
    point = {"TOP","BOTTOM",0,-3}, --if no relativeTo is given the frame base will be the relativeTo reference
    colorPower = true,
  },
  --raidmark
  raidmark = {
    enabled = true,
    size = {18,18},
    point = {"CENTER","TOP",0,4},
  },
  --readycheck
  readycheck = {
    enabled = true,
    size = {26,26},
    point = {"CENTER","CENTER",0,0},
  },
  --resurrect
  resurrect = {
    enabled = true,
    size = {26,26},
    point = {"CENTER","CENTER",0,0},
  },
  --debuffs
  debuffs = {
    enabled = true,
    point = {"LEFT","RIGHT",5,0},
    num = 3,
    cols = 3,
    size = 26,
    spacing = 5,
    initialAnchor = "TOPLEFT",
    growthX = "RIGHT",
    growthY = "DOWN",
    disableCooldown = true,
  },
  setup = {
    template = nil,
    visibility = "custom [group:party,nogroup:raid] show; hide",
    showPlayer = true,
    showSolo = false,
    showParty = true,
    showRaid = false,
    point = "TOP",
    xOffset = 0,
    yOffset = -27,
  },
  range = {
    insideAlpha = 1,
    outsideAlpha = .5,
  },
}