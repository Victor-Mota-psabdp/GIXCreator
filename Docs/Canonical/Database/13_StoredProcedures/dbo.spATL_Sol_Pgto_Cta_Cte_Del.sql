SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Sol_Pgto_Cta_Cte
Create Procedure [dbo].[spATL_Sol_Pgto_Cta_Cte_Del]
(
	@ID			bigint
)
			
AS
Begin Transaction

If Exists(Select ID from Sol_Pgto_Cta_Cte where ID = @ID)
	Begin
		Update Sol_Pgto_Cta_Cte set Status = 0 where ID = @ID 
	End

			
Commit Transaction

GO
