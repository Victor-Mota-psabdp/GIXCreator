SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spATL_HBO_Del]
(
	@Num_Proc	VarChar(16)
)
			
AS
Begin Transaction

If Exists(Select Num_Proc_Lbo from LLP_BDP_OUT where Num_Proc_Lbo = @Num_Proc)
	Begin
		update LLP_BDP_OUT set ID_Status = 9 where Num_Proc_Lbo = @Num_Proc
	End

			
Commit Transaction					
			















GO
