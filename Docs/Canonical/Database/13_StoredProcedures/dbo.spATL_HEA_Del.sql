SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_HEA_Del]
(
	@Num_Proc	VarChar(16)
)
			
AS
Begin Transaction

If Exists(Select Num_Proc_Lea from LLP_Exp_Aer where Num_Proc_Lea = @Num_Proc)
	Begin
		update LLP_Exp_Aer set ID_Status = 9 where Num_Proc_Lea = @Num_Proc
	End

			
Commit Transaction

GO
