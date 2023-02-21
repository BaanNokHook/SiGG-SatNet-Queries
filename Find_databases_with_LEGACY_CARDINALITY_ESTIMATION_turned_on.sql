CREATE TABLE #dbs     
(
      [dbname] sysname NOT NULL,  
      value SQL_VARIANT NOT NULL  
);  

INSERT INTO #dbs  
EXEC sp_ineachdb 'SELECT DB_NAME(DB_ID()), value FROM sys.database_scoped_configuration WHERE name = ''LEGACY_CARDINALITY_ESTIMATION'' AND value = 1';  

SELECT dbname AS DatabaseName, 'USE ' + dbname + '; ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF' AS CommandToTurnOff
FROM #dbs;

DROP TABLE #dbs;

