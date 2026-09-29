SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  procedure spICI_Rel

as

select 
	 'Ship' Tipo,'IA' Modal,org.nome_local Origem, dst.nome_local Destino,count(num_proc_hia) Qty, month(convert(datetime,dt_cheg_mia,105)) Mes
from
	house_imp_aer HOU
	Join localidade ORG on org.cd_local=cd_org_hia
	Join localidade DST on dst.cd_local=cd_dst_hia
	Join Pessoa pp on pp.cd_pes=cd_import_hia
	Join Master_imp_aer mas on mas.num_proc_mia=hou.num_proc_mia
where
	apelido like 'ICI%' and left(num_proc_hia,5)<> 'IAJOB' and convert(datetime,dt_cheg_mia,105)>='01-01-2005'

Group by
	org.nome_local, dst.nome_local, month(convert(datetime, dt_cheg_mia,105)) 


union all

select 
	 'Ship' Tipo,'Im' Modal,org.nome_local, dst.nome_local,count(num_proc_him) Qty, month(convert(datetime,dt_atrac_mim,105)) Mes
from
	house_imp_mar HOU
	Join localidade ORG on org.cd_local=cd_org_him
	Join localidade DST on dst.cd_local=cd_dst_him
	Join Pessoa pp on pp.cd_pes=cd_import_him
	Join Master_imp_mar mas on mas.num_proc_mim=hou.num_proc_mim
where
	apelido like 'ICI%' and left(num_proc_him,5)<> 'imJOB' and convert(datetime, dt_atrac_mim,105)>='01-01-2005'

Group by
	org.nome_local, dst.nome_local, month(convert(datetime, dt_atrac_mim,105)) 



GO
