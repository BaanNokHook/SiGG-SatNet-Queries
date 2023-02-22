EXEC dbo.sp_foreachdb @command = 'ALTER DATABASE ? SET COMPATIBILITY_LEVEL = 130',
                      @user_only = 1;