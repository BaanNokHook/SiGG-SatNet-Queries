SELECT DISTINCT
       tb.value
FROM
(
    SELECT T.value
    FROM [DBA_Rep].[dbo].[ServerList_SSIS] AS S
        CROSS APPLY STRING_SPLIT([Server], '\') AS T
    WHERE T.value LIKE 'SV%'
          OR T.value LIKE 'UN%'
) AS dt
    CROSS APPLY STRING_SPLIT(value, '.') AS tb
WHERE tb.value LIKE 'SV%'
      OR tb.value LIKE 'UN%'
ORDER BY tb.value;