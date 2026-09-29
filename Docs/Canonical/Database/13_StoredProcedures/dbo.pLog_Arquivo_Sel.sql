SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.pLog_Arquivo_Sel    Script Date: 17/10/2002 07:32:50 ******/
CREATE PROCEDURE pLog_Arquivo_Sel
(
@Arquivo 	VarChar(20)
)
AS
	Select * From Imp_LOG Where ILOG_Arquivo = @Arquivo 
	



GO
