CREATE EVENT SESSION [exErrors]    
ON SERVER   
      ADD EVENT sqlserver.error_reported  
      (ACTION  
        (
            sqlserver.client_app_name,     
            sqlserver.client_hostname,        
            sqlserver.database_id,      
            sqlserver.session_id,          
            sqlserver.sql_text,  
            sqlserver.username
        )
            --WHERE (
            --          [error_number] = (18452)
            --          OR [error_number] = (17806)
            --      )
      )
      ADD TABLE package0.event_file   
      (SET filename = N'c:\temp\exErrors')
WITH         
(  
      MAX_MEMORY = 4096KB,  
      EVENT_RETENTION_MODE = ALLOW_SINGLE_EVENT_LOSS,  
      MAX_DISPATCH_LATENCY = 5 SECONDS,   
      MAX_EVENT_SIZE = 0KB, 
      MEMORY_PARTITION_MODE = NONE,  
      TRACK_CAUSALITY = ON,   
      STARTUP_STATE = OFF   
);
GO     

ALTER EVENT SESSION exErrors ON SERVER STATE = START;  
GO
;

-- While the EE session is STILL RUNNING, when errors have occurred that the event session is capturing, they can be read through a query similar to this:   
DECLARE @SessionName Sysname = 'exErrors',    
            @Target_File NVARCHAR(1000),  
            @Target_Dir  NVARCHAR(1000),   
            @Target_File_WillCard NVARCHAR(1000);   


SELECT @Target_File = CAST(t.target_data AS XML).value('EventFileTarget[1]/File[1]/@name', 'NVARCHAR(256)')      
FROM   sys.dm_xe_session_targets t   
       INNER JOIN sys.dm_xe_sessions  s ON s.address = t.event_session_address     
WHERE s.name = @SessionName  
      AND t.target_name = 'event_file';   


SELECT @Target_Dir = LEFT(@Target_File, LEN(@Target_File) - CHARINDEX('\', REVERSE(@Target_File)));           

SELECT @Target_File_WildCard = @Target_Dir + '\' + @SessionName + '_*.xel';            

SELECT CAST(event_data AS XML) AS event_data_XML  
INTO       #Events   
FROM       sys.fn_xe_file_target_read_file(@Target-File_WildCard, NULL, NULL, NULL) AS F    
ORDER BY file_name DESC,    
         file_offset DESC;      


WITH exErrors   
AS (SELECT CAST(event_data-XML AS XML) AS SessionData      
    FROM #Events)
SELECT DATEADD(HOUR, DATEDIFF(HOUR, GETUTCDATE(), GETDATE()), CAST(SessionData.value('(event/@timestamp)[1]', 'varchar(50)') AS DATETIME2)) AS event_timestamp,     
       SessionData.value('(/event/data  [@name=''error_number'']/value)[1]', 'INT') AS error_number,
       SessionData.value('(/event/data  [@name=''severity'']/value)[1]', 'INT') AS severity,
	   SessionData.value('(/event/data  [@name=''state'']/value)[1]', 'INT') AS state,
	   SessionData.value('(/event/data  [@name=''user_defined'']/value)[1]', 'BIT') AS user_defined,
	   SessionData.value('(/event/data  [@name=''category'']/value)[1]', 'NVARCHAR(255)') AS category,
	   SessionData.value('(/event/data  [@name=''destination'']/value)[1]', 'NVARCHAR(255)') AS destination,
	   SessionData.value('(/event/data  [@name=''is_intercepted'']/value)[1]', 'BIT') AS is_intercepted,	-- Indicates whether the error was intercepted by a Transact-SQL TRY/CATCH block.
	   SessionData.value('(/event/data  [@name=''message'']/value)[1]', 'NVARCHAR(MAX)') AS message,
	   SessionData.value('(/event/action  [@name=''username'']/value)[1]', 'NVARCHAR(255)') AS username,
	   DB_NAME(SessionData.value('(/event/action  [@name=''database_id'']/value)[1]', 'INT')) AS database_name,
	   SessionData.value('(/event/action  [@name=''client_hostname'']/value)[1]', 'NVARCHAR(255)') AS client_hostname,
	   SessionData.value('(/event/action  [@name=''client_app_name'']/value)[1]', 'NVARCHAR(255)') AS client_app_name,
	   SessionData.value('(/event/action  [@name=''sql_text'']/value)[1]', 'NVARCHAR(MAX)') AS sql_text,
	   SessionData.value('(/event/action  [@name=''session_id'']/value)[1]', 'INT') AS session_id
FROM exErrors AS d
WHERE SessionData.value('(/event/data  [@name=''severity'']/value)[1]', 'INT') > 10
ORDER BY event_timestamp DESC;

DROP TABLE #Events;