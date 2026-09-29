SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE pVolExpMar_Del
(
@Num_Proc_HEM		varchar(16),
@Item_EM 			varchar(2)
)
 AS
	Delete
		Volume_Exp_Mar
	Where 
		Item_EM = @Item_EM and  
		@Num_Proc_HEM = Num_Proc_HEM



GO
