SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure spMiroDet_InsUpd

		@Num_Proc	VarChar(16),
		@Miro		Varchar(20)

AS

Begin Transaction
	UPDATE 
		Custo_Cliente
	SET
		Num_NF_Custo=@Miro
	Where
		Num_Proc=@Num_Proc and
		Cd_tp_tx in
		(select cd_tp_tx from fatura_chb FC
		Join fatura_chb_item FI on FI.fatura_cc=FC.fatura_pc
		where  fatura_pc in (
		select max(fatura_pc) from fatura_chb where processo_pc=@Num_Proc)
		)
	
	if @@Error <> 0
		Begin
			Rollback Transaction
			return -1
		End

Commit Transaction

GO
