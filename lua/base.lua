include("modules/WeaponStatTracker.lua")

----------
-- INIT --
----------
wTrack = WeaponStatTracker()

---------------
-- DEBUGGING --
---------------
-- This will be removed in the future upon release
concommand.Add("WeaponStats_getMyStats", function(ply, cmd, args)

  print(wTrack.getWeaponStats(ply))

end)
concommand.Add("GiveWeapon", function(ply, cmd, args)

  ply:Give("weapon_ttt_glock")
  ply:Give("weapon_ttt_m16")

end)
