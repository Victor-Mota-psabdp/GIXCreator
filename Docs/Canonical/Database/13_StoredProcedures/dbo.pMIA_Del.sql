SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pMIA_Del
(
@Num_Proc_MIA		varchar(14) 
)
AS
		Delete
			Master_Imp_Aer
		Where 
			Num_Proc_MIA = @Num_Proc_MIA
		If @@RowCount <> 1 
			Return - 2
		Else
			Return 1



GO
