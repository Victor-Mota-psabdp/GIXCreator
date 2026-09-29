SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pMINV_Sel    Script Date: 03/10/2002 12:08:10 ******/
CREATE PROCEDURE pMINV_Sel 
(
@MINV_ID		Int=Null, 
@Status 		Char(1)=''
)
AS
	If @MINV_ID = Null 
		Select * From Imp_MINV Where IMINV_Status = @Status 
	Else
		Select * From Imp_MINV Where IMINV_ID = @MINV_ID



GO
