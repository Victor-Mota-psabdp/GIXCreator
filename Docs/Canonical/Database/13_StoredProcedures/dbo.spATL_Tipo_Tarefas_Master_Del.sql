SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Tarefas_Master
CREATE procedure [dbo].[spATL_Tipo_Tarefas_Master_Del]
(
	@ID_Task			int,
	@CD_TP_MODAL		varchar(2),	
	@Cd_Pes_Grupo		varchar(10)

)
AS

	If exists (select ID_Task from Tipo_Tarefas_Master where ID_Task = @ID_Task and Modal = @CD_TP_MODAL
							and Cd_Pes_Grupo = @cd_pes_grupo)
		begin
			update Tipo_Tarefas_Master set Ativo = 'N' where ID_Task = @ID_Task and Modal = @CD_TP_MODAL
			and Cd_Pes_Grupo = @cd_pes_grupo
		end

GO
