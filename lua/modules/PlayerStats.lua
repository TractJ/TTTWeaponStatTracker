include("Stats.lua")

local CONSTANTS = {
  sql = {
    insertPlayer = [[
      INSERT into tblWTPlayers (playerID, allowTracking) SELECT $PARAM1, $PARAM2
      EXCEPT
      SELECT playerID, allowTracking FROM tblWTPlayers WHERE playerID=$PARAM1;
    ]]
  }
}

function PlayerStats(ply, canTrack, isDebug)

  local self = {
    statsTable = {}, -- A collection of stats-objects per-weapon for a player
    pendingCommit = false,
    steamID = "",
    isDebug = false
  }

  if (options ~= nil && isDebug == true)then

    self.isDebug = true

  end

  self.steamID = ply:SteamID64()

  local function preInitFunc()

    local param1 = self.steamID

    local param2 = true

    if (canTrack ~= nil && type(canTrack) == "boolean") then
      param2 = canTrack
    end

    local sSql = CONSTANTS.sql.insertPlayer:gsub("$PARAM1", param1):gsub("$PARAM2", param2)
    sql.Query(sSql)


  end

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

  function commitChanges ()

    -- TODO - Insert table data here.


    self.pendingCommit = false
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
