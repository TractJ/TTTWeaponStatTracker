CREATE TABLE IF NOT EXISTS tblWTPlayerStats(
  steamID TEXT NOT NULL,
  weaponName TEXT NOT NULL,
  fireCount INT DEFAULT 0,
  TOTAL INT DEFAULT 0,
  HITGROUP_HEAD INT DEFAULT 0,
  HITGROUP_CHEST INT DEFAULT 0,
  HITGROUP_STOMACH INT DEFAULT 0,
  HITGROUP_LEFTARM INT DEFAULT 0,
  HITGROUP_RIGHTARM INT DEFAULT 0,
  HITGROUP_LEFTLEG INT DEFAULT 0,
  HITGROUP_RIGHTLEG INT DEFAULT 0,
  HITGROUP_GENERIC INT DEFAULT 0,
  PRIMARY KEY (steamID, weaponName)
);
