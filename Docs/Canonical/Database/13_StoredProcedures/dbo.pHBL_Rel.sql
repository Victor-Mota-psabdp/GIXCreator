SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pHBL_Rel 
(
@Processo	VarChar(30) 
)
AS
	Select * From HBL Where Num_Proc = @Processo

GO
