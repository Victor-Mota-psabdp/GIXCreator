SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spPOHBO_Del] 
		@Processo	VarChar(16),
		@ID_PO_HBO int
			
AS
Begin Transaction

If Exists (Select Num_Proc_HBO from PO_HBO where Num_Proc_HBO = @Processo and ID_PO_HBO=@ID_PO_HBO)
	
		Begin
			delete PO_HBO where Num_Proc_HBO=@Processo and ID_PO_HBO=@ID_PO_HBO
		End

			IF @@Error <> 0
			BEGIN
				PRINT 'ERRADO'
				ROLLBACK TRANSACTION
				RETURN -1
			END
Commit Transaction					
			












GO
