DECLARE @SPID INT = <SPID>;

SELECT COUNT(*)
FROM fn_dblog(NULL, NULL)
WHERE Operation IN ( 'LOP_MODIFY_ROW', 'LOP_INSERT_ROWS', 'LOP_DELETE_ROWS' )
      AND Context IN ( 'LCX_HEAP', 'LCX_CLUSTERED' )
      AND [Transaction ID] =
      (
          SELECT fn_dblog.[Transaction ID]
          FROM sys.dm_tran_session_transactions session_trans
              JOIN fn_dblog(NULL, NULL)
                  ON fn_dblog.[Xact ID] = session_trans.transaction_id
          WHERE session_id = @SPID
      );