include("Stats.lua")

local CONSTANTS = {
  sql = {
    insertPlayer = "INSERT into tblWTPlayers (steamId) VALUES ('$STEAMID')",
    toggleTracking = "UPDATE tblWTPlayers SET allowTracking = (1 - allowTracking) WHERE steamID = $STEAMID;",
    getPlayer = "SELECT * FROM tblWTPlayers WHERE steamID = '$STEAMID'"
  }
}

function PlayerStats(ply)

  local self = {
    statsTable = {}, -- A collection of stats-objects per-weapon for a player
    pendingCommit = false,
    steamID = ply:SteamID64(),
    allowTracking = true
  }

  local function qryInsertPlayer()

    return sql.Query(CONSTANTS.sql.insertPlayer:gsub("$STEAMID", self.steamID)) ~= false

  end

  local function qryToggleTracking()

    return sql.Query(CONSTANTS.sql.toggleTracking:gsub("$STEAMID", self.steamID)) ~= false

  end

  local function qryGetPlayer()

    return sql.Query(CONSTANTS.Sql.getPlayer)

  end

  local function getPlayer()

    local existingPly = qryGetPlayer()

    if (!existingStat) then

      if (qryInsertPlayer() ~= false) then

        existingStat = qryGetPlayer()

      else

        existingStat = {CONSTANTS.classDefaults}

      end

    end

    return existingPly[0]

  end

  local function init()

    local this = getPlayer()

    self.allowTracking = this.allowTracking

  end

  -- Gets the 'stat' object instantiated for the player. Creates one if it does not exist
  local function getStatObject(weaponName)

    local stat = nil

    if (self.statsTable[weaponName] == nil) then
      self.statsTable[weaponName] = Stats(weaponName, self.steamID)
    end

    stat = self.statsTable[weaponName]

    return stat;

  end

  -- Returns a generic object of all 'stat' objects for the player
  local function getStats()
    return self.statsTable;
  end

  function self.commitChanges ()

    if (self.pendingCommit) then

      -- Loop through the stat objects and commit changes
      self.pendingCommit = false

    end

    self.pendingCommit = ~self.pendingCommit

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

  -- Return a new instance of the object
  return self
end
