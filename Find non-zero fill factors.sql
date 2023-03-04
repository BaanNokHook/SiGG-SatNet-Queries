EXEC dbo.sp_ineachdb @command = '
SELECT ''?'' AS DatabaseName,
       OBJECT_NAME(object_id) AS TableName,
       name AS IndexName,
       fill_factor
FROM sys.indexes
WHERE fill_factor <> 0 AND fill_factor <> 100;
',
                     @user_only = 1;