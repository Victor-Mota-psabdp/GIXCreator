SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spVerificaRegistroFinanceiro_Sel]
(
	@Num_Proc varchar(16),
	@Cd_Tp_Tx varchar(3),
	@DC char(1)
)
as
	select 
		Num_Proc Num_Proc,cd_tp_tx,DC from [vwRegistroFinanceiroItem]
	where 
		Num_Proc =@Num_Proc  and cd_tp_tx = @Cd_Tp_Tx and DC = @DC


GO
