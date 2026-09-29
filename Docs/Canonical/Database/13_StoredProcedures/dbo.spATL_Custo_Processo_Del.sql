SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure [dbo].[spATL_Custo_Processo_Del]
		
		@Num_Proc	Varchar(16),
		@Cd_Tp_Tx	Varchar(3),
		@Valor		float
as


Begin Transaction
	if exists(select num_proc from custo_processo where num_proc=@num_proc and cd_tp_Tx=@cd_tp_tx)		
		Begin
			delete Custo_Processo
			Where	num_proc=@num_proc 
			and cd_tp_tx=@cd_tp_tx
		end
		
	if @@error <> 0 
		Begin
			Rollback transaction
			return -1
		end
commit transaction
GO
