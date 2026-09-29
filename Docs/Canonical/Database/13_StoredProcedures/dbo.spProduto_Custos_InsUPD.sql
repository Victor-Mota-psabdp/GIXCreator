SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure spProduto_Custos_InsUPD

@Num_proc	varchar(16),
@Cd_Tp_Tx	varchar(30),
@Valor		float(10)

AS

Begin Transaction

	If exists (select * from custo_processo where num_proc = @Num_proc and cd_tp_tx = @Cd_Tp_Tx)
		Begin
			Update
				custo_processo
			set
				Valor = @Valor
			where
				num_proc = @Num_proc 
				and cd_tp_tx = @Cd_Tp_Tx
			end
	Else
		Begin
			insert into
				custo_processo
				(
				Num_Proc,
				Cd_Tp_Tx,
				Valor
				)
			values
				(
				@Num_proc,
				@Cd_Tp_Tx,
				@Valor
				)
			end

	if @@error <> 0
		Begin
			Rollback transaction
			return -1
		End

Commit Transaction
GO
