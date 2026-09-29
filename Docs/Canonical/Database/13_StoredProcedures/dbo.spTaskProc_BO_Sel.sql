SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spTaskProc_BO_Sel] 

	@Num_Proc 	varchar(16),
	@Grupo		varchar(50)
as

	select
		(case when Dt_Conclusao IS null then 'Waiting' else 'Closed' End) [Status],
		Nome_Task,
		convert(varchar(10),Dt_Previsao,103) Dt_Previsao,
		convert(varchar(10),Dt_Conclusao,103) Dt_Conclusao,
		Nome_Usuario
		--Num_Proc, Nome_Task, Dt_Previsao, Dt_Conclusao, Nome_Usuario
	from tarefas_processos TP With(nolock)
	Inner Join Tipo_tarefas TT  With(nolock) on TT.id_task=TP.ID_Task and modal=left(@num_proc,2) and (TT.cd_pes_grupo = @Grupo or TT.cd_pes_grupo='10017')
	Left Join Usuario US With(nolock) on TP.cd_usuario=US.cd_usuario
	Where
		Num_proc=@num_proc
		and ativo = 'S'
	order by
		Nome_Task
OPTION (HASH JOIN)




GO
