SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spTaskProc_LerXML_Upd]
		@Num_Proc		Varchar(16),
		@Id_task		Int,
		@Dt_Conclusao	Datetime,
		@Cd_Usuario	Varchar(6)

as



BEGIN TRANSACTION	

	if @Dt_Conclusao > getdate()
		begin
		--100-150182 - Alterado 19/09 
		set  @Dt_Conclusao =  @Dt_Conclusao
			--ROLLBACK TRANSACTION
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
				
			Insert into Log_Tarefas_Processos 
				Values(@NUM_Proc,@ID_Task,@Dt_Conclusao,Null,@cd_usuario,GETDATE(),'spTaskProc_LerXML_Upd')
		END		
		
	IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END

COMMIT TRANSACTION	






GO
