DECLARE @job_id UNIQUEIDENTIFIER;

DECLARE job_cur CURSOR LOCAL FAST_FORWARD FOR
SELECT job_id
FROM msdb.dbo.sysjobs;

OPEN job_cur;

FETCH NEXT FROM job_cur
INTO @job_id;

WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC msdb.dbo.sp_update_job @job_id = @job_id, @owner_login_name = N'sa';
    FETCH NEXT FROM job_cur
    INTO @job_id;
END;

CLOSE job_cur;

DEALLOCATE job_cur;
