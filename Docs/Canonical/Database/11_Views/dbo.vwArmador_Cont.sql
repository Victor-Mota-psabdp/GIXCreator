SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE  View vwArmador_Cont

as
/*
select 
	Nome_Armador, nome_Tp_cont, count(item_Cont_im) QTY,Month(convert(Datetime,dt_atrac_mim,105)) MEs, Year((convert(Datetime,dt_atrac_mim,105))) Ano
from 
	master_imp_mar MAS
	Join Armador ARM on ARM.cd_armador=mas.cd_armador
	Join container_mas_imp_mar CM on cm.num_proc_mim=mas.num_proc_mim
	Join Tipo_container TC on TC.cd_Tp_cont=CM.cd_tp_Cont
Where 
	convert(Datetime,dt_atrac_mim,105) between 
	'01-01-2005' and '09-30-2006' and cm.cd_tp_cont not in ('LCL','LCM')	
GRoup by
	Nome_Armador, nome_Tp_cont,
Month(convert(Datetime,dt_atrac_mim,105)), Year((convert(Datetime,dt_atrac_mim,105)))
*/

select 
	Nome_Armador, nome_Tp_cont, count(item_Cont_em) QTY,Month(convert(Datetime,dt_saida_mem,105)) MEs, Year((convert(Datetime,dt_saida_mem,105))) Ano
from 
	master_exp_mar MAS
	Join Armador ARM on ARM.cd_armador=mas.cd_armador
	Join container_mas_exp_mar CM on cm.num_proc_mem=mas.num_proc_mem
	Join Tipo_container TC on TC.cd_Tp_cont=CM.cd_tp_Cont
Where 
	convert(Datetime,dt_saida_mem,105) between 
	'01-01-2005' and '09-30-2006' and cm.cd_tp_cont not in ('LCL','LCM')	
GRoup by
	Nome_Armador, nome_Tp_cont,
Month(convert(Datetime,dt_saida_mem,105)), Year((convert(Datetime,dt_saida_mem,105)))










GO
