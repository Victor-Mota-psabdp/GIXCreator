SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pRecCtaCte_Sel    Script Date: 17/10/2002 07:32:51 ******/
CREATE PROCEDURE pRecCtaCte_Sel 
(
@Num_Lcto_Mov	VarChar(12)='', 
@Num_Lcto_Rec	VarChar(12)=''
)
 AS	
	If @Num_Lcto_Mov <> '' 
		Select 
			*
		From 
			Rec_cta_cte	
		Where 
			Num_Lcto_Mov = @Num_Lcto_Mov
	Else
		Select 
			*
		From 
			Rec_cta_cte	
		Where 
			Num_Lcto_Rec = @Num_Lcto_Rec



GO
