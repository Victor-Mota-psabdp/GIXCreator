SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure spMovMar_rel

			@datainicial	varchar(10),
			@datafinal	varchar(10)

AS

select 
	'Importação Marítima' as Modal,nome_armador,count(num_proc_mim) as Embarques, sum(peso_bruto_mim) as Peso, cd_tp_moeda, sum(vlr_frete_mim) as Frete,0 Volume

from 
	master_imp_mar mas
	inner join armador arm on (arm.cd_armador=mas.cd_armador)

where 
	convert(datetime, dt_atrac_mim, 105) between convert(datetime, @datainicial,105) and convert(datetime, @datafinal,105)

group by nome_armador, cd_tp_moeda 


UNION ALL

select 
	'Exportação Marítima' as Modal,nome_armador,count(num_proc_mem) as Embarques, sum(peso_bruto_mem) as Peso, cd_tp_moeda, sum(vlr_frete_mem) as Frete, SUM(Vol_Tot_MEM) Volume 

from 
	master_exp_mar mas
	inner join armador arm on (arm.cd_armador=mas.cd_armador)

where 
	convert(datetime, dt_saida_mem, 105) between convert(datetime, @datainicial,105) and convert(datetime, @datafinal,105)

group by nome_armador, cd_tp_moeda 





GO
