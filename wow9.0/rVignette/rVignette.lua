-- rVignette: core
-- zork, 2018

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Functions
-----------------------------

local function OnVignetteAdded(self,event,id)
  if not id then return end
  self.vignettes = self.vignettes or {}
  if self.vignettes[id] then return end
  local vignetteInfo = C_VignetteInfo.GetVignetteInfo(id)
  if not vignetteInfo then return end
  local atlas = C_Texture.GetAtlasInfo(vignetteInfo.atlasName)
  if not atlas.filename then return end
  local atlasWidth = atlas.width/(atlas.txRight-atlas.txLeft)
  local atlasHeight = atlas.height/(atlas.txBottom-atlas.txTop)
  local str = string.format("|T%s:%d:%d:0:0:%d:%d:%d:%d:%d:%d|t", atlas.filename, 0, 0, atlasWidth, atlasHeight, atlasWidth*atlas.txLeft, atlasWidth*atlas.txRight, atlasHeight*atlas.txTop, atlasHeight*atlas.txBottom)
  PlaySoundFile("Sound\\Interface\\RaidWarning.ogg")
  RaidNotice_AddMessage(RaidWarningFrame, str.." "..vignetteInfo.name.." spotted!", ChatTypeInfo["RAID_WARNING"])
  print(str.." "..vignetteInfo.name,"spotted!")
  self.vignettes[id] = true
end

-----------------------------
-- Init
-----------------------------

--eventHandler
local eventHandler = CreateFrame("Frame")
eventHandler:RegisterEvent("VIGNETTE_MINIMAP_UPDATED")
eventHandler:SetScript("OnEvent", OnVignetteAdded)