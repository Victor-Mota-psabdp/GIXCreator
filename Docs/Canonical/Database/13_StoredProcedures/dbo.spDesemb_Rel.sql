SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE   Procedure spDesemb_Rel 
			(
				@DataInicial Char(10),
				@DataFinal Char(10)
			)

as

Select 
	Num_ctA_cte,dt_pgto_Rcto_hia Data, Apelido,Nome_tp_tx Taxa,cta.dc_hia DC,vlr_pgto_Rcto_hia Valor
from 
	cta_cte_hou_imp_aer CTA
	Join Caixa_hou_imp_aer CXA ON CTA.num_proc_hia=CXA.num_proc_hia and CTA.cd_tp_Tx=CXA.cd_tp_tx and CTA.dc_hia=CXA.dc_hia
	Join Pessoa PP on PP.cd_pes=CTA.cd_cred_dev_hia
	Join Tipo_Taxa TT on TT.cd_tp_Tx=CTA.cd_tp_Tx
	Join Pgto_rcto PG on PG.num_lcto=CXA.num_lcto
Where
	cta.cd_tp_tx in (select * from param_AekContabil_taxas_exc)
	and convert(datetime,dt_pgto_rcto_hia,105) between @DataInicial and @DataFinal


UNION ALL


Select 
	Num_ctA_cte,dt_pgto_Rcto_mia,Apelido,Nome_tp_tx,cta.dc_mia,vlr_pgto_Rcto_mia 
from 
	cta_cte_mas_imp_aer CTA
	Join Caixa_mas_imp_aer CXA ON CTA.num_proc_mia=CXA.num_proc_mia and CTA.cd_tp_Tx=CXA.cd_tp_tx and CTA.dc_mia=CXA.dc_mia
	Join Pessoa PP on PP.cd_pes=CTA.cd_cred_dev_mia
	Join Tipo_Taxa TT on TT.cd_tp_Tx=CTA.cd_tp_Tx
	Join Pgto_rcto PG on PG.num_lcto=CXA.num_lcto
Where
	cta.cd_tp_tx in (select * from param_AekContabil_taxas_exc)
	and convert(datetime,dt_pgto_rcto_mia,105) between @DataInicial and @DataFinal


UNION ALL

Select 
	Num_ctA_cte,dt_pgto_Rcto_hea,Apelido,Nome_tp_tx,cta.dc_hea, vlr_pgto_Rcto_hea 
from 
	cta_cte_hou_exp_aer CTA
	Join Caixa_hou_exp_aer CXA ON CTA.num_proc_hea=CXA.num_proc_hea and CTA.cd_tp_Tx=CXA.cd_tp_tx and CTA.dc_hea=CXA.dc_hea
	Join Pessoa PP on PP.cd_pes=CTA.cd_cred_dev_hea
	Join Tipo_Taxa TT on TT.cd_tp_Tx=CTA.cd_tp_Tx
	Join Pgto_rcto PG on PG.num_lcto=CXA.num_lcto
Where
	cta.cd_tp_tx in (select * from param_AekContabil_taxas_exc)
	and convert(datetime,dt_pgto_rcto_hea,105) between @DataInicial and @DataFinal


UNION ALL


Select 
	Num_ctA_cte,dt_pgto_Rcto_mea,Apelido,Nome_tp_tx,cta.dc_mea,vlr_pgto_Rcto_mea 
from 
	cta_cte_mas_exp_aer CTA
	Join Caixa_mas_exp_aer CXA ON CTA.num_proc_mea=CXA.num_proc_mea and CTA.cd_tp_Tx=CXA.cd_tp_tx and CTA.dc_mea=CXA.dc_mea
	Join Pessoa PP on PP.cd_pes=CTA.cd_cred_dev_mea
	Join Tipo_Taxa TT on TT.cd_tp_Tx=CTA.cd_tp_Tx
	Join Pgto_rcto PG on PG.num_lcto=CXA.num_lcto
Where
	cta.cd_tp_tx in (select * from param_AekContabil_taxas_exc)
	and convert(datetime,dt_pgto_rcto_mea,105) between @DataInicial and @DataFinal


UNION ALL



Select 
	Num_ctA_cte,dt_pgto_Rcto_mim,Apelido,Nome_tp_tx,cta.dc_mim,vlr_pgto_Rcto_mim 
from 
	cta_cte_mas_imp_mar CTA
	Join Caixa_mas_imp_mar CXA ON CTA.num_proc_mim=CXA.num_proc_mim and CTA.cd_tp_Tx=CXA.cd_tp_tx and CTA.dc_mim=CXA.dc_mim
	Join Pessoa PP on PP.cd_pes=CTA.cd_cred_dev_mim
	Join Tipo_Taxa TT on TT.cd_tp_Tx=CTA.cd_tp_Tx
	Join Pgto_rcto PG on PG.num_lcto=CXA.num_lcto
Where
	cta.cd_tp_tx in (select * from param_AekContabil_taxas_exc)
	and convert(datetime,dt_pgto_rcto_mim,105) between @DataInicial and @DataFinal



UNION ALL

Select 
	Num_ctA_cte,dt_pgto_Rcto_hem,Apelido,Nome_tp_tx,cta.dc_hem,vlr_pgto_Rcto_hem 
from 
	cta_cte_hou_exp_mar CTA
	Join Caixa_hou_exp_mar CXA ON CTA.num_proc_hem=CXA.num_proc_hem and CTA.cd_tp_Tx=CXA.cd_tp_tx and CTA.dc_hem=CXA.dc_hem
	Join Pessoa PP on PP.cd_pes=CTA.cd_cred_dev_hem
	Join Tipo_Taxa TT on TT.cd_tp_Tx=CTA.cd_tp_Tx
	Join Pgto_rcto PG on PG.num_lcto=CXA.num_lcto
Where
	cta.cd_tp_tx in (select * from param_AekContabil_taxas_exc)
	and convert(datetime,dt_pgto_rcto_hem,105) between @DataInicial and @DataFinal


UNION ALL


Select 
	Num_ctA_cte,dt_pgto_Rcto_mem,Apelido,Nome_tp_tx,cta.dc_mem,vlr_pgto_Rcto_mem 
from 
	cta_cte_mas_exp_mar CTA
	Join Caixa_mas_exp_mar CXA ON CTA.num_proc_mem=CXA.num_proc_mem and CTA.cd_tp_Tx=CXA.cd_tp_tx and CTA.dc_mem=CXA.dc_mem
	Join Pessoa PP on PP.cd_pes=CTA.cd_cred_dev_mem
	Join Tipo_Taxa TT on TT.cd_tp_Tx=CTA.cd_tp_Tx
	Join Pgto_rcto PG on PG.num_lcto=CXA.num_lcto
Where
	cta.cd_tp_tx in (select * from param_AekContabil_taxas_exc)
	and convert(datetime,dt_pgto_rcto_mem,105) between @DataInicial and @DataFinal

union all

Select 
	Num_ctA_cte,dt_pgto_Rcto_HIM Data, Apelido,Nome_tp_tx Taxa,cta.dc_HIM DC,vlr_pgto_Rcto_HIM Valor
from 
	cta_cte_hou_imp_MAR CTA
	Join Caixa_hou_imp_MAR CXA ON CTA.num_proc_HIM=CXA.num_proc_HIM and CTA.cd_tp_Tx=CXA.cd_tp_tx and CTA.dc_HIM=CXA.dc_HIM
	Join Pessoa PP on PP.cd_pes=CTA.cd_cred_dev_HIM
	Join Tipo_Taxa TT on TT.cd_tp_Tx=CTA.cd_tp_Tx
	Join Pgto_rcto PG on PG.num_lcto=CXA.num_lcto
Where
	cta.cd_tp_tx in (select * from param_AekContabil_taxas_exc)
	and convert(datetime,dt_pgto_rcto_HIM,105) between @DataInicial and @DataFinal





GO
