SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tarefas_Processos
CREATE procedure [dbo].[spATL_Tarefas_Processos_Del] 
(	
	@Num_Proc			varchar(16),
	@ID_Task			int	
)

as
	
if exists(Select * from Tarefas_Processos where num_proc = @Num_Proc and ID_Task = @ID_Task and Dt_Conclusao is not null)
	Begin
		update Tarefas_Processos set Dt_Conclusao = null, Dt_Insert = null, Cd_Usuario = null where num_proc = @Num_Proc and ID_Task = @ID_Task and Dt_Conclusao is not null
	END


GO
