SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_JOB_HBO_InsUpd]

	@Num_Proc_HBO	VarChar(16),
	@Num_Proc		VarChar(16),	
	@cd_usuario		varchar(25)
	
AS

BEGIN TRANSACTION

	IF not EXISTS(SELECT Num_Proc_HBO FROM job_hbo H where H.Num_Proc_HBO = @Num_Proc_HBO and H.Num_proc = @Num_Proc)
		BEGIN		
			INSERT INTO				
				JOB_HBO
				(
					Num_Proc_HBO,Num_proc,cd_usuario,dt_ins					
				)
			VALUES
				(
					@Num_Proc_HBO,@Num_Proc,@Cd_Usuario,Getdate()					
				)
		END
		
	IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

COMMIT TRANSACTION




GO
