SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pHEM_Historico_Sel    Script Date: 17/10/2002 07:32:49 ******/
CREATE PROCEDURE pHEM_Historico_Sel
(
@Num_Proc	VarChar(14) 
)
 AS
	Select  
		* 
	From 
		Historico_Exp_Mar 
	Where 
		Num_Proc_HEM = @Num_Proc



GO
