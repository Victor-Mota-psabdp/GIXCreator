SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spControleFatura_JOB_Sel]--'IMCSR201201003br'

	 @job varchar(16)

as 

	if left(@job,2) = 'IM'
		Begin
			select 
				HOU.num_proc_him num_proc,
				CP31.campo_dados paridade		
			from house_imp_mar HOU
				left join campo_processo CP31 on CP31.num_proc = HOU.num_proc_him and id_campo = 31
			where
				num_proc_him = @job
		End
	else
		if left(@job,2) = 'EM'
			Begin
				select 
					HOU.num_proc_hem num_proc,
					CP31.campo_dados paridade		
				from house_exp_mar HOU
					left join campo_processo CP31 on CP31.num_proc = HOU.num_proc_hem and id_campo = 31
				where
					num_proc_hem = @job
			End
	
GO
