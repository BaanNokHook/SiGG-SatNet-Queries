DECLARE @logInfoResults AS TABLE
(
    [RecoveryUnitId] BIGINT NOT NULL, -- only on SQL Server 2012 and newer
    [FileId] TINYINT NOT NULL,
    [FileSize] BIGINT NOT NULL,
    [StartOffset] BIGINT NOT NULL,
    [FSeqNo] INTEGER NOT NULL,
    [Status] TINYINT NOT NULL,
    [Parity] TINYINT NOT NULL,
    [CreateLSN] NUMERIC(38, 0) NOT NULL
);

INSERT INTO @logInfoResults
(
    RecoveryUnitId,
    FileId,
    FileSize,
    StartOffset,
    FSeqNo,
    Status,
    Parity,
    CreateLSN
)
EXEC sys.sp_executesql @stmt = N'DBCC LOGINFO WITH NO_INFOMSGS';

SELECT CAST(FileSize / 1024.0 / 1024 AS DECIMAL(20, 1)) AS FileSizeInMB,
       CASE
           WHEN FSeqNo = 0 THEN
               'Available - Never Used'
           ELSE
       (CASE
            WHEN Status = 2 THEN
                'In Use'
            ELSE
                'Available'
        END
       )
       END AS TextStatus,
       [Status],
       REPLICATE(   CASE
                        WHEN [Status] = 2 THEN
                            'X'
                        ELSE
                            'O'
                    END,
                    FileSize / MIN(FileSize) OVER ()
                ) AS [BarChart ________________________________________________________________________________________________]
FROM @logInfoResults;
