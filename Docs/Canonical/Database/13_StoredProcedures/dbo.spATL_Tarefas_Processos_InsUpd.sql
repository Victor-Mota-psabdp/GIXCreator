SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Tarefas_Processos
CREATE Procedure [dbo].[spATL_Tarefas_Processos_InsUpd]
(
	@ID_TP			int,
	@Num_Proc		Varchar(16),
	@ID_Task		int,
	@Dt_Conclusao	Datetime,
	@Dt_Previsao	Datetime,
	@Cd_Usuario		Varchar(6),
	@Dt_Insert		Datetime,
	@Cd_Pes_Grupo	varChar(10)
)

as

BEGIN TRANSACTION
	
	--Set @Id_task=(select Id_task from tipo_tarefas where 
	--nome_task=@Nome_task and modal=left(@num_proc,2) and (cd_pes_grupo = @Grupo or cd_pes_grupo='10017'))
	
	if convert(datetime,convert(varchar(10),@Dt_Conclusao,103),103) > convert(datetime,convert(varchar(10),getdate(),103),103)
		begin
			ROLLBACK TRANSACTION
		end
	else		
		BEGIN
			UPDATE 
				TAREFAS_PROCESSOS
			SET
				Dt_Conclusao=@Dt_Conclusao,
				Cd_Usuario=@cd_usuario
			WHERE
				Num_Proc=@NUM_Proc and id_task=@ID_Task
		END

	IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END

COMMIT TRANSACTION

GO
