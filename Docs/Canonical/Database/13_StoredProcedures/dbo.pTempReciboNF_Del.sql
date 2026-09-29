SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pTempReciboNF_Del
(
@Num_Proc		VarChar(16)='',
@Cd_Tp_Tx		VarChar(3)='',
@DC			Char(1), 
@ID_Machine		VarChar(30)
)
 AS
	If @Num_Proc  = '' 
		Delete
			Temp_Recibo_NF
		Where
			ID_Machine  = @ID_Machine 
	Else 
		Delete
			Temp_Recibo_NF
		Where
			Num_Proc = @Num_Proc and 
			Cd_Tp_Tx =  @Cd_Tp_Tx and 
			DC = @DC and 
			ID_Machine  = @ID_Machine



GO
