SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[spTaskMaster_Sel] 
	@Num_Proc 	varchar(16),
	@Grupo		varchar(3)
as
	declare @cd_Pes_Grupo varchar(10)
	set @cd_Pes_Grupo = (select Cd_Pes_Grupo from grupo where grupo=@grupo)

	declare @Tipo_Consol char(1)
	set @Tipo_Consol = (select tipo from LLP_Master where num_proc_master = @Num_Proc)

	select 
		Num_Proc, Nome_Task, Dt_Previsao, Dt_Conclusao, Nome_Usuario
	from 
		tarefas_Master TP with(nolock)
		join Tipo_tarefas_Master TT with(nolock) on TT.id_task=TP.ID_Task and modal=left(@num_proc,2) and (TT.cd_pes_grupo = @cd_Pes_Grupo or TT.cd_pes_grupo='10017') and Tipo_Consol = @Tipo_Consol
		left join Usuario US with(nolock) on TP.cd_usuario=US.cd_usuario
	Where
		Num_proc=@num_proc
	order by
		Nome_Task









GO
