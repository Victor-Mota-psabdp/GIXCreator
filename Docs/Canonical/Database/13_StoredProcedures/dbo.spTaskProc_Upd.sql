SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--alterado dia 7/4/2017 - 13:59h

--select convert(datetime,convert(varchar(10),'07/04/2017 10:25:20.713',103),103) 
--	, convert(datetime,convert(varchar(10),getdate(),103),103)

CREATE Procedure [dbo].[spTaskProc_Upd]
		@Num_Proc		Varchar(16),
		@Nome_Task		VarChar(30),
		@Dt_Conclusao	Datetime,
		@Usuario		VarChar(50),
		@Grupo			varChar(10)

as

BEGIN TRANSACTION



		
	Declare @ID_Task	int
	Declare @Cd_Usuario	Varchar(15)
	
	Set @Id_task=(select Id_task from tipo_tarefas where nome_task=@Nome_task and modal=left(@num_proc,2) and (cd_pes_grupo = @Grupo or cd_pes_grupo='10017'))
	Set @Cd_Usuario=(select Cd_Usuario from Usuario where Nome_usuario = @Usuario)

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
