SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO






CREATE PROCEDURE pVolExpAer_Del
(
@Num_Proc_HEA		varchar(16),
@Item_EA 			varchar(2)
)
 AS
	Delete
		Volume_Exp_Aer
	Where 
		Item_EA = @Item_EA and  
		@Num_Proc_HEA = Num_Proc_HEA
GO
