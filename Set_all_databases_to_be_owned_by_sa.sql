EXEC dbo.sp_ineachdb @command = 'EXEC dbo.sp_changedbowner @loginame = N''sa'', @map = false',
                     @user_only = 1;