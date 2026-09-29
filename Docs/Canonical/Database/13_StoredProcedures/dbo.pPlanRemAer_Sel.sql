SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE pPlanRemAer_Sel 
(
@StrMachine		VarChar(25)
)
AS
	Select 
		*
	From 
		Tmp_Plan_Rem 
	Where 
		StrMachine = @StrMachine

GO
