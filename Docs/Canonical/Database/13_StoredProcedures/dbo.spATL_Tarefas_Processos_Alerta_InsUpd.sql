SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--SP_HELP Tarefas_Processos_Alerta
CREATE Procedure [dbo].[spATL_Tarefas_Processos_Alerta_InsUpd]
(
	@ID_TP			int,
	@Num_Proc		Varchar(16),
	@ID_Task		int,
	@Dt_Conclusao	Datetime,
	@Dt_Previsao	Datetime,
	@Cd_Usuario		Varchar(6),
	@Dt_Insert		Datetime,
	@Cd_Pes_Grupo	varChar(10),
	@ID_Alerta		bigint,
	@Dt_Envio		Datetime
)

as

BEGIN TRANSACTION	
		
		if exists(select id_task from Tarefas_Processos_Alerta WHERE Num_Proc=@NUM_Proc and id_task=@ID_Task and ID_Alerta= @ID_Alerta)
			BEGIN
				UPDATE 
					Tarefas_Processos_Alerta
				SET
					--Dt_Previsao=@Dt_Previsao,
					--Dt_Conclusao=@Dt_Conclusao,
					--Cd_Usuario=@cd_usuario,
					Dt_Envio = @Dt_Envio
				WHERE
					Num_Proc=@NUM_Proc and id_task=@ID_Task and ID_Alerta= @ID_Alerta
			END
		else
			BEGIN
				Insert into Tarefas_Processos_Alerta
					(Num_Proc,ID_Task,Dt_Conclusao,Dt_Previsao,Cd_Usuario,ID_Alerta,Dt_Envio)
				Values
					(@Num_Proc,@ID_Task,@Dt_Conclusao,@Dt_Previsao,@Cd_Usuario,@ID_Alerta,@Dt_Envio)
			END
		

	IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END

COMMIT TRANSACTION	

GO
