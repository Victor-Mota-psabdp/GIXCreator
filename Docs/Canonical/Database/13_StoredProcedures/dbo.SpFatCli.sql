SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE     PROCEDURE SpFatCli

		@datainicial	varchar(10),
		@datafinal	varchar (10),
		@cliente	varchar (30),
		@usuario	varchar (30)

As


select 
	cta_cte_hou_imp_aer.num_proc_hia, nome_tp_Tx, pft_aer, apelido, num_nf_hia, dc_hia, cast(vlr_pgto_nf_hia as money) as vlr_pgto_nf_hia, emissao, nome_usuario, cd_tp_grupo from cta_Cte_hou_imp_aer


inner join base_nota_fiscal on (num_nf_hia=nota_fiscal AND ref_acesso=Ref_Acesso_NF_HIA)
inner join tipo_taxa on (tipo_taxa.cd_tp_tx=cta_Cte_hou_imp_aer.cd_tp_tx)
inner join housE_imp_Aer on (house_imp_aer.num_proc_hia=cta_cte_hou_imp_aer.num_proc_hia)
inner join pessoa on (pessoa.cd_pes=cd_import_hia)
inner join usuario on (usuario.cd_usuario=pessoa.cd_usuario)
where cta_cte_hou_imp_aer.cd_tp_tx <> 'FRT'
and emissao between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
and apelido like @cliente
and nome_usuario like @usuario

union

select cta_cte_mas_imp_aer.num_proc_mia, nome_tp_Tx, pft_aer, apelido, num_nf_mia, dc_mia, vlr_pgto_nf_mia, emissao, nome_usuario, cd_tp_grupo from cta_Cte_mas_imp_aer
inner join base_nota_fiscal on (num_nf_mia=nota_fiscal AND ref_acesso=Ref_Acesso_NF_MIA)
inner join tipo_taxa on (tipo_taxa.cd_tp_tx=cta_Cte_mas_imp_aer.cd_tp_tx)
inner join housE_imp_Aer on (left(house_imp_aer.num_proc_hia, 14)=cta_cte_mas_imp_aer.num_proc_mia)
inner join pessoa on (pessoa.cd_pes=cd_import_hia)
inner join usuario on (usuario.cd_usuario=pessoa.cd_usuario)
where cta_cte_mas_imp_aer.cd_tp_tx <> 'FRT'
and emissao between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
and apelido like @cliente
and nome_usuario like @usuario


union

select cta_cte_hou_imp_mar.num_proc_him, nome_tp_Tx, pft_aer, apelido, num_nf_him, dc_him, vlr_pgto_nf_him, emissao, nome_usuario, cd_tp_grupo from cta_Cte_hou_imp_mar
inner join base_nota_fiscal on (num_nf_him=nota_fiscal AND ref_acesso=Ref_Acesso_NF_HIM)
inner join tipo_taxa on (tipo_taxa.cd_tp_tx=cta_Cte_hou_imp_mar.cd_tp_tx)
inner join housE_imp_mar on (house_imp_mar.num_proc_him=cta_cte_hou_imp_mar.num_proc_him)
inner join pessoa on (pessoa.cd_pes=cd_import_him)
inner join usuario on (usuario.cd_usuario=pessoa.cd_usuario)
where cta_cte_hou_imp_mar.cd_tp_tx <> 'FRT'
and emissao between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
and apelido like @cliente
and nome_usuario like @usuario

union

select cta_cte_mas_imp_mar.num_proc_mim, nome_tp_Tx, pft_aer, apelido, num_nf_mim, dc_mim, vlr_pgto_nf_mim, emissao, nome_usuario, cd_tp_grupo from cta_Cte_mas_imp_mar
inner join base_nota_fiscal on (num_nf_mim=nota_fiscal AND ref_acesso=Ref_Acesso_NF_MIM)
inner join tipo_taxa on (tipo_taxa.cd_tp_tx=cta_Cte_mas_imp_mar.cd_tp_tx)
inner join housE_imp_mar on (left(house_imp_mar.num_proc_him, 14)=cta_cte_mas_imp_mar.num_proc_mim)
inner join pessoa on (pessoa.cd_pes=cd_import_him)
inner join usuario on (usuario.cd_usuario=pessoa.cd_usuario)
where cta_cte_mas_imp_mar.cd_tp_tx <> 'FRT'
and emissao between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
and apelido like @cliente
and nome_usuario like @usuario

union 

select cta_cte_hou_exp_mar.num_proc_hem, nome_tp_Tx, pft_aer, apelido, num_nf_hem, dc_hem, vlr_pgto_nf_hem, emissao, nome_usuario, cd_tp_grupo from cta_Cte_hou_exp_mar
inner join base_nota_fiscal on (num_nf_hem=nota_fiscal AND ref_acesso=Ref_Acesso_NF_HEM)
inner join tipo_taxa on (tipo_taxa.cd_tp_tx=cta_Cte_hou_exp_mar.cd_tp_tx)
inner join housE_exp_mar on (house_exp_mar.num_proc_hem=cta_cte_hou_exp_mar.num_proc_hem)
inner join pessoa on (pessoa.cd_pes=cd_export_hem)
inner join usuario on (usuario.cd_usuario=pessoa.cd_usuario)
where cta_cte_hou_exp_mar.cd_tp_tx <> 'FRT'
and emissao between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
and apelido like @cliente
and nome_usuario like @usuario

union

select cta_cte_mas_exp_mar.num_proc_mem, nome_tp_Tx, pft_aer, apelido, num_nf_mem, dc_mem, vlr_pgto_nf_mem, emissao, nome_usuario, cd_tp_grupo from cta_Cte_mas_exp_mar
inner join base_nota_fiscal on (num_nf_mem=nota_fiscal AND ref_acesso=Ref_Acesso_NF_MEM)
inner join tipo_taxa on (tipo_taxa.cd_tp_tx=cta_Cte_mas_exp_mar.cd_tp_tx)
inner join housE_exp_mar on (left(house_exp_mar.num_proc_hem, 14)=cta_cte_mas_exp_mar.num_proc_mem)
inner join pessoa on (pessoa.cd_pes=cd_export_hem)
inner join usuario on (usuario.cd_usuario=pessoa.cd_usuario)
where cta_cte_mas_exp_mar.cd_tp_tx <> 'FRT'
and emissao between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
and apelido like @cliente
and nome_usuario like @usuario

union

select cta_cte_hou_exp_aer.num_proc_hea, nome_tp_Tx, pft_aer, dbo.StrGm_Grupo(apelido,cd_consig_hea) Cliente, num_nf_hea, dc_hea, vlr_pgto_nf_hea, emissao, nome_usuario, cd_tp_grupo from cta_Cte_hou_exp_aer
inner join base_nota_fiscal on (num_nf_hea=nota_fiscal AND ref_acesso=Ref_Acesso_NF_HEA)
inner join tipo_taxa on (tipo_taxa.cd_tp_tx=cta_Cte_hou_exp_aer.cd_tp_tx)
inner join housE_exp_aer on (house_exp_aer.num_proc_hea=cta_cte_hou_exp_aer.num_proc_hea)
inner join pessoa on (pessoa.cd_pes=cd_export_hea)
inner join usuario on (usuario.cd_usuario=pessoa.cd_usuario)
where cta_cte_hou_exp_aer.cd_tp_tx <> 'FRT'
and emissao between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
and apelido like @cliente
and nome_usuario like @usuario

union

select cta_cte_mas_exp_aer.num_proc_mea, nome_tp_Tx, pft_aer, dbo.StrGm_Grupo(apelido,cd_consig_hea) Cliente, num_nf_mea, dc_mea, vlr_pgto_nf_mea, emissao, nome_usuario, cd_tp_grupo from cta_Cte_mas_exp_aer
inner join base_nota_fiscal on (num_nf_mea=nota_fiscal AND ref_acesso=Ref_Acesso_NF_MEA)
inner join tipo_taxa on (tipo_taxa.cd_tp_tx=cta_Cte_mas_exp_aer.cd_tp_tx)
inner join housE_exp_aer on (left(house_exp_aer.num_proc_hea, 14)=cta_cte_mas_exp_aer.num_proc_mea)
inner join pessoa on (pessoa.cd_pes=cd_export_hea)
inner join usuario on (usuario.cd_usuario=pessoa.cd_usuario)
where cta_cte_mas_exp_aer.cd_tp_tx <> 'FRT'
and emissao between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
and apelido like @cliente
and nome_usuario like @usuario






GO
