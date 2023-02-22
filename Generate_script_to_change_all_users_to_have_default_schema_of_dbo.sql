CREATE TABLE #UsersWithNoDefaultSchema
(
    DatabaseName sysname NULL,
    UserName sysname NULL,
    DefaultSchemaName sysname NULL,
    Command VARCHAR(1000) NULL
);

INSERT INTO #UsersWithNoDefaultSchema
(
    DatabaseName,
    UserName,
    DefaultSchemaName,
    Command
)
EXEC dbo.sp_ineachdb @command = '
SELECT DB_NAME() AS DatabaseName, name AS UserName, default_schema_name AS DefaultSchemaName, ''USE ?; ALTER USER ['' + name + ''] WITH DEFAULT_SCHEMA = [dbo];'' AS Command
FROM sys.database_principals
WHERE type = ''G''
AND default_schema_name IS NULL;
',
                     @exclude_list = 'tempdb';

SELECT DatabaseName,
       UserName,
       DefaultSchemaName,
       Command
FROM #UsersWithNoDefaultSchema;
DROP TABLE #UsersWithNoDefaultSchema;

