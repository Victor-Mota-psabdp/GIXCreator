SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spLog_InsertJOB_Reference_Rules_InsUpd]
(
	@ID_Log							bigint,
	@Dt_Alter						Datetime,

	@ID						bigint,
	@Cd_Pes_Grupo			varchar(10),
	@Modal					varchar(2),
	@ID_DC					int, 
	@Cd_Usuario				varchar(10),
	@Status					bit
)

AS

BEGIN
	BEGIN TRY
		Declare @ID_New as bigint;
		BEGIN		    
			IF not exists(select ID_Log from LOG_InsertJOB_Reference_Rules where ID_Log = @ID_Log)
				begin
					insert into LOG_InsertJOB_Reference_Rules
					(						
						[Dt_Alter] ,
						ID,Cd_Pes_Grupo, Modal,ID_DC,Cd_Usuario,Status
					)
					values
					(			
						Getdate(),
						@ID,@Cd_Pes_Grupo, @Modal,@ID_DC,@Cd_Usuario,@Status
					)
					set @ID_New = @@IDENTITY
				  End
			ELSE
				begin
					UPDATE
						LOG_InsertJOB_Reference_Rules
					SET
						ID = @ID,
						Cd_Pes_Grupo=@Cd_Pes_Grupo,
						Modal= @Modal,
						ID_DC=@ID_DC,
						Cd_Usuario=@Cd_Usuario,
						Status = @Status	
					WHERE
						ID_Log = @ID_Log
						set @ID_New = @ID_Log									
				 End
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
