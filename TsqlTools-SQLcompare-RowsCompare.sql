DECLARE @SOURCEDBSERVER varchar(100)   
DECLARE @DESTINATIONDBSERVER varchar(100)  
DECLARE @SOURCE_SQL_DBNAME nvarchar(300)   
DECLARE @SOURCE_DATABASENAME TABLE (  dbname varchar(100))   
DECLARE @DESTINATION_SQL_DBNAME nvarchar(300)   
DECLARE @DESTINATION_DATABASENAME TABLE ( dbname varchar(100))     


SELECT  @SOURCEDBSERVER = '[db01]'  --==> Replace YOUR Source DB serverName Here   

SELECT  @DESTINATIONDBSERVER = '[db02]' --==> Replace Your Target DB serverName Here         

Create table #sourceTbl (DBname nvarchar(200),TableName nvarchar(200),Rows bigint)    
Create table #DestTbl (DBname nvarchar(200),TableName nvarchar(200),Rows bigint)    ADD

SELECT @SOURCE_SQL_DBNAME = 'select name from ' +  @SOURCEDBSERVER + ' .master.sys.databases where database_id>4'   
INSERT INTO @SOURCE_DATABASENAME EXEC sp_executesql @SOURCE_SQL_DBNAME 

SELECT @DESTINATION_SQL_DBNAME = 'select name from ' + @DESTINATIONDBSERVER + '.master.sys.databases where database_od'


DECLARE dbcursor CURSOR FOR
SELECT  dbname FROM @SOURCE_DATABASENAME
OPEN dbcursor
DECLARE @Source_DBname varchar(100)
FETCH NEXT FROM dbcursor INTO @Source_DBNAME
WHILE @@FETCH_STATUS = 0

BEGIN

  DECLARE @SOURCE_SQL nvarchar(max)

  SELECT
    @SOURCE_SQL =

' SELECT '+''''+@Source_DBNAME+''''+' as DBname, sc.name +'+''''+'.'+''''+'+ ta.name TableName
 ,SUM(pa.rows) RowCnt
 FROM '+@SOURCEDBSERVER+'.'+@Source_DBNAME+'.sys.tables ta
 INNER JOIN '+@SOURCEDBSERVER+'.'+@Source_DBNAME+'.sys.partitions pa
 ON pa.OBJECT_ID = ta.OBJECT_ID
 INNER JOIN '+@SOURCEDBSERVER+'.'+@Source_DBNAME+'.sys.schemas sc
 ON ta.schema_id = sc.schema_id
 WHERE ta.is_ms_shipped = 0 AND pa.index_id IN (1,0)
 GROUP BY sc.name,ta.name
 ORDER BY SUM(pa.rows) DESC'

   
  insert into #sourceTbl EXEC sp_executesql @SOURCE_SQL
  FETCH NEXT FROM dbcursor INTO @Source_DBname
END

CLOSE dbcursor

DEALLOCATE dbcursor
 

DECLARE dbcursor CURSOR FOR
SELECT
  dbname
FROM @DESTINATION_DATABASENAME

OPEN dbcursor
DECLARE @DESTINATION_DBname varchar(100)
FETCH NEXT FROM dbcursor INTO @DESTINATION_DBNAME
WHILE @@FETCH_STATUS = 0
BEGIN

  DECLARE @DESTINATION_SQL nvarchar(max)

  SELECT
    @DESTINATION_SQL =
   ' SELECT  '+''''+@DESTINATION_DBNAME+''''+' as DBname,sc.name +'+''''+'.'+''''+'+ ta.name TableName
 ,SUM(pa.rows) RowCnt
 FROM '+@DESTINATIONDBSERVER+'.'+@DESTINATION_DBNAME+'.sys.tables ta
 INNER JOIN '+@DESTINATIONDBSERVER+'.'+@DESTINATION_DBNAME+'.sys.partitions pa
 ON pa.OBJECT_ID = ta.OBJECT_ID
 INNER JOIN '+@DESTINATIONDBSERVER+'.'+@DESTINATION_DBNAME+'.sys.schemas sc
 ON ta.schema_id = sc.schema_id
 WHERE ta.is_ms_shipped = 0 AND pa.index_id IN (1,0)
 GROUP BY sc.name,ta.name
 ORDER BY SUM(pa.rows) DESC'
 
   
  insert into #DestTbl  EXEC sp_executesql @DESTINATION_SQL
  FETCH NEXT FROM dbcursor INTO @DESTINATION_DBname
END

CLOSE dbcursor

DEALLOCATE dbcursor
 
select a.DBname,a.TableName,(b.Rows-a.rows) as RowsDifference,
case 
  when(b.Rows-a.rows) >=100 then 'Alert' 
when(b.Rows-a.rows) <100 then 'OK' End as Status
from #sourceTbl a,#DestTbl b where a.DBname=b.DBname and a.TableName=b.TableName
drop table #sourceTbl
drop table #DestTbl
