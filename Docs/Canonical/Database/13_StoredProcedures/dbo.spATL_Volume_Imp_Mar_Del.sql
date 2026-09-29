SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spATL_Volume_Imp_Mar_Del]
(
@Num_Proc		varchar(16),
@Item 			varchar(2)
)
 AS
	Delete
		Volume_Imp_Mar
	Where 
		Item_IM = @Item and  
		Num_Proc_HIM =@Num_Proc



GO
