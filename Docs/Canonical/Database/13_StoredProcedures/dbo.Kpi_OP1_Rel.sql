SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   procedure Kpi_OP1_Rel
		@datainicial	varchar(10),
		@datafinal	varchar(10)

as

select 
	'Importação Aérea' Modal , num_proc_mia Processo,convert(datetime,dt_cheg_mia,105) Data,
	convert(datetime,dt_emis_mia,105) Insercao 

from 
	master_imp_aer 

where convert(datetime,dt_emis_mia,105) between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105)
and year(convert(datetime,dt_cheg_mia,105))>=2004
UNION ALL

select 
	'Exportação Aérea' Modal , num_proc_mea Processo,convert(datetime,dt_saida_mea,105) Data,
	convert(datetime,dt_emis_mea,105) Insercao 

from 
	master_exp_aer 

where convert(datetime,dt_emis_mea,105) between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105)
and year(convert(datetime,dt_saida_mea,105))>=2004

UNION

select 
	'Importação Marítima' Modal , num_proc_mim Processo,convert(datetime,dt_atrac_mim,105) Data,
	convert(datetime,dt_emis_mim,105) Insercao 

from 
	master_imp_mar 

where convert(datetime,dt_emis_mim,105) between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105)
and year(convert(datetime,dt_atrac_mim,105))>=2004

UNION ALL

select 
	'Exportação Marítma' Modal , num_proc_mem Processo,convert(datetime,dt_saida_mem,105) Data,
	convert(datetime,dt_emis_mem,105) Insercao 

from 
	master_exp_mar 

where convert(datetime,dt_emis_mem,105) between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105)
and year(convert(datetime,dt_saida_mem,105))>=2004




GO
