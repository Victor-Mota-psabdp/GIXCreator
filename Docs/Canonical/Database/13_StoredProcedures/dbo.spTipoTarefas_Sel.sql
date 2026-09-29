SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--select * from tipo_tarefas where nome_task like '%%'
--spTipoTarefas_Sel '','','H'

CREATE procedure [dbo].[spTipoTarefas_Sel] 
	@Task varchar(100),
	@Grupo varchar(50),
	@Tipo char(1) -- H = House, M = Master
AS

	If @Tipo = 'H'
		select
			T.id_task [Id], T.nome_task [Task Name], T.Modal, T.dias [Days], T.tipo_data [Type Date],
			G.apelido [Group Name], T.Smart_Previsao, T.Smart_Conclusao, T.descr_tarefa [Description],
			dt_criacao [Creation Date], T.cd_usuario [User ID], T.Ativo
		from
			tipo_tarefas T with (nolock)
			join pessoa G on G.cd_pes = T.cd_pes_grupo
		where
			(G.apelido like @Grupo or @Grupo = '')
			and (T.nome_task like @Task or @Task = '')
		order by 1,2
	Else
		select
			T.id_task [Id], T.nome_task [Task Name], T.Modal, T.dias [Days], T.tipo_data [Type Date],
			G.apelido [Group Name], T.Smart_Previsao, T.Smart_Conclusao, T.descr_tarefa [Description],
			dt_criacao [Creation Date], T.cd_usuario [User ID], T.Ativo
		from
			tipo_tarefas_master T with (nolock)
			join pessoa G on G.cd_pes = T.cd_pes_grupo
		where
			(G.apelido like @Grupo or @Grupo = '')
			and (T.nome_task like @Task or @Task = '')
		order by 1,2		



GO
