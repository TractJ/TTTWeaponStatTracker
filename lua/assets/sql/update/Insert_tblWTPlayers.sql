INSERT into tblWTPlayers (playerID, allowTracking) SELECT $PARAM1, $PARAM2
EXCEPT
SELECT playerID, allowTracking FROM tblWTPlayers WHERE playerID=$PARAM1
