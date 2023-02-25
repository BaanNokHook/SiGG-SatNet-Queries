CREATE EVENT SESSION [Lock_Acquired] ON SERVER   
ADD EVENT sqlserver.lock_acquired(WHERE ((([mode]=('IX')) OR ([mode]=('X'))) AND ([object_id]=(<ObjectId>))))
ADD TARGET package0.event_file(SET filename=N'c:\temp\Lock_Acquired')   
GO