SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Tarefas_Processos_Temp
CREATE PROCEDURE [dbo].[spATLANTIS_Tarefas_Processos_Temp_InsUpd]
(
	@ID				BIGINT,	
	@ID_House_Temp	varchar(200),
	@ID_Req			varchar(200),
	@Intl_Reference	varchar(200),
	@Num_Proc		varchar(200),
	@ID_TP_Temp		varchar(200),
	@ID_Task		varchar(200),
	@Name_Task		varchar(200),
	@Dt_Conclusao	varchar(200),
	@Dt_Previsao	varchar(200),
	@cd_usuario		varchar(200),
	@Dt_Insert		varchar(200)
)

AS

	
BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Tarefas_Processos_Temp
	BEGIN TRY
	
	Declare @ID_New as bigint;

	if not exists(select ID from Tarefas_Processos_Temp  with(nolock)
		where 
			ID = @ID and Name_Task = @Name_Task)
		BEGIN
			insert into Tarefas_Processos_Temp
			(
				ID_House_Temp,ID_Req,Intl_Reference,Num_Proc,ID_TP_Temp,ID_Task,
				Name_Task,Dt_Conclusao,Dt_Previsao,cd_usuario,Dt_Insert,
				ID
			)
			Values
			(
				@ID_House_Temp,@ID_Req,@Intl_Reference,@Num_Proc,@ID_TP_Temp,
				@ID_Task,@Name_Task,@Dt_Conclusao,@Dt_Previsao,@cd_usuario,@Dt_Insert
				,@ID

			)
			
			set @ID_New = @ID;
			
		END
	else
		BEGIN
			update
				Tarefas_Processos_Temp
			set
				ID_House_Temp=@ID_House_Temp,
				ID_Req=@ID_Req,
				Intl_Reference=@Intl_Reference,
				Num_Proc=@Num_Proc,
				ID_TP_Temp=@ID_TP_Temp,
				ID_Task=@ID_Task,
				Name_Task=@Name_Task,
				Dt_Conclusao=@Dt_Conclusao,
				Dt_Previsao=@Dt_Previsao,
				cd_usuario=@cd_usuario,
				Dt_Insert=@Dt_Insert
			where
				ID = @ID and Name_Task = @Name_Task
				
			set @ID_New = @ID
		
		END
		
	
	Select @ID_New as Retorno;

		
		--COMMIT TRAN
	END TRY

	BEGIN CATCH
		--ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	

END

GO
