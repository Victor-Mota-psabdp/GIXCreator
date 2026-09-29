SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.pPendencias_Sel    Script Date: 17/10/2002 07:32:51 ******/
CREATE PROCEDURE pPendencias_Sel
AS
	Select * From Imp_LOG Where ILOG_Inconsistencia = 1 and Cast(ILOG_Data as VarChar(10)) = Cast(GetDate() as VarChar(10))
	



GO
