SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE pVolImpMar_Del
(
@Num_Proc_HIM		varchar(16),
@Item_IM 			varchar(2)
)
 AS
	Delete
		Volume_Imp_Mar
	Where 
		Item_IM = @Item_IM and  
		@Num_Proc_HIM = Num_Proc_HIM



GO
