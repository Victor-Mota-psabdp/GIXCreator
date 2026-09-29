SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure spKPI_CS4_Rel

		@datainicial varchar(10),
		@datafinal   varchar(10)

AS

select 
	
	job_hea Job,dt_hist DataLanc,dt_follow_up DtCheg
	
from 
	house_exp_aer
	inner  join historico_geral HST on job_hea=HST.refer_hist and cd_tp_ocor=10

where 
	
	left(job_hea,5)='EAJOB' and convert(datetime,dt_emis_hea,105) between convert(datetime,@datainicial,105) and
	convert(datetime,@datafinal,105)

UNION ALL

select 
	
	job_hem Job,dt_hist DataLanc,dt_follow_up DtCheg
	
from 
	house_exp_mar
	inner  join historico_geral HST on job_hem=HST.refer_hist and cd_tp_ocor=10

where 
	
	left(job_hem,5)='EMJOB'  and convert(datetime,dt_emis_hem,105) between convert(datetime,@datainicial,105) and
	convert(datetime,@datafinal,105)

	

GO
