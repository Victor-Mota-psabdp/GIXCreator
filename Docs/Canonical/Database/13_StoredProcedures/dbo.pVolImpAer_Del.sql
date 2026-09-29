SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pVolImpAer_Del
(
@Num_Proc_HIA		varchar(16),
@Item_IA 			varchar(2)
)
 AS
	Delete
		Volume_Imp_Aer
	Where 
		Item_IA = @Item_IA and  
		Num_Proc_HIA = @Num_Proc_HIA

GO
