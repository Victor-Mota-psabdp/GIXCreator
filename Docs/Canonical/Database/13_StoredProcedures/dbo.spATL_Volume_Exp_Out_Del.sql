SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spATL_Volume_Exp_Out_Del]
(
@Num_Proc		varchar(16),
@Item 			varchar(2)
)
 AS
	Delete
		Volume_Exp_Out
	Where 
		Item_EO = @Item and  
		Num_Proc_HEO = @Num_Proc



GO
