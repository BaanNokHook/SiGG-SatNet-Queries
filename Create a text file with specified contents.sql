IF EXISTS (SELECT * FROM sys.sysobjects WHERE name = 'usp_WriteToTextFile')
BEGIN
    DROP PROC dbo.usp_WriteToTextFile;
END;
GO

CREATE PROC dbo.usp_WriteToTextFile
    @text VARCHAR(1000),
    @file VARCHAR(255),
    @overwrite BIT = 0
AS
BEGIN
    EXEC sys.sp_configure 'show advanced options', 1;
    RECONFIGURE;
    EXEC sys.sp_configure 'xp_cmdshell', 1;
    RECONFIGURE;

    SET NOCOUNT ON;
    DECLARE @query VARCHAR(255);
    SET @query = 'ECHO ' + COALESCE(LTRIM(@text), '-') + CASE
                                                             WHEN (@overwrite = 1) THEN
                                                                 ' > '
                                                             ELSE
                                                                 ' >> '
                                                         END + RTRIM(@file);
    EXEC master..xp_cmdshell @query;

    SET NOCOUNT OFF;
    EXEC sys.sp_configure 'xp_cmdshell', 0;
    RECONFIGURE;
END;
GO

GRANT EXEC ON dbo.usp_WriteToTextFile TO PUBLIC;
GO
