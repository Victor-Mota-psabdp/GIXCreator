SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure [dbo].[spDemurrageControl_JOBS_Sel]
as
select llp.Num_Proc_Lim Processos from LLP_Imp_Mar LLP   With(nolock)
	join house_imp_mar HOU on LLP.Num_Proc_Lim = HOU.Num_Proc_HIM 
	Join Master_imp_mar MAS With(nolock) on mas.num_proc_mim=hou.num_proc_mim 
Where
	LLP.ATA_Lim  >= GetDate() - 730 
	 --Convert(DateTime, dt_atrac_mim, 103) >= GetDate() - 730 
	 --Or ATA_Master >= GetDate() - 730 
	 and hou.num_proc_mim <> 'JOB'
order by 1 desc 

GO
