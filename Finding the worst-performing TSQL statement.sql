USE [master];
GO
CREATE PROC [dbo].[usp_Worst_TSQL]

AS
BEGIN
    DECLARE @DBNAME VARCHAR(128) = '<not supplied>',
            @COUNT INT = 100,
            @ORDERBY VARCHAR(4) = 'TLR';

    -- Check for valid @ORDERBY parameter
    IF (
       (
           SELECT CASE
                      WHEN @ORDERBY IN ( 'ACPU', 'TCPU', 'AE', 'TE', 'EC', 'AIO', 'TIO', 'ALR', 'TLR', 'ALW', 'TLW',
                                         'APR', 'TPR'
                                       ) THEN
                          1
                      ELSE
                          0
                  END
       ) = 0
       )
    BEGIN
        -- abort if invalid @ORDERBY parameter entered
        RAISERROR('@ORDERBY parameter not APCU, TCPU, AE, TE, EC, AIO, TIO, ALR, TLR, ALW, TLW, APR or TPR', 11, 1);
        RETURN;
    END;
    SELECT TOP (@COUNT)
           COALESCE(DB_NAME(st.dbid), DB_NAME(CAST(pa.value AS INT)) + '*', 'Resource') AS [Database Name],
           -- find the offset of the actual statement being executed
           SUBSTRING(   st.text,
                        qs.statement_start_offset / 2 + 1,
                        ((CASE
                              WHEN qs.statement_end_offset = -1 THEN
                        (LEN(CONVERT(NVARCHAR(MAX), st.text)) * 2)
                              ELSE
                                  qs.statement_end_offset
                          END
                         ) - qs.statement_start_offset
                        ) / 2 + 1
                    ) AS [Statement],
           qp.query_plan AS [Query Plan],
           OBJECT_SCHEMA_NAME(st.objectid, st.dbid) [Schema Name],
           OBJECT_NAME(st.objectid, st.dbid) [Object Name],
           cp.objtype [Cached Plan objtype],
           qs.total_elapsed_time / qs.execution_count [Avg Elapsed Time],
           qs.execution_count [Execution Count],
           (qs.total_logical_reads + qs.total_logical_writes + qs.total_physical_reads) / qs.execution_count [Average IOs],
           qs.total_logical_reads + qs.total_logical_writes + qs.total_physical_reads [Total IOs],
           qs.total_logical_reads / qs.execution_count [Avg Logical Reads],
           qs.total_logical_reads [Total Logical Reads],
           qs.total_logical_writes / qs.execution_count [Avg Logical Writes],
           qs.total_logical_writes [Total Logical Writes],
           qs.total_physical_reads / qs.execution_count [Avg Physical Reads],
           qs.total_physical_reads [Total Physical Reads],
           qs.total_worker_time / qs.execution_count [Avg CPU],
           qs.total_worker_time [Total CPU],
           qs.total_elapsed_time [Total Elasped Time],
           qs.last_execution_time [Last Execution Time]
    FROM sys.dm_exec_query_stats qs
        JOIN sys.dm_exec_cached_plans cp
            ON qs.plan_handle = cp.plan_handle
        CROSS APPLY sys.dm_exec_sql_text(qs.plan_handle) st
        CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
        OUTER APPLY sys.dm_exec_plan_attributes(qs.plan_handle) pa
    WHERE pa.attribute = 'dbid'
          AND CASE
                  WHEN @DBNAME = '<not supplied>' THEN
                      '<not supplied>'
                  ELSE
                      COALESCE(DB_NAME(st.dbid), DB_NAME(CAST(pa.value AS INT)) + '*', 'Resource')
              END IN ( RTRIM(@DBNAME), RTRIM(@DBNAME) + '*' )
          AND COALESCE(DB_NAME(st.dbid), DB_NAME(CAST(pa.value AS INT)) + '*', 'Resource') NOT IN ( 'master', 'msdb',
                                                                                                    'Resource'
                                                                                                  )
    ORDER BY CASE
                 WHEN @ORDERBY = 'ACPU' THEN
                     qs.total_worker_time / qs.execution_count
                 WHEN @ORDERBY = 'TCPU' THEN
                     qs.total_worker_time
                 WHEN @ORDERBY = 'AE' THEN
                     qs.total_elapsed_time / qs.execution_count
                 WHEN @ORDERBY = 'TE' THEN
                     qs.total_elapsed_time
                 WHEN @ORDERBY = 'EC' THEN
                     qs.execution_count
                 WHEN @ORDERBY = 'AIO' THEN
        (qs.total_logical_reads + qs.total_logical_writes + qs.total_physical_reads) / qs.execution_count
                 WHEN @ORDERBY = 'TIO' THEN
                     qs.total_logical_reads + qs.total_logical_writes + qs.total_physical_reads
                 WHEN @ORDERBY = 'ALR' THEN
                     qs.total_logical_reads / qs.execution_count
                 WHEN @ORDERBY = 'TLR' THEN
                     qs.total_logical_reads
                 WHEN @ORDERBY = 'ALW' THEN
                     qs.total_logical_writes / qs.execution_count
                 WHEN @ORDERBY = 'TLW' THEN
                     qs.total_logical_writes
                 WHEN @ORDERBY = 'APR' THEN
                     qs.total_physical_reads / qs.execution_count
                 WHEN @ORDERBY = 'TPR' THEN
                     qs.total_physical_reads
             END DESC;
END;