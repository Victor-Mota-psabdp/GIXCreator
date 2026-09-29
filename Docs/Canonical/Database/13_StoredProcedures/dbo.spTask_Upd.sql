SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spTask_Upd]
	@Num_Proc		Varchar(16),
	@Nome_Task		VarChar(30),
	@Dt_Conclusao	Datetime,
	@Dt_Previsao	datetime,
	@Usuario		VarChar(50),
	@Grupo			Char(10)

as
	
--BEGIN TRANSACTION
	
	Declare @ID_Task	int
	Declare @Cd_Usuario	Varchar(15)
	
	Set @Id_task=(select Id_task from tipo_tarefas with(nolock) where nome_task=@Nome_task and modal=left(@num_proc,2) and (cd_pes_grupo = @Grupo or cd_pes_grupo='10017') and Ativo = 'S')
	Set @Cd_Usuario=(select Cd_Usuario from Usuario with(nolock) where Nome_usuario = @Usuario)
--	BEGIN
		UPDATE 
			TAREFAS_PROCESSOS
		SET
			Dt_Previsao=@Dt_Previsao,
			Dt_Conclusao=@Dt_Conclusao,
			Cd_Usuario=@cd_usuario
		WHERE
			Num_Proc=@NUM_Proc and id_task=@ID_Task
--	END

--	IF @@ERROR <> 0 
--		BEGIN
--			ROLLBACK TRANSACTION
--		END
--
--COMMIT TRANSACTION	










GO
