SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spATL_Volume_Exp_Mar_Del]
(
@Num_Proc		varchar(16),
@Item 			varchar(2)
)
 AS
	Delete
		Volume_Exp_Mar
	Where 
		Item_EM = @Item and  
		Num_Proc_HEM = @Num_Proc 



GO
