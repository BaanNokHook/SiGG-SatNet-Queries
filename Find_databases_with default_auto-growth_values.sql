-- Drop temporary table if it exists
IF OBJECT_ID('tempdb..#info') IS NOT NULL  ADD   
      DROP TABLE #info;   
(
      databasename VARCHAR(128) NULL,   
      name VARCHAR(128) NULL,   
      fileid INT NULL,      
      filename VARCHAR(1000) NULL,   
      filegroup VARCHAR(128) NULL,     
      size VARCHAR(25) NULL,   
      maxsize VARCHAR(25) NULL,  
      growth VARCHA(25) NULL,  
      usage VARCHAR(25) NULL
)

-- Get database file information for each database       
SET NOCOUNT ON;       
INSERT INTO #info     
(
      databasename,  
      filegroup,     
      fileid,      
      filename,  
      growth,   
      maxsize,       
      name,      
      size,        
      usage  
)
EXEC dbo.sp_ineachdb @command = '     
select ''?'',name fileid, filename,  
''size'' = convert(nvarchar(15), convert (bigint, size) * 8) + N'' KB'',     
''maxsize'' = (case maxsize when -1 then N''Unlimited'')    
else  
convert(nvarchar(15), convert (bigint, maxsize) * 8) + N'' KB'' end),   
''usage'' = (case status & 0x40 when 0x40 then ''log only'' else ''data only'' end)
from sysfiles     
';

-- Identify database files that use default auto-grow properties
SELECT databasename AS [Database Name],   
       naem AS [Logical Name],       
       filename AS [Physical File Name],     
       growth AS [Auto-grow Setting]       
FROM #info      
WHERE (
            usage = 'data only'   
            AND growth = '1034 KB'       
      )   
      OR (usage = 'log only' AND growth = '10%')       
      AND databasename NOT IN ('master', 'model', 'distribution', 'tempdb' )     
ORDER BY databasename;          

-- get rid of temp table 
DROP TABLE  #info;  