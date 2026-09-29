SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spProcessosCHBLLP_Sel]

as


select num_proc_hem Processo from house_exp_mar
where convert(datetime,dt_emis_hem,105) >= getdate() -90 and right(left(num_proc_hem,5),3) <> 'JOB'

union

select num_proc_hea from house_exp_Aer
where convert(datetime,dt_emis_hea,105) >= getdate() -90 and right(left(num_proc_hea,5),3) <> 'JOB'
UNION

select num_proc_hia from house_imp_Aer
where convert(datetime,dt_emis_hia,105) >= getdate() -90 and right(left(num_proc_hia,5),3) <> 'JOB'
union

select num_proc_him from house_imp_mar
where convert(datetime,dt_emis_him,105) >= getdate() -90 and right(left(num_proc_him,5),3) <> 'JOB'
union

select num_proc_hIo from house_imp_out
where convert(datetime,dt_emis_hio,105) >= getdate() -90 and right(left(num_proc_hio,5),3) <> 'JOB'
union

select num_proc_heo from house_exp_out
where convert(datetime,dt_emis_heo,105) >= getdate() -90 and right(left(num_proc_heo,5),3) <> 'JOB'
union
select num_proc_mia from master_imp_aer
where right(left(num_proc_mia,5),3) = 'CLI' and convert(datetime,dt_emis_mia,105) >= getdate() -90
union
select num_proc_mim from master_imp_mar
where right(left(num_proc_mim,5),3) = 'CLI' and convert(datetime,dt_emis_mim,105) >= getdate() -90
union
select num_proc_mea from master_exp_aer
where right(left(num_proc_mea,5),3) = 'CLI' and convert(datetime,dt_emis_mea,105) >= getdate() -90
union
select num_proc_mem from master_exp_mar
where right(left(num_proc_mem,5),3) = 'CLI' and convert(datetime,dt_emis_mem,105) >= getdate() -90

UNION
select Num_Proc_HBO Processo from House_BDP_OUT
where convert(datetime,Dt_Emis_HBO,105) >= getdate() -90 and right(left(Num_Proc_HBO,5),3) <> 'JOB'

GO
