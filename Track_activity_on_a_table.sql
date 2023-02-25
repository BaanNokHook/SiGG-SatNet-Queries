CREATE EVENT SESSION TrackActivity   
ON SERVER 
      ADD EVENT sqlserver.sql_batch_completed   
      (SET collect_batch_text = (1)
       ACTION     
       (  
            sqlserver.sql_text
       ) 
       WHERE (   
                [sqlserver].[equal_i_sql_unicode_string]([sqlserver].[database_name], N'<DatabaseName>')
               AND [sqlserver].[like_i_sql_unicode_string]([batch_text], N'%<SchemaName>.<TableName>%')
           )
    ),
    ADD EVENT sqlserver.rpc_completed
    (ACTION
     (
         sqlserver.sql_text
     )
     WHERE (([sqlserver].[equal_i_sql_unicode_string]([sqlserver].[database_name], N'<DatabaseName>')))
    )
    ADD TARGET package0.event_file
    (SET filename = N'TrackActivity');