SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spIntSmartTaxaPPRoduto_Sel]
	@Num_Proc	varchar(16),
	@Produto	varchar(40)

as

select nome_tp_Tx_ing Taxa,vlr_item_custo,cc.cd_tp_tx from custo_Cliente CC With(nolock)
Join Tipo_Taxa TT With(nolock) on TT.cd_tp_Tx=CC.cd_tp_Tx
Join Produto_Cliente   PC With(nolock) on cd_produto=cd_prod
Where
	Num_Proc=@Num_Proc and Cd_proc_cliente=@PRoduto
	and nome_tp_Tx_ing  is not null
GO
