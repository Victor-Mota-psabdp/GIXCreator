SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE    view  vwArmador

as



SElect 'Importação' Modal,nome_armador, sum(Peso_Bruto_mim) Peso, sum(cast(Qtd_HAWB_mim as numeric)) HBL,month(convert(datetime,dt_atrac_mim,105)) mes, year(converT(Datetime,dt_atrac_mim,105)) Ano
from master_imp_mar MAS
join container_mas_imp_mar CM on CM.num_proc_mim=mas.num_proc_mim
Join armador ARM on MAS.cd_armador=arm.cd_armador
Where
	convert(Datetime,dt_atrac_mim,105) >='01-01-2006'
	and cd_tp_cont in ('LCL','LCM')	
group by nome_armador,month(convert(datetime,dt_atrac_mim,105)),year(converT(Datetime,dt_atrac_mim,105))

union 



SElect 'exportação' Modal,nome_armador, sum(Peso_Bruto_mem) Peso, sum(cast(Qtd_HAWB_mem as numeric)) HBL,month(convert(datetime,dt_saida_mem,105)) mes, year(converT(Datetime,dt_saida_mem,105)) Ano
from master_exp_mar MAS
join container_mas_exp_mar CM on CM.num_proc_mem=mas.num_proc_mem
Join armador ARM on MAS.cd_armador=arm.cd_armador
Where
	convert(Datetime,dt_saida_mem,105) >='01-01-2006'
	and cd_tp_cont in ('LCL','LCM')	
group by nome_armador,month(convert(datetime,dt_saida_mem,105)),year(converT(Datetime,dt_saida_mem,105))




GO
