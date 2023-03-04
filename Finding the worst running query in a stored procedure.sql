SELECT CAST(qp.query_plan AS XML) AS XML_Plan,
       SUBSTRING(   st.text,
                    qs.statement_start_offset / 2 + 1,
                    ((CASE
                          WHEN qs.statement_end_offset = -1 THEN
                              DATALENGTH(st.text)
                          ELSE
                              qs.statement_end_offset
                      END
                     ) - qs.statement_start_offset
                    ) / 2 + 1
                ) AS SqlText,
       qs.sql_handle,
       qs.statement_start_offset,
       qs.statement_end_offset,
       qs.plan_generation_num,
       qs.plan_handle,
       qs.creation_time,
       qs.last_execution_time,
       qs.execution_count,
       qs.total_worker_time,
       qs.last_worker_time,
       qs.min_worker_time,
       qs.max_worker_time,
       qs.total_physical_reads,
       qs.last_physical_reads,
       qs.min_physical_reads,
       qs.max_physical_reads,
       qs.total_logical_writes,
       qs.last_logical_writes,
       qs.min_logical_writes,
       qs.max_logical_writes,
       qs.total_logical_reads,
       qs.last_logical_reads,
       qs.min_logical_reads,
       qs.max_logical_reads,
       qs.total_clr_time,
       qs.last_clr_time,
       qs.min_clr_time,
       qs.max_clr_time,
       qs.total_elapsed_time,
       qs.last_elapsed_time,
       qs.min_elapsed_time,
       qs.max_elapsed_time,
       qs.query_hash,
       qs.query_plan_hash,
       qs.total_rows,
       qs.last_rows,
       qs.min_rows,
       qs.max_rows,
       qs.statement_sql_handle,
       qs.statement_context_id,
       qs.total_dop,
       qs.last_dop,
       qs.min_dop,
       qs.max_dop,
       qs.total_grant_kb,
       qs.last_grant_kb,
       qs.min_grant_kb,
       qs.max_grant_kb,
       qs.total_used_grant_kb,
       qs.last_used_grant_kb,
       qs.min_used_grant_kb,
       qs.max_used_grant_kb,
       qs.total_ideal_grant_kb,
       qs.last_ideal_grant_kb,
       qs.min_ideal_grant_kb,
       qs.max_ideal_grant_kb,
       qs.total_reserved_threads,
       qs.last_reserved_threads,
       qs.min_reserved_threads,
       qs.max_reserved_threads,
       qs.total_used_threads,
       qs.last_used_threads,
       qs.min_used_threads,
       qs.max_used_threads,
       qs.total_columnstore_segment_reads,
       qs.last_columnstore_segment_reads,
       qs.min_columnstore_segment_reads,
       qs.max_columnstore_segment_reads,
       qs.total_columnstore_segment_skips,
       qs.last_columnstore_segment_skips,
       qs.min_columnstore_segment_skips,
       qs.max_columnstore_segment_skips,
       qs.total_spills,
       qs.last_spills,
       qs.min_spills,
       qs.max_spills,
       qs.total_num_physical_reads,
       qs.last_num_physical_reads,
       qs.min_num_physical_reads,
       qs.max_num_physical_reads,
       qs.total_page_server_reads,
       qs.last_page_server_reads,
       qs.min_page_server_reads,
       qs.max_page_server_reads,
       qs.total_num_page_server_reads,
       qs.last_num_page_server_reads,
       qs.min_num_page_server_reads,
       qs.max_num_page_server_reads
FROM sys.dm_exec_query_stats qs
    JOIN sys.dm_exec_procedure_stats ps
        ON qs.sql_handle = ps.sql_handle
    CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
    CROSS APPLY sys.dm_exec_text_query_plan(qs.plan_handle, qs.statement_start_offset, qs.statement_end_offset) qp
WHERE ps.object_id = OBJECT_ID('<DatabaseName>.<SchemaName>.<StoredProcedureName')
ORDER BY ps.last_logical_reads DESC;