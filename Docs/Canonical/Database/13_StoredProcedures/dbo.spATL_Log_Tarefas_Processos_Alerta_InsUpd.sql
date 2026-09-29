SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--SP_HELP Log_Tarefas_Processos_Alerta
CREATE Procedure [dbo].[spATL_Log_Tarefas_Processos_Alerta_InsUpd]
(
	@Id_Log			bigint,
	@Num_Proc		Varchar(16),
	@ID_Task		int,
	@Dt_Conclusao	Datetime,
	@Dt_Previsao	Datetime,
	@Cd_Usuario		Varchar(6),
	@Dt_Ins			Datetime,	
	@ID_Alerta		bigint,
	@Dt_Envio		Datetime,
	@Dt_Log			Datetime,
	@Log_Message	Varchar(Max)
)

as

BEGIN TRANSACTION	
	
	BEGIN
		Insert into Log_Tarefas_Processos_Alerta
			(Num_Proc,ID_Task,Dt_Conclusao,Dt_Previsao,Cd_Usuario,Dt_Ins,ID_Alerta,Dt_Envio,Dt_Log,Log_Message)
		Values
			(@Num_Proc,@ID_Task,@Dt_Conclusao,@Dt_Previsao,@Cd_Usuario,@Dt_Ins,@ID_Alerta,@Dt_Envio,@Dt_Log,@Log_Message)
	END
		

	IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END

COMMIT TRANSACTION	

GO
