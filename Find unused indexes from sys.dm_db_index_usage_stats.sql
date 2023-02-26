CREATE TABLE #output
(
    DatabaseName sysname NULL,
    TableName sysname NULL,
    IndexName sysname NULL,
    Rows BIGINT NULL,
    Reads BIGINT NULL,
    Writes BIGINT NULL,
    ReadsPerWrite DECIMAL(18, 1) NULL,
    DropStatement VARCHAR(255) NULL
);
INSERT INTO #output
(
    DatabaseName,
    TableName,
    IndexName,
    Rows,
    Reads,
    Writes,
    ReadsPerWrite,
    DropStatement
)
EXEC dbo.sp_ineachdb @command = 'SELECT DB_NAME() AS DatabaseName,
       o.name AS TableName,
       i.name AS IndexName,
       (
           SELECT SUM(p.rows)
           FROM sys.partitions p
           WHERE p.index_id = i.index_id
                 AND i.object_id = p.object_id
       ) AS Rows,
       s.user_seeks + s.user_scans + s.user_lookups AS Reads,
       s.user_updates AS Writes,
       CASE
           WHEN s.user_updates < 1 THEN
               0
           ELSE
               1.00 * (s.user_seeks + s.user_scans + s.user_lookups) / s.user_updates
       END AS ReadsPerWrite,
       ''DROP INDEX '' + QUOTENAME(i.name) + '' ON '' + QUOTENAME(c.name) + ''.'' + QUOTENAME(OBJECT_NAME(i.object_id)) + '';'' AS ''DropStatement''
FROM sys.indexes i
    INNER JOIN sys.objects o
        ON i.object_id = o.object_id
    INNER JOIN sys.schemas c
        ON o.schema_id = c.schema_id
    LEFT OUTER JOIN sys.dm_db_index_usage_stats s
        ON i.index_id = s.index_id
           AND s.object_id = i.object_id
		   AND s.database_id = DB_ID()
WHERE (
          OBJECTPROPERTY(o.object_id, ''isusertable'') = 1
          OR OBJECTPROPERTY(o.object_id, ''isview'') = 1
      )
      AND i.type_desc = ''nonclustered''
      AND i.is_primary_key = 0
      AND i.is_unique = 0
      AND i.is_unique_constraint = 0;';

SELECT DatabaseName,
       TableName,
       IndexName,
       Rows,
       Reads,
       Writes,
       ReadsPerWrite,
       DropStatement
FROM #output
WHERE (
          ReadsPerWrite = 0
          OR ReadsPerWrite IS NULL
      )
      AND Rows > 1000
      AND DatabaseName NOT IN ( 'msdb' )
ORDER BY DatabaseName,
         TableName,
         IndexName;

DROP TABLE #output;