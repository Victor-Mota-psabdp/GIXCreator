SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pPais_Sel    Script Date: 04/11/2002 16:18:14 ******/
CREATE PROCEDURE pPais_Sel
(
@Pais		VarChar(15)=''
)
 AS
	If @Pais <> '' 
		Select 
			*
		From 
			Localidade 
		Where 
			Pais_Local  = @Pais 
	Else
		Select 
			Distinct Pais_Local
		From 
			Localidade



GO
