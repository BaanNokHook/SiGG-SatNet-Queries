CREATE TABLE #DBInfo
(
    Id INT IDENTITY(1, 1),
    ParentObject VARCHAR(255),
    [Object] VARCHAR(255),
    Field VARCHAR(255),
    [Value] VARCHAR(255)
);

CREATE TABLE #Value
(
    DatabaseName VARCHAR(255),
    LastDBCCCheckDB_RunDate VARCHAR(255)
);

EXECUTE dbo.sp_foreachdb @command = 'INSERT INTO #DBInfo Execute (''DBCC DBINFO ( ''''?'''') WITH TABLERESULTS'');
INSERT INTO #Value (DatabaseName) SELECT [Value] FROM #DBInfo WHERE Field IN (''dbi_dbname'');
UPDATE #Value SET LastDBCCCHeckDB_RunDate = (SELECT TOP 1 [Value] FROM #DBInfo WHERE Field IN (''dbi_dbccLastKnownGood'')) where LastDBCCCHeckDB_RunDate is NULL;
TRUNCATE TABLE #DBInfo', @suppress_quotename = 1;

SELECT DatabaseName,
       LastDBCCCheckDB_RunDate,
	   'DBCC CHECKDB(' + DatabaseName + ')' AS DBCCCOmmand
FROM #Value
ORDER BY LastDBCCCheckDB_RunDate;

DROP TABLE #DBInfo;
DROP TABLE #Value;