SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spProdutoCustos_Del]

@Num_proc	varchar(16),
@Cd_Tp_Tx	varchar(30)

AS
	If Exists(select * from custo_processo where num_proc = @Num_proc and  cd_tp_tx = @Cd_Tp_Tx)
		Delete 
			custo_processo 
		Where
			num_proc = @Num_proc and  cd_tp_tx = @Cd_Tp_Tx
	
	Else
		Return -1
GO
