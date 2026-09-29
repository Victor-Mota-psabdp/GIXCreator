SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pCxaMIM_Sel    Script Date: 17/10/2002 07:32:49 ******/
CREATE PROCEDURE pCxaMIM_Sel 
(
@Num_Proc_MIM	VarChar(16),
@Cd_Tp_Tx		VarChar(3), 
@DC_MIM		Char(1)
)
 AS
	Select 
		*
	From 
		Caixa_Mas_Imp_Mar
	Where 
		Num_Proc_MIM = @Num_Proc_MIM  AND 
		Cd_Tp_Tx = @Cd_Tp_Tx AND 
		DC_MIM = @DC_MIM
	Order by 
		Num_Lcto



GO
