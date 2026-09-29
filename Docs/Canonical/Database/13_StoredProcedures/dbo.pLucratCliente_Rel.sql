SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pLucratCliente_Rel
(
@StrMachine		VarChar(30)
)
AS
	Select 
		* 
	From 
		TMP_Lucrat_Pos
	Where
		StrMachine  = @StrMachine

GO
