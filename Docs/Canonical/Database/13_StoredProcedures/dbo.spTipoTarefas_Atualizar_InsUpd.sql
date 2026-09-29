SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spTipoTarefas_Atualizar_InsUpd]
(
	@ID_Task int,
	@modal varchar(30),
	@Dias_Novo float,
	@Tipo_Data_Novo varchar(20)
)
AS
	if exists(select TOP 1 ID_Task from tipo_tarefas where id_task = @ID_Task and modal = @Modal and Ativo = 'S')
		BEGIN
			Update tipo_tarefas
			set		
				Dias = @Dias_Novo,
				Tipo_Data = @Tipo_Data_Novo,
				Descr_Tarefa = 'Alterado pelo ticket:100-111803'
			where
				id_task = @ID_Task and modal = @Modal and Ativo = 'S'
		END
						
GO
