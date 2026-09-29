SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  Procedure spRecEmi_Rel

		@DataInicial	char(10),
		@DataFinal	char(10)

as

Select 
	CTA.Num_proc_hia,Apelido,Num_Rcb_hia,Nome_Tp_TX,cta.dc_hia,vlr_pgto_rcto_hia, cta.num_nf_hia, emissao,convert(datetime,dt_pgto_rcto_hia,105) Dt_Pgto 

From 
	Caixa_hou_imp_aer CXA
	Join Cta_cte_hou_imp_Aer CTA on CTA.num_proc_hia=CXA.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia 
	Join Pessoa PP on pp.cd_pes=cd_cred_dev_hia
	Join Tipo_Taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
	Left Join Base_Nota_fiscal NF on ref_acesso_nf_hia=ref_acesso and cta.num_nf_hia=nota_fiscal
Where
	convert(Datetime,dt_pgto_rcto_hia,105) between @DataInicial and @DataFinal
	and num_lcto <> 'PROVISÓRIO'
	and left(num_rcb_hia,2)='RC'

UNION ALL


Select 
	CTA.Num_proc_him,Apelido,Num_Rcb_him,Nome_Tp_TX,cta.dc_him,vlr_pgto_rcto_him, cta.num_nf_him, emissao,convert(datetime,dt_pgto_rcto_him,105) Dt_Pgto 

From 
	Caixa_hou_imp_mar CXA
	Join Cta_cte_hou_imp_mar CTA on CTA.num_proc_him=CXA.num_proc_him and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_him=cxa.dc_him 
	Join Pessoa PP on pp.cd_pes=cd_cred_dev_him
	Join Tipo_Taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
	Left Join Base_Nota_fiscal NF on ref_acesso_nf_him=ref_acesso and cta.num_nf_him=nota_fiscal
Where
	convert(Datetime,dt_pgto_rcto_him,105) between @DataInicial and @DataFinal
	and num_lcto <> 'PROVISÓRIO'
	and left(num_rcb_him,2)='RC'

UNION ALL



Select 
	CTA.Num_proc_MIA,Apelido,Num_Rcb_MIA,Nome_Tp_TX,cta.dc_MIA,vlr_pgto_rcto_MIA, cta.num_nf_MIA, emissao,convert(datetime,dt_pgto_rcto_mia,105) Dt_Pgto 

From 
	Caixa_MAS_imp_aer CXA
	Join Cta_cte_MAS_imp_Aer CTA on CTA.num_proc_MIA=CXA.num_proc_MIA and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_MIA=cxa.dc_MIA 
	Join Pessoa PP on pp.cd_pes=cd_cred_dev_MIA
	Join Tipo_Taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
	Left Join Base_Nota_fiscal NF on ref_acesso_nf_MIA=ref_acesso and cta.num_nf_MIA=nota_fiscal
Where
	convert(Datetime,dt_pgto_rcto_MIA,105) between @DataInicial and @DataFinal
	and num_lcto <> 'PROVISÓRIO'
	and left(num_rcb_MIA,2)='RC'

UNION ALL


Select 
	CTA.Num_proc_MIM,Apelido,Num_Rcb_MIM,Nome_Tp_TX,cta.dc_MIM,vlr_pgto_rcto_MIM, cta.num_nf_MIM, emissao,convert(datetime,dt_pgto_rcto_mim,105) Dt_Pgto 

From 
	Caixa_MAS_imp_mar CXA
	Join Cta_cte_MAS_imp_mar CTA on CTA.num_proc_MIM=CXA.num_proc_MIM and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_MIM=cxa.dc_MIM 
	Join Pessoa PP on pp.cd_pes=cd_cred_dev_MIM
	Join Tipo_Taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
	Left Join Base_Nota_fiscal NF on ref_acesso_nf_MIM=ref_acesso and cta.num_nf_MIM=nota_fiscal
Where
	convert(Datetime,dt_pgto_rcto_MIM,105) between @DataInicial and @DataFinal
	and num_lcto <> 'PROVISÓRIO'
	and left(num_rcb_MIM,2)='RC'

union


Select 
	CTA.Num_proc_hea,Apelido,Num_Rcb_hea,Nome_Tp_TX,cta.dc_hea,vlr_pgto_rcto_hea, cta.num_nf_hea, emissao,convert(datetime,dt_pgto_rcto_hea,105) Dt_Pgto 

From 
	Caixa_hou_exp_aer CXA
	Join Cta_cte_hou_exp_Aer CTA on CTA.num_proc_hea=CXA.num_proc_hea and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hea=cxa.dc_hea 
	Join Pessoa PP on pp.cd_pes=cd_cred_dev_hea
	Join Tipo_Taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
	Left Join Base_Nota_fiscal NF on ref_acesso_nf_hea=ref_acesso and cta.num_nf_hea=nota_fiscal
Where
	convert(Datetime,dt_pgto_rcto_hea,105) between @DataInicial and @DataFinal
	and num_lcto <> 'PROVISÓRIO'
	and left(num_rcb_hea,2)='RC'

UNION ALL


Select 
	CTA.Num_proc_hem,Apelido,Num_Rcb_hem,Nome_Tp_TX,cta.dc_hem,vlr_pgto_rcto_hem, cta.num_nf_hem, emissao,convert(datetime,dt_pgto_rcto_hem,105) Dt_Pgto 

From 
	Caixa_hou_exp_mar CXA
	Join Cta_cte_hou_exp_mar CTA on CTA.num_proc_hem=CXA.num_proc_hem and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hem=cxa.dc_hem 
	Join Pessoa PP on pp.cd_pes=cd_cred_dev_hem
	Join Tipo_Taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
	Left Join Base_Nota_fiscal NF on ref_acesso_nf_hem=ref_acesso and cta.num_nf_hem=nota_fiscal
Where
	convert(Datetime,dt_pgto_rcto_hem,105) between @DataInicial and @DataFinal
	and num_lcto <> 'PROVISÓRIO'
	and left(num_rcb_hem,2)='RC'

UNION ALL



Select 
	CTA.Num_proc_mea,Apelido,Num_Rcb_mea,Nome_Tp_TX,cta.dc_mea,vlr_pgto_rcto_mea, cta.num_nf_mea, emissao,convert(datetime,dt_pgto_rcto_mea,105) Dt_Pgto 

From 
	Caixa_MAS_exp_aer CXA
	Join Cta_cte_MAS_exp_Aer CTA on CTA.num_proc_mea=CXA.num_proc_mea and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mea=cxa.dc_mea 
	Join Pessoa PP on pp.cd_pes=cd_cred_dev_mea
	Join Tipo_Taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
	Left Join Base_Nota_fiscal NF on ref_acesso_nf_mea=ref_acesso and cta.num_nf_mea=nota_fiscal
Where
	convert(Datetime,dt_pgto_rcto_mea,105) between @DataInicial and @DataFinal
	and num_lcto <> 'PROVISÓRIO'
	and left(num_rcb_mea,2)='RC'

UNION ALL


Select 
	CTA.Num_proc_mem,Apelido,Num_Rcb_mem,Nome_Tp_TX,cta.dc_mem,vlr_pgto_rcto_mem, cta.num_nf_mem, emissao,convert(datetime,dt_pgto_rcto_mem,105) Dt_Pgto 

From 
	Caixa_MAS_exp_mar CXA
	Join Cta_cte_MAS_exp_mar CTA on CTA.num_proc_mem=CXA.num_proc_mem and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mem=cxa.dc_mem 
	Join Pessoa PP on pp.cd_pes=cd_cred_dev_mem
	Join Tipo_Taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
	Left Join Base_Nota_fiscal NF on ref_acesso_nf_mem=ref_acesso and cta.num_nf_mem=nota_fiscal
Where
	convert(Datetime,dt_pgto_rcto_mem,105) between @DataInicial and @DataFinal
	and num_lcto <> 'PROVISÓRIO'
	and left(num_rcb_mem,2)='RC'




GO
