SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pHIA_Historico_Del
(
@Num_Proc	VarChar(16) 
)
 AS
	If Exists(	Select  * From Historico_Imp_Aer Where Num_Proc_HIA = @Num_Proc)
		Delete From 
			Historico_Imp_Aer
		Where 
			Num_Proc_HIA = @Num_Proc



GO
