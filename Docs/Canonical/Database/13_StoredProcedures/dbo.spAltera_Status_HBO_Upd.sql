SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spAltera_Status_HBO_Upd]	
	@JOB		varchar(16),	
	@Status		int
	
AS

BEGIN TRANSACTION

	IF exists(select Num_Proc_LBO from LLP_BDP_OUT where Num_Proc_LBO = @JOB)
		BEGIN
			update LLP_BDP_OUT 
				SET id_Status=@Status 
			where 
				Num_Proc_LBO=@JOB
		END
	
	IF @@ERROR<>0 
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END
COMMIT TRANSACTION

GO
