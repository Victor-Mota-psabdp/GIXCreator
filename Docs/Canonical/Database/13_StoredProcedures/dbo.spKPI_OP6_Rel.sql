SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure spKPI_OP6_Rel

		@DataInicial	varchar(10),
		@DataFinal	varchar(10)

AS

select 

	'Importação Marítima' Modal, apelido, hawb_him MAWB, mas.num_proc_mim,convert(datetime,dt_atrac_mim,105) Data

from

	master_imp_mar MAS
	inner join pessoa pp on MAS.cd_export_mim=PP.cd_pes
	inner join house_imp_mar HOU on HOU.num_proc_mim=MAS.num_proc_mim

where 
	
	convert(datetime,dt_atrac_mim,105) between 
	convert(Datetime,@datainicial,105) and
	convert(datetime,@datafinal,105)

UNION 

select 

	'Importação Aérea' Modal,apelido, hawb_hia MAWB, mas.num_proc_mia,convert(datetime,dt_cheg_mia,105) Data

from

	master_imp_aer MAS
	inner join pessoa pp on MAS.cd_export_mia=PP.cd_pes
	inner join house_imp_aer HOU on HOU.num_proc_mia=MAS.num_proc_mia
where 
	
	convert(datetime,dt_cheg_mia,105) between 
	convert(Datetime,@datainicial,105) and
	convert(datetime,@datafinal,105)



GO
