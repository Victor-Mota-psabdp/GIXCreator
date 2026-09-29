SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spTempPrestacao_rel]

	@num_proc	varchar(16)
as


select DBO.VALOR(VLR_ORG_HIA,CTA.DC_HIA) VALOR,cta.CD_TP_TX,cta.DC_HIA DC_HIA from cta_cte_hou_IMP_aer cta  
Left Join Caixa_hou_IMP_aer cxa on cta.num_proc_hia=cxa.num_proc_hia and cta.dc_hia=cxa.dc_hia and cta.cd_tp_tx=CXA.cd_tp_Tx  
Join house_imp_aer hou on hou.num_proc_hia=cta.num_proc_hia and cd_consig_hia=cd_cred_deV_hia  
where cta.num_proc_hia=@num_proc and cta.num_nf_hia is null      and cxa.num_lcto is null and cta.cd_tp_tx not in ('XAP','XBA','110')

union

select DBO.VALOR(VLR_ORG_him,CTA.DC_him) VALOR,cta.CD_TP_TX,cta.DC_him DC_him from cta_cte_hou_IMP_mar cta  
Left Join Caixa_hou_IMP_mar cxa on cta.num_proc_him=cxa.num_proc_him and cta.dc_him=cxa.dc_him and cta.cd_tp_tx=CXA.cd_tp_Tx  
Join house_imp_mar hou on hou.num_proc_him=cta.num_proc_him and cd_consig_him=cd_cred_deV_him  
where cta.num_proc_him=@num_proc and cta.num_nf_him is null      and cxa.num_lcto is null and cta.cd_tp_tx not in ('XAP','XBA','110')

union

select DBO.VALOR(VLR_ORG_hio,CTA.DC_hio) VALOR,cta.CD_TP_TX,cta.DC_hio DC_hio from cta_cte_hou_IMP_out cta  
Left Join Caixa_hou_IMP_out cxa on cta.num_proc_hio=cxa.num_proc_hio and cta.dc_hio=cxa.dc_hio and cta.cd_tp_tx=CXA.cd_tp_Tx  
Join house_imp_out hou on hou.num_proc_hio=cta.num_proc_hio and cd_consig_hio=cd_cred_deV_hio  
where cta.num_proc_hio=@num_proc and cta.num_nf_hio is null      and cxa.num_lcto is null and cta.cd_tp_tx not in ('XAP','XBA','110')


union

select DBO.VALOR(VLR_ORG_hea,CTA.DC_hea) VALOR,cta.CD_TP_TX,cta.DC_hea DC_hea from cta_cte_hou_exp_aer cta  
Left Join Caixa_hou_exp_aer cxa on cta.num_proc_hea=cxa.num_proc_hea and cta.dc_hea=cxa.dc_hea and cta.cd_tp_tx=CXA.cd_tp_Tx  
Join house_exp_aer hou on hou.num_proc_hea=cta.num_proc_hea and cd_export_hea=cd_cred_deV_hea  
where cta.num_proc_hea=@num_proc and cta.num_nf_hea is null      and cxa.num_lcto is null and cta.cd_tp_tx not in ('XAP','XBA','110')

union

select DBO.VALOR(VLR_ORG_hem,CTA.DC_hem) VALOR,cta.CD_TP_TX,cta.DC_hem DC_hem from cta_cte_hou_exp_mar cta  
Left Join Caixa_hou_exp_mar cxa on cta.num_proc_hem=cxa.num_proc_hem and cta.dc_hem=cxa.dc_hem and cta.cd_tp_tx=CXA.cd_tp_Tx  
Join house_exp_mar hou on hou.num_proc_hem=cta.num_proc_hem and cd_export_hem=cd_cred_deV_hem  
where cta.num_proc_hem=@num_proc and cta.num_nf_hem is null      and cxa.num_lcto is null and cta.cd_tp_tx not in ('XAP','XBA','110')

union

select DBO.VALOR(VLR_ORG_heo,CTA.DC_heo) VALOR,cta.CD_TP_TX,cta.DC_heo DC_heo from cta_cte_hou_exp_out cta  
Left Join Caixa_hou_exp_out cxa on cta.num_proc_heo=cxa.num_proc_heo and cta.dc_heo=cxa.dc_heo and cta.cd_tp_tx=CXA.cd_tp_Tx  
Join house_exp_out hou on hou.num_proc_heo=cta.num_proc_heo and cd_export_heo=cd_cred_deV_heo  
where cta.num_proc_heo=@num_proc and cta.num_nf_heo is null      and cxa.num_lcto is null and cta.cd_tp_tx not in ('XAP','XBA','110')



GO
