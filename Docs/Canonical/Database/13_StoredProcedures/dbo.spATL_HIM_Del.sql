SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_HIM_Del]
(
	@Num_Proc	VarChar(16)
)
			
AS
Begin Transaction

If Exists(Select Num_Proc_Lim from LLP_Imp_Mar where Num_Proc_Lim = @Num_Proc)
	Begin
		update LLP_Imp_Mar set ID_Status = 9 where Num_Proc_lIM = @Num_Proc
	End

			
Commit Transaction

GO
