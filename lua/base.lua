include("modules/WeaponStatTracker.lua")

local CONSTANTS = {
  timerTickRateS = 15, -- seconds
  sql = {
    reupPlayers = [[
      CREATE TABLE IF NOT EXISTS tblWTPlayers(
       steamID TEXT PRIMARY KEY,
       allowTracking INT NOT NULL DEFAULT 1,
       createdAt DATETIME DEFAULT current_timestamp,
       updatedAt DATETIME DEFAULT current_timestamp
      );
    ]],
    reupStats = [[
      CREATE TABLE IF NOT EXISTS tblWTPlayerStats(
        steamID TEXT NOT NULL,
        weaponName TEXT NOT NULL,
        fireCount INT DEFAULT 0,
        headHits INT DEFAULT 0,
        chestHits INT DEFAULT 0,
        stomachHits INT DEFAULT 0,
        leftarmHits INT DEFAULT 0,
        rightarmHits INT DEFAULT 0,
        leftlegHits INT DEFAULT 0,
        rightlegHits INT DEFAULT 0,
        genericHits INT DEFAULT 0,
        PRIMARY KEY (steamID, weaponName)
      );
    ]]
  }
}

local function init()
  sql.Query(CONSTANTS.sql.reupPlayers);
  sql.Query(CONSTANTS.sql.reupStats);
end

local function handleCommitTimerTick(trackObj)

  -- Handle functions for WeaponStatTracker class here.

  -- TODO:
  --    1. Specify class function for checking whether or not to commit user stat changes
  --    2. Create a logging-scheme in the same fashion that handles these changes (commit successful or not)
  --    3. Exclusion-list? (Certain users may not wish to be tracked, Administrators may have debugging accounts?)

end

local function generateCommitTimer(name, trackObj)

  timer.Create(name, CONSTANTS.timerTickRateS, 0, function() handleCommitTimerTick(trackObj) end)

end

----------
-- INIT --
----------
-- Pre-requisite instantiation/functions to call
init()

-- Initialize a WeaponStatTracker object
wTrack = WeaponStatTracker()

-- Create a timer to handle the WeaponStatTracker object's methods (comitting changes)
generateCommitTimer("GlobalCommitTimer", wTrack)

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
