include("PlayerStats.lua")

-- Weapon Tracker (General Class)

function WeaponStatTracker()

  -- Class For tracking
  local self = {
    playerTable = {}, -- list of players, and a list of stats per player
    timer = nil,
    timeoutIterations = 0
  }

  local function getPlayerStatObject(ply)

    local steamID64 = ply:SteamID64()

    local oPly = nil

    if (self.playerTable[steamID64] == nil) then
      self.playerTable[steamID64] = PlayerStats(ply)
    end
    oPly = self.playerTable[steamID64]
    return oPly;

  end

  local function bindEntityFireBullets()
    -- preAmble
    local function handleEntityFireBullets (ent, dt)

      local aWep = tostring(ent:GetActiveWeapon():GetClass())

      local oPly = getPlayerStatObject(ent)

      oPly.handleWeaponFire(aWep)
    end

    hook.Add("EntityFireBullets", "WT_ttt2_EntityFireBullets", handleEntityFireBullets)

  end

  local function bindScalePlayerDamage()

    local function handleScalePlayerDamage ( ply, hitGroup, dmgInfo )

      local hitPly = ply
      local attackingPly = dmgInfo:GetAttacker()

      local aWep = tostring(attackingPly:GetActiveWeapon():GetClass())

      local oPly = getPlayerStatObject(attackingPly)

      oPly.handleWeaponHit(aWep, hitGroup)
    end

    hook.Add("ScalePlayerDamage", "WT_ttt2_ScalePlayerDamage", handleScalePlayerDamage)

  end

  function self.getWeaponStats(ply)

    local p = getPlayerStatObject(ply)

    return p.tostring()

  end

  bindEntityFireBullets()
  bindScalePlayerDamage()

  return self
end
