SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--alter table ATL_INT.dbo.Exchange_ODS add [Error_Message] varchar(MAX) NULL
Create Procedure [dbo].[spExchange_Exchange_ODS_Upd]
		@Num_Proc			Varchar(16),
		@Error_Message		Varchar(MAX)
AS

Begin Transaction

	update ATL_INT.dbo.Exchange_ODS set excdtenvio=getdate(), Error_Message = @Error_Message 
		where excprocesso=@Num_PRoc and excdtenvio is null			

	if @@error <> 0
		Begin
			RollBack Transaction
			return 0
		End

Commit Transaction
GO
