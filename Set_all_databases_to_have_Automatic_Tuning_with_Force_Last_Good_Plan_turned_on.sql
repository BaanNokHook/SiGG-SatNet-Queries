EXEC dbo.sp_ineachdb @command = 'ALTER DATABASE ? SET AUTOMATIC_TUNING ( FORCE_LAST_GOOD_PLAN = ON )',
                     @user_only = 1;