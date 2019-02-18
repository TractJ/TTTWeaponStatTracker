include("modules/WeaponTracking.lua")

-- Init weapon tracking
wTrack = WeaponTracker()


concommand.Add("WeaponStats_getMyStats", function(ply, cmd, args)

  print(wTrack.getWeaponStats(ply))

end)

concommand.Add("GiveWeapon", function(ply, cmd, args)

  ply:Give("weapon_ttt_glock")
  ply:Give("weapon_ttt_m16")

end)
