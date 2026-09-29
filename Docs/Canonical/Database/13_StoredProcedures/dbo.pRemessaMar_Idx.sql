SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pRemessaMar_Idx 

AS
	Select 
		Num_Ref_RM
	From 
		Remessa_Mar
	Order by 
		Num_Ref_RM Desc

GO
