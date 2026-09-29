SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE function [dbo].[fTransfPriceCusto] --'EACSR20110100301'
(
	@num_proc as Varchar(16),
	@Cd_Prod  as int,
	@Cd_TP_Tx	as varchar(3)
)

RETURNS float

BEGIN

	Declare @Saida float

	Set @Saida= isnull((select sum(vlr_item_custo) Valor from custo_Cliente CC with (nolock) Join Tipo_taxa TT with (nolock)  on TT.cd_tp_tx=CC.cd_tp_Tx  Where codigotp=@Cd_Tp_Tx and num_proc=@Num_Proc and cd_produto=@Cd_PRod),0)

	Return @Saida

ENd

















GO
