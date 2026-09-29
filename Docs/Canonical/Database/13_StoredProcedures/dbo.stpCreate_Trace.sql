SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpCreate_Trace]
AS
BEGIN
    DECLARE @rc INT, @TraceID INT, @maxfilesize BIGINT, @on BIT, @intfilter INT, @bigintfilter BIGINT
    SELECT @on = 1, @maxfilesize = 50
    
    -- Criação do trace
    EXEC @rc = [dbo].[sp_trace_create] @TraceID OUTPUT, 0, N'G:\Trace\Querys_Demoradas1', @maxfilesize, NULL
    
    IF (@rc != 0) GOTO error
    
    EXEC [dbo].[sp_trace_setevent] @TraceID, 10, 1,  @on
    EXEC [dbo].[sp_trace_setevent] @TraceID, 10, 6,  @on
    EXEC [dbo].[sp_trace_setevent] @TraceID, 10, 8,  @on
    EXEC [dbo].[sp_trace_setevent] @TraceID, 10, 10, @on
    EXEC [dbo].[sp_trace_setevent] @TraceID, 10, 11, @on
    EXEC [dbo].[sp_trace_setevent] @TraceID, 10, 12, @on
    EXEC [dbo].[sp_trace_setevent] @TraceID, 10, 13, @on
    EXEC [dbo].[sp_trace_setevent] @TraceID, 10, 14, @on
    EXEC [dbo].[sp_trace_setevent] @TraceID, 10, 15, @on
    EXEC [dbo].[sp_trace_setevent] @TraceID, 10, 16, @on
    EXEC [dbo].[sp_trace_setevent] @TraceID, 10, 17, @on
    EXEC [dbo].[sp_trace_setevent] @TraceID, 10, 18, @on
    EXEC [dbo].[sp_trace_setevent] @TraceID, 10, 26, @on
    EXEC [dbo].[sp_trace_setevent] @TraceID, 10, 35, @on
    EXEC [dbo].[sp_trace_setevent] @TraceID, 10, 40, @on
    EXEC [dbo].[sp_trace_setevent] @TraceID, 10, 48, @on
    EXEC [dbo].[sp_trace_setevent] @TraceID, 10, 64, @on
    EXEC [dbo].[sp_trace_setevent] @TraceID, 12, 1,  @on
    EXEC [dbo].[sp_trace_setevent] @TraceID, 12, 6,  @on
    EXEC [dbo].[sp_trace_setevent] @TraceID, 12, 8,  @on
    EXEC [dbo].[sp_trace_setevent] @TraceID, 12, 10, @on
    EXEC [dbo].[sp_trace_setevent] @TraceID, 12, 11, @on
    EXEC [dbo].[sp_trace_setevent] @TraceID, 12, 12, @on
    EXEC [dbo].[sp_trace_setevent] @TraceID, 12, 13, @on
    EXEC [dbo].[sp_trace_setevent] @TraceID, 12, 14, @on
    EXEC [dbo].[sp_trace_setevent] @TraceID, 12, 15, @on
    EXEC [dbo].[sp_trace_setevent] @TraceID, 12, 16, @on
    EXEC [dbo].[sp_trace_setevent] @TraceID, 12, 17, @on
    EXEC [dbo].[sp_trace_setevent] @TraceID, 12, 18, @on
    EXEC [dbo].[sp_trace_setevent] @TraceID, 12, 26, @on
    EXEC [dbo].[sp_trace_setevent] @TraceID, 12, 35, @on
    EXEC [dbo].[sp_trace_setevent] @TraceID, 12, 40, @on
    EXEC [dbo].[sp_trace_setevent] @TraceID, 12, 48, @on
    EXEC [dbo].[sp_trace_setevent] @TraceID, 12, 64, @on
    
    SET @bigintfilter = 3000000 -- 3 segundos
    
    EXEC [dbo].[sp_trace_setfilter] @TraceID, 13, 0, 4, @bigintfilter
    
    -- Set the trace status to start
    EXEC [dbo].[sp_trace_setstatus] @TraceID, 1
    
    GOTO finish
    
    error:
		SELECT ErrorCode = @rc
    finish:
END
GO
