SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pTmpVarCambial_Sel
(
@StrMachine 	VarChar(20)
)
AS
	Select 
		*
	From 
		TMP_Var_Cambial
	Where 
		Machine = @StrMachine

GO
