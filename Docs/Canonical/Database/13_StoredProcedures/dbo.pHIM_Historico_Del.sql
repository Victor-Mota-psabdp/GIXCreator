SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pHIM_Historico_Del
(
@Num_Proc	VarChar(16) 
)
 AS
	If Exists(	Select  * From Historico_Imp_Mar Where 	Num_Proc_HIM = @Num_Proc)
		Delete From 
			Historico_Imp_Mar 
		Where 
			Num_Proc_HIM = @Num_Proc



GO
