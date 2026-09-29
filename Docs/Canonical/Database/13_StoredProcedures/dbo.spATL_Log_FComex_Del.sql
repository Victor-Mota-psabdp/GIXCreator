SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE Procedure [dbo].[spATL_Log_FComex_Del]
        @Num_Proc   varchar(16)
AS
Begin Transaction
					Begin
						Delete
						From  Log_FComex  
						Where Num_Proc = @Num_Proc 
					End
  
if @@error <> 0
		Begin

			RollBack Transaction
			return 0
		End

Commit Transaction

GO
