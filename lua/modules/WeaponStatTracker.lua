include("PlayerStats.lua")

-- Weapon Tracker (General Class)

function WeaponStatTracker()

  -- Class-Attributes
  local self = {
    playerTable = {}, -- list of players, containing a list of stat objects
    timer = nil, -- to iterate at a constant interval checking if each player has pending changes. If so--commit them.
    timeoutIterations = 0 -- to be used in handling how many iterations to check (maybe on a timer?) before queuing data commits
  }

  -- Resolves a stat object per a provided player ent. Generates one if it does not exist.
  local function getPlayerStatObject(ply)

    local steamID64 = ply:SteamID64()

    local oPly = nil

    if (self.playerTable[steamID64] == nil) then
      self.playerTable[steamID64] = PlayerStats(ply)
    end
    oPly = self.playerTable[steamID64]
    return oPly;

  end

  -- Binds a function handling a hook (triggered when a player fires bullets from a weapon/ent)
  local function bindEntityFireBullets()
    -- preAmble
    local function handleEntityFireBullets (ent, dt)

      local aWep = tostring(ent:GetActiveWeapon():GetClass())

      local oPly = getPlayerStatObject(ent)

      oPly.handleWeaponFire(aWep)
    end

    hook.Add("EntityFireBullets", "WT_ttt2_EntityFireBullets", handleEntityFireBullets)

  end

  -- Binds a function handling a hook (triggered when a player takes damage)
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

  -- Calls the tostring method of the 'PlayerStat' object returned from getPlayerStatObject
  function self.getWeaponStats(ply)

    local p = getPlayerStatObject(ply)

    return p.tostring()

  end

  -- Init the binds when we generate an instance of the tracker-class
  bindEntityFireBullets()
  bindScalePlayerDamage()

  return self
end
