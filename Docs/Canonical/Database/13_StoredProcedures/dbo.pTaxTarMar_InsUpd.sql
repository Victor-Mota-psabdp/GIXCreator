SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE pTaxTarMar_InsUpd 
(
@TAMID		Int,
@Nome_Tp_Tx 		VarChar(30), 
@Cd_Tp_Moeda	VarChar(3), 
@TXMValor		float,
@TXMEspec		VarChar(30)=null
)
AS
	Declare @Cd_Tp_Tx 	VarChar(3) 
	Begin Transaction 
	Set @Cd_Tp_Tx = (Select Cd_Tp_Tx From Tipo_Taxa Where Nome_Tp_Tx = @Nome_Tp_Tx )
	If Exists(Select * From Tax_Tar_Mar Where Cd_Tp_Tx = @Cd_Tp_Tx  and TAMID = @TAMID) 
		Begin 
			Update 
				Tax_Tar_Mar
			Set 
				Cd_Tp_Moeda = @Cd_Tp_Moeda, 
				TXMValor = @TXMValor, 
				TXMEspec = @TXMEspec
			Where
				Cd_Tp_Tx = @Cd_Tp_Tx and 
				TAMID = @TAMID

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
			Insert into Tax_Tar_Mar  (TAMID, Cd_Tp_Tx, Cd_Tp_Moeda, TXMValor, TXMEspec) values 
				(@TAMID, @Cd_Tp_Tx, @Cd_Tp_Moeda, @TXMValor, @TXMEspec)
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
