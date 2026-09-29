SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





CREATE       PROCEDURE  spMoedaFluxo

				@datainicial	varchar(10),
				@datafinal	varchar(10),
				@DataFluxo	varchar(10)
		
AS

select  cta_cte_hou_imp_aer.cd_tp_moeda as Moeda, par_moeda  from cta_cte_hou_imp_aer
left join paridade on (cta_cte_hou_imp_aer.cd_tp_moeda=paridade.cd_tp_moeda and 'OFC'=cd_tp_par and @datafluxo=dt_par)
left join pessoa on (cd_cred_dev_hia=cd_pes)
left join tipo_taxa on (tipo_taxa.cd_tp_tx=cta_cte_hou_imp_aer.cd_tp_tx)
where desp_org_hia='N' and ((vlr_org_hia <> (select sum(vlr_ref_hia) from caixa_hou_imp_aer where
caixA_hou_imp_aer.num_proc_hia=cta_cte_hou_imp_aer.num_proc_hia and
caixa_hou_imp_aer.cd_tp_tx=cta_Cte_hou_imp_aer.cd_tp_tx and
caixa_hou_imp_aer.dc_hia=cta_Cte_hou_imp_Aer.dc_hia and num_lcto <> 'PROVISÓRIO')) or (select sum(vlr_ref_hia) from caixa_hou_imp_aer where
caixA_hou_imp_aer.num_proc_hia=cta_cte_hou_imp_aer.num_proc_hia and
caixa_hou_imp_aer.cd_tp_tx=cta_Cte_hou_imp_aer.cd_tp_tx and
caixa_hou_imp_aer.dc_hia=cta_Cte_hou_imp_Aer.dc_hia and num_lcto <> 'PROVISÓRIO') is null) and 
convert(datetime, dt_prev_pgto_hia, 105) between 
convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
group by cta_cte_hou_imp_aer.cd_tp_moeda, par_moeda

UNION

select cta_cte_mas_imp_aer.cd_tp_moeda as Moeda, par_moeda  from cta_cte_mas_imp_aer
left join paridade on (cta_cte_mas_imp_aer.cd_tp_moeda=paridade.cd_tp_moeda and 'OFC'=cd_tp_par and @datafluxo=dt_par)
left join pessoa on (cd_cred_dev_MIA=cd_pes)
left join tipo_taxa on (tipo_taxa.cd_tp_tx=cta_cte_mas_imp_aer.cd_tp_tx)
where desp_org_MIA='N' and ((vlr_org_MIA <> (select sum(vlr_ref_MIA) from caixa_mas_imp_aer where
caixA_mas_imp_aer.num_proc_MIA=cta_cte_mas_imp_aer.num_proc_MIA and
caixa_mas_imp_aer.cd_tp_tx=cta_Cte_mas_imp_aer.cd_tp_tx and
caixa_mas_imp_aer.dc_MIA=cta_Cte_mas_imp_Aer.dc_MIA and num_lcto <> 'PROVISÓRIO')) or (select sum(vlr_ref_MIA) from caixa_mas_imp_aer where
caixA_mas_imp_aer.num_proc_MIA=cta_cte_mas_imp_aer.num_proc_MIA and
caixa_mas_imp_aer.cd_tp_tx=cta_Cte_mas_imp_aer.cd_tp_tx and
caixa_mas_imp_aer.dc_MIA=cta_Cte_mas_imp_Aer.dc_MIA and num_lcto <> 'PROVISÓRIO') is null) and
convert(datetime, dt_prev_pgto_mia, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105)
group by cta_cte_mas_imp_aer.cd_tp_moeda , par_moeda


UNION

select  cta_cte_hou_EXP_aer.cd_tp_moeda as Moeda, par_moeda  from cta_cte_hou_EXP_aer
left join paridade on (cta_cte_hou_EXP_aer.cd_tp_moeda=paridade.cd_tp_moeda and 'OFC'=cd_tp_par and @datafluxo=dt_par)
left join pessoa on (cd_cred_dev_HEA=cd_pes)
left join tipo_taxa on (tipo_taxa.cd_tp_tx=cta_cte_hou_EXP_aer.cd_tp_tx)
where desp_DST_HEA='N' and ((vlr_org_HEA <> (select sum(vlr_ref_HEA) from caixa_hou_EXP_aer where
caixA_hou_EXP_aer.num_proc_HEA=cta_cte_hou_EXP_aer.num_proc_HEA and
caixa_hou_EXP_aer.cd_tp_tx=cta_Cte_hou_EXP_aer.cd_tp_tx and
caixa_hou_EXP_aer.dc_HEA=cta_Cte_hou_EXP_Aer.dc_HEA and num_lcto <> 'PROVISÓRIO')) or (select sum(vlr_ref_HEA) from caixa_hou_EXP_aer where
caixA_hou_EXP_aer.num_proc_HEA=cta_cte_hou_EXP_aer.num_proc_HEA and
caixa_hou_EXP_aer.cd_tp_tx=cta_Cte_hou_EXP_aer.cd_tp_tx and
caixa_hou_EXP_aer.dc_HEA=cta_Cte_hou_EXP_Aer.dc_HEA and num_lcto <> 'PROVISÓRIO') is null) and
convert(datetime, dt_prev_pgto_hea, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @dataFinal, 105)
group by cta_cte_hou_EXP_aer.cd_tp_moeda, par_moeda

UNION

select  cta_cte_mas_EXP_aer.cd_tp_moeda as Moeda,  par_moeda  from cta_cte_mas_EXP_aer
left join paridade on (cta_cte_mas_EXP_aer.cd_tp_moeda=paridade.cd_tp_moeda and 'OFC'=cd_tp_par and @datafluxo=dt_par)
left join pessoa on (cd_cred_dev_MEA=cd_pes)
left join tipo_taxa on (tipo_taxa.cd_tp_tx=cta_cte_mas_EXP_aer.cd_tp_tx)
where desp_DST_MEA='N' and ((vlr_org_MEA <> (select sum(vlr_ref_MEA) from caixa_mas_EXP_aer where
caixA_mas_EXP_aer.num_proc_MEA=cta_cte_mas_EXP_aer.num_proc_MEA and
caixa_mas_EXP_aer.cd_tp_tx=cta_Cte_mas_EXP_aer.cd_tp_tx and
caixa_mas_EXP_aer.dc_MEA=cta_Cte_mas_EXP_Aer.dc_MEA and num_lcto <> 'PROVISÓRIO')) or (select sum(vlr_ref_MEA) from caixa_mas_EXP_aer where
caixA_mas_EXP_aer.num_proc_MEA=cta_cte_mas_EXP_aer.num_proc_MEA and
caixa_mas_EXP_aer.cd_tp_tx=cta_Cte_mas_EXP_aer.cd_tp_tx and
caixa_mas_EXP_aer.dc_MEA=cta_Cte_mas_EXP_Aer.dc_MEA and num_lcto <> 'PROVISÓRIO') is null) and
convert(datetime, dt_prev_pgto_mea, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105)
group by cta_cte_mas_EXP_aer.cd_tp_moeda , par_moeda

union



select CTA.cd_tp_moeda as Moeda,  par_moeda  from cta_cte_hou_imp_MAR cta
left join paridade on (CTA.cd_tp_moeda=paridade.cd_tp_moeda and 'OFC'=cd_tp_par and @datafluxo=dt_par)
left join pessoa on (cd_cred_dev_HIM=cd_pes)
left join tipo_taxa on (tipo_taxa.cd_tp_tx=CTA.cd_tp_tx)
Left Join Caixa_hou_imp_mar cxa on cta.num_proc_him=cxa.num_proc_him and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_him=cxa.dc_him and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_him,105) <=Convert(datetime,@DataFinal,105)
where desp_org_HIM='N'  AND  cxa.num_lcto is null and left(cta.num_proc_him,5) <> 'IMJOB'
group by CTA.cd_tp_moeda,  par_moeda,cta.num_proc_him


UNION

select  cta_cte_mas_imp_MAR.cd_tp_moeda as Moeda,  par_moeda  from cta_cte_mas_imp_MAR
left join paridade on (cta_cte_mas_imp_MAR.cd_tp_moeda=paridade.cd_tp_moeda and 'OFC'=cd_tp_par and @datafluxo=dt_par)
left join pessoa on (cd_cred_dev_MIM=cd_pes)
left join tipo_taxa on (tipo_taxa.cd_tp_tx=cta_cte_mas_imp_MAR.cd_tp_tx)
where desp_org_MIM='N' and ((vlr_org_MIM <> (select sum(vlr_ref_MIM) from caixa_mas_imp_MAR where
caixA_mas_imp_MAR.num_proc_MIM=cta_cte_mas_imp_MAR.num_proc_MIM and
caixa_mas_imp_MAR.cd_tp_tx=cta_Cte_mas_imp_MAR.cd_tp_tx and
caixa_mas_imp_MAR.dc_MIM=cta_Cte_mas_imp_MAR.dc_MIM and num_lcto <> 'PROVISÓRIO')) or (select sum(vlr_ref_MIM) from caixa_mas_imp_MAR where
caixA_mas_imp_MAR.num_proc_MIM=cta_cte_mas_imp_MAR.num_proc_MIM and
caixa_mas_imp_MAR.cd_tp_tx=cta_Cte_mas_imp_MAR.cd_tp_tx and
caixa_mas_imp_MAR.dc_MIM=cta_Cte_mas_imp_MAR.dc_MIM and num_lcto <> 'PROVISÓRIO') is null) and
convert(datetime, dt_prev_pgto_mim, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105) 
group by cta_cte_mas_imp_MAR.cd_tp_moeda ,  par_moeda 

UNION

select  cta_cte_hou_EXP_MAR.cd_tp_moeda as Moeda, par_moeda  from cta_cte_hou_EXP_MAR
left join paridade on (cta_cte_hou_EXP_MAR.cd_tp_moeda=paridade.cd_tp_moeda and 'OFC'=cd_tp_par and @datafluxo=dt_par)
left join pessoa on (cd_cred_dev_HEM=cd_pes)
left join tipo_taxa on (tipo_taxa.cd_tp_tx=cta_cte_hou_EXP_MAR.cd_tp_tx)
where desp_DST_HEM='N' and ((vlr_org_HEM <> (select sum(vlr_ref_HEM) from caixa_hou_EXP_MAR where
caixA_hou_EXP_MAR.num_proc_HEM=cta_cte_hou_EXP_MAR.num_proc_HEM and
caixa_hou_EXP_MAR.cd_tp_tx=cta_Cte_hou_EXP_MAR.cd_tp_tx and
caixa_hou_EXP_MAR.dc_HEM=cta_Cte_hou_EXP_MAR.dc_HEM and num_lcto <> 'PROVISÓRIO')) or (select sum(vlr_ref_HEM) from caixa_hou_EXP_MAR where
caixA_hou_EXP_MAR.num_proc_HEM=cta_cte_hou_EXP_MAR.num_proc_HEM and
caixa_hou_EXP_MAR.cd_tp_tx=cta_Cte_hou_EXP_MAR.cd_tp_tx and
caixa_hou_EXP_MAR.dc_HEM=cta_Cte_hou_EXP_MAR.dc_HEM and num_lcto <> 'PROVISÓRIO') is null) andconvert(datetime, dt_prev_pgto_hem, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105)
group by cta_cte_hou_EXP_MAR.cd_tp_moeda , par_moeda  

UNION

select cta_cte_mas_EXP_MAR.cd_tp_moeda as Moeda, par_moeda  from cta_cte_mas_EXP_MAR
left join paridade on (cta_cte_mas_EXP_MAR.cd_tp_moeda=paridade.cd_tp_moeda and 'OFC'=cd_tp_par and @datafluxo=dt_par)
left join pessoa on (cd_cred_dev_MEM=cd_pes)
left join tipo_taxa on (tipo_taxa.cd_tp_tx=cta_cte_mas_EXP_MAR.cd_tp_tx)
where desp_DST_MEM='N' and ((vlr_org_MEM <> (select sum(vlr_ref_MEM) from caixa_mas_EXP_MAR where
caixA_mas_EXP_MAR.num_proc_MEM=cta_cte_mas_EXP_MAR.num_proc_MEM and
caixa_mas_EXP_MAR.cd_tp_tx=cta_Cte_mas_EXP_MAR.cd_tp_tx and
caixa_mas_EXP_MAR.dc_MEM=cta_Cte_mas_EXP_MAR.dc_MEM and num_lcto <> 'PROVISÓRIO')) or (select sum(vlr_ref_MEM) from caixa_mas_EXP_MAR where
caixA_mas_EXP_MAR.num_proc_MEM=cta_cte_mas_EXP_MAR.num_proc_MEM and
caixa_mas_EXP_MAR.cd_tp_tx=cta_Cte_mas_EXP_MAR.cd_tp_tx and
caixa_mas_EXP_MAR.dc_MEM=cta_Cte_mas_EXP_MAR.dc_MEM and num_lcto <> 'PROVISÓRIO') is null) and
convert(datetime, dt_prev_pgto_mem, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105)
group by cta_cte_mas_EXP_MAR.cd_tp_moeda , par_moeda 






GO
