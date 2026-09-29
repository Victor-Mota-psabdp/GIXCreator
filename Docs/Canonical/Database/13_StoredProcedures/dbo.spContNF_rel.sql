SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spContNF_rel 

		@datainicial	varchar(10),
		@datafinal	varchar(10)

as

select convert(datetime, cxa.dt_pgto_rcto_hia, 105) as DataPgto, cxa.num_proc_hia, apelido, nome_tp_Tx, cxa.num_rcb_Hia, cxa.dc_hia, cta.cd_tp_moeda as MoedaCx,cast(cxa.vlr_ref_hia as money) as ValorRef, cxa.Par_moeda_hia as CXAPAR, cast(cxa.vlr_pgto_rcto_hia as money)as ValorPgto, emissao, cta.par_nf_hia, cast(cta.vlr_pgto_nf_hia as money) as ValorNF from caixa_hou_imp_aer as cxa
inner join cta_cte_hou_imp_aer as cta on (cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia)
inner join tipo_taxa on (cta.cd_tp_tx=tipo_taxa.cd_tp_tx)
inner join pessoa on (cta.cd_cred_dev_hia=cd_pes)
left outer join  cta_cte_hou_imp_aer as ctaO on(cta.num_proC_hia=ctao.num_proC_hia and cta.cd_tp_tx=ctao.cd_tp_Tx and cta.dc_hia<>ctao.dc_hia and ctao.desp_org_hia='N')
left outer join cta_cte_mas_imp_aer as ctam on (left(cta.num_proc_hia,14)=ctam.num_proc_mia and cta.cd_tp_tx=ctam.cd_tp_tx and cta.dc_hia<>ctam.dc_mia and ctam.desp_org_mia='N')
left outer join base_notA_fiscal on (cta.num_nf_hia=nota_fiscal and cta.ref_acesso_nf_hia=ref_acesso and cta.cd_tp_Tx<>'FRT')
where cxa.num_lcto<>'PROVISÓRIO' 
and (ctao.num_proc_hia is null and ctam.num_proc_mia is null)
and convert(datetime, cxa.dt_pgto_rcto_hia, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)

UNION

select convert(datetime, cxa.dt_pgto_rcto_mia, 105) as DataPgto, cxa.num_proc_mia, apelido, nome_tp_Tx, cxa.num_rcb_mia, cxa.dc_mia, cta.cd_tp_moeda as MoedaCx,cast(cxa.vlr_ref_mia as money) as ValorRef, cxa.Par_moeda_mia as CXAPAR, cast(cxa.vlr_pgto_rcto_mia as money)as ValorPgto, emissao, cta.par_nf_mia, cast(cta.vlr_pgto_nf_mia as money) as ValorNF from caixa_mas_imp_aer as cxa
inner join cta_cte_mas_imp_aer as cta on (cta.num_proc_mia=cxa.num_proc_mia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mia=cxa.dc_mia)
inner join tipo_taxa on (cta.cd_tp_tx=tipo_taxa.cd_tp_tx)
inner join pessoa on (cta.cd_cred_dev_mia=cd_pes)
left outer join  cta_cte_mas_imp_aer as ctaO on(cta.num_proC_mia=ctao.num_proC_mia and cta.cd_tp_tx=ctao.cd_tp_Tx and cta.dc_mia<>ctao.dc_mia and ctao.desp_org_mia='N')
left outer join cta_cte_hou_imp_aer as ctam on (cta.num_proc_mia=left(ctam.num_proc_Hia,14) and cta.cd_tp_tx=ctam.cd_tp_tx and cta.dc_mia<>ctam.dc_hia and ctam.desp_org_hia='N')
left outer join base_notA_fiscal on (cta.num_nf_mia=nota_fiscal and cta.ref_acesso_nf_mia=ref_acesso and cta.cd_tp_Tx<>'FRT')
where cxa.num_lcto<>'PROVISÓRIO' 
and (ctao.num_proc_mia is null and ctam.num_proc_hia is null) and
convert(datetime, cxa.dt_pgto_rcto_mia, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105)

union

select convert(datetime, cxa.dt_pgto_rcto_him, 105) as DataPgto, cxa.num_proc_him, apelido, nome_tp_Tx, cxa.num_rcb_him, cxa.dc_him, cta.cd_tp_moeda as MoedaCx,cast(cxa.vlr_ref_him as money) as ValorRef, cxa.Par_moeda_him as CXAPAR, cast(cxa.vlr_pgto_rcto_him as money)as ValorPgto, emissao, cta.par_nf_him, cast(cta.vlr_pgto_nf_him as money) as ValorNF from caixa_hou_imp_mar as cxa
inner join cta_cte_hou_imp_mar as cta on (cta.num_proc_him=cxa.num_proc_him and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_him=cxa.dc_him)
inner join tipo_taxa on (cta.cd_tp_tx=tipo_taxa.cd_tp_tx)
inner join pessoa on (cta.cd_cred_dev_him=cd_pes)
left outer join  cta_cte_hou_imp_mar as ctaO on(cta.num_proC_him=ctao.num_proC_him and cta.cd_tp_tx=ctao.cd_tp_Tx and cta.dc_him<>ctao.dc_him and ctao.desp_org_him='N')
left outer join cta_cte_mas_imp_mar as ctam on (left(cta.num_proc_him,14)=ctam.num_proc_mim and cta.cd_tp_tx=ctam.cd_tp_tx and cta.dc_him<>ctam.dc_mim and ctam.desp_org_mim='N')
left outer join base_notA_fiscal on (cta.num_nf_him=nota_fiscal and cta.ref_acesso_nf_him=ref_acesso and cta.cd_tp_Tx<>'FRT')
where cxa.num_lcto<>'PROVISÓRIO' 
and (ctao.num_proc_him is null and ctam.num_proc_mim is null)
and convert(datetime, cxa.dt_pgto_rcto_him, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)

UNION

select convert(datetime, cxa.dt_pgto_rcto_mim, 105) as DataPgto, cxa.num_proc_mim, apelido, nome_tp_Tx, cxa.num_rcb_mim, cxa.dc_mim, cta.cd_tp_moeda as MoedaCx,cast(cxa.vlr_ref_mim as money) as ValorRef, cxa.Par_moeda_mim as CXAPAR, cast(cxa.vlr_pgto_rcto_mim as money)as ValorPgto, emissao, cta.par_nf_mim, cast(cta.vlr_pgto_nf_mim as money) as ValorNF from caixa_mas_imp_mar as cxa
inner join cta_cte_mas_imp_mar as cta on (cta.num_proc_mim=cxa.num_proc_mim and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mim=cxa.dc_mim)
inner join tipo_taxa on (cta.cd_tp_tx=tipo_taxa.cd_tp_tx)
inner join pessoa on (cta.cd_cred_dev_mim=cd_pes)
left outer join  cta_cte_mas_imp_mar as ctaO on(cta.num_proC_mim=ctao.num_proC_mim and cta.cd_tp_tx=ctao.cd_tp_Tx and cta.dc_mim<>ctao.dc_mim and ctao.desp_org_mim='N')
left outer join cta_cte_hou_imp_mar as ctam on (cta.num_proc_mim=left(ctam.num_proc_him,14) and cta.cd_tp_tx=ctam.cd_tp_tx and cta.dc_mim<>ctam.dc_him and ctam.desp_org_him='N')
left outer join base_notA_fiscal on (cta.num_nf_mim=nota_fiscal and cta.ref_acesso_nf_mim=ref_acesso and cta.cd_tp_Tx<>'FRT')
where cxa.num_lcto<>'PROVISÓRIO' 
and (ctao.num_proc_mim is null and ctam.num_proc_him is null) and
convert(datetime, cxa.dt_pgto_rcto_mim, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105)

union

select convert(datetime, cxa.dt_pgto_rcto_HEM, 105) as DataPgto, cxa.num_proc_HEM, apelido, nome_tp_Tx, cxa.num_rcb_HEM, cxa.dc_HEM, cta.cd_tp_moeda as MoedaCx,cast(cxa.vlr_ref_HEM as money) as ValorRef, cxa.Par_moeda_HEM as CXAPAR, cast(cxa.vlr_pgto_rcto_HEM as money)as ValorPgto, emissao, cta.par_nf_HEM, cast(cta.vlr_pgto_nf_HEM as money) as ValorNF from caixa_hou_exp_mar as cxa
inner join cta_cte_hou_exp_mar as cta on (cta.num_proc_HEM=cxa.num_proc_HEM and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_HEM=cxa.dc_HEM)
inner join tipo_taxa on (cta.cd_tp_tx=tipo_taxa.cd_tp_tx)
inner join pessoa on (cta.cd_cred_dev_HEM=cd_pes)
left outer join  cta_cte_hou_exp_mar as ctaO on(cta.num_proC_HEM=ctao.num_proC_HEM and cta.cd_tp_tx=ctao.cd_tp_Tx and cta.dc_HEM<>ctao.dc_HEM and ctao.desp_dst_HEM='N')
left outer join cta_cte_mas_exp_mar as ctam on (left(cta.num_proc_HEM,14)=ctam.num_proc_MEM and cta.cd_tp_tx=ctam.cd_tp_tx and cta.dc_HEM<>ctam.dc_MEM and ctam.desp_dst_MEM='N')
left outer join base_notA_fiscal on (cta.num_nf_HEM=nota_fiscal and cta.ref_acesso_nf_HEM=ref_acesso and cta.cd_tp_Tx<>'FRT')
where cxa.num_lcto<>'PROVISÓRIO' 
and (ctao.num_proc_HEM is null and ctam.num_proc_MEM is null)
and convert(datetime, cxa.dt_pgto_rcto_HEM, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)

UNION

select convert(datetime, cxa.dt_pgto_rcto_MEM, 105) as DataPgto, cxa.num_proc_MEM, apelido, nome_tp_Tx, cxa.num_rcb_MEM, cxa.dc_MEM, cta.cd_tp_moeda as MoedaCx,cast(cxa.vlr_ref_MEM as money) as ValorRef, cxa.Par_moeda_MEM as CXAPAR, cast(cxa.vlr_pgto_rcto_MEM as money)as ValorPgto, emissao, cta.par_nf_MEM, cast(cta.vlr_pgto_nf_MEM as money) as ValorNF from caixa_mas_exp_mar as cxa
inner join cta_cte_mas_exp_mar as cta on (cta.num_proc_MEM=cxa.num_proc_MEM and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_MEM=cxa.dc_MEM)
inner join tipo_taxa on (cta.cd_tp_tx=tipo_taxa.cd_tp_tx)
inner join pessoa on (cta.cd_cred_dev_MEM=cd_pes)
left outer join  cta_cte_mas_exp_mar as ctaO on(cta.num_proC_MEM=ctao.num_proC_MEM and cta.cd_tp_tx=ctao.cd_tp_Tx and cta.dc_MEM<>ctao.dc_MEM and ctao.desp_dst_MEM='N')
left outer join cta_cte_hou_exp_mar as ctam on (cta.num_proc_MEM=left(ctam.num_proc_HEM,14) and cta.cd_tp_tx=ctam.cd_tp_tx and cta.dc_MEM<>ctam.dc_HEM and ctam.desp_dst_HEM='N')
left outer join base_notA_fiscal on (cta.num_nf_MEM=nota_fiscal and cta.ref_acesso_nf_MEM=ref_acesso and cta.cd_tp_Tx<>'FRT')
where cxa.num_lcto<>'PROVISÓRIO' 
and (ctao.num_proc_MEM is null and ctam.num_proc_HEM is null) and
convert(datetime, cxa.dt_pgto_rcto_MEM, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105)

UNION


select convert(datetime, cxa.dt_pgto_rcto_hea, 105) as DataPgto, cxa.num_proc_hea, apelido, nome_tp_Tx, cxa.num_rcb_hea, cxa.dc_hea, cta.cd_tp_moeda as MoedaCx,cast(cxa.vlr_ref_hea as money) as ValorRef, cxa.Par_moeda_hea as CXAPAR, cast(cxa.vlr_pgto_rcto_hea as money)as ValorPgto, emissao, cta.par_nf_hea, cast(cta.vlr_pgto_nf_hea as money) as ValorNF from caixa_hou_exp_aer as cxa
inner join cta_cte_hou_exp_aer as cta on (cta.num_proc_hea=cxa.num_proc_hea and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hea=cxa.dc_hea)
inner join tipo_taxa on (cta.cd_tp_tx=tipo_taxa.cd_tp_tx)
inner join pessoa on (cta.cd_cred_dev_hea=cd_pes)
left outer join  cta_cte_hou_exp_aer as ctaO on(cta.num_proC_hea=ctao.num_proC_hea and cta.cd_tp_tx=ctao.cd_tp_Tx and cta.dc_hea<>ctao.dc_hea and ctao.desp_dst_hea='N')
left outer join cta_cte_mas_exp_aer as ctam on (left(cta.num_proc_hea,14)=ctam.num_proc_mea and cta.cd_tp_tx=ctam.cd_tp_tx and cta.dc_hea<>ctam.dc_mea and ctam.desp_dst_mea='N')
left outer join base_notA_fiscal on (cta.num_nf_hea=nota_fiscal and cta.ref_acesso_nf_hea=ref_acesso and cta.cd_tp_Tx<>'FRT')
where cxa.num_lcto<>'PROVISÓRIO' 
and (ctao.num_proc_hea is null and ctam.num_proc_mea is null)
and convert(datetime, cxa.dt_pgto_rcto_hea, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)

UNION

select convert(datetime, cxa.dt_pgto_rcto_mea, 105) as DataPgto, cxa.num_proc_mea, apelido, nome_tp_Tx, cxa.num_rcb_mea, cxa.dc_mea, cta.cd_tp_moeda as MoedaCx,cast(cxa.vlr_ref_mea as money) as ValorRef, cxa.Par_moeda_mea as CXAPAR, cast(cxa.vlr_pgto_rcto_mea as money)as ValorPgto, emissao, cta.par_nf_mea, cast(cta.vlr_pgto_nf_mea as money) as ValorNF from caixa_mas_exp_aer as cxa
inner join cta_cte_mas_exp_aer as cta on (cta.num_proc_mea=cxa.num_proc_mea and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mea=cxa.dc_mea)
inner join tipo_taxa on (cta.cd_tp_tx=tipo_taxa.cd_tp_tx)
inner join pessoa on (cta.cd_cred_dev_mea=cd_pes)
left outer join  cta_cte_mas_exp_aer as ctaO on(cta.num_proC_mea=ctao.num_proC_mea and cta.cd_tp_tx=ctao.cd_tp_Tx and cta.dc_mea<>ctao.dc_mea and ctao.desp_dst_mea='N')
left outer join cta_cte_hou_exp_aer as ctam on (cta.num_proc_mea=left(ctam.num_proc_hea,14) and cta.cd_tp_tx=ctam.cd_tp_tx and cta.dc_mea<>ctam.dc_hea and ctam.desp_dst_hea='N')
left outer join base_notA_fiscal on (cta.num_nf_mea=nota_fiscal and cta.ref_acesso_nf_mea=ref_acesso and cta.cd_tp_Tx<>'FRT')
where cxa.num_lcto<>'PROVISÓRIO' 
and (ctao.num_proc_mea is null and ctam.num_proc_hea is null) and
convert(datetime, cxa.dt_pgto_rcto_mea, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105)



GO
