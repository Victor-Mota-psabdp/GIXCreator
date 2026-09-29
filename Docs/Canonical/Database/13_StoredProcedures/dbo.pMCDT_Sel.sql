SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pMCDT_Sel 
(
@MCDT_ID		Int=Null, 
@Status 		Char(1)=''
)
AS
	If @MCDT_ID = Null 
		Select * From Imp_MCDT Where IMCDT_Status = @Status 
	Else
		Select * From Imp_MCDT Where IMCDT_ID = @MCDT_ID



GO
