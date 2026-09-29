SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE  Procedure [dbo].[spSalesPerformance_Sel] --'01-01-2010','12-31-2011','%'
		@DataInicial	Varchar(10),
		@DataFinal		Varchar(10),
		@Vendedor		Varchar(50)

AS



select 
	nome_usuario Vendedor,PP.Apelido Cliente,GRP.apelido  Grupoi , hou.num_proc_him Job, org.nome_local Origem, dst.nome_local Destino,sum(dbo.valor(vlr_pgto_nf_him,dc_him)) Total_Invoiced 
from 
	house_imp_mar Hou
	Join Job_Imp_mar Job on hou.num_proc_him=job.num_proc_him
	Join Cta_Cte_Hou_Imp_mar CTA on cta.num_proc_him=hou.num_proc_him and ref_Acesso_nf_him <> 'P' 
	Join Base_Nota_Fiscal NF on NF.nota_fiscal=Num_Nf_Him and ref_Acesso_nf_him=nf.ref_Acesso
	Join Usuario US on US.cd_usuario=Cd_Vendedor
	Join Localidade ORg on org.cd_local=cd_org_him
	Join Localidade DST on dst.cd_local=cd_Dst_him
	Join Pessoa PP on pp.cd_pes=cd_consig_him
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_consig_him
	Join Pessoa GRP on GRP.cd_pes=cd_pes_Grupo	

Where
	emissao between @DataInicial and @DataFinal and Nome_Usuario like @Vendedor
	and cta.cd_tp_Tx not in (select cd_tp_tx from tipo_taxa where nome_tp_tx like '%Demur%')
--	and  (
--	cta.cd_Tp_tx in (select cd_tp_tx from tipo_Taxa where pft_aer='S' )
--	or
--	cta.cd_tp_tx collate SQL_Latin1_General_CP1_CI_AS  in (
--		select   cd_tp_Tx from dbo.Taxas_Despacho TD 
--				)
--	)

Group by nome_usuario,hou.num_proc_him,org.nome_local,dst.nome_local,PP.Apelido,GRP.apelido

Union all

select 
	nome_usuario Vendedor,PP.Apelido Cliente,GRP.apelido  Grupoi , hou.num_proc_hia Job, org.nome_local Origem, dst.nome_local Destino,sum(dbo.valor(vlr_pgto_nf_hia,dc_hia)) Total_Invoiced 
from 
	house_imp_aer Hou
	Join Job_Imp_aer Job on hou.num_proc_hia=job.num_proc_hia
	Join Cta_Cte_Hou_Imp_aer CTA on cta.num_proc_hia=hou.num_proc_hia and ref_Acesso_nf_hia <> 'P' 
	Join Base_Nota_Fiscal NF on NF.nota_fiscal=Num_Nf_Hia and ref_Acesso_nf_hia=nf.ref_Acesso
	Join Usuario US on US.cd_usuario=Cd_Vendedor
	Join Localidade ORg on org.cd_local=cd_org_hia
	Join Localidade DST on dst.cd_local=cd_Dst_hia
	Join Pessoa PP on pp.cd_pes=cd_consig_hia
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_consig_hia
	Join Pessoa GRP on GRP.cd_pes=cd_pes_Grupo	

Where
	emissao between @DataInicial and @DataFinal and Nome_Usuario like @Vendedor 
--	and
--	(
--	cta.cd_Tp_tx in (select cd_tp_tx from tipo_Taxa where pft_aer='S' )
--	or
--	cta.cd_tp_tx collate SQL_Latin1_General_CP1_CI_AS  in (
--		select   cd_tp_Tx from dbo.Taxas_Despacho TD 
--				)
--	)

Group by nome_usuario,hou.num_proc_hia,org.nome_local,dst.nome_local,PP.Apelido,GRP.apelido


Union all


select 
	nome_usuario Vendedor,PP.Apelido Cliente,GRP.apelido  Grupoi , hou.num_proc_hem Job, org.nome_local Origem, dst.nome_local Destino,sum(dbo.valor(vlr_pgto_nf_hem,dc_hem)) Total_Invoiced 
from 
	house_exp_mar Hou
	Join Job_exp_mar Job on hou.num_proc_hem=job.num_proc_hem
	Join Cta_Cte_Hou_exp_mar CTA on cta.num_proc_hem=hou.num_proc_hem and ref_Acesso_nf_hem <> 'P' 
	Join Base_Nota_Fiscal NF on NF.nota_fiscal=Num_Nf_hem and ref_Acesso_nf_hem=nf.ref_Acesso
	Join Usuario US on US.cd_usuario=Cd_Vendedor
	Join Localidade ORg on org.cd_local=cd_org_hem
	Join Localidade DST on dst.cd_local=cd_Dst_hem
	Join Pessoa PP on pp.cd_pes=cd_Export_hem
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_Export_hem
	Join Pessoa GRP on GRP.cd_pes=cd_pes_Grupo	

Where
	emissao between @DataInicial and @DataFinal and Nome_Usuario like @Vendedor 
--	and
--	(
--	cta.cd_Tp_tx in (select cd_tp_tx from tipo_Taxa where pft_aer='S' )
--	or
--	cta.cd_tp_tx collate SQL_Latin1_General_CP1_CI_AS  in (
--		select   cd_tp_Tx from dbo.Taxas_Despacho TD 
--				)
--	)

Group by nome_usuario,hou.num_proc_hem,org.nome_local,dst.nome_local,PP.Apelido,GRP.apelido

Union all

select 
	nome_usuario Vendedor,PP.Apelido Cliente,GRP.apelido  Grupoi , hou.num_proc_hea Job, org.nome_local Origem, dst.nome_local Destino,sum(dbo.valor(vlr_pgto_nf_hea,dc_hea)) Total_Invoiced 
from 
	house_exp_aer Hou
	Join Job_exp_aer Job on hou.num_proc_hea=job.num_proc_hea
	Join Cta_Cte_Hou_exp_aer CTA on cta.num_proc_hea=hou.num_proc_hea and ref_Acesso_nf_hea <> 'P' 
	Join Base_Nota_Fiscal NF on NF.nota_fiscal=Num_Nf_hea and ref_Acesso_nf_hea=nf.ref_Acesso
	Join Usuario US on US.cd_usuario=Cd_Vendedor
	Join Localidade ORg on org.cd_local=cd_org_hea
	Join Localidade DST on dst.cd_local=cd_Dst_hea
	Join Pessoa PP on pp.cd_pes=cd_Export_hea
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_Export_hea
	Join Pessoa GRP on GRP.cd_pes=cd_pes_Grupo	

Where
	emissao between @DataInicial and @DataFinal and Nome_Usuario like @Vendedor 
--	and
--	(
--	cta.cd_Tp_tx in (select cd_tp_tx from tipo_Taxa where pft_aer='S' )
--	or
--	cta.cd_tp_tx collate SQL_Latin1_General_CP1_CI_AS  in (
--		select   cd_tp_Tx from dbo.Taxas_Despacho TD 
--				)
--	)

Group by nome_usuario,hou.num_proc_hea,org.nome_local,dst.nome_local,PP.Apelido,GRP.apelido


Union All

select 
	nome_usuario Vendedor,PP.Apelido Cliente,GRP.apelido  Grupoi , hou.num_proc_heo Job, org.nome_local Origem, dst.nome_local Destino,sum(dbo.valor(vlr_pgto_nf_heo,dc_heo)) Total_Invoiced 
from 
	house_exp_out Hou
	Join LLP_exp_out Job on hou.num_proc_heo=job.num_proc_leo
	Join Cta_Cte_Hou_exp_out CTA on cta.num_proc_heo=hou.num_proc_heo and ref_Acesso_nf_heo <> 'P' 
	Join Base_Nota_Fiscal NF on NF.nota_fiscal=Num_Nf_heo and ref_Acesso_nf_heo=nf.ref_Acesso
	Join Usuario US on US.cd_usuario=Cd_Vendedor
	Join Localidade ORg on org.cd_local=cd_org_heo
	Join Localidade DST on dst.cd_local=cd_Dst_heo
	Join Pessoa PP on pp.cd_pes=cd_Export_heo
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_Export_heo
	Join Pessoa GRP on GRP.cd_pes=cd_pes_Grupo	

Where
	emissao between @DataInicial and @DataFinal and Nome_Usuario like @Vendedor 
--	and
--	(
--	cta.cd_Tp_tx in (select cd_tp_tx from tipo_Taxa where pft_aer='S' )
--	or
--	cta.cd_tp_tx collate SQL_Latin1_General_CP1_CI_AS  in (
--		select   cd_tp_Tx from dbo.Taxas_Despacho TD 
--				)
--	)
--
Group by nome_usuario,hou.num_proc_heo,org.nome_local,dst.nome_local,PP.Apelido,GRP.apelido

Union all

select 
	nome_usuario Vendedor,PP.Apelido Cliente,GRP.apelido  Grupoi , hou.num_proc_hio Job, org.nome_local Origem, dst.nome_local Destino,sum(dbo.valor(vlr_pgto_nf_hio,dc_hio)) Total_Invoiced 
from 
	house_imp_out Hou
	Join LLP_imp_out Job on hou.num_proc_hio=job.num_proc_lio
	Join Cta_Cte_Hou_imp_out CTA on cta.num_proc_hio=hou.num_proc_hio and ref_Acesso_nf_hio <> 'P' 
	Join Base_Nota_Fiscal NF on NF.nota_fiscal=Num_Nf_hio and ref_Acesso_nf_hio=nf.ref_Acesso
	Join Usuario US on US.cd_usuario=Cd_Vendedor
	Join Localidade ORg on org.cd_local=cd_org_hio
	Join Localidade DST on dst.cd_local=cd_Dst_hio
	Join Pessoa PP on pp.cd_pes=cd_consig_hio
	Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_consig_hio
	Join Pessoa GRP on GRP.cd_pes=cd_pes_Grupo	

Where
	emissao between @DataInicial and @DataFinal and Nome_Usuario like @Vendedor 
--	and
--	(
--	cta.cd_Tp_tx in (select cd_tp_tx from tipo_Taxa where pft_aer='S' )
--	or
--	cta.cd_tp_tx collate SQL_Latin1_General_CP1_CI_AS  in (
--		select   cd_tp_Tx from dbo.Taxas_Despacho TD 
--				)
--	)
--
Group by nome_usuario,hou.num_proc_hio,org.nome_local,dst.nome_local,PP.Apelido,GRP.apelido




GO
