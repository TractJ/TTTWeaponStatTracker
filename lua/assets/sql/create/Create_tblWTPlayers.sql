CREATE TABLE IF NOT EXISTS tblWTPlayers(
 steamID TEXT PRIMARY KEY,
 allowTracking INT NOT NULL DEFAULT 1,
 createdAt DATETIME DEFAULT current_timestamp,
 updatedAt DATETIME DEFAULT current_timestamp
);
