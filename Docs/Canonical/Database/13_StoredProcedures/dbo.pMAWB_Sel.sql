SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.pMAWB_Sel    Script Date: 17/10/2002 07:32:50 ******/
CREATE PROCEDURE pMAWB_Sel 
(
@MAWB_ID		Int=Null, 
@Status 		Char(1)=''
)
AS
	If @MAWB_ID = Null 
		Select * From Imp_MAWB Where IMAWB_Status = @Status 
	Else
		Select * From Imp_MAWB Where IMAWB_ID = @MAWB_ID



GO
