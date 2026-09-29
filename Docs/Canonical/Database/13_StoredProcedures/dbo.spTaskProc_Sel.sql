SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--cadu - incluido ver se esta ativo o task
CREATE procedure [dbo].[spTaskProc_Sel] 

	@Num_Proc 	varchar(16),
	@Grupo		varchar(50)
as

	select 
		Num_Proc, Nome_Task, Dt_Previsao, Dt_Conclusao, Nome_Usuario, Dt_Insert
	from 
		tarefas_processos TP With(nolock)
		Inner Join Tipo_tarefas TT  With(nolock) on TT.id_task=TP.ID_Task and modal=left(@num_proc,2) and (TT.cd_pes_grupo = @Grupo or TT.cd_pes_grupo='10017')
		Left Join Usuario US With(nolock) on TP.cd_usuario=US.cd_usuario
	Where
		Num_proc=@num_proc
		and ativo = 'S'
	order by
		Nome_Task
OPTION (HASH JOIN)




GO
