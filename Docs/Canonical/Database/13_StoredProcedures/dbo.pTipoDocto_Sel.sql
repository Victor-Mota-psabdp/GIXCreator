SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pTipoDocto_Sel    Script Date: 17/10/2002 07:32:52 ******/
CREATE PROCEDURE pTipoDocto_Sel 
(
@Cd_Tp_Doc 		VarChar(3)='' ,
@Nome_Tp_Doc    	VarChar(30)=''
)
 AS
	If @Cd_Tp_Doc <>'' 
		Select 
			*
		From 
			Tipo_Documento 
		Where
			Cd_Tp_Doc = @Cd_Tp_Doc		
	Else
		Begin 
			If @Nome_Tp_Doc <> '' 
				Select 
					*
				From 
					Tipo_Documento 
				Where
					Nome_Tp_Doc = @Nome_Tp_Doc 
			Else 
				Select 
					*
				From 
					Tipo_Documento 
				Order by 
					Nome_Tp_Doc 
		End 
	



GO
