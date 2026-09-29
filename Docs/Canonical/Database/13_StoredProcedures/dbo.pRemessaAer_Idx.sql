SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pRemessaAer_Idx 

AS
	Select 
		Num_Ref_RA
	From 
		Remessa_Aer 
	Order by 
		Num_Ref_RA Desc 

GO
