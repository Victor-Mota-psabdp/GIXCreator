SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







CREATE            PROCEDURE  spFluxoDiario

				@datainicial	varchar(10),
				@datafinal	varchar(10),
				@DataFluxo	varchar(10)
		
AS

select convert(datetime, dt_prev_pgto_hia, 105) as DataPrevista, apelido, cd_tp_ativ, nome_tp_tx,  dc_hia as DC, cta_cte_hou_imp_aer.cd_tp_moeda as Moeda, vlr_org_hia as ValorOriginal,   par_moeda, num_proc_hia as Processo  from cta_cte_hou_imp_aer
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
convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105) and num_proc_hia not like 'IAJOB%'
and left(cta_cte_hou_imp_aer.num_proc_hia,5) <> 'IAJOB'

UNION

select convert(datetime, dt_prev_pgto_MIA, 105) as DataPrevista, apelido, cd_tp_ativ, nome_tp_tx,  dc_MIA as DC, cta_cte_mas_imp_aer.cd_tp_moeda as Moeda, vlr_org_MIA as ValorOriginal,   par_moeda, num_proc_mia as Processo  from cta_cte_mas_imp_aer
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
convert(datetime, @datafinal, 105) and num_proc_mia <> 'JOB'

UNION

select convert(datetime, dt_prev_pgto_HEA, 105) as DataPrevista, apelido, cd_tp_ativ, nome_tp_tx,  dc_HEA as DC, cta_cte_hou_EXP_aer.cd_tp_moeda as Moeda, vlr_org_HEA as ValorOriginal,   par_moeda, num_proc_hea as Processo  from cta_cte_hou_EXP_aer
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
convert(datetime, @dataFinal, 105) and num_proc_hea not like 'EAJOB%'


UNION

select convert(datetime, dt_prev_pgto_MEA, 105) as DataPrevista, apelido, cd_tp_ativ, nome_tp_tx,  dc_MEA as DC, cta_cte_mas_EXP_aer.cd_tp_moeda as Moeda, vlr_org_MEA as ValorOriginal,   par_moeda, num_proc_mea as Processo  from cta_cte_mas_EXP_aer
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
convert(datetime, @datafinal, 105) and num_proc_mea <> 'JOB'


union

select convert(datetime, dt_prev_pgto_HIM, 105) as DataPrevista, apelido, cd_tp_ativ, nome_tp_tx,  dc_HIM as DC, cta_cte_hou_imp_MAR.cd_tp_moeda as Moeda, vlr_org_HIM as ValorOriginal,   par_moeda, num_proc_him as Processo  from cta_cte_hou_imp_MAR
left join paridade on (cta_cte_hou_imp_MAR.cd_tp_moeda=paridade.cd_tp_moeda and 'OFC'=cd_tp_par and @datafluxo=dt_par)
left join pessoa on (cd_cred_dev_HIM=cd_pes)
left join tipo_taxa on (tipo_taxa.cd_tp_tx=cta_cte_hou_imp_MAR.cd_tp_tx)
where desp_org_HIM='N' and ((vlr_org_HIM <> (select sum(vlr_ref_HIM) from caixa_hou_imp_MAR where
caixA_hou_imp_MAR.num_proc_HIM=cta_cte_hou_imp_MAR.num_proc_HIM and
caixa_hou_imp_MAR.cd_tp_tx=cta_Cte_hou_imp_MAR.cd_tp_tx and
caixa_hou_imp_MAR.dc_HIM=cta_Cte_hou_imp_MAR.dc_HIM and num_lcto <> 'PROVISÓRIO')) or (select sum(vlr_ref_HIM) from caixa_hou_imp_MAR where
caixA_hou_imp_MAR.num_proc_HIM=cta_cte_hou_imp_MAR.num_proc_HIM and
caixa_hou_imp_MAR.cd_tp_tx=cta_Cte_hou_imp_MAR.cd_tp_tx and
caixa_hou_imp_MAR.dc_HIM=cta_Cte_hou_imp_MAR.dc_HIM and num_lcto <> 'PROVISÓRIO') is null) and
convert(datetime, dt_prev_pgto_him, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105) and num_proc_him not like 'IMJOB%'


UNION

select convert(datetime, dt_prev_pgto_MIM, 105) as DataPrevista, apelido, cd_tp_ativ, nome_tp_tx,  dc_MIM as DC, cta_cte_mas_imp_MAR.cd_tp_moeda as Moeda, vlr_org_MIM as ValorOriginal,   par_moeda, num_proc_mim as Processo  from cta_cte_mas_imp_MAR
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
convert(datetime, @datafinal, 105)  and num_proc_mim <> 'JOB'


UNION

select convert(datetime, dt_prev_pgto_HEM, 105) as DataPrevista, apelido, cd_tp_ativ, nome_tp_tx,  dc_HEM as DC, cta_cte_hou_EXP_MAR.cd_tp_moeda as Moeda, vlr_org_HEM as ValorOriginal,   par_moeda, num_proc_hem as Processo  from cta_cte_hou_EXP_MAR
left join paridade on (cta_cte_hou_EXP_MAR.cd_tp_moeda=paridade.cd_tp_moeda and 'OFC'=cd_tp_par and @datafluxo=dt_par)
left join pessoa on (cd_cred_dev_HEM=cd_pes)
left join tipo_taxa on (tipo_taxa.cd_tp_tx=cta_cte_hou_EXP_MAR.cd_tp_tx)
where desp_DST_HEM='N' and ((vlr_org_HEM <> (select sum(vlr_ref_HEM) from caixa_hou_EXP_MAR where
caixA_hou_EXP_MAR.num_proc_HEM=cta_cte_hou_EXP_MAR.num_proc_HEM and
caixa_hou_EXP_MAR.cd_tp_tx=cta_Cte_hou_EXP_MAR.cd_tp_tx and
caixa_hou_EXP_MAR.dc_HEM=cta_Cte_hou_EXP_MAR.dc_HEM and num_lcto <> 'PROVISÓRIO')) or (select sum(vlr_ref_HEM) from caixa_hou_EXP_MAR where
caixA_hou_EXP_MAR.num_proc_HEM=cta_cte_hou_EXP_MAR.num_proc_HEM and
caixa_hou_EXP_MAR.cd_tp_tx=cta_Cte_hou_EXP_MAR.cd_tp_tx and
caixa_hou_EXP_MAR.dc_HEM=cta_Cte_hou_EXP_MAR.dc_HEM and num_lcto <> 'PROVISÓRIO') is null) and
convert(datetime, dt_prev_pgto_hem, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105) and
num_proc_hem not like 'EMJOB%'

UNION

select convert(datetime,dt_prev_pgto_MEM,105) as DataPrevista, apelido, cd_tp_ativ, nome_tp_tx,  dc_MEM as DC, cta_cte_mas_EXP_MAR.cd_tp_moeda as Moeda, vlr_org_MEM as ValorOriginal,   par_moeda, num_proc_mem as Processo  from cta_cte_mas_EXP_MAR
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
convert(datetime, @datafinal, 105) and
num_proc_mem <> 'JOB'


union

select convert(datetime, Dt_Vcto_Div,105) as DataPrevista, apelido, 'OUTROS', 'PAGAMENTOS DIVERSOS', DC_DIV AS dc, 'REL', cast(Vlr_Doc_Div as money) as ValorOriginal,'1', Num_Lcto_Div as Processo from pgto_rcto_div
inner join pessoa on (pgto_rcto_div.cd_pes=pessoa.cd_pes)
where convert(datetime, dt_vcto_div, 105) between convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105) and Concil_div='N'


GO
