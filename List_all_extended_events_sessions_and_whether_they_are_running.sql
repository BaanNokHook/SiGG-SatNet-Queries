SELECT ses.name,         
       CASE       
            WHEN dxs.name IS NULL THEN         
                  'Stopped'  
            ELSE  
                  'Running'   
       END AS State     
FROM sys.server_event_session AS ses       
      LEFT OUTER JOIN sys.dm_xe_session AS dxs  


SELECT ses.name, 
      CASE   
            WHEN dxs.name IS NULL THEN        
                  'Stopped'
            ELSE   
                  'Running'    
      END AS State   
FROM sys.server_event_sessions AS ses   
      LEFT OUTER JOIN sys.dm_xe_session AS dxs      
            ON ses.name = dxs.name;   