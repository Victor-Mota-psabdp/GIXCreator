SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure spDesembaraco_Saldo

as

select CXA.NUM_PROC_HIA, APELIDO from caixa_hou_imp_aer CXA
Join Cta_CtE_hou_imp_aer CTA on CTA.num_proc_hia=cxa.num_proC_hia and cta.cd_tp_Tx=cxa.cd_tp_Tx and cta.dc_hia=cxa.dc_hia
Left Join cta_ctE_hou_imp_Aer CTO on CTa.num_proc_hia=cto.num_proc_hia and CTa.cd_cred_Dev_hia=CTO.cd_cred_dev_hia and cto.cd_tp_tx in ('125','143','149')
Left Join caixa_hou_imp_aer CXO on CTO.num_proc_hia=CXO.num_proc_hia and CTO.cd_tp_Tx=CXO.cd_tp_Tx and CTO.dC_hia=CXO.dc_hia and converT(datetime,cxo.dt_pgto_Rcto_hia,105)<='02-28-2006'
Join Pessoa pp on pp.cd_pes=cta.cd_cred_dev_hia
Where convert(datetime,cxa.dt_pgto_Rcto_hia,105) between  '01-01-2006' and '02-28-2006'
and cxo.num_lcto is null and 
cxa.cd_tp_Tx in ('135','142','adt')
ORDER BY CXA.NUM_PROC_HIA



GO
