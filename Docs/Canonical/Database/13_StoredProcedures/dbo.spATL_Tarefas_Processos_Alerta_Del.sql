SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tarefas_Processos_Alerta
Create procedure [dbo].[spATL_Tarefas_Processos_Alerta_Del]
(
	@Num_Proc			varchar(16),
	@ID_Alerta			bigint
)
as
	if exists(select Num_Proc from Tarefas_Processos_Alerta where Num_Proc = @Num_Proc and ID_Alerta = @ID_Alerta) 
		begin
			Delete Tarefas_Processos_Alerta where Num_Proc = @Num_Proc and ID_Alerta = @ID_Alerta
		end

GO
