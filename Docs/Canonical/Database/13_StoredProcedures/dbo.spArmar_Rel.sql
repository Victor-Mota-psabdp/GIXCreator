SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure spArmar_Rel
				(
				 @Ano Int
				)

as

Select 
	'Importação' Modal,Nome_Armador,Nome_tp_cont,
	count(Item_Cont_IM) Qty, month(convert(datetime,dt_atrac_mim,105)) Mes 
From 
	Master_imp_mar MAS
	Join Armador ARM on ARM.cd_armador=mas.cd_armador
	Join Container_mas_imp_mar CTM on CTM.num_proc_mim=MAS.num_proc_mim
	Join Tipo_container TC on TC.cd_tp_cont=CTM.cd_tp_cont
Where 
	Year(convert(datetime,dt_atrac_mim,105)) =@Ano and tc.cd_tp_cont not in ('LCL', 'LCM')
group by
	Nome_Armador,Nome_tp_cont,month(convert(datetime,dt_atrac_mim,105)) 

UNION


Select 
	'Exportação' Modal,Nome_Armador,Nome_tp_cont,
	count(Item_Cont_EM) Qty, month(convert(datetime,dt_Saida_mem,105)) Mes 
From 
	Master_Exp_mar MAS
	Join Armador ARM on ARM.cd_armador=mas.cd_armador
	Join Container_mas_exp_mar CTM on CTM.num_proc_mem=MAS.num_proc_mem
	Join Tipo_container TC on TC.cd_tp_cont=CTM.cd_tp_cont
Where 
	Year(convert(datetime,dt_saida_mem,105)) =@Ano and tc.cd_tp_cont not in ('LCL', 'LCM')
group by
	Nome_Armador,Nome_tp_cont,month(convert(datetime,dt_Saida_mem,105)) 




GO
