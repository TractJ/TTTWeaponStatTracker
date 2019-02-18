CREATE TABLE IF NOT EXISTS tblWTPlayerStats(
  statID INT PRIMARY KEY,
  playerID TEXT NOT NULL,
  weaponName TEXT NOT NULL,
  fireCount INT DEFAULT 0,
  headHits INT DEFAULT 0,
  chestHits INT DEFAULT 0,
  stomachHits INT DEFAULT 0,
  leftarmHits INT DEFAULT 0,
  rightarmHits INT DEFAULT 0,
  leftlegHits INT DEFAULT 0,
  rightlegHits INT DEFAULT 0,
  genericHits INT DEFAULT 0
);
