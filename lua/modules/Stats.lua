-- Reverse map hitgroups (automation)
local hgENUMS = {
  "HITGROUP_GENERIC", -- index 0
  "HITGROUP_HEAD",
  "HITGROUP_CHEST",
  "HITGROUP_STOMACH",
  "HITGROUP_LEFTARM",
  "HITGROUP_RIGHTARM",
  "HITGROUP_LEFTLEG",
  "HITGROUP_RIGHTLEG" -- index 7
}

-- Stats Object

function Stats (weaponName)

  local self = {
    fireCount = 0,
    hitGroupCount = {
      TOTAL = 0, -- Total hits (TODO: Relegate to a calculated field?)
      HITGROUP_HEAD = 0,
      HITGROUP_CHEST = 0,
      HITGROUP_STOMACH = 0,
      HITGROUP_LEFTARM = 0,
      HITGROUP_RIGHTARM = 0,
      HITGROUP_LEFTLEG = 0,
      HITGROUP_RIGHTLEG = 0,
      HITGROUP_GENERIC = 0, -- to be aliased as 'OTHER'
    },
    weaponName = weaponName
  }

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
    if (self.fireCount ~= 0 && self.hitGroupCount.TOTAL ~= 0) then

      -- Divide the fire-count by the total amount of shots actually hit. round to
      -- 2 decimal places.
      t.accuracy = round((self.fireCount / self.hitGroupCount.TOTAL), 2)

    end

    -- If the user has hit a target...
    if (self.hitGroupCount.TOTAL ~= 0) then

      -- Go through each hitgroup. Splice off the HITGROUP_ prefix and downcase the result to
      -- append to the correct class-attribute property
      for k, i in pairs(self.hitGroupCount) do

        local value = i[k]
        local resolvedKey = k:gsub("HITGROUP_", ""):lower()

        -- Resolves the value for the hitgroup, if it's greater than 0 then...
        if (value ~= 0) then
          -- Append the accuracy of that particular hitgroup to the temporary table scoped to this function
          t.distribution[resolvedKey] = round((value / self.hitGroupCount.TOTAL), 2)
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
  function self.incrementHitGroupCount(hitGroup)
    local hgKey = hgENUMS[hitGroup];
    self.hitGroupCount[hgKey] = self.hitGroupCount[hgKey] + 1
    self.hitGroupCount.TOTAL = self.hitGroupCount.TOTAL + 1

  end

  -- Return a new instance of the stat object
  return self
end
