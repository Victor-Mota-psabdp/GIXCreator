SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spFMCMiroPgtobyBDP_Sel]
		@num_proc Varchar(16),
		@ID_MIRO	INT

as

select Isnull(sum(vlr_item_Custo),0) Valor from custo_cliente CC
Join vwcta_cte CTA on CTA.num_proc_hia=CC.num_proc and cta.cd_tp_tx=CC.cd_tp_Tx and dc_hia='D'
Join FMC_Plano_Contas_V2 PC on PC.cd_tp_tx=CC.cd_tp_tx
Where
	BDP_Pgto='S' and num_proc=@num_proc
	AND CC.NUM_NF_CUSTO=@ID_MIRO

GO
