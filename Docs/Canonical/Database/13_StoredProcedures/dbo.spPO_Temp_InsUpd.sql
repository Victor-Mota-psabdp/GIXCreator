SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPO_Temp_InsUpd]
(
	@ID						BIGINT,				
	@ID_House_Temp			BIGINT,
	@ID_Req					BIGINT,
	@Intl_Reference			varchar(200),
	@Num_Proc				varchar(200),
	@ID_PO_Temp				varchar(200),
	@Numero_PO_Temp			varchar(200),
	@Name_Reference			varchar(200),
	@Data_PO_Temp			varchar(200),
	@ID_DC					varchar(200),
	@cd_usuario				varchar(200),
	@dt_ins					varchar(200)
)

AS

	
BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help PO_Temp
	BEGIN TRY
	
	Declare @ID_New as bigint;

	if not exists(select ID from PO_Temp with(nolock) 
		where 
			ID = @ID 
			and Numero_PO_Temp = @Numero_PO_Temp and Name_Reference = @Name_Reference)
			--AND ID_PO_Temp = @ID_PO_Temp)
		BEGIN
			insert into PO_Temp
			(
				ID,ID_House_Temp,ID_Req,Intl_Reference,Num_Proc,
				ID_PO_Temp,Numero_PO_Temp,Name_Reference,Data_PO_Temp,
				ID_DC,cd_usuario,dt_ins
			)
			Values
			(
				@ID,@ID_House_Temp,@ID_Req,@Intl_Reference,@Num_Proc,
				@ID_PO_Temp,@Numero_PO_Temp,@Name_Reference,@Data_PO_Temp,
				@ID_DC,@cd_usuario,@Dt_Ins
			)
			
			set @ID_New = @ID;
			
		END
	else
		BEGIN
			update
				PO_Temp
			set
				--ID_House_Temp=@ID_House_Temp,
				--ID_Req=@ID_Req,
				--Intl_Reference=@Intl_Reference,
				Num_Proc=@Num_Proc,
				--Numero_PO_Temp=@Numero_PO_Temp,
				--Name_Reference=@Name_Reference,
				Data_PO_Temp=@Data_PO_Temp,
				ID_DC=@ID_DC,
				cd_usuario=@cd_usuario,
				dt_ins=@dt_ins
			where
				--ID= @ID AND	ID_PO_Temp=@ID_PO_Temp
				ID = @ID 
				and Numero_PO_Temp = @Numero_PO_Temp and Name_Reference = @Name_Reference
				
			set @ID_New = @ID
		
		END
		
	
	Select @ID_New as Retorno;

		
		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	

END

GO
