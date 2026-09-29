SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE pTaxTarAer_InsUpd 
(
@TAEID		Int,
@Nome_Tp_Tx 		VarChar(30), 
@Cd_Tp_Moeda	VarChar(3), 
@TXAValor		float,
@TXAEspec		VarChar(30)=Null
)
AS
	Declare @Cd_Tp_Tx 	VarChar(3) 
	Begin Transaction 
	Set @Cd_Tp_Tx = (Select Cd_Tp_Tx From Tipo_Taxa Where Nome_Tp_Tx = @Nome_Tp_Tx )
	If Exists(Select * From Tax_Tar_Aer Where Cd_Tp_Tx = @Cd_Tp_Tx  and TAEID = @TAEID) 
		Begin 
			Update 
				Tax_Tar_Aer
			Set 
				Cd_Tp_Moeda = @Cd_Tp_Moeda, 
				TXAValor = @TXAValor,
				TXAEspec = @TXAEspec
			Where
				Cd_Tp_Tx = @Cd_Tp_Tx and 
				TAEID = @TAEID

			If @@Error  <> 0 
				Begin 
					Rollback  Transaction 
					Return -1 
				End 
			Else
				Begin 
					Commit Transaction 
					Return 1 
				End 

		End 
	Else
		Begin
			Insert into Tax_Tar_Aer  (TAEID, Cd_Tp_Tx, Cd_Tp_Moeda, TXAValor, TXAEspec) values 
				(@TAEID, @Cd_Tp_Tx, @Cd_Tp_Moeda, @TXAValor, @TXAEspec)
			If @@Error  <> 0 
				Begin 
					Rollback  Transaction 
					Return -1 
				End 
			Else
				Begin 
					Commit Transaction 
					Return 1 
				End 
		End
GO
