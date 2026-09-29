SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pHEM_Historico_Del    Script Date: 17/10/2002 07:32:49 ******/
CREATE PROCEDURE pHEM_Historico_Del
(
@Num_Proc	VarChar(14) 
)
 AS
	If Exists(	Select  * From Historico_Exp_Mar Where 	Num_Proc_HEM = @Num_Proc)
		Delete From 
			Historico_Exp_Mar 
		Where 
			Num_Proc_HEM = @Num_Proc



GO
