SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view vwResultado

as

select 
	left(num_proc_hia,2) Modal,
	nome_tp_tx, dc_hia, sum(cast(vlr_org_hia as smallmoney)*isnull(Par_moeda,1)) Valor
	,num_proc_hia
from 
	vwcta_Cte CTA
	Left Join Paridade PAR on PAR.cd_tp_moeda=cta.cd_tp_moeda and dt_par='31/01/2006' and cd_Tp_par='OFC'
	Join Tipo_taxa tt on tt.cd_tp_tx=cta.cd_tp_tx
Where 
	convert(Datetime,dt_ins_hia, 105) between '02-01-2006' and '02-28-2006'
	and desp_org_hia='N'
	and cta.cd_tp_tx not in ('135','142','ADT','143','149','125')	
	and num_proc_hia not like '%JOB%'
	
	
group by 
	dc_hia, left(num_proc_hia,2), nome_tp_tx,cta.cd_tp_tx,num_proc_hia





GO
