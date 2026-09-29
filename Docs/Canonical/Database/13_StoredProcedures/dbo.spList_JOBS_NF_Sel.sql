SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  Procedure [dbo].[spList_JOBS_NF_Sel]--'2013-05-01','2013-05-10'
		@DataInicial 	varchar(10),
		@DataFinal	varchar(10)
AS

select distinct
	Nota_Fiscal [Nota Fiscal],Cta.Num_proc_HEA [Job],
	TT.nome_tp_tx [Nome Taxa],
	Vlr_pgto_nf_hea [Valor],Emissao [Data]
from 
	Base_Nota_Fiscal NF	
	Join ctA_cte_hou_EXP_aer CTA on NF.Nota_Fiscal=cta.num_nf_hea and ref_acesso=ref_Acesso_nf_hea 
	join tipo_taxa TT on TT.cd_tp_tx = CTA.cd_tp_tx
Where
	emissao between @DataInicial and @DataFinal
	and cd_status = 0
	
UNION ALL

select distinct
	Nota_Fiscal [Nota Fiscal],Cta.Num_proc_HIA [Job],
	TT.nome_tp_tx [Nome Taxa],
	Vlr_pgto_nf_hia[Valor],Emissao[Data]
from 
	Base_Nota_Fiscal NF
	Join ctA_cte_hou_imp_aer CTA on NF.Nota_Fiscal=cta.num_nf_hia and ref_acesso=ref_Acesso_nf_hia 
	join tipo_taxa TT on TT.cd_tp_tx = CTA.cd_tp_tx
Where	
	emissao between @DataInicial and @DataFinal	
	and cd_status = 0

union all

select distinct
	Nota_Fiscal [Nota Fiscal],Cta.Num_proc_HIM [Job],
	TT.nome_tp_tx [Nome Taxa],
	Vlr_pgto_nf_him[Valor],Emissao[Data]
from 
	Base_Nota_Fiscal NF	
	Join ctA_cte_hou_imp_mar CTA on NF.Nota_Fiscal=cta.num_nf_him and ref_acesso=ref_Acesso_nf_him 
	join tipo_taxa TT on TT.cd_tp_tx = CTA.cd_tp_tx
Where
	emissao between @DataInicial and @DataFinal
	and cd_status = 0

UNION ALL

select distinct
	Nota_Fiscal [Nota Fiscal],Cta.Num_proc_HEM [Job],
	TT.nome_tp_tx [Nome Taxa] ,
	Vlr_pgto_nf_hem[Valor],Emissao[Data]
from 
	Base_Nota_Fiscal NF	
	Join ctA_cte_hou_EXP_mar CTA on NF.Nota_Fiscal=cta.num_nf_hem and ref_acesso=ref_Acesso_nf_hem	
	join tipo_taxa TT on TT.cd_tp_tx = CTA.cd_tp_tx	
Where
	emissao between @DataInicial and @DataFinal
	and cd_status = 0

union all

select distinct
	Nota_Fiscal [Nota Fiscal],Cta.Num_proc_HIO [Job],
	TT.nome_tp_tx [Nome Taxa] ,
	Vlr_pgto_nf_hio[Valor],Emissao[Data]
from 
	Base_Nota_Fiscal NF	
	Join ctA_cte_hou_imp_out CTA on NF.Nota_Fiscal=cta.num_nf_hio and ref_acesso=ref_Acesso_nf_hio 
	join tipo_taxa TT on TT.cd_tp_tx = CTA.cd_tp_tx
Where
	emissao between @DataInicial and @DataFinal
	and cd_status = 0

UNION ALL

select distinct
	Nota_Fiscal [Nota Fiscal],Cta.Num_proc_HEO [Job],
	TT.nome_tp_tx [Nome Taxa] ,
	Vlr_pgto_nf_heo[Valor],Emissao[Data]
from 
	Base_Nota_Fiscal NF	
	Join ctA_cte_hou_EXP_out CTA	 on NF.Nota_Fiscal=cta.num_nf_heo and ref_acesso=ref_Acesso_nf_heo
	join tipo_taxa TT on TT.cd_tp_tx = CTA.cd_tp_tx
Where
	emissao between @DataInicial and @DataFinal
	and cd_status = 0


order by 1


--select 
--	Nota_Fiscal [Nota Fiscal],Cta.Num_proc_MEA[Job],Valor_Total [Valor],Emissao [Data]
--from 
--	ctA_cte_MAS_EXP_AER CTA	
--	Left Join Base_Nota_Fiscal NF on NF.Nota_Fiscal=cta.num_nf_mea and ref_acesso=ref_Acesso_nf_mea
--
--Where
--	emissao between @DataInicial and @DataFinal
--
--UNION ALL
--
--select 
--	Nota_Fiscal [Nota Fiscal],Cta.Num_proc_MEA [Job], Valor_Total[Valor],Emissao[Data]
--from 
--	ctA_cte_MAS_imp_AER CTA	
--	Left Join Base_Nota_Fiscal NF on NF.Nota_Fiscal=cta.num_nf_mia and ref_acesso=ref_Acesso_nf_mia
--	lEFT jOIN pgto_Rcto PG on CXA.num_lcto=PG.num_lcto 
--Where
--	emissao between @DataInicial and @DataFinal
--
--union all
--
--select 
--	Nota_Fiscal	[Nota Fiscal],Cta.Num_proc_HEA [Job],Valor_Total [Valor],Emissao[Data]
--from 
--	ctA_cte_MAS_imp_MAR CTA	
--	Left Join Base_Nota_Fiscal NF on NF.Nota_Fiscal=cta.num_nf_mim and ref_acesso=ref_Acesso_nf_mim
--Where
--	emissao between @DataInicial and @DataFinal
--
--UNION ALL
--
--select 
--	Nota_Fiscal [Nota Fiscal],Cta.Num_proc_mem [Job],Valor_Total[Valor],Emissao[Data]
--from 
--	ctA_cte_MAS_EXP_MAR CTA
--	Left Join Base_Nota_Fiscal NF on NF.Nota_Fiscal=cta.num_nf_mem and ref_acesso=ref_Acesso_nf_mem
--Where
--	emissao between @DataInicial and @DataFinal
GO
