SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spATL_Volume_Imp_Out_Del]
(
@Num_Proc		varchar(16),
@Item			varchar(2)
)
 AS
	Delete
		Volume_Imp_Out
	Where 
		Item_IO = @Item  and  
		Num_Proc_HIO = @Num_Proc 

GO
