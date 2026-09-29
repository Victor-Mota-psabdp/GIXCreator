SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tarefas_Processos
CREATE procedure [dbo].[spATL_Tarefas_Processos_Sel] 
(	
	@Num_Proc			varchar(16),
	@ID_Task			int,
	@cd_pes_grupo		varchar(10),
	@Tipo				char(1)
)
as
	
/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codgo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
S e L para Solicitacao de LI
*/

IF @Tipo = 'A' or @Tipo = 'B'
	Begin
		select
			(case when Dt_Conclusao IS null then 'Waiting' 
			else 'Closed' End)								[Status],
			TP.Num_Proc										[JOB],
			TP.ID_Task										[Task Type Code],
			TT.Nome_Task									[Task Type Name],
			-- convert(varchar(10),TP.Dt_Previsao,103)			[Prevision Date],
			-- convert(varchar(10),TP.Dt_Conclusao,103)		[Conclusion Date],
            TP.Dt_Previsao			[Prevision Date],
			TP.Dt_Conclusao		[Conclusion Date],
			TP.Cd_Usuario									[User Code],
			Nome_Usuario									[User Name],
			-- convert(varchar(10),TP.Dt_Insert,103)			[Insert Date]
           TP.Dt_Insert			[Insert Date]
		from tarefas_processos TP With(nolock)
			Inner Join Tipo_tarefas TT  With(nolock) on TT.id_task=TP.ID_Task 
				and modal=left(@num_proc,2) and (TT.cd_pes_grupo = @cd_pes_grupo or TT.cd_pes_grupo='10017')
			Left Join Usuario US With(nolock) on TP.cd_usuario=US.cd_usuario
		Where
			TP.Num_proc=@Num_Proc
			and TT.Ativo = 'S'
		order by
			1,2
	End
	
IF @Tipo = 'C' or @Tipo = 'D'
	Begin
		select
			(case when Dt_Conclusao IS null then 'Waiting' 
			else 'Closed' End)								[Status],
			TP.Num_Proc										[JOB],
			TP.ID_Task										[Task Type Code],
			TT.Nome_Task									[Task Type Name],
			-- convert(varchar(10),TP.Dt_Previsao,103)			[Prevision Date],
			-- convert(varchar(10),TP.Dt_Conclusao,103)		[Conclusion Date],
            TP.Dt_Previsao			[Prevision Date],
			TP.Dt_Conclusao		[Conclusion Date],
			TP.Cd_Usuario									[User Code],
			Nome_Usuario									[User Name],
			-- convert(varchar(10),TP.Dt_Insert,103)			[Insert Date]
           TP.Dt_Insert			[Insert Date]
		from tarefas_processos TP With(nolock)
			Inner Join Tipo_tarefas TT  With(nolock) on TT.id_task=TP.ID_Task 
				and modal=left(@num_proc,2) and (TT.cd_pes_grupo = @cd_pes_grupo or TT.cd_pes_grupo='10017')
			Left Join Usuario US With(nolock) on TP.cd_usuario=US.cd_usuario
		Where
			TP.Num_proc=@Num_Proc and TP.ID_Task = @ID_Task
			and TT.Ativo = 'S'
		order by
			1,2
	End
	
IF @Tipo = 'N' OR @Tipo = 'O'
	Begin
		select
			(case when Dt_Conclusao IS null then 'Waiting' 
			else 'Closed' End)								[Status],
			TP.Num_Proc										[JOB],
			TP.ID_Task										[Task Type Code],
			TT.Nome_Task									[Task Type Name],
			-- convert(varchar(10),TP.Dt_Previsao,103)			[Prevision Date],
			-- convert(varchar(10),TP.Dt_Conclusao,103)		[Conclusion Date],
            TP.Dt_Previsao			[Prevision Date],
			TP.Dt_Conclusao		[Conclusion Date],
			TP.Cd_Usuario									[User Code],
			Nome_Usuario									[User Name],
			-- convert(varchar(10),TP.Dt_Insert,103)			[Insert Date]
           TP.Dt_Insert			[Insert Date]
		from tarefas_processos TP With(nolock)
			Inner Join Tipo_tarefas TT  With(nolock) on TT.id_task=TP.ID_Task 
				and modal=left(@num_proc,2) and (TT.cd_pes_grupo = @cd_pes_grupo or TT.cd_pes_grupo='10017')
			Left Join Usuario US With(nolock) on TP.cd_usuario=US.cd_usuario
		Where
			TP.Num_proc=@Num_Proc and TP.ID_Task = @ID_Task
			and TT.Ativo = 'S'
		order by
			1,2
	End

--para verificar se ja esta preenchido o task
IF @Tipo = 'S' 
	Begin
		select
			(case when Dt_Conclusao IS null then 'Waiting' 
			else 'Closed' End)								[Status],
			TP.Num_Proc										[JOB],
			TP.ID_Task										[Task Type Code],
			TT.Nome_Task									[Task Type Name],
			-- convert(varchar(10),TP.Dt_Previsao,103)			[Prevision Date],
			-- convert(varchar(10),TP.Dt_Conclusao,103)		[Conclusion Date],
            TP.Dt_Previsao			[Prevision Date],
			TP.Dt_Conclusao		[Conclusion Date],
			TP.Cd_Usuario									[User Code],
			Nome_Usuario									[User Name],
			-- convert(varchar(10),TP.Dt_Insert,103)			[Insert Date]
           TP.Dt_Insert			[Insert Date]
		from tarefas_processos TP With(nolock)
			Inner Join Tipo_tarefas TT  With(nolock) on TT.id_task=TP.ID_Task 
				and modal=left(@num_proc,2) and (TT.cd_pes_grupo = @cd_pes_grupo or TT.cd_pes_grupo='10017')
			Left Join Usuario US With(nolock) on TP.cd_usuario=US.cd_usuario
		Where
			TP.Num_proc=@Num_Proc and TP.ID_Task = @ID_Task
			and TP.Dt_Conclusao is null
			and TT.Ativo = 'S'
		order by
			1,2
	End

--if @Tipo = 'Z' 
--	Begin
--		select 
--			Cd_Tp_Ocor				[Code],
--			Nome_Tp_Ocor			[Occurrence Type Name],
--			Previsao_Obrigatoria	[Mandatory Forecast Date],
--			Permite_Dias_Anteriores [Allows Previous Days]
--		from 
--			Tipo_Tarefas with(nolock)
--		where 
--			Nome_Tp_Ocor = @Nome_Tp_Ocor AND Cd_Tp_Ocor <> @Cd_Tp_Ocor
--	End	
	

IF @Tipo = 'R' 
	Begin
		select
			(case when Dt_Conclusao IS null then 'Waiting' 
			else 'Closed' End)								[Status],
			TP.Num_Proc										[JOB],
			TP.ID_Task										[Task Type Code],
			TT.Nome_Task									[Task Type Name],
			-- convert(varchar(10),TP.Dt_Previsao,103)			[Prevision Date],
			-- convert(varchar(10),TP.Dt_Conclusao,103)		[Conclusion Date],
            TP.Dt_Previsao			[Prevision Date],
			TP.Dt_Conclusao		[Conclusion Date],
			TP.Cd_Usuario									[User Code],
			Nome_Usuario									[User Name],
			-- convert(varchar(10),TP.Dt_Insert,103)			[Insert Date]
           TP.Dt_Insert			[Insert Date]
		from tarefas_processos TP With(nolock)
			Inner Join Tipo_tarefas TT  With(nolock) on TT.id_task=TP.ID_Task 
				and modal=left(@num_proc,2) and (TT.cd_pes_grupo = @cd_pes_grupo or TT.cd_pes_grupo='10017')
			Left Join Usuario US With(nolock) on TP.cd_usuario=US.cd_usuario
		Where
			TP.Num_proc Like @Num_Proc and TP.ID_Task = @ID_Task
			and TP.Dt_Conclusao is not null
			and TT.Ativo = 'S'
		order by
			1,2
	End
GO
