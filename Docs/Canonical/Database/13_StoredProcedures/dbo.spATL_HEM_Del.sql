SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_HEM_Del]
(
	@Num_Proc	VarChar(16)
)
			
AS
Begin Transaction

If Exists(Select Num_Proc_Lem from LLP_Exp_Mar where Num_Proc_Lem = @Num_Proc)
	Begin
		update LLP_Exp_Mar set ID_Status = 9 where Num_Proc_Lem = @Num_Proc
	End

			
Commit Transaction

GO
