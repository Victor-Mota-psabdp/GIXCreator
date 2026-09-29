SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spList_JOBS_Sel]--'2013-06-01','2013-06-30'
	
	@datainicial datetime,
	@datafinal datetime

as

select 
	dt_emis_him [Creation DT],num_proc_him [Job] from house_imp_mar Hou	
where 
	convert(datetime,dt_emis_him,105) between @datainicial and @datafinal

UNION ALL

select 
	dt_emis_hia [Creation DT],num_proc_hia [Job] from house_imp_aer Hou	
where 
	convert(datetime,dt_emis_hia,105) between @datainicial and @datafinal

UNION ALL

select 
	dt_emis_hio [Creation DT],num_proc_hio [Job] from house_imp_out Hou	
where 
	convert(datetime,dt_emis_hio,105) between @datainicial and @datafinal
 
UNION ALL

select 
	dt_emis_hem [Creation DT],num_proc_hem [Job] from house_exp_mar Hou	
where 
	convert(datetime,dt_emis_hem,105) between @datainicial and @datafinal

UNION ALL

select 
	dt_emis_hea [Creation DT],num_proc_hea [Job] from house_exp_aer Hou	
where 
	convert(datetime,dt_emis_hea,105) between @datainicial and @datafinal

UNION ALL

select 
	dt_emis_heo [Creation DT],num_proc_heo [Job] from house_exp_out Hou	
where 
	convert(datetime,dt_emis_heo,105) between @datainicial and @datafinal


GO
