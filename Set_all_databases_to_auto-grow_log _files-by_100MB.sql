EXEC dbo.sp_foreachdb @command = 'DECLARE @sql VARCHAR(1000); SELECT @sql = ''ALTER DATABASE [?] MODIFY FILE ( NAME = N'''''' + name + '''''', MAXSIZE = UNLIMITED, FILEGROWTH = 102400KB )'' FROM [?].sys.master_files WHERE database_id = DB_ID(''?'') AND file_id = 2; EXEC(@sql);',
                      @user_only = 1,
                      @suppress_quotename = 1;