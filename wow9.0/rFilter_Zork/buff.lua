
-- rFilter_Zork: buff
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Buff Config
-----------------------------

if L.C.playerName == "Zörk" then
  rFilter:CreateBuff(132404,"player",36,{"CENTER"},"[spec:3,combat]show;hide",{0.2,1},true,nil) --SB
  rFilter:CreateBuff(190456,"player",36,{"CENTER"},"[spec:3,combat]show;hide",{0.2,1},true,nil) --IP
end

