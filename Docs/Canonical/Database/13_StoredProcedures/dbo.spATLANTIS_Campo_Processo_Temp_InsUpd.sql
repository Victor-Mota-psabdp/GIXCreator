SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Campo_Processo_Temp
CREATE PROCEDURE [dbo].[spATLANTIS_Campo_Processo_Temp_InsUpd]
(
	@ID						BIGINT,				
	@ID_House_Temp			BIGINT,
	@ID_Req					BIGINT,
	@Intl_Reference			varchar(200),
	@Num_Proc				varchar(200),
	@Id_Campo				varchar(200),
	@Name_Id_Campo			varchar(200),
	@Campo_Dados			varchar(200),
	@cd_usuario				varchar(200),
	@Dt_Insert				varchar(200)
)

AS

	
BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Campo_Processo_Temp
	BEGIN TRY
	
	Declare @ID_New as bigint;

	if not exists(select ID from Campo_Processo_Temp 
		where ID = @ID 
			and Name_Id_Campo = @Name_Id_Campo) 
			--AND Id_Campo = @ID_Campo)
		BEGIN
			insert into Campo_Processo_Temp
			(
				ID,ID_House_Temp,ID_Req,Intl_Reference,Num_Proc,
				Id_Campo,Name_Id_Campo,Campo_Dados,cd_usuario,Dt_Insert
			)
			Values
			(
				@ID,@ID_House_Temp,@ID_Req,@Intl_Reference,@Num_Proc,
				@Id_Campo,@Name_Id_Campo,@Campo_Dados,@cd_usuario,@Dt_Insert
			)
			
			set @ID_New = @ID;
			
		END
	else
		BEGIN
			update
				Campo_Processo_Temp
			set
				--ID_House_Temp=@ID_House_Temp,
				--ID_Req=@ID_Req,
				--Intl_Reference=@Intl_Reference,
				Num_Proc=@Num_Proc,
				--Name_Id_Campo=@Name_Id_Campo,
				--Name_Reference=@Name_Reference,
				Campo_Dados=@Campo_Dados,
				cd_usuario=@cd_usuario,
				Dt_Insert=@Dt_Insert
			where
				ID = @ID 
				and Name_Id_Campo = @Name_Id_Campo
				
			set @ID_New = @ID
		
		END
		
	
	Select @ID as Retorno;

		
		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	

END

GO
