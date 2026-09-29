SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  Procedure [dbo].[spList_JOBS_NF_BDPINVOICE_Sel]--'2013-07-05','2013-07-10'
		@DataInicial 	varchar(10),
		@DataFinal	varchar(10)
AS

select distinct
	Nota_Fiscal [Nota Fiscal],
	Cta.Num_proc_HEA [Job],
--	TT.nome_tp_tx [Nome Taxa],
--	Vlr_pgto_nf_hea [Valor],
	Emissao [Data],
	FAT.FatCod [Fatura],
	FATdtEmissao [Data da Fatura]	
from 
	Base_Nota_Fiscal NF	with(nolock)
	Join ctA_cte_hou_EXP_aer CTA with(nolock)on NF.Nota_Fiscal=cta.num_nf_hea and ref_acesso=ref_Acesso_nf_hea 
	join tipo_taxa TT with(nolock) on TT.cd_tp_tx = CTA.cd_tp_tx
	Left Join item_Fat FAT with(nolock) on CTA.num_proc_HEA = FAT.num_proc and CTA.cd_tp_tx = FAT.cd_tp_tx and CTA.dc_hea = FAT.dc
	Left Join Fatura F with(nolock) on F.FatCod=FAT.FatCod  
Where
	emissao between @DataInicial and @DataFinal	
	and cd_status = 0 and F.FatStatus = 1
	
UNION ALL

select distinct
	Nota_Fiscal [Nota Fiscal],
	Cta.Num_proc_HIA [Job],
--	TT.nome_tp_tx [Nome Taxa],
--	Vlr_pgto_nf_hia[Valor],
	Emissao[Data],
	FAT.FatCod,
	FATdtEmissao
from 
	Base_Nota_Fiscal NF with(nolock)
	Join ctA_cte_hou_imp_aer CTA  with(nolock) on NF.Nota_Fiscal=cta.num_nf_hia and ref_acesso=ref_Acesso_nf_hia 
	join tipo_taxa TT with(nolock) on TT.cd_tp_tx = CTA.cd_tp_tx
	Left Join item_Fat FAT with(nolock) on CTA.num_proc_HIA = FAT.num_proc and CTA.cd_tp_tx = FAT.cd_tp_tx and CTA.dc_hia = FAT.dc
	Left Join Fatura F with(nolock) on F.FatCod=FAT.FatCod  
Where	
	emissao between @DataInicial and @DataFinal	
	and cd_status = 0 and F.FatStatus = 1
	

union all

select distinct
	Nota_Fiscal [Nota Fiscal],Cta.Num_proc_HIM [Job],
--	TT.nome_tp_tx [Nome Taxa],
--	Vlr_pgto_nf_him[Valor],
	Emissao[Data],
	FAT.FatCod,
	FATdtEmissao
from 
	Base_Nota_Fiscal NF	with(nolock)
	Join ctA_cte_hou_imp_mar CTA with(nolock) on NF.Nota_Fiscal=cta.num_nf_him and ref_acesso=ref_Acesso_nf_him 
	join tipo_taxa TT with(nolock) on TT.cd_tp_tx = CTA.cd_tp_tx
	Left Join item_Fat FAT with(nolock) on CTA.num_proc_HIM = FAT.num_proc and CTA.cd_tp_tx = FAT.cd_tp_tx and CTA.dc_him = FAT.dc
	Left Join Fatura F with(nolock) on F.FatCod=FAT.FatCod  
Where
	emissao between @DataInicial and @DataFinal
	and cd_status = 0 and F.FatStatus = 1
	

UNION ALL

select distinct
	Nota_Fiscal [Nota Fiscal],Cta.Num_proc_HEM [Job],
--	TT.nome_tp_tx [Nome Taxa],
--	Vlr_pgto_nf_hem[Valor],
	Emissao[Data],
	FAT.FatCod,
	FATdtEmissao
from 
	Base_Nota_Fiscal NF	with(nolock)
	Join ctA_cte_hou_EXP_mar CTA with(nolock) on NF.Nota_Fiscal=cta.num_nf_hem and ref_acesso=ref_Acesso_nf_hem	
	join tipo_taxa TT with(nolock) on TT.cd_tp_tx = CTA.cd_tp_tx
	Left Join item_Fat FAT with(nolock) on CTA.num_proc_HEm = FAT.num_proc and CTA.cd_tp_tx = FAT.cd_tp_tx and CTA.dc_hem = FAT.dc
	Left Join Fatura F with(nolock) on F.FatCod=FAT.FatCod  
Where
	emissao between @DataInicial and @DataFinal
	and cd_status = 0 and F.FatStatus = 1
	

union all

select distinct
	Nota_Fiscal [Nota Fiscal],Cta.Num_proc_HIO [Job],
--	TT.nome_tp_tx [Nome Taxa] ,
--	Vlr_pgto_nf_hio[Valor],
	Emissao[Data],
	FAT.FatCod,
	FATdtEmissao
from 
	Base_Nota_Fiscal NF	with(nolock)
	Join ctA_cte_hou_imp_out CTA with(nolock) on NF.Nota_Fiscal=cta.num_nf_hio and ref_acesso=ref_Acesso_nf_hio 
	join tipo_taxa TT with(nolock) on TT.cd_tp_tx = CTA.cd_tp_tx
	Left Join item_Fat FAT with(nolock) on CTA.num_proc_Hio = FAT.num_proc and CTA.cd_tp_tx = FAT.cd_tp_tx and CTA.dc_hio = FAT.dc
	Left Join Fatura F with(nolock) on F.FatCod=FAT.FatCod  
Where
	emissao between @DataInicial and @DataFinal
	and cd_status = 0 and F.FatStatus = 1
	

UNION ALL

select distinct
	Nota_Fiscal [Nota Fiscal],
	Cta.Num_proc_HEO [Job],
--	TT.nome_tp_tx [Nome Taxa],
--	Vlr_pgto_nf_heo[Valor],
	Emissao[Data],
	FAT.FatCod,
	FATdtEmissao
from 
	Base_Nota_Fiscal NF	with(nolock)
	Join ctA_cte_hou_EXP_out CTA with(nolock) on NF.Nota_Fiscal=cta.num_nf_heo and ref_acesso=ref_Acesso_nf_heo
	join tipo_taxa TT with(nolock) on TT.cd_tp_tx = CTA.cd_tp_tx
	Left Join item_Fat FAT with(nolock) on CTA.num_proc_HEO = FAT.num_proc and CTA.cd_tp_tx = FAT.cd_tp_tx and CTA.dc_heo = FAT.dc
	Left Join Fatura F with(nolock) on F.FatCod=FAT.FatCod  
Where
	emissao between @DataInicial and @DataFinal
	and cd_status = 0 and F.FatStatus = 1
	


order by 1


GO
