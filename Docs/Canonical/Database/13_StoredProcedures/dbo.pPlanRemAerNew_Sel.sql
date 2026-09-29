SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[pPlanRemAerNew_Sel] 
(
@StrMachine		VarChar(25)
)
AS
	Select 
		*
	From 
		Tmp_Plan_Rem_New
	Where 
		StrMachine = @StrMachine


GO
