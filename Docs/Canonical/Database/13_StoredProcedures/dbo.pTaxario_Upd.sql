SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE pTaxario_Upd
(
@Cd_Tp_TX			varchar(3), 
@Cd_Modal			char(2),
@Cd_Local			varchar(3), 
@TxrNat			char(1), 
@Cd_Pes			varchar(10), 
@Cd_Tp_Moeda		varchar(3), 
@TxrValor			float, 
@TxrForma			varchar(80), 
@TxrValidade			datetime
)
AS
	Begin Transaction 
	Declare @Seq 	Int 
	Set @Seq = IsNull((Select TxrSeq From Taxario Where Cd_Tp_Tx = @Cd_Tp_Tx and Cd_Modal = @Cd_Modal and Cd_Local = @Cd_Local and TxrNat = @TxrNat and Cd_Pes = @Cd_Pes ) , 0 )

	If @Seq= 0 
		Begin 
			Rollback Transaction 
			Return -1 	
		End 

	Update
		Taxario 
	Set 
		Cd_Tp_moeda = @Cd_Tp_Moeda,
		TxrValor = @TxrValor,
		TxrForma = @TxrForma, 
		TxrValidade = @TxrValidade
	Where
		TxrSeq = @Seq 

	
	If @@Error <> 0 
		Begin 
			Rollback Transaction 
			Return -2 
		End 
	Else
		Begin 
			Commit Transaction 
			Return 1 
		End

GO
