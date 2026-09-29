SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spATL_Volume_Imp_Aer_Del]
(
@Num_Proc		varchar(16),
@Item			varchar(2)
)
 AS
	Delete
		Volume_Imp_Aer
	Where 
		Item_IA = @Item and  
		Num_Proc_HIA = @Num_Proc

GO
