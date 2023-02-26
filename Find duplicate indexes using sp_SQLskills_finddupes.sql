USE master;
GO
EXEC dbo.sp_ineachdb @command = 'EXEC dbo.sp_SQLskills_finddupes',
                     @user_only = 1;
GO