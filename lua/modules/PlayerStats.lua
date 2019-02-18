include("Stats.lua")

function PlayerStats(ply)

  local self = {
    statsTable = {}, -- A collection of stats-objects per-weapon for a player
    pendingCommit = false,
    steamID = ""
  }

  self.steamID = ply:SteamID64()

  -- Gets the 'stat' object instantiated for the player. Creates one if it does not exist
  local function getStatObject(weaponName)

    local stat = nil

    if (self.statsTable[weaponName] == nil) then
      self.statsTable[weaponName] = Stats(weaponName)
    end

    stat = self.statsTable[weaponName]

    return stat;

  end

  -- Returns a generic object of all 'stat' objects for the player
  local function getStats()
    return self.statsTable;
  end

  -- Parses the PlayerStats object to a prettified JSON string
  function self.tostring()
    return table.ToString(self, self.steamID .. "WT -- Stats: ", true)
  end

  -- Get the stat object for the provided weapon, and increment the fire count
  function self.handleWeaponFire(weaponName)

    local stat = getStatObject(weaponName)
    stat.incrementFireCount()
    self.statsTable[weaponName] = stat
    self.pendingCommit = true

  end

  -- Get the stat object for the provided weapon, and increment the hitgroup count on-hhit
  function self.handleWeaponHit(weaponName, hitGroup)

    local stat = getStatObject(weaponName)
    stat.incrementHitGroupCount(hitGroup)
    self.statsTable[weaponName] = stat;
    self.pendingCommit = true
  end

  function commitChanges ()

    -- TODO - Insert table data here.

    self.pendingCommit = false
  end

  -- Return a new instance of the object
  return self
end
