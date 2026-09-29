SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_HIA_Del]
(
	@Num_Proc	VarChar(16)
)
			
AS
Begin Transaction

If Exists(Select Num_Proc_Lia from LLP_Imp_Aer where Num_Proc_Lia = @Num_Proc)
	Begin
		update LLP_Imp_Aer set ID_Status = 9 where Num_Proc_Lia = @Num_Proc
	End

			
Commit Transaction

GO
