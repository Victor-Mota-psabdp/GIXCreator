SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE      Procedure spContNfAberto

			@DataInicial 	varchar(10),
			@DataFinal	varchar(10)

AS

select convert(datetime, cta.dt_ins_hea, 105) as Insercao, cta.par_nf_hea, cta.num_proc_hea, apelido,nome_tp_tx, cta.dc_hea, cta.cd_tp_moeda as MoedaCta, cast(cta.vlr_org_hea as Money) as ValorCta, emissao, nota_fiscal, mas.vlr_org_mea, ctao.vlr_org_hea, par.par_moeda  from Cta_ctE_hou_exp_aer as Cta
inner join tipo_taxa on (tipo_taxa.cd_tp_tx=cta.cd_tp_tx)
inner join pessoa on (cd_pes=cta.cd_cred_dev_hea)
left outer join caixa_hou_exp_aer as cxa on (cta.num_proc_hea=cxa.num_proc_hea and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hea=cxa.dc_hea and cxa.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxa.dt_pgto_rcto_hea, 105)<=convert(datetime, @datafinal, 105))
left outer join cta_cte_hou_exp_aer as ctao on (cta.num_proc_hea=ctao.num_proc_hea and cta.cd_tp_tx=ctao.cd_tp_tx and cta.dc_hea<>ctao.dc_hea and ctao.desp_dst_hea='N')
left outer join base_nota_fiscal on (cta.num_nf_hea=nota_fiscal and cta.ref_acesso_nf_hea=ref_acesso)
left outer join cta_ctE_mas_exp_aer as mas on (left(cta.num_proc_hea, 14)=mas.num_proc_mea and cta.cd_tp_tx=mas.cd_tp_tx and cta.dc_hea <> mas.dc_Mea and mas.desp_dst_mea='N')
left outer join paridade as Par on (cta.dt_ins_hea=dt_par and cta.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC')
where cxa.vlr_ref_hea is  null
and ctao.vlr_org_hea is null and  mas.vlr_org_mea is null
and convert(datetime, cta.dt_ins_hea, 105) between
convert(datetime, @dataInicial, 105) and convert(datetime, @datafinal, 105) and
cta.desp_dst_hea='N' and
cta.num_proc_hea not like 'EAJOB%'


union


select convert(datetime, cta.dt_ins_mea, 105) as Insercao, cta.par_nf_mea, cta.num_proc_mea, apelido,nome_tp_tx, cta.dc_mea, cta.cd_tp_moeda as MoedaCta, cast(cta.vlr_org_mea as Money) as ValorCta, emissao, nota_fiscal, mas.vlr_org_hea, ctao.vlr_org_mea, par.par_moeda  from Cta_ctE_mas_exp_aer as Cta
inner join tipo_taxa on (tipo_taxa.cd_tp_tx=cta.cd_tp_tx)
inner join pessoa on (cd_pes=cta.cd_cred_dev_mea)
left outer join caixa_mas_exp_aer as cxa on (cta.num_proc_mea=cxa.num_proc_mea and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mea=cxa.dc_mea and cxa.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxa.dt_pgto_rcto_mea, 105)<=convert(datetime, @datafinal, 105))
left outer join cta_cte_mas_exp_aer as ctao on (cta.num_proc_mea=ctao.num_proc_mea and cta.cd_tp_tx=ctao.cd_tp_tx and cta.dc_mea<>ctao.dc_mea and ctao.desp_dst_mea='N')
left outer join base_nota_fiscal on (cta.num_nf_mea=nota_fiscal and cta.ref_acesso_nf_mea=ref_acesso)
left outer join cta_ctE_hou_exp_aer as mas on (cta.num_proc_mea=left(mas.num_proc_hea,14) and cta.cd_tp_tx=mas.cd_tp_tx and cta.dc_mea <> mas.dc_hea and mas.desp_dst_hea='N')
left outer join paridade as Par on (cta.dt_ins_mea=dt_par and cta.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC')
where cxa.vlr_ref_mea is  null
and ctao.vlr_org_mea is null and  mas.vlr_org_hea is null
and convert(datetime, cta.dt_ins_mea, 105) between
convert(datetime, @dataInicial, 105) and convert(datetime, @datafinal, 105)
and cta.desp_dst_mea='N' 

union


select convert(datetime, cta.dt_ins_hia, 105) as Insercao, cta.par_nf_hia, cta.num_proc_hia, apelido,nome_tp_tx, cta.dc_hia, cta.cd_tp_moeda as MoedaCta, cast(cta.vlr_org_hia as Money) as ValorCta, emissao, nota_fiscal, mas.vlr_org_mia, ctao.vlr_org_hia,par.par_moeda  from Cta_ctE_hou_imp_aer as Cta
inner join tipo_taxa on (tipo_taxa.cd_tp_tx=cta.cd_tp_tx)
inner join pessoa on (cd_pes=cta.cd_cred_dev_hia)
left outer join caixa_hou_imp_aer as cxa on (cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia and cxa.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxa.dt_pgto_rcto_hia, 105)<=convert(datetime, @datafinal, 105))
left outer join cta_cte_hou_imp_aer as ctao on (cta.num_proc_hia=ctao.num_proc_hia and cta.cd_tp_tx=ctao.cd_tp_tx and cta.dc_hia<>ctao.dc_hia and ctao.desp_org_hia='N')
left outer join base_nota_fiscal on (cta.num_nf_hia=nota_fiscal and cta.ref_acesso_nf_hia=ref_acesso)
left outer join cta_ctE_mas_imp_aer as mas on (left(cta.num_proc_hia, 14)=mas.num_proc_mia and cta.cd_tp_tx=mas.cd_tp_tx and cta.dc_hia <> mas.dc_mia and mas.desp_org_mia='N')
left outer join paridade as Par on (cta.dt_ins_hia=dt_par and cta.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC')
where cxa.vlr_ref_hia is  null
and ctao.vlr_org_hia is null and  mas.vlr_org_mia is null
and convert(datetime, cta.dt_ins_hia, 105) between
convert(datetime, @dataInicial, 105) and convert(datetime, @datafinal, 105) and
cta.desp_org_hia='N'
and left(cta.num_proc_hia, 5) <> 'IAJOB'

union


select convert(datetime, cta.dt_ins_mia, 105)as insercao, cta.par_nf_mia, cta.num_proc_mia, apelido,nome_tp_tx, cta.dc_mia, cta.cd_tp_moeda as MoedaCta, cast(cta.vlr_org_mia as Money) as ValorCta, emissao, nota_fiscal, mas.vlr_org_hia, ctao.vlr_org_mia, par.par_moeda  from Cta_ctE_mas_imp_aer as Cta
inner join tipo_taxa on (tipo_taxa.cd_tp_tx=cta.cd_tp_tx)
inner join pessoa on (cd_pes=cta.cd_cred_dev_mia)
left outer join caixa_mas_imp_aer as cxa on (cta.num_proc_mia=cxa.num_proc_mia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mia=cxa.dc_mia and cxa.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxa.dt_pgto_rcto_mia, 105)<=convert(datetime, @datafinal, 105))
left outer join cta_cte_mas_imp_aer as ctao on (cta.num_proc_mia=ctao.num_proc_mia and cta.cd_tp_tx=ctao.cd_tp_tx and cta.dc_mia<>ctao.dc_mia and ctao.desp_org_mia='N')
left outer join base_nota_fiscal on (cta.num_nf_mia=nota_fiscal and cta.ref_acesso_nf_mia=ref_acesso)
left outer join cta_ctE_hou_imp_aer as mas on (cta.num_proc_mia=left(mas.num_proc_hia,14) and cta.cd_tp_tx=mas.cd_tp_tx and cta.dc_mia <> mas.dc_hia and mas.desp_org_hia='N')
left outer join paridade as Par on (cta.dt_ins_mia=dt_par and cta.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC')
where cxa.vlr_ref_mia is  null
and ctao.vlr_org_mia is null and  mas.vlr_org_hia is null
and convert(datetime, cta.dt_ins_mia, 105) between
convert(datetime, @dataInicial, 105) and convert(datetime, @datafinal, 105)
and cta.desp_org_mia='N' 


union

select convert(datetime, cta.dt_ins_hem, 105) as Insercao, cta.par_nf_hem, cta.num_proc_hem, apelido,nome_tp_tx, cta.dc_hem, cta.cd_tp_moeda as MoedaCta, cast(cta.vlr_org_hem as Money) as ValorCta, emissao, nota_fiscal, mas.vlr_org_mem, ctao.vlr_org_hem, par.par_moeda  from Cta_ctE_hou_exp_mar as Cta
inner join tipo_taxa on (tipo_taxa.cd_tp_tx=cta.cd_tp_tx)
inner join pessoa on (cd_pes=cta.cd_cred_dev_hem)
left outer join caixa_hou_exp_mar as cxa on (cta.num_proc_hem=cxa.num_proc_hem and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hem=cxa.dc_hem and cxa.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxa.dt_pgto_rcto_hem, 105)<=convert(datetime, @datafinal, 105))
left outer join cta_cte_hou_exp_mar as ctao on (cta.num_proc_hem=ctao.num_proc_hem and cta.cd_tp_tx=ctao.cd_tp_tx and cta.dc_hem<>ctao.dc_hem and ctao.desp_dst_hem='N')
left outer join base_nota_fiscal on (cta.num_nf_hem=nota_fiscal and cta.ref_acesso_nf_hem=ref_acesso)
left outer join cta_ctE_mas_exp_mar as mas on (left(cta.num_proc_hem, 14)=mas.num_proc_mem and cta.cd_tp_tx=mas.cd_tp_tx and cta.dc_hem <> mas.dc_mem and mas.desp_dst_mem='N')
left outer join paridade as Par on (cta.dt_ins_hem=dt_par and cta.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC')
where cxa.vlr_ref_hem is  null
and ctao.vlr_org_hem is null and  mas.vlr_org_mem is null
and convert(datetime, cta.dt_ins_hem, 105) between
convert(datetime, @dataInicial, 105) and convert(datetime, @datafinal, 105) and
cta.desp_dst_hem='N' and
left(cta.num_proC_hem,5) <> 'EMJOB'



union


select convert(datetime, cta.dt_ins_mem, 105) as Insercao, cta.par_nf_mem, cta.num_proc_mem, apelido,nome_tp_tx, cta.dc_mem, cta.cd_tp_moeda as MoedaCta, cast(cta.vlr_org_mem as Money) as ValorCta, emissao, nota_fiscal, mas.vlr_org_hem, ctao.vlr_org_mem,par.par_moeda  from Cta_ctE_mas_exp_mar as Cta
inner join tipo_taxa on (tipo_taxa.cd_tp_tx=cta.cd_tp_tx)
inner join pessoa on (cd_pes=cta.cd_cred_dev_mem)
left outer join caixa_mas_exp_mar as cxa on (cta.num_proc_mem=cxa.num_proc_mem and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mem=cxa.dc_mem and cxa.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxa.dt_pgto_rcto_mem, 105)<=convert(datetime, @datafinal, 105))
left outer join cta_cte_mas_exp_mar as ctao on (cta.num_proc_mem=ctao.num_proc_mem and cta.cd_tp_tx=ctao.cd_tp_tx and cta.dc_mem<>ctao.dc_mem and ctao.desp_dst_mem='N')
left outer join base_nota_fiscal on (cta.num_nf_mem=nota_fiscal and cta.ref_acesso_nf_mem=ref_acesso)
left outer join cta_ctE_hou_exp_mar as mas on (cta.num_proc_mem=left(mas.num_proc_hem,14) and cta.cd_tp_tx=mas.cd_tp_tx and cta.dc_mem <> mas.dc_hem and mas.desp_dst_hem='N')
left outer join paridade as Par on (cta.dt_ins_mem=dt_par and cta.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC')
where cxa.vlr_ref_mem is  null
and ctao.vlr_org_mem is null and  mas.vlr_org_hem is null
and convert(datetime, cta.dt_ins_mem, 105) between
convert(datetime, @dataInicial, 105) and convert(datetime, @datafinal, 105)
and cta.desp_dst_mem='N'


union


select convert(datetime, cta.dt_ins_him, 105) as Insercao, cta.par_nf_him, cta.num_proc_him, apelido,nome_tp_tx, cta.dc_him, cta.cd_tp_moeda as MoedaCta, cast(cta.vlr_org_him as Money) as ValorCta, emissao, nota_fiscal, mas.vlr_org_mim, ctao.vlr_org_him, par.par_moeda  from Cta_ctE_hou_imp_mar as Cta
inner join tipo_taxa on (tipo_taxa.cd_tp_tx=cta.cd_tp_tx)
inner join pessoa on (cd_pes=cta.cd_cred_dev_him)
left outer join caixa_hou_imp_mar as cxa on (cta.num_proc_him=cxa.num_proc_him and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_him=cxa.dc_him and cxa.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxa.dt_pgto_rcto_him, 105)<=convert(datetime, @datafinal, 105))
left outer join cta_cte_hou_imp_mar as ctao on (cta.num_proc_him=ctao.num_proc_him and cta.cd_tp_tx=ctao.cd_tp_tx and cta.dc_him<>ctao.dc_him and ctao.desp_org_him='N')
left outer join base_nota_fiscal on (cta.num_nf_him=nota_fiscal and cta.ref_acesso_nf_him=ref_acesso)
left outer join cta_ctE_mas_imp_mar as mas on (left(cta.num_proc_him, 14)=mas.num_proc_mim and cta.cd_tp_tx=mas.cd_tp_tx and cta.dc_him <> mas.dc_mim and mas.desp_org_mim='N')
left outer join paridade as Par on (cta.dt_ins_him=dt_par and cta.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC')
where cxa.vlr_ref_him is  null
and ctao.vlr_org_him is null and  mas.vlr_org_mim is null
and convert(datetime, cta.dt_ins_him, 105) between
convert(datetime, @dataInicial, 105) and convert(datetime, @datafinal, 105) and
cta.desp_org_him='N' and
left(cta.num_proc_him,5) <> 'IMJOB'


union


select convert(datetime, cta.dt_ins_mim, 105) as Insercao, cta.par_nf_mim, cta.num_proc_mim, apelido,nome_tp_tx, cta.dc_mim, cta.cd_tp_moeda as MoedaCta, cast(cta.vlr_org_mim as Money) as ValorCta, emissao, nota_fiscal, mas.vlr_org_him, ctao.vlr_org_mim, par.par_moeda  from Cta_ctE_mas_imp_mar as Cta
inner join tipo_taxa on (tipo_taxa.cd_tp_tx=cta.cd_tp_tx)
inner join pessoa on (cd_pes=cta.cd_cred_dev_mim)
left outer join caixa_mas_imp_mar as cxa on (cta.num_proc_mim=cxa.num_proc_mim and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mim=cxa.dc_mim and cxa.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxa.dt_pgto_rcto_mim, 105)<=convert(datetime, @datafinal, 105))
left outer join cta_cte_mas_imp_mar as ctao on (cta.num_proc_mim=ctao.num_proc_mim and cta.cd_tp_tx=ctao.cd_tp_tx and cta.dc_mim<>ctao.dc_mim and ctao.desp_org_mim='N')
left outer join base_nota_fiscal on (cta.num_nf_mim=nota_fiscal and cta.ref_acesso_nf_mim=ref_acesso)
left outer join cta_ctE_hou_imp_mar as mas on (cta.num_proc_mim=left(mas.num_proc_him,14) and cta.cd_tp_tx=mas.cd_tp_tx and cta.dc_mim <> mas.dc_him and mas.desp_org_him='N')
left outer join paridade as Par on (cta.dt_ins_mim=dt_par and cta.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC')
where cxa.vlr_ref_mim is  null
and ctao.vlr_org_mim is null and  mas.vlr_org_him is null
and convert(datetime, cta.dt_ins_mim, 105) between
convert(datetime, @dataInicial, 105) and convert(datetime, @datafinal, 105)
and cta.desp_org_mim='N'





GO
