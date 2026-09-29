SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--18/08/2023 Cadu -[FRemoveAcentuacao] - Update to not send the accentuation 
CREATE  Procedure [dbo].[spCSRJob_SEL]
	@Num_Proc VarChar(16)

as


select 
	[dbo].[FRemoveAcentuacao](US.Nome_Usuario) Nome_Usuario,	
	--US.Nome_Usuario Nome_Usuario,
	US.Email Email,us.Fone Fone 
from vwCliente_Alerta HOU
	Join Usuario US with(nolock) on US.cd_usuario=HOU.cd_usuario
where
	num_proc = @Num_Proc

--if left(@num_proc,2)='EM'
--	BEGIN
--		select Nome_Usuario,Email,us.Fone from job_exp_mar JOB with(nolock)
--		Join Usuario US with(nolock) on US.cd_usuario=job.cd_usuario
--		where num_proc_hem=@Num_Proc
--	END
--IF LEFT(@num_proc,2)='EA'
--	Begin
--		select Nome_Usuario,Email,us.Fone from job_exp_aer JOB with(nolock)
--		Join Usuario US with(nolock) on US.cd_usuario=job.cd_usuario
--		where num_proc_hea=@Num_Proc
--	End
--IF LEFT(@num_proc,2)='IA'
--	Begin
--		select Nome_Usuario,Email ,us.Fone from job_imp_aer JOB with(nolock)
--		Join Usuario US with(nolock)  on US.cd_usuario=job.cd_usuario
--		where num_proc_hIA=@Num_Proc
--	End
--IF LEFT(@num_proc,2)='IM'
--	Begin
--		select Nome_Usuario,Email,us.Fone from job_imp_mar JOB with(nolock)
--		Join Usuario US with(nolock) on US.cd_usuario=job.cd_usuario
--		where num_proc_hIm=@Num_Proc
--	End
--IF LEFT(@num_proc,2)='IO'
--	Begin
--		select Nome_Usuario,Email,us.Fone from LLP_imp_out JOB with(nolock)
--		Join Usuario US with(nolock) on US.cd_usuario=job.cd_usuario
--		where num_proc_lIo=@Num_Proc
--	End
--IF LEFT(@num_proc,2)='EO'
--	Begin
--		select Nome_Usuario,Email,us.Fone from LLP_exp_out JOB with(nolock)
--		Join Usuario US with(nolock) on US.cd_usuario=job.cd_usuario
--		where num_proc_leo=@Num_Proc
--	End
	
--IF LEFT(@num_proc,2)='BO'
--	Begin
--		select Nome_Usuario,Email,us.Fone from LLP_BDP_OUT JOB with(nolock)
--		Join Usuario US with(nolock) on US.cd_usuario=job.cd_usuario
--		where Num_Proc_LBO=@Num_Proc
--	End




GO
