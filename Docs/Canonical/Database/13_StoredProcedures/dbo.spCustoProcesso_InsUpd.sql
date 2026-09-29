SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spCustoProcesso_InsUpd]
		
		@Num_Proc	Varchar(16),
		@Cd_Tp_Tx	Varchar(3),
		@Valor		float
as


Begin Transaction
	if not exists(select num_proc from custo_processo where num_proc=@num_proc and cd_tp_Tx=@cd_tp_tx)
		Begin
			Insert into
				Custo_Processo
				(
					Num_Proc, cd_tp_Tx,valor
				)
			Values
				(
					@num_proc,@cd_tp_Tx,@valor
				)
		End
	else
		Begin
			Update
				Custo_Processo
					Set
						Valor=@valor
				Where
					num_proc=@num_proc and cd_tp_tx=@cd_tp_tx
		end
	if @@error <> 0 
		Begin
			Rollback transaction
			return -1
		end
commit transaction

GO
