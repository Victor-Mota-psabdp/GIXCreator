SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE   Procedure [dbo].[spContVar] 
		(@DataInicial VarChar(10),
		@DataFinal Varchar(10)
)

as

Select 
	'IA' Modal,cta.num_proc_hia,cta.cd_Tp_tx,
	0 Valor --dbo.valor(vlr_pgto_rcto_hia,cxa.dc_hia)-IsNull(dbo.valor(vlr_contab_ant,cta.dc_hia),0) Valor 
from 
	caixa_hou_imp_aer CXA
	Join cta_Cte_hou_imp_aer CTA on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia 
Where
	convert(DateTime,dt_pgto_rcto_hia,105) between @DataInicial and @DataFinal
	and convert(datetime,dt_pgto_rcto_hia,105)>convert(Datetime,dt_ins_hia,105)
	and month(convert(datetime,dt_pgto_rcto_hia,105))<>month(convert(Datetime,dt_ins_hia,105))
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	and year(convert(Datetime,dt_ins_hia,105))>=2006
	and num_lcto <> 'PROVISÓRIO'

/*
UNION ALL


Select 
	'IA',cta.num_proc_mia,cta.cd_Tp_tx,
	0 Valor --dbo.valor(vlr_pgto_rcto_mia,cxa.dc_mia)-IsNull(dbo.valor(vlr_contab_ant,cta.dc_mia),0) Valor 
from 
	caixa_mas_imp_aer CXA
	Join cta_Cte_mas_imp_aer CTA on cta.num_proc_mia=cxa.num_proc_mia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_mia=cxa.dc_mia 
Where
	convert(DateTime,dt_pgto_rcto_mia,105) between @DataInicial and @DataFinal
	and convert(datetime,dt_pgto_rcto_mia,105)>convert(Datetime,dt_ins_mia,105)
	and month(convert(datetime,dt_pgto_rcto_mia,105))<>month(convert(Datetime,dt_ins_mia,105))
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	and year(convert(Datetime,dt_ins_mia,105))>=2006
	and num_lcto <> 'PROVISÓRIO'

UNION

Select 
	'EA',cta.num_proc_HEA,cta.cd_Tp_tx,0 Valor
--	dbo.valor(vlr_pgto_rcto_HEA,cxa.dc_HEA)-IsNull(dbo.valor(vlr_contab_ant,cta.dc_HEA),0) Valor 
from 
	caixa_hou_EXP_aer CXA
	Join cta_Cte_hou_EXP_aer CTA on cta.num_proc_HEA=cxa.num_proc_HEA and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_HEA=cxa.dc_HEA 
Where
	convert(DateTime,dt_pgto_rcto_HEA,105) between @DataInicial and @DataFinal
	and convert(datetime,dt_pgto_rcto_HEA,105)>convert(Datetime,dt_ins_HEA,105)
	and month(convert(datetime,dt_pgto_rcto_HEA,105))<>month(convert(Datetime,dt_ins_HEA,105))
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	and year(convert(Datetime,dt_ins_HEA,105))>=2006
	and num_lcto <> 'PROVISÓRIO'


UNION ALL


Select 
	'EA',cta.num_proc_MEA,cta.cd_Tp_tx,0 Valor
--	dbo.valor(vlr_pgto_rcto_MEA,cxa.dc_MEA)-IsNull(dbo.valor(vlr_contab_ant,cta.dc_MEA),0) Valor 
from 
	caixa_mas_EXP_aer CXA
	Join cta_Cte_mas_EXP_aer CTA on cta.num_proc_MEA=cxa.num_proc_MEA and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_MEA=cxa.dc_MEA 
Where
	convert(DateTime,dt_pgto_rcto_MEA,105) between @DataInicial and @DataFinal
	and convert(datetime,dt_pgto_rcto_MEA,105)>convert(Datetime,dt_ins_MEA,105)
	and month(convert(datetime,dt_pgto_rcto_MEA,105))<>month(convert(Datetime,dt_ins_MEA,105))
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	and year(convert(Datetime,dt_ins_MEA,105))>=2006
	and num_lcto <> 'PROVISÓRIO'

UNION 

Select 
	'IM',cta.num_proc_HIM,cta.cd_Tp_tx, 0 Valor
--	dbo.valor(vlr_pgto_rcto_HIM,cxa.dc_HIM)-IsNull(dbo.valor(vlr_contab_ant,cta.dc_HIM),0) Valor 
from 
	caixa_hou_imp_MAR CXA
	Join cta_Cte_hou_imp_MAR CTA on cta.num_proc_HIM=cxa.num_proc_HIM and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_HIM=cxa.dc_HIM 
Where
	convert(DateTime,dt_pgto_rcto_HIM,105) between @DataInicial and @DataFinal
	and convert(datetime,dt_pgto_rcto_HIM,105)>convert(Datetime,dt_ins_HIM,105)
	and month(convert(datetime,dt_pgto_rcto_HIM,105))<>month(convert(Datetime,dt_ins_HIM,105))
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	and year(convert(Datetime,dt_ins_HIM,105))>=2006
	and num_lcto <> 'PROVISÓRIO'


UNION ALL


Select 
	'IM',cta.num_proc_MIM,cta.cd_Tp_tx,0 Valor
	--dbo.valor(vlr_pgto_rcto_MIM,cxa.dc_MIM)-IsNull(dbo.valor(vlr_contab_ant,cta.dc_MIM),0) Valor 
from 
	caixa_mas_imp_MAR CXA
	Join cta_Cte_mas_imp_MAR CTA on cta.num_proc_MIM=cxa.num_proc_MIM and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_MIM=cxa.dc_MIM 
Where
	convert(DateTime,dt_pgto_rcto_MIM,105) between @DataInicial and @DataFinal
	and convert(datetime,dt_pgto_rcto_MIM,105)>convert(Datetime,dt_ins_MIM,105)
	and month(convert(datetime,dt_pgto_rcto_MIM,105))<>month(convert(Datetime,dt_ins_MIM,105))
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	and year(convert(Datetime,dt_ins_MIM,105))>=2006
	and num_lcto <> 'PROVISÓRIO'

UNION

Select 
	'EM',cta.num_proc_HEM,cta.cd_Tp_tx,0 Valor
--	dbo.valor(vlr_pgto_rcto_HEM,cxa.dc_HEM)-IsNull(dbo.valor(vlr_contab_ant,cta.dc_HEM),0) Valor 
from 
	caixa_hou_EXP_MAR CXA
	Join cta_Cte_hou_EXP_MAR CTA on cta.num_proc_HEM=cxa.num_proc_HEM and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_HEM=cxa.dc_HEM 
Where
	convert(DateTime,dt_pgto_rcto_HEM,105) between @DataInicial and @DataFinal
	and convert(datetime,dt_pgto_rcto_HEM,105)>convert(Datetime,dt_ins_HEM,105)
	and month(convert(datetime,dt_pgto_rcto_HEM,105))<>month(convert(Datetime,dt_ins_HEM,105))
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	and year(convert(Datetime,dt_ins_HEM,105))>=2006
	and num_lcto <> 'PROVISÓRIO'


UNION ALL


Select 
	'EM',cta.num_proc_MEM,cta.cd_Tp_tx, 0 Valor
--	dbo.valor(vlr_pgto_rcto_MEM,cxa.dc_MEM)-IsNull(dbo.valor(vlr_contab_ant,cta.dc_MEM),0) Valor 
from 
	caixa_mas_EXP_MAR CXA
	Join cta_Cte_mas_EXP_MAR CTA on cta.num_proc_MEM=cxa.num_proc_MEM and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_MEM=cxa.dc_MEM 
Where
	convert(DateTime,dt_pgto_rcto_MEM,105) between @DataInicial and @DataFinal
	and convert(datetime,dt_pgto_rcto_MEM,105)>convert(Datetime,dt_ins_MEM,105)
	and month(convert(datetime,dt_pgto_rcto_MEM,105))<>month(convert(Datetime,dt_ins_MEM,105))
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	and year(convert(Datetime,dt_ins_MEM,105))>=2006
	and num_lcto <> 'PROVISÓRIO'




*/
GO
