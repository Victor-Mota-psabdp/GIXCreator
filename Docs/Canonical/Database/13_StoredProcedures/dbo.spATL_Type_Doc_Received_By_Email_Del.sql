SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spATL_Type_Doc_Received_By_Email_Del]
( 
	@ID					bigint
 )
  
AS
BEGIN

	If exists (select ID from ATL_INT.[dbo].Type_Doc_Received_By_Email where ID = @ID)
		Begin
			Update
				ATL_INT.[dbo].Type_Doc_Received_By_Email
			Set				
				Ativo =0				
			Where
				ID = @ID
		END

END

GO
