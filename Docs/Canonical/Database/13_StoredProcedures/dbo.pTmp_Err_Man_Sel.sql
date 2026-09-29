SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pTmp_Err_Man_Sel
(
@Tmp_ID_Machine	varchar(30)
)
 AS
	Select 
		*
	From 
		Tmp_Err_Man
	Where 
		Tmp_ID_Machine = @Tmp_ID_Machine



GO
