SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pRecCtaCte_Ins    Script Date: 17/10/2002 07:32:51 ******/
CREATE PROCEDURE pRecCtaCte_Ins
(
@Num_Lcto_Mov 	VarChar(12),
@Num_Lcto_Rec	VarChar(12),
@Perc_Rec 		Float = Null
)
 AS	
	Insert Into 
		Rec_cta_cte	
		(Num_Lcto_Mov, Num_Lcto_Rec, Perc_Rec )
	Values 
		(@Num_Lcto_Mov, @Num_Lcto_Rec, @Perc_Rec)



GO
