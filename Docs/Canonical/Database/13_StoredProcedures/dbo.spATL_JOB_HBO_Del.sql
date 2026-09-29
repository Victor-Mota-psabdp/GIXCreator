SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_JOB_HBO_Del] 

	@Num_Proc_HBO	VarChar(16),
	@Num_Proc		VarChar(16)
AS

BEGIN TRANSACTION

	IF EXISTS(SELECT Num_Proc_HBO FROM job_hbo H where H.Num_Proc_HBO = @Num_Proc_HBO and H.Num_proc = @Num_Proc)
		BEGIN
			delete JOB_HBO WHERE Num_Proc_HBO = @Num_Proc_HBO and Num_proc = @Num_Proc
		END
		

	IF @@Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END

COMMIT TRANSACTION

GO
