SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pCtaCtb_Sel    Script Date: 17/10/2002 07:32:47 ******/
CREATE PROCEDURE pCtaCtb_Sel 
(
@Cd_Cta_Ctb		VarChar(14)='',
@Nome_Cta_Ctb	Varchar(60)='',
@Ck_Lanc		Char(1) = '' 
)
 AS
	If @Cd_Cta_Ctb <> ''
		Select 
			*
		From 
			Cta_Ctb
		Where
			Cd_Cta_Ctb = @Cd_Cta_Ctb
	Else
		Begin 
			If @Nome_Cta_Ctb <> '' 
				Begin 
					If @Ck_Lanc <> ''
						Select 
							*
						From 
							Cta_Ctb
						Where			
							Nome_Cta_Ctb =  @Nome_Cta_Ctb and 
							Ck_Lanc = @Ck_Lanc		
					Else
						Select 
							*
						From 
							Cta_Ctb
						Where			
							Nome_Cta_Ctb =  @Nome_Cta_Ctb 
				End 
			Else 
				Select 
					*
				From 
					Cta_Ctb
				Order by 
					Nome_Cta_Ctb
		End



GO
