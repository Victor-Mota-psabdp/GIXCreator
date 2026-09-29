SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   PROCEDURE spDemurrageExtrato_Rel 

	(
		@DC Char(1)
	)
as

Select 
	pp.Apelido Pessoa_CTA,CTA.num_proc_him Processo, 
	Nome_tp_Tx, cta.cd_tp_moeda,cta.dc_him, cta.vlr_org_him,PO.Apelido Pessoa_Opos, 
	cxo.vlr_pgto_Rcto_him, Isnull(CXo.num_lcto,'Em Aberto') Sit
From 
	Cta_cte_hou_imp_Mar CTA
	Join Pessoa pp on pp.cd_pes=cta.cd_cred_dev_him
	Left Join Caixa_hou_imp_Mar CXA on CTA.num_proc_him=CXA.num_proc_him and CTA.cd_tp_Tx=CXA.cd_tp_tx and cTA.dc_him=CXA.dc_him
	Left Join Cta_Cte_hou_imp_mar CTO on CTA.num_proc_him=CTO.num_proc_him and CTA.cd_tp_Tx=CTO.cd_tp_tx and CTA.dc_him <> CTO.dc_him
	Left Join Caixa_hou_imp_mar CXO on CTO.num_proc_him=CXO.num_proc_him and CTO.cd_tp_tx=CXO.cd_tp_Tx and CTO.dc_him=CXO.dC_him
	Join Pessoa PO on PO.cd_pes=cto.cd_cred_Dev_him
	join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
Where 
	CXA.num_lcto is null and cta.dc_him=@DC
	and cta.cd_tp_tx in ('DEM','DE2','DE3','DE4','DE5')



GO
