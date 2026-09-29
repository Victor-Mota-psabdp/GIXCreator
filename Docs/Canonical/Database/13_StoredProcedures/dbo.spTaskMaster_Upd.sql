SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spTaskMaster_Upd]
	@Num_Proc		Varchar(16),
	@Nome_Task		VarChar(30),
	@Dt_Conclusao	Datetime,
	@Usuario		VarChar(50),
	@Grupo			Char(3)
as

BEGIN TRANSACTION
	
	Declare @ID_Task	int
	Declare @Cd_Usuario	Varchar(15)
	declare @cd_Pes_Grupo varchar(10)

	set @cd_Pes_Grupo = (select Cd_Pes_Grupo from grupo where grupo=@grupo)
	Set @Id_task=(select Id_task from tipo_tarefas_master where nome_task=@Nome_task and modal=left(@num_proc,2) and (cd_pes_grupo = @cd_Pes_Grupo or cd_pes_grupo='10017'))
	Set @Cd_Usuario=(select Cd_Usuario from Usuario where Nome_usuario = @Usuario)

	BEGIN
		UPDATE 
			TAREFAS_MASTER
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
