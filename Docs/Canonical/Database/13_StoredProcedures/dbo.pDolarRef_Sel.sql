SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pDolarRef_Sel    Script Date: 17/10/2002 07:32:49 ******/
CREATE PROCEDURE pDolarRef_Sel 
(
@Dt_DR   		VarChar(7)='', 
@Espec_DR		VarChar(5)=''
)
 AS
	If @Dt_DR  <> '' 
		Select 
			*
		From 
			Dolar_Ref
		Where
			Dt_DR = @Dt_DR and 
			Espec_DR = @Espec_DR 
	Else
		Select 
			*
		From 
			Dolar_Ref
		Order by 
			Cast(('01/' + Dt_DR) as DateTime)  ASC, Espec_DR DESC



GO
