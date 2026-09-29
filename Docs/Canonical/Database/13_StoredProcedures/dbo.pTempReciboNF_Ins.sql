SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pTempReciboNF_Ins 
(
@Num_Proc		VarChar(16)='',
@Cd_Tp_Tx		VarChar(3)='',
@DC			Char(1), 
@ID_Machine		VarChar(50),
@Cd_Tp_Moeda	VarChar(3),
@Vlr_Oficial		Float, 
@Tx_Convers		Float, 
@Vlr_Pgto		Float, 
@Exc			Char(1) = 'N'
)
 AS
	If @Exc = 'S'
		Begin 
			Begin Transaction 
			Exec pTempReciboNF_Del  '','', @ID_Machine 
			If @@Error <> 0 
				Begin 
					RollBack Transaction 
					Return -1 
				End 
			Else 
				Begin 
					Insert Into
						Temp_Recibo_NF
						(Num_Proc, Cd_Tp_Tx, DC, ID_Machine, Cd_Tp_Moeda, Vlr_Oficial, Tx_Convers, Vlr_Pago) 
					Values 
						(@Num_Proc, @Cd_Tp_Tx, @DC, @ID_Machine, @Cd_Tp_Moeda, @Vlr_Oficial, @Tx_Convers, @Vlr_Pgto) 
					Commit Transaction 
					Return 1 
				End 
		End 
	Else 
		Begin 
			Insert Into
				Temp_Recibo_NF
				(Num_Proc, Cd_Tp_Tx, DC, ID_Machine, Cd_Tp_Moeda, Vlr_Oficial, Tx_Convers, Vlr_Pago) 
			Values 
				(@Num_Proc, @Cd_Tp_Tx, @DC, @ID_Machine, @Cd_Tp_Moeda, @Vlr_Oficial, @Tx_Convers, @Vlr_Pgto) 
			Return 1 
		End



GO
