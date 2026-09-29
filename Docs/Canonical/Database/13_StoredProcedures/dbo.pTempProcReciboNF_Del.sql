SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pTempProcReciboNF_Del 
(
@Num_Proc		Varchar(16), 
@Cd_Tp_Tx 		VarChar(3), 
@DC			Char(1),
@ID_Machine 		VarChar(50) 
)
 AS
	Delete 
		Temp_Recibo_NF
	Where 
		Num_Proc Like @Num_Proc and 
		Cd_Tp_Tx Like @Cd_Tp_Tx and 
		DC Like  @DC and 
		ID_Machine = @ID_Machine



GO
