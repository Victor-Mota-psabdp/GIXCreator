SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pCtaCtbPessoa_Sel    Script Date: 17/10/2002 07:32:47 ******/
CREATE PROCEDURE pCtaCtbPessoa_Sel 
(
@Cd_Cta_Ctb		VarChar(13) =''
)
 AS
	If @Cd_Cta_Ctb <> '' 
		Select 
			Nome_Cta_Ctb, Cd_Cta_Ctb 
		From  
			Cta_Ctb 
		Where  	
			(Left(Cd_Cta_Ctb, 8) = '2.1.5.01' or 
			Left(Cd_Cta_Ctb, 8) = '2.1.5.02') and 
			Len(Cd_Cta_Ctb) = 13 and Ck_Lanc = 'S'  and 
			Cd_Cta_Ctb = @Cd_Cta_Ctb
	Else
		Select 
			Nome_Cta_Ctb, Cd_Cta_Ctb 
		From  
			Cta_Ctb 
		Where  	
			(Left(Cd_Cta_Ctb, 8) = '2.1.5.01' or 
			Left(Cd_Cta_Ctb, 8) = '2.1.5.02') and 
			Len(Cd_Cta_Ctb) = 13 and Ck_Lanc = 'S' 
		Order by 
			Cd_Cta_Ctb



GO
