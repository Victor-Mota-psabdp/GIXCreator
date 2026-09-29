SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pCxaMIA_Sel 
(
@Num_Proc_MIA	VarChar(16),
@Cd_Tp_Tx		VarChar(3), 
@DC_MIA		Char(1)
)
 AS
	Select 
		*
	From 
		Caixa_Mas_Imp_Aer
	Where 
		Num_Proc_MIA = @Num_Proc_MIA  AND 
		Cd_Tp_Tx = @Cd_Tp_Tx AND 
		DC_MIA = @DC_MIA
	Order by 
		Num_Lcto



GO
