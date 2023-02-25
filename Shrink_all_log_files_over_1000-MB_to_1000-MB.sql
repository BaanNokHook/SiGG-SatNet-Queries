EXEC dbo.sp_ineachdb @command = N'
DECLARE @new_size_MB int = 1000,
		@curr_size_8K int,
		@sql VARCHAR(1000);
SELECT @curr_size_8K = size,
	   @sql = ''DBCC SHRINKFILE (N'''''' + name + '''''', '' + CAST(@new_size_MB AS VARCHAR(10)) + '')''
	FROM sys.database_files
	WHERE type_desc = ''LOG'';
IF @curr_size_8K * 8 / 1024 > @new_size_MB
BEGIN
	PRINT @sql;
	EXEC (@sql);
END;
',
                     @user_only = 1;