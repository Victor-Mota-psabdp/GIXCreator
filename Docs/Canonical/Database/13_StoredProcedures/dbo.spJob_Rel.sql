SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure spJob_Rel

as


select job_hia JOB from house_imp_aer where convert(datetime,dt_emis_hia,105)>=getdate()-120 
group by job_hia
union all
select Job_him from house_imp_mar where convert(datetime,dt_emis_him,105)>=getdate()-120
group by job_him
union all
select Job_hem from house_exp_mar where convert(datetime,dt_emis_hem,105)>=getdate()-120
group by job_hem
union all
select Job_hea from house_exp_aer where convert(datetime,dt_emis_hea,105)>=getdate()-120
group by job_hea

GO
