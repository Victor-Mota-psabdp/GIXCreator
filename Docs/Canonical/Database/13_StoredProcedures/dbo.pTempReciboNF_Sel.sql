SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pTempReciboNF_Sel
(
@ID_Machine		VarChar(30)
)
 AS
	Select 
		TR.*, TT.Nome_Tp_Tx as Taxa 
	From
		Temp_Recibo_NF as TR Join Tipo_Taxa as TT on TR.Cd_Tp_Tx = TT.Cd_Tp_Tx 
	Where
		ID_Machine  = @ID_Machine
	Order by 
		Num_Proc, TR.Cd_Tp_Tx



GO
