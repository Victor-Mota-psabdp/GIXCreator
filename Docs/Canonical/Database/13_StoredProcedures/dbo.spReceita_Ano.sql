SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   procedure spReceita_Ano 

as

select 'IA' Modal, nome_tp_tx,apelido,sum(dbo.valor(vlr_pgto_nf_hia,dc_hia)) Valor,month(emissao) Mes from cta_ctE_hou_imp_aer cta
inner join base_nota_fiscal nf on nf.notA_fiscal=num_nf_hia and ref_acesso_nf_hia=ref_acesso
inner join tipo_taxa tt on tt.cd_tp_Tx=cta.cd_tp_Tx
inner join house_imp_aer hou on hou.num_proc_hia=cta.num_proc_hia
inner join pessoa pp on pp.cd_pes=cd_import_hia
where 
emissao between convert(datetime, '01/01/2004',105) and convert(datetime, '31/12/2004',105)
group by nome_tp_tx,apelido,month(emissao)


union all

select 'IA' Modal, nome_tp_tx,apelido,sum(dbo.valor(vlr_pgto_nf_mia,dc_mia)) Valor,month(emissao) Mes from cta_ctE_mas_imp_aer cta
inner join base_nota_fiscal nf on nf.notA_fiscal=num_nf_mia and ref_acesso_nf_mia=ref_acesso
inner join tipo_taxa tt on tt.cd_tp_Tx=cta.cd_tp_Tx
inner join house_imp_aer mas on mas.num_proc_mia=cta.num_proc_mia
inner join pessoa pp on pp.cd_pes=cd_import_hia
where emissao between convert(datetime, '01/01/2004',105) and convert(datetime, '31/12/2004',105)
group by nome_tp_tx,apelido,month(emissao)

union

select 'EA' Modal, nome_tp_tx,apelido,sum(dbo.valor(vlr_pgto_nf_hea,dc_hea)) Valor,month(emissao) Mes from cta_ctE_hou_exp_aer cta
inner join base_nota_fiscal nf on nf.notA_fiscal=num_nf_hea and ref_acesso_nf_hea=ref_acesso
inner join tipo_taxa tt on tt.cd_tp_Tx=cta.cd_tp_Tx
inner join house_exp_aer hou on hou.num_proc_hea=cta.num_proc_hea
inner join pessoa pp on pp.cd_pes=cd_export_hea
where 
emissao between convert(datetime, '01/01/2004',105) and convert(datetime, '31/12/2004',105)
group by nome_tp_tx,apelido,month(emissao)


union all

select 'EA' Modal, nome_tp_tx,apelido,sum(dbo.valor(vlr_pgto_nf_mea,dc_mea)) Valor,month(emissao) Mes from cta_ctE_mas_exp_aer cta
inner join base_nota_fiscal nf on nf.notA_fiscal=num_nf_mea and ref_acesso_nf_mea=ref_acesso
inner join tipo_taxa tt on tt.cd_tp_Tx=cta.cd_tp_Tx
inner join house_exp_aer mas on mas.num_proc_mea=cta.num_proc_mea
inner join pessoa pp on pp.cd_pes=cd_export_hea
where emissao between convert(datetime, '01/01/2004',105) and convert(datetime, '31/12/2004',105)
group by nome_tp_tx,apelido,month(emissao)

union all

select 'IM' Modal, nome_tp_tx,apelido,sum(dbo.valor(vlr_pgto_nf_him,dc_him)) Valor,month(emissao) Mes from cta_ctE_hou_imp_mar cta
inner join base_nota_fiscal nf on nf.notA_fiscal=num_nf_him and ref_acesso_nf_him=ref_acesso
inner join tipo_taxa tt on tt.cd_tp_Tx=cta.cd_tp_Tx
inner join house_imp_mar hou on hou.num_proc_him=cta.num_proc_him
inner join pessoa pp on pp.cd_pes=cd_import_him
where 
emissao between convert(datetime, '01/01/2004',105) and convert(datetime, '31/12/2004',105)
group by nome_tp_tx,apelido,month(emissao)


union all

select 'IM' Modal, nome_tp_tx,apelido,sum(dbo.valor(vlr_pgto_nf_mim,dc_mim)) Valor,month(emissao) Mes from cta_ctE_mas_imp_mar cta
inner join base_nota_fiscal nf on nf.notA_fiscal=num_nf_mim and ref_acesso_nf_mim=ref_acesso
inner join tipo_taxa tt on tt.cd_tp_Tx=cta.cd_tp_Tx
inner join house_imp_mar mas on mas.num_proc_mim=cta.num_proc_mim
inner join pessoa pp on pp.cd_pes=cd_import_him
where emissao between convert(datetime, '01/01/2004',105) and convert(datetime, '31/12/2004',105)
group by nome_tp_tx,apelido,month(emissao)

union

select 'EM' Modal, nome_tp_tx,apelido,sum(dbo.valor(vlr_pgto_nf_hem,dc_hem)) Valor,month(emissao) Mes from cta_ctE_hou_exp_mar cta
inner join base_nota_fiscal nf on nf.notA_fiscal=num_nf_hem and ref_acesso_nf_hem=ref_acesso
inner join tipo_taxa tt on tt.cd_tp_Tx=cta.cd_tp_Tx
inner join house_exp_mar hou on hou.num_proc_hem=cta.num_proc_hem
inner join pessoa pp on pp.cd_pes=cd_export_hem
where 
emissao between convert(datetime, '01/01/2004',105) and convert(datetime, '31/12/2004',105)
group by nome_tp_tx,apelido,month(emissao)


union all

select 'EM' Modal, nome_tp_tx,apelido,sum(dbo.valor(vlr_pgto_nf_mem,dc_mem)) Valor,month(emissao) Mes from cta_ctE_mas_exp_mar cta
inner join base_nota_fiscal nf on nf.notA_fiscal=num_nf_mem and ref_acesso_nf_mem=ref_acesso
inner join tipo_taxa tt on tt.cd_tp_Tx=cta.cd_tp_Tx
inner join house_exp_mar mas on mas.num_proc_mem=cta.num_proc_mem
inner join pessoa pp on pp.cd_pes=cd_export_hem
where emissao between convert(datetime, '01/01/2004',105) and convert(datetime, '31/12/2004',105)
group by nome_tp_tx,apelido,month(emissao)





GO
