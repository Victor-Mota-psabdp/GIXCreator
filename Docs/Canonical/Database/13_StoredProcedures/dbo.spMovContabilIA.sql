SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE spMovContabilIA

			@dataInicial	varchar(10),
			@datafinal	varchar(10)

AS

select convert(datetime, cxa.dt_pgto_rcto_hia, 105) as DataPgto, cxa.num_proc_hia, apelido, nome_tp_Tx, cxa.num_rcb_Hia, cxa.dc_hia, cta.cd_tp_moeda as MoedaCx,cast(cxa.vlr_ref_hia as money) as ValorRef, cxa.Par_moeda_hia as CXAPAR, cast(cxa.vlr_pgto_rcto_hia as money)as ValorPgto, ctaO.cd_tp_moeda as MoedaOPOSC, cast(ctao.vlr_org_hia as money) as ValorOpos, cxao.par_moeda_hia as ParidadeCxOps, cast(cxao.vlr_pgto_rcto_hia as money) as ValorPGOps, convert(datetime, cxao.dt_pgto_rcto_hia, 105) as DtPagtoOpos, ctam.cd_tp_moeda as MoedaMIA, cast(ctam.vlr_org_mia as money) as ValorCtaMia, cxam.par_moeda_mia as ParMIA, convert(datetime, cxam.dt_pgto_rcto_mia, 105) as DtPgtoMIA, cast(cxam.vlr_pgto_rcto_mia as money) as VlrPgtoMIA from caixa_hou_imp_aer as cxa
inner join tipo_taxa on (cxa.cd_tp_Tx=tipo_taxa.cd_tp_Tx)
inner join cta_cte_hou_imp_Aer as Cta on (cta.num_proc_hia = cxa.num_proc_hia and cta.dc_hia = cxa.dc_hia and cta.cd_tp_tx=cxa.cd_tp_Tx)
inner join pessoa on (cta.cd_cred_dev_hia=cd_pes)
left  join cta_cte_hou_imp_aer as CtaO on (cxa.num_proc_hia=ctao.num_proc_hia and cxa.cd_tp_tx=ctao.cd_tp_Tx and cxa.dc_hia<>ctao.dc_hia)
left outer join caixa_hou_imp_Aer as CxaO on (ctao.num_proc_hia=cxao.num_proc_hia and ctao.cd_tp_Tx=cxao.cd_tp_Tx and ctao.dc_hia=cxao.dc_hia and cxao.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxao.dt_pgto_rcto_hia, 105) <= convert(datetime, @datafinal, 105 ) and ctao.desp_org_hia='N') 
left outer join cta_cte_mas_imp_Aer as CtaM on (left(cta.num_proc_hia,14)=ctam.num_proc_mia and cta.cd_tp_Tx=ctam.cd_tp_Tx and cta.dc_hia<>ctam.dc_mia)
left outer join caixa_mas_imp_aer as CxaM on (ctam.num_proc_mia=cxam.num_proc_mia and ctam.cd_tp_tx=cxam.cd_tp_tx and ctam.dc_mia=cxam.dc_mia and cxam.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxam.dt_pgto_rcto_mia, 105) <= convert(datetime, @datafinal, 105) and ctam.desp_org_mia='N')
where cxa.num_lcto <> 'PROVISÓRIO'
and (ctao.vlr_org_hia is not null or ctam.vlr_org_mia is not null) and
convert(datetime, cxa.dt_pgto_rcto_hia, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105)


UNION

select convert(datetime, cxa.dt_pgto_rcto_mia, 105) as DataPgto, cxa.num_proc_mia, apelido, nome_tp_tx, cxa.num_rcb_mia, cxa.dc_mia, cta.cd_tp_moeda as MoedaCx, cast(cxa.vlr_ref_mia as money) as ValorRef, cxa.Par_moeda_mia as CxPAr, cast(cxa.vlr_pgto_rcto_mia as money)as ValorPgto, ctaO.cd_tp_moeda as MoedaOPOSC, cast(ctao.vlr_org_hia as money) as ValorOpos, cxao.par_moeda_hia as ParidadeCxOps, cast(cxao.vlr_pgto_rcto_hia as money) as ValorPGOps, convert(datetime, cxao.dt_pgto_rcto_hia, 105) as DtPagtoOpos, ctam.cd_tp_moeda as MoedaMIA, cast(ctam.vlr_org_mia as money) as ValorCtaMia, cxam.par_moeda_mia as ParMIA, convert(datetime, cxam.dt_pgto_rcto_mia, 105) as DtPgtoMIA, cast(cxam.vlr_pgto_rcto_mia as money) as VlrPgtoMIA from caixa_mas_imp_aer as cxa
inner join tipo_taxa on (cxa.cd_tp_tx=tipo_taxa.cd_tp_tx)
inner join cta_cte_mas_imp_aer as cta on (cta.num_proc_mia=cxa.num_proc_mia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mia=cxa.dc_mia)
inner jOIN pessoa on (cta.cd_cred_dev_mia=cd_peS)
left outer join cta_cte_hou_imp_aer as ctao on (cta.num_proc_mia=left(ctao.num_proc_hia,14) and cta.cd_tp_tx=ctao.cd_tp_tx and cta.dc_mia <> ctao.dc_hia)
left outer join caixa_hou_imp_aer as cxao on (ctao.num_proc_hia=cxao.num_proc_hia and ctao.cd_tp_tx=cxao.cd_tp_tx and ctao.dc_hia=cxao.dc_hia and cxao.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxao.dt_pgto_rcto_hia, 105) <= convert(datetime, @datafinal, 105 ) and ctao.desp_org_hia='N')
left outer join cta_cte_mas_imp_aer as ctaM on (cta.num_proc_mia=ctam.num_proc_mia and cta.cd_tp_tx=ctam.cd_tp_tx and cta.dc_mia<>ctam.dc_mia)
left outer join caixa_mas_imp_aer as CxaM on (ctam.num_proc_mia=cxam.num_proc_mia and ctam.cd_tp_tx=cxam.cd_tp_Tx and ctam.dc_mia=cxam.dc_mia and  cxam.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxam.dt_pgto_rcto_mia, 105) <= convert(datetime, @datafinal, 105) and ctam.desp_org_mia='N') 
where cxa.num_lcto <> 'PROVISÓRIO'
and (ctao.vlr_org_hia is not null or ctam.vlr_org_mia is not null) and
convert(datetime, cxa.dt_pgto_rcto_mia, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105)


UNION

select convert(datetime, cxa.dt_pgto_rcto_him, 105) as DataPgto, cxa.num_proc_him, apelido, nome_tp_Tx, cxa.num_rcb_him, cxa.dc_him, cta.cd_tp_moeda as MoedaCx,cast(cxa.vlr_ref_him as money) as ValorRef, cxa.Par_moeda_him as CXAPAR, cast(cxa.vlr_pgto_rcto_him as money)as ValorPgto, ctaO.cd_tp_moeda as MoedaOPOSC, cast(ctao.vlr_org_him as money) as ValorOpos, cxao.par_moeda_him as ParidadeCxOps, cast(cxao.vlr_pgto_rcto_him as money) as ValorPGOps, convert(datetime, cxao.dt_pgto_rcto_him, 105) as DtPagtoOpos, ctam.cd_tp_moeda as Moedamim, cast(ctam.vlr_org_mim as money) as ValorCtamim, cxam.par_moeda_mim as Parmim, convert(datetime, cxam.dt_pgto_rcto_mim, 105) as DtPgtomim, cast(cxam.vlr_pgto_rcto_mim as money) as VlrPgtomim from caixa_hou_imp_mar as cxa
inner join tipo_taxa on (cxa.cd_tp_Tx=tipo_taxa.cd_tp_Tx)
inner join cta_cte_hou_imp_mar as Cta on (cta.num_proc_him = cxa.num_proc_him and cta.dc_him = cxa.dc_him and cta.cd_tp_tx=cxa.cd_tp_Tx)
inner join pessoa on (cta.cd_cred_dev_him=cd_pes)
left  join cta_cte_hou_imp_mar as CtaO on (cxa.num_proc_him=ctao.num_proc_him and cxa.cd_tp_tx=ctao.cd_tp_Tx and cxa.dc_him<>ctao.dc_him)
left outer join caixa_hou_imp_mar as CxaO on (ctao.num_proc_him=cxao.num_proc_him and ctao.cd_tp_Tx=cxao.cd_tp_Tx and ctao.dc_him=cxao.dc_him and cxao.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxao.dt_pgto_rcto_him, 105) <= convert(datetime, @datafinal, 105 ) and ctao.desp_org_him='N') 
left outer join cta_cte_mas_imp_mar as CtaM on (left(cta.num_proc_him,14)=ctam.num_proc_mim and cta.cd_tp_Tx=ctam.cd_tp_Tx and cta.dc_him<>ctam.dc_mim)
left outer join caixa_mas_imp_mar as CxaM on (ctam.num_proc_mim=cxam.num_proc_mim and ctam.cd_tp_tx=cxam.cd_tp_tx and ctam.dc_mim=cxam.dc_mim and cxam.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxam.dt_pgto_rcto_mim, 105) <= convert(datetime, @datafinal, 105) and ctam.desp_org_mim='N')
where cxa.num_lcto <> 'PROVISÓRIO'
and (ctao.vlr_org_him is not null or ctam.vlr_org_mim is not null) and
convert(datetime, cxa.dt_pgto_rcto_him, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105)


UNION

select convert(datetime, cxa.dt_pgto_rcto_mim, 105) as DataPgto, cxa.num_proc_mim, apelido, nome_tp_tx, cxa.num_rcb_mim, cxa.dc_mim, cta.cd_tp_moeda as MoedaCx, cast(cxa.vlr_ref_mim as money) as ValorRef, cxa.Par_moeda_mim as CxPAr, cast(cxa.vlr_pgto_rcto_mim as money)as ValorPgto, ctaO.cd_tp_moeda as MoedaOPOSC, cast(ctao.vlr_org_him as money) as ValorOpos, cxao.par_moeda_him as ParidadeCxOps, cast(cxao.vlr_pgto_rcto_him as money) as ValorPGOps, convert(datetime, cxao.dt_pgto_rcto_him, 105) as DtPagtoOpos, ctam.cd_tp_moeda as Moedamim, cast(ctam.vlr_org_mim as money) as ValorCtamim, cxam.par_moeda_mim as Parmim, convert(datetime, cxam.dt_pgto_rcto_mim, 105) as DtPgtomim, cast(cxam.vlr_pgto_rcto_mim as money) as VlrPgtomim from caixa_mas_imp_mar as cxa
inner join tipo_taxa on (cxa.cd_tp_tx=tipo_taxa.cd_tp_tx)
inner join cta_cte_mas_imp_mar as cta on (cta.num_proc_mim=cxa.num_proc_mim and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mim=cxa.dc_mim)
inner jOIN pessoa on (cta.cd_cred_dev_mim=cd_peS)
left outer join cta_cte_hou_imp_mar as ctao on (cta.num_proc_mim=left(ctao.num_proc_him,14) and cta.cd_tp_tx=ctao.cd_tp_tx and cta.dc_mim <> ctao.dc_him)
left outer join caixa_hou_imp_mar as cxao on (ctao.num_proc_him=cxao.num_proc_him and ctao.cd_tp_tx=cxao.cd_tp_tx and ctao.dc_him=cxao.dc_him and cxao.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxao.dt_pgto_rcto_him, 105) <= convert(datetime, @datafinal, 105 ) and ctao.desp_org_him='N')
left outer join cta_cte_mas_imp_mar as ctaM on (cta.num_proc_mim=ctam.num_proc_mim and cta.cd_tp_tx=ctam.cd_tp_tx and cta.dc_mim<>ctam.dc_mim)
left outer join caixa_mas_imp_mar as CxaM on (ctam.num_proc_mim=cxam.num_proc_mim and ctam.cd_tp_tx=cxam.cd_tp_Tx and ctam.dc_mim=cxam.dc_mim and  cxam.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxam.dt_pgto_rcto_mim, 105) <= convert(datetime, @datafinal, 105) and ctam.desp_org_mim='N') 
where cxa.num_lcto <> 'PROVISÓRIO'
and (ctao.vlr_org_him is not null or ctam.vlr_org_mim is not null) and
convert(datetime, cxa.dt_pgto_rcto_mim, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105)

UNION

select convert(datetime, cxa.dt_pgto_rcto_HEM, 105) as DataPgto, cxa.num_proc_HEM, apelido, nome_tp_Tx, cxa.num_rcb_HEM, cxa.dc_HEM, cta.cd_tp_moeda as MoedaCx,cast(cxa.vlr_ref_HEM as money) as ValorRef, cxa.Par_moeda_HEM as CXAPAR, cast(cxa.vlr_pgto_rcto_HEM as money)as ValorPgto, ctaO.cd_tp_moeda as MoedaOPOSC, cast(ctao.vlr_org_HEM as money) as ValorOpos, cxao.par_moeda_HEM as ParidadeCxOps, cast(cxao.vlr_pgto_rcto_HEM as money) as ValorPGOps, convert(datetime, cxao.dt_pgto_rcto_HEM, 105) as DtPagtoOpos, ctam.cd_tp_moeda as MoedaMEM, cast(ctam.vlr_org_MEM as money) as ValorCtaMEM, cxam.par_moeda_MEM as ParMEM, convert(datetime, cxam.dt_pgto_rcto_MEM, 105) as DtPgtoMEM, cast(cxam.vlr_pgto_rcto_MEM as money) as VlrPgtoMEM from caixa_hou_exp_mar as cxa
inner join tipo_taxa on (cxa.cd_tp_Tx=tipo_taxa.cd_tp_Tx)
inner join cta_cte_hou_exp_mar as Cta on (cta.num_proc_HEM = cxa.num_proc_HEM and cta.dc_HEM = cxa.dc_HEM and cta.cd_tp_tx=cxa.cd_tp_Tx)
inner join pessoa on (cta.cd_cred_dev_HEM=cd_pes)
left  join cta_cte_hou_exp_mar as CtaO on (cxa.num_proc_HEM=ctao.num_proc_HEM and cxa.cd_tp_tx=ctao.cd_tp_Tx and cxa.dc_HEM<>ctao.dc_HEM)
left outer join caixa_hou_exp_mar as CxaO on (ctao.num_proc_HEM=cxao.num_proc_HEM and ctao.cd_tp_Tx=cxao.cd_tp_Tx and ctao.dc_HEM=cxao.dc_HEM and cxao.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxao.dt_pgto_rcto_HEM, 105) <= convert(datetime, @datafinal, 105 ) and ctao.desp_dst_hem='N') 
left outer join cta_cte_mas_exp_mar as CtaM on (left(cta.num_proc_HEM,14)=ctam.num_proc_MEM and cta.cd_tp_Tx=ctam.cd_tp_Tx and cta.dc_HEM<>ctam.dc_MEM)
left outer join caixa_mas_exp_mar as CxaM on (ctam.num_proc_MEM=cxam.num_proc_MEM and ctam.cd_tp_tx=cxam.cd_tp_tx and ctam.dc_MEM=cxam.dc_MEM and cxam.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxam.dt_pgto_rcto_MEM, 105) <= convert(datetime, @datafinal, 105) and ctam.desp_dst_Mem='N')
where cxa.num_lcto <> 'PROVISÓRIO'
and (ctao.vlr_org_HEM is not null or ctam.vlr_org_MEM is not null) and
convert(datetime, cxa.dt_pgto_rcto_HEM, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105)


UNION

select convert(datetime, cxa.dt_pgto_rcto_MEM, 105) as DataPgto, cxa.num_proc_MEM, apelido, nome_tp_tx, cxa.num_rcb_MEM, cxa.dc_MEM, cta.cd_tp_moeda as MoedaCx, cast(cxa.vlr_ref_MEM as money) as ValorRef, cxa.Par_moeda_MEM as CxPAr, cast(cxa.vlr_pgto_rcto_MEM as money)as ValorPgto, ctaO.cd_tp_moeda as MoedaOPOSC, cast(ctao.vlr_org_HEM as money) as ValorOpos, cxao.par_moeda_HEM as ParidadeCxOps, cast(cxao.vlr_pgto_rcto_HEM as money) as ValorPGOps, convert(datetime, cxao.dt_pgto_rcto_HEM, 105) as DtPagtoOpos, ctam.cd_tp_moeda as MoedaMEM, cast(ctam.vlr_org_MEM as money) as ValorCtaMEM, cxam.par_moeda_MEM as ParMEM, convert(datetime, cxam.dt_pgto_rcto_MEM, 105) as DtPgtoMEM, cast(cxam.vlr_pgto_rcto_MEM as money) as VlrPgtoMEM from caixa_mas_exp_mar as cxa
inner join tipo_taxa on (cxa.cd_tp_tx=tipo_taxa.cd_tp_tx)
inner join cta_cte_mas_exp_mar as cta on (cta.num_proc_MEM=cxa.num_proc_MEM and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_MEM=cxa.dc_MEM)
inner jOIN pessoa on (cta.cd_cred_dev_MEM=cd_peS)
left outer join cta_cte_hou_exp_mar as ctao on (cta.num_proc_MEM=left(ctao.num_proc_HEM,14) and cta.cd_tp_tx=ctao.cd_tp_tx and cta.dc_MEM <> ctao.dc_HEM)
left outer join caixa_hou_exp_mar as cxao on (ctao.num_proc_HEM=cxao.num_proc_HEM and ctao.cd_tp_tx=cxao.cd_tp_tx and ctao.dc_HEM=cxao.dc_HEM and cxao.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxao.dt_pgto_rcto_HEM, 105) <= convert(datetime, @datafinal, 105 ) and ctao.desp_dst_hem='N')
left outer join cta_cte_mas_exp_mar as ctaM on (cta.num_proc_MEM=ctam.num_proc_MEM and cta.cd_tp_tx=ctam.cd_tp_tx and cta.dc_MEM<>ctam.dc_MEM)
left outer join caixa_mas_exp_mar as CxaM on (ctam.num_proc_MEM=cxam.num_proc_MEM and ctam.cd_tp_tx=cxam.cd_tp_Tx and ctam.dc_MEM=cxam.dc_MEM and  cxam.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxam.dt_pgto_rcto_MEM, 105) <= convert(datetime, @datafinal, 105) and ctam.desp_dst_Mem='N') 
where cxa.num_lcto <> 'PROVISÓRIO'
and (ctao.vlr_org_HEM is not null or ctam.vlr_org_MEM is not null) and
convert(datetime, cxa.dt_pgto_rcto_MEM, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105)

union

select convert(datetime, cxa.dt_pgto_rcto_HEA, 105) as DataPgto, cxa.num_proc_HEA, apelido, nome_tp_Tx, cxa.num_rcb_HEA, cxa.dc_HEA, cta.cd_tp_moeda as MoedaCx,cast(cxa.vlr_ref_HEA as money) as ValorRef, cxa.Par_moeda_HEA as CXAPAR, cast(cxa.vlr_pgto_rcto_HEA as money)as ValorPgto, ctaO.cd_tp_moeda as MoedaOPOSC, cast(ctao.vlr_org_HEA as money) as ValorOpos, cxao.par_moeda_HEA as ParidadeCxOps, cast(cxao.vlr_pgto_rcto_HEA as money) as ValorPGOps, convert(datetime, cxao.dt_pgto_rcto_HEA, 105) as DtPagtoOpos, ctam.cd_tp_moeda as MoedaMEA, cast(ctam.vlr_org_MEA as money) as ValorCtaMEA, cxam.par_moeda_MEA as ParMEA, convert(datetime, cxam.dt_pgto_rcto_MEA, 105) as DtPgtoMEA, cast(cxam.vlr_pgto_rcto_MEA as money) as VlrPgtoMEA from caixa_hou_exp_aer as cxa
inner join tipo_taxa on (cxa.cd_tp_Tx=tipo_taxa.cd_tp_Tx)
inner join cta_cte_hou_exp_aer as Cta on (cta.num_proc_HEA = cxa.num_proc_HEA and cta.dc_HEA = cxa.dc_HEA and cta.cd_tp_tx=cxa.cd_tp_Tx)
inner join pessoa on (cta.cd_cred_dev_HEA=cd_pes)
left  join cta_cte_hou_exp_aer as CtaO on (cxa.num_proc_HEA=ctao.num_proc_HEA and cxa.cd_tp_tx=ctao.cd_tp_Tx and cxa.dc_HEA<>ctao.dc_HEA)
left outer join caixa_hou_exp_aer as CxaO on (ctao.num_proc_HEA=cxao.num_proc_HEA and ctao.cd_tp_Tx=cxao.cd_tp_Tx and ctao.dc_HEA=cxao.dc_HEA and cxao.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxao.dt_pgto_rcto_HEA, 105) <= convert(datetime, @datafinal, 105 ) and ctao.desp_dst_HEA='N') 
left outer join cta_cte_mas_exp_aer as CtaM on (left(cta.num_proc_HEA,14)=ctam.num_proc_MEA and cta.cd_tp_Tx=ctam.cd_tp_Tx and cta.dc_HEA<>ctam.dc_MEA)
left outer join caixa_mas_exp_aer as CxaM on (ctam.num_proc_MEA=cxam.num_proc_MEA and ctam.cd_tp_tx=cxam.cd_tp_tx and ctam.dc_MEA=cxam.dc_MEA and cxam.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxam.dt_pgto_rcto_MEA, 105) <= convert(datetime, @datafinal, 105) and ctam.desp_dst_MEA='N')
where cxa.num_lcto <> 'PROVISÓRIO'
and (ctao.vlr_org_HEA is not null or ctam.vlr_org_MEA is not null) and
convert(datetime, cxa.dt_pgto_rcto_HEA, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105)


UNION

select convert(datetime, cxa.dt_pgto_rcto_MEA, 105) as DataPgto, cxa.num_proc_MEA, apelido, nome_tp_tx, cxa.num_rcb_MEA, cxa.dc_MEA, cta.cd_tp_moeda as MoedaCx, cast(cxa.vlr_ref_MEA as money) as ValorRef, cxa.Par_moeda_MEA as CxPAr, cast(cxa.vlr_pgto_rcto_MEA as money)as ValorPgto, ctaO.cd_tp_moeda as MoedaOPOSC, cast(ctao.vlr_org_HEA as money) as ValorOpos, cxao.par_moeda_HEA as ParidadeCxOps, cast(cxao.vlr_pgto_rcto_HEA as money) as ValorPGOps, convert(datetime, cxao.dt_pgto_rcto_HEA, 105) as DtPagtoOpos, ctam.cd_tp_moeda as MoedaMEA, cast(ctam.vlr_org_MEA as money) as ValorCtaMEA, cxam.par_moeda_MEA as ParMEA, convert(datetime, cxam.dt_pgto_rcto_MEA, 105) as DtPgtoMEA, cast(cxam.vlr_pgto_rcto_MEA as money) as VlrPgtoMEA from caixa_mas_exp_aer as cxa
inner join tipo_taxa on (cxa.cd_tp_tx=tipo_taxa.cd_tp_tx)
inner join cta_cte_mas_exp_aer as cta on (cta.num_proc_MEA=cxa.num_proc_MEA and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_MEA=cxa.dc_MEA)
inner jOIN pessoa on (cta.cd_cred_dev_MEA=cd_peS)
left outer join cta_cte_hou_exp_aer as ctao on (cta.num_proc_MEA=left(ctao.num_proc_HEA,14) and cta.cd_tp_tx=ctao.cd_tp_tx and cta.dc_MEA <> ctao.dc_HEA)
left outer join caixa_hou_exp_aer as cxao on (ctao.num_proc_HEA=cxao.num_proc_HEA and ctao.cd_tp_tx=cxao.cd_tp_tx and ctao.dc_HEA=cxao.dc_HEA and cxao.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxao.dt_pgto_rcto_HEA, 105) <= convert(datetime, @datafinal, 105 ) and ctao.desp_dst_HEA='N')
left outer join cta_cte_mas_exp_aer as ctaM on (cta.num_proc_MEA=ctam.num_proc_MEA and cta.cd_tp_tx=ctam.cd_tp_tx and cta.dc_MEA<>ctam.dc_MEA)
left outer join caixa_mas_exp_aer as CxaM on (ctam.num_proc_MEA=cxam.num_proc_MEA and ctam.cd_tp_tx=cxam.cd_tp_Tx and ctam.dc_MEA=cxam.dc_MEA and  cxam.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxam.dt_pgto_rcto_MEA, 105) <= convert(datetime, @datafinal, 105) and ctam.desp_dst_MEA='N') 
where cxa.num_lcto <> 'PROVISÓRIO'
and (ctao.vlr_org_HEA is not null or ctam.vlr_org_MEA is not null) and
convert(datetime, cxa.dt_pgto_rcto_MEA, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105)





GO
