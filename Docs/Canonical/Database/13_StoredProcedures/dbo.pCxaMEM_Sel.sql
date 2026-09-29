SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pCxaMEM_Sel    Script Date: 17/10/2002 07:32:48 ******/
CREATE PROCEDURE pCxaMEM_Sel 
(
@Num_Proc_MEM	VarChar(16),
@Cd_Tp_Tx		VarChar(3), 
@DC_MEM		Char(1)
)
 AS
	Select 
		*
	From 
		Caixa_Mas_Exp_Mar
	Where 
		Num_Proc_MEM = @Num_Proc_MEM  AND 
		Cd_Tp_Tx = @Cd_Tp_Tx AND 
		DC_MEM = @DC_MEM
	Order by 
		Num_Lcto



GO
