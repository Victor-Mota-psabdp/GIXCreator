SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pHAWB_Sel    Script Date: 17/10/2002 07:32:49 ******/
CREATE PROCEDURE pHAWB_Sel 
(
@HAWB_ID		Int=Null,
@MAWB_ID		Int=Null, 
@Status 		Char(1)=''
)
AS
	If @HAWB_ID = Null 
		Begin 
			If @Status = '' 
				Select * From Imp_HAWB Where IHAWB_ID_Master = @MAWB_ID 
			Else
				Select * From Imp_HAWB Where IHAWB_ID_Master = @MAWB_ID  and IHAWB_Status = @Status 
		End 
	Else
		Select * From Imp_HAWB Where IHAWB_ID = @HAWB_ID



GO
