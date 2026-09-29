SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pTmp_Lucrat_Rel 
(
@StrMachine		VarChar(30)
)
AS
	Select 
		* 
	From 
		TMP_Lucrat 
	Where
		StrMachine = @StrMachine 
	Order by 
		Cliente

GO
