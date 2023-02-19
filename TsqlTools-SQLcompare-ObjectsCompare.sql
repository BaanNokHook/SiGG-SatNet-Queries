DECLARE @SOURCEDBSERVER VARCHAR(100)   
DECLARE @DESTINATIONDBSERVER VARCHAR(100)    
DECLARE @SOURCE_SQL_DBNAME NVARCHAR(300)   
DECLARE @SOURCE_DATABASENAME TABLE   
  (
      dbname VARCHAR(100)       
  )
SELECT @SOURCEDBSERVER = '[db01]' --==> Replace Your Source DB serverName Here    

SELECT @DESTINATIONDBSERVER = '[db02]' --==> Replace Your Target DB serverName Here  

SELECT @SOURCE_SQL_DBNAME = 'select name from ' + @SOURCEDBSERVER  
                              + '.master.sys.databases where database_id>4'      ADD

INSERT INTO @SOURCE_DATABASENAME   
EXEC Sp_executesql       
      @SOURCE_SQL_DBNAME  

CREATE TABLE #objectstatus   
      (
            dbname       NVARCHAR(500) 
            , objectname NVARCHAR(500)  
            , objecttype VARCHAR(500)
            , status     NVARCHAR(500)        
      )

DECLARE dbcursor CURSOR FOR 
      SELECT dbname
      FROM   @SOURCE_DATABASENAME     

OPEN dbcursor       

DECLARE @SOURCE_DBNAME VARCHAR(100)      

FETCH next FROM dbcursor INTO @SOURCE_DBNAME    


WHILE @@FETCH_STATUS = 0   
      BEGIN 
            DECLARE @SOURCEDBSERVERNAME SYSNAME  
            DECLARE @DESTDBNAME SYSNAME   
            DECLARE @SQL VARCHAR(max)   


            SELECT @SOURCEDBSERVERNAME = (SELECT
                   @SOURCEDBSERVER + '-' + @SOURCE_DBNAME)      
   
                
      SELECT @DESTDBNAME = @DESTINATIONDBSERVER + '-' + @SOURCE_DBNAME     

      SELECT @SQL = '  SELECT ' + '''' + @SOURCE_DBNAME + '''' + ' as DB, 
      ISNULL(SoSource.name,SoDestination.name) ''Object Name'' , SoDestination.type_desc ,  
      CASE 
        WHEN SoSource.object_id IS NULL THEN +  ''  Available on  ' + @DESTDBNAME + ''' COLLATE database_default  
        WHEN SoDestination.object_id IS NULL THEN +  '' Available On ' + @SOURCEDBSERVERNAME + ''' COLLATE database_default     
      ELSE   
      + '' Available On Both Servers'' COLLATE database_default END ''Status''
      FROM (SELECT * FROM ' 
                    + @SOURCEDBSERVERNAME 
                    + '.SYS.objects WHERE Type_desc not in  (''INTERNAL_TABLE'',''SYSTEM_TABLE'',''SERVICE_QUEUE'')) SoSource 
                      FULL OUTER JOIN (SELECT * FROM ' + @DESTDBNAME 
                    + '.SYS.objects 
                    WHERE Type_desc not in (''INTERNAL_TABLE'',''SYSTEM_TABLE'',''SERVICE_QUEUE'')) 
                    SoDestination  ON SoSource.name = SoDestination.name COLLATE database_default 
                    AND SoSource.type = SoDestination.type 
                    COLLATE database_default 
                    ORDER BY isnull(SoSource.type,SoDestination.type)' 

      INSERT INTO #objectstaus 
      EXEC (@SQL) 

      FETCH next FROM dbcursor INTO @SOURCE_DBNAME 
  END 

CLOSE dbcursor 

DEALLOCATE dbcursor 

SELECT * 
FROM   #objectstaus where objecttype='USER_TABLE'
ORDER  BY dbname ASC 

SELECT * 
FROM   #objectstaus where objecttype='CHECK_CONSTRAINT'
ORDER  BY dbname ASC 

SELECT * 
FROM   #objectstaus where objecttype='DEFAULT_CONSTRAINT'
ORDER  BY dbname ASC 

SELECT * 
FROM   #objectstaus where objecttype='FOREIGN_KEY_CONSTRAINT'
ORDER  BY dbname ASC 

SELECT * 
FROM   #objectstaus where objecttype='PRIMARY_KEY_CONSTRAINT'
ORDER  BY dbname ASC 

SELECT * 
FROM   #objectstaus where objecttype='UNIQUE_CONSTRAINT'
ORDER  BY dbname ASC 

SELECT * 
FROM   #objectstaus where objecttype='SQL_TRIGGER'
ORDER  BY dbname ASC 

SELECT * 
FROM   #objectstaus where objecttype='VIEW'
ORDER  BY dbname ASC 

SELECT * 
FROM   #objectstaus where objecttype='SQL_STORED_PROCEDURE'
ORDER  BY dbname ASC 

SELECT * 
FROM   #objectstaus where objecttype not in ('USER_TABLE',
'CHECK_CONSTRAINT',
'DEFAULT_CONSTRAINT',
'FOREIGN_KEY_CONSTRAINT',
'PRIMARY_KEY_CONSTRAINT',
'SQL_TRIGGER',
'VIEW',
'SQL_STORED_PROCEDURE'
'UNIQUE_CONSTRAINT')
ORDER  BY dbname ASC 
DROP TABLE #objectstaus 