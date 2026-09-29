SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spTask_PO_Req_Date_Upd]
		@Num_Proc		Varchar(16),
		@PO_Req_Date	Datetime

as

BEGIN TRANSACTION	
	
		BEGIN
			update LLP_BDP_OUT 
			set PO_Req_Date = @PO_Req_Date
            where num_proc_LBO = @Num_Proc 
		END

	IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END

COMMIT TRANSACTION	
GO
