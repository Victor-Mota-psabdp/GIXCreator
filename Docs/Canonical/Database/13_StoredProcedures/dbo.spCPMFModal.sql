SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure spCPMFModal
		(
		  @DataInicial Varchar(10),
		  @DataFinal Varchar(10)
)

AS

Select 
	'IA' Modal,sum(isnull(dbo.valor(vlr_org_hia,dc_hia),0)) Valor 
from 
	cta_cte_hou_imp_aer
where 
	left(cd_tp_tx,2)='C$' and convert(datetime,dt_ins_hia,105) between @DataInicial and @DataFinal
	and desp_org_hia='N'

UNION ALL

Select 
	'IA' Modal,sum(isnull(dbo.valor(vlr_org_mia,dc_mia),0)) Valor 
from 
	cta_cte_mas_imp_aer
where 
	left(cd_tp_tx,2)='C$' and convert(datetime,dt_ins_mia,105) between @DataInicial and @DataFinal
	and desp_org_mia='N'

union

Select 
	'EA' Modal,sum(IsNull(dbo.valor(vlr_org_HEA,dc_HEA),0)) Valor 
from 
	cta_cte_hou_EXP_aer
where 
	left(cd_tp_tx,2)='C$' and convert(datetime,dt_ins_HEA,105) between @DataInicial and @DataFinal
	and desp_dst_HEA='N'

UNION ALL

Select 
	'EA' Modal,sum(IsNull(dbo.valor(vlr_org_MEA,dc_MEA),0)) Valor 
from 
	cta_cte_mas_EXP_aer
where 
	left(cd_tp_tx,2)='C$' and convert(datetime,dt_ins_MEA,105) between @DataInicial and @DataFinal
	and desp_dst_mea='N'


UNION 


Select 
	'IM' Modal,sum(IsNull(dbo.valor(vlr_org_him,dc_him),0)) Valor 
from 
	cta_cte_hou_imp_mar
where 
	left(cd_tp_tx,2)='C$' and convert(datetime,dt_ins_him,105) between @DataInicial and @DataFinal
	and desp_org_him='N'

UNION ALL

Select 
	'IM' Modal,sum(IsNull(dbo.valor(vlr_org_mim,dc_mim),0)) Valor 
from 
	cta_cte_mas_imp_mar
where 
	left(cd_tp_tx,2)='C$' and convert(datetime,dt_ins_mim,105) between @DataInicial and @DataFinal
	and desp_org_mim='N'

union

Select 
	'EM' Modal,sum(IsNull(dbo.valor(vlr_org_hem,dc_hem),0)) Valor 
from 
	cta_cte_hou_EXP_mar
where 
	left(cd_tp_tx,2)='C$' and convert(datetime,dt_ins_hem,105) between @DataInicial and @DataFinal
	and desp_dst_hem='N'

UNION ALL

Select 
	'EM' Modal,sum(IsNull(dbo.valor(vlr_org_mem,dc_mem),0)) Valor 
from 
	cta_cte_mas_EXP_mar
where 
	left(cd_tp_tx,2)='C$' and convert(datetime,dt_ins_mem,105) between @DataInicial and @DataFinal
	and desp_dst_mem='N'


GO
