SELECT CASE SUBSTRING(CONVERT(NVARCHAR(20), SERVERPROPERTY('ProductVersion')), 1, 4)
           WHEN '16.0' THEN
               'SQL Server 2022'
           WHEN '15.0' THEN
               'SQL Server 2019'
           WHEN '14.0' THEN
               'SQL Server 2017'
           WHEN '13.0' THEN
               'SQL Server 2016'
           WHEN '12.0' THEN
               'SQL Server 2014'
           WHEN '11.0' THEN
               'SQL Server 2012'
           WHEN '10.5' THEN
               'SQL Server 2008 R2'
           WHEN '10.0' THEN
               'SQL Server 2008'
       END AS Version,
       CONVERT(NVARCHAR(100), SERVERPROPERTY('Edition')) AS Edition;