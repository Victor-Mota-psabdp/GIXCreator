SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spATL_Volume_Exp_Aer_Del]
(
@Num_Proc		varchar(16),
@Item 			varchar(2)
)
 AS
	Delete
		Volume_Exp_Aer
	Where 
		Item_EA = @Item and  
		Num_Proc_HEA = @Num_Proc

GO
