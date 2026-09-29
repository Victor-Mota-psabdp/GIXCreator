SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE pControleProc_Rel
(
@StrMachine		VarChar(30)
)
AS
	Select 
		* 
	From 
		Tmp_Cont_Proc
	Where
		StrMachine = @StrMachine
GO
