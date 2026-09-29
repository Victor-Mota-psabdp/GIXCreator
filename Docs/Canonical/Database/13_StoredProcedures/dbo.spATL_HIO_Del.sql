SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_HIO_Del]
(
	@Num_Proc	VarChar(16)
)
			
AS
Begin Transaction

If Exists(Select Num_Proc_LiO from LLP_Imp_OUT where Num_Proc_LiO = @Num_Proc)
	Begin
		update LLP_Imp_OUT set ID_Status = 9 where Num_Proc_LiO = @Num_Proc
	End

			
Commit Transaction

GO
