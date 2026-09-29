SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[pTempReciboNF_Upd]
(
@Num_Proc		VarChar(16)='',
@Cd_Tp_Tx		VarChar(3)='',
@DC			Char(1), 
@ID_Machine		VarChar(50),
@Tx_Convers		Float 
)
 AS
	Update
		Temp_Recibo_NF
	Set 
		Tx_Convers = @Tx_Convers,
		Vlr_Pago = @Tx_Convers * Vlr_Oficial
	Where
		Num_Proc = @Num_Proc and 
		Cd_Tp_Tx =  @Cd_Tp_Tx and 
		DC = @DC and 
		ID_Machine  = @ID_Machine



GO
