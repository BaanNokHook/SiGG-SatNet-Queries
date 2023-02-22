SELECT name AS DatabaseName,
       recovery_model_desc AS RecoveryModel,
       'ALTER DATABASE [' + name + '] SET RECOVERY FULL;' AS SQL
FROM sys.databases
WHERE recovery_model_desc <> 'FULL'
AND database_id > 4
ORDER BY DatabaseName;