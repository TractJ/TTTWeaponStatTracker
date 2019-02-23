-- Reverse map hitgroups (automation)

local CONSTANTS = {
  sql = {
    insertStat = "INSERT into tblWTPlayerStats (steamID, weaponName) VALUES ('$STEAMID', '$WEAPONNAME')",
    updateStat = "UPDATE tblWTPlayerStats SET $FIELD = (SELECT $FIELD FROM tblWTPlayerStats WHERE steamID = '$STEAMID' and weaponName = '$WEAPONNAME');",
    getStat = "SELECT * FROM tblWTPlayerStats WHERE steamID = '$STEAMID' and weaponName = '$WEAPONNAME';"
  },
  hgENUMS = {
    "HITGROUP_GENERIC", -- index 0
    "HITGROUP_HEAD",
    "HITGROUP_CHEST",
    "HITGROUP_STOMACH",
    "HITGROUP_LEFTARM",
    "HITGROUP_RIGHTARM",
    "HITGROUP_LEFTLEG",
    "HITGROUP_RIGHTLEG" -- index 7
  },
  classDefaults = {
    fireCount = 0,
    TOTAL = 0,
    HITGROUP_HEAD = 0,
    HITGROUP_CHEST = 0,
    HITGROUP_STOMACH = 0,
    HITGROUP_LEFTARM = 0,
    HITGROUP_RIGHTARM = 0,
    HITGROUP_LEFTLEG = 0,
    HITGROUP_RIGHTLEG = 0,
    HITGROUP_GENERIC = 0
  }
}

-- Stats Object

function Stats (weaponName, steamID)

  local self = CONSTANTS.classDefaults

  self.weaponName = weaponName
  self.steamID = steamID

  local function qryInsertStat()

    return sql.Query(CONSTANTS.sql.insertStat:gsub("$STEAMID", self.steamID):gsub("$WEAPONNAME", self.weaponName)) ~= false

  end

  local function qryUpdateStat(field, fieldVal)

    return sql.Query(CONSTANTS.sql.updateStat:gsub("$STEAMID", self.steamID):gsub("$WEAPONNAME", self.weaponName):gsub("$FIELD", field):gsub("$FIELDVAL", fieldVal)) ~= false

  end

  local function qryGetStat()

    return sql.Query(CONSTANTS.Sql.getStat:gsub("$STEAMID", self.steamID):gsub("$WEAPONNAME", self.weaponName))

  end

  local function getStat()

    local existingStat = qryGetStat()

    if (!existingStat) then

      if (qryInsertStat() ~= false) then

        existingStat = qryGetStat()

      else

        existingStat = {CONSTANTS.classDefaults}

      end

    end

    return existingStat[0]

  end

  local function targetFromSrc(src, target)


    for _, k in pairs(src) do

      target[k] = src[k]

    end

    return target

  end

  local function init()

    local this = self

    self = targetFromSrc(getStat(), this)

  end

  function self.commitChanges()

    for k, _ in pairs(CONSTANTS.classDefaults) do

      if (self[k] ~= 0) then

        qryUpdateStat(k, self[k])

      end

    end

  end

  function getStats ()

    -- get the average hit rate
    -- get a distribution of your hits (most often hit)
    -- get the weapon name (obviously...)
    local t = {
      accuracy = 0.0,
      distribution = {
        head = 0.0,
        chest = 0.0,
        stomach = 0.0,
        leftarm = 0.0,
        rightarm = 0.0,
        leftleg = 0.0,
        rightleg = 0.0,
        generic = 0.0
      } -- accuracy
    }

    -- Ensure the user has data to return
    if (self.fireCount ~= 0 && self.TOTAL ~= 0) then

      -- Divide the fire-count by the total amount of shots actually hit. round to
      -- 2 decimal places.
      t.accuracy = round((self.fireCount / self.TOTAL), 2)

    end

    -- If the user has hit a target...
    if (self.TOTAL ~= 0) then

      -- Go through each hitgroup. Splice off the HITGROUP_ prefix and downcase the result to
      -- append to the correct class-attribute property
      for _, k in pairs(CONSTANTS.hgENUMS) do

        local value = self[k]
        local resolvedKey = k:gsub("HITGROUP_", ""):lower()

        -- Resolves the value for the hitgroup, if it's greater than 0 then...
        if (value ~= 0) then
          -- Append the accuracy of that particular hitgroup to the temporary table scoped to this function
          t.distribution[resolvedKey] = round((value / self.TOTAL), 2)
        end

      end

    end

    -- Return the table object
    return t

  end

  -- Simply increments the fire-count for this weapon
  function self.incrementFireCount()
    self.fireCount = self.fireCount + 1
  end

  -- Simply increments the hit-count for this particular weapon, scoped to a hitgroup
  function self.incrementHitGroupCount(hitGroupNum)
    local hgKey = CONSTANTS.hgENUMS[hitGroupNum];
    self[hgKey] = self[hgKey] + 1
    self.TOTAL = self.TOTAL + 1

  end

  init()

  -- Return a new instance of the stat object
  return self

end
