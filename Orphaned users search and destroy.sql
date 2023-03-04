DECLARE @SQL AS NVARCHAR(2000)    = N'
INSERT INTO #Orphan
(
DBName
,IsReadOnly
,UserName
,UserType
,DropScript
)
SELECT
DB_NAME()
,(SELECT is_read_only FROM sys.databases WHERE name = DB_NAME())
,dp.name
,dp.type_desc
,CASE
WHEN (SELECT is_read_only FROM sys.databases WHERE name = DB_NAME()) = 0 THEN ''USE '' + QUOTENAME(DB_NAME()) + ''; DROP USER '' + QUOTENAME(dp.name) + '';''
WHEN (SELECT is_read_only FROM sys.databases WHERE name = DB_NAME()) = 1
THEN ''USE master; ALTER DATABASE ''
+ QUOTENAME(DB_NAME()) + '' SET READ_WRITE WITH NO_WAIT; USE ''
+ QUOTENAME(DB_NAME()) + ''; DROP USER '' + QUOTENAME(dp.name)
+ ''; USE master; ALTER DATABASE '' + QUOTENAME(DB_NAME()) + '' SET READ_ONLY WITH NO_WAIT;''
ELSE NULL
END
FROM sys.database_principals AS dp
LEFT JOIN sys.server_principals AS sp ON dp.sid = sp.sid
WHERE
dp.type IN (''G'', ''S'', ''U'')
AND dp.name NOT IN(
''guest'', ''INFORMATION_SCHEMA'', ''sys'', ''dbo'', ''MS_DataCollectorInternalUser'', ''AllSchemaOwner'', ''mdw_check_operator_admin'', ''auraReportsUser'', ''k2_schema_owner'', ''##MS_SSISServerCleanupJobLogin##''
)
AND dp.name NOT LIKE ''NT %''
AND sp.sid IS NULL;
';
---------------------------------------------------------------------------------------------------
--Drop the temp table if it exists and create the temp table
---------------------------------------------------------------------------------------------------
IF OBJECT_ID('tempdb.dbo.#Orphan') IS NOT NULL
    DROP TABLE #Orphan;

CREATE TABLE #Orphan
(
    DBName NVARCHAR(128) NULL,
    IsReadOnly BIT NULL,
    UserName NVARCHAR(128) NULL,
    UserType NVARCHAR(60) NULL,
    DropScript NVARCHAR(4000) NULL
);
---------------------------------------------------------------------------------------------------
--Execute the dynamic sql statement
---------------------------------------------------------------------------------------------------
EXEC dbo.sp_ineachdb @command = @SQL;
---------------------------------------------------------------------------------------------------
--Get results
---------------------------------------------------------------------------------------------------
SELECT DBName,
       IsReadOnly,
       UserName,
       UserType,
       DropScript
FROM #Orphan
ORDER BY DBName,
         UserName;
---------------------------------------------------------------------------------------------------
--Cleanup
---------------------------------------------------------------------------------------------------
DROP TABLE #Orphan;
GO
