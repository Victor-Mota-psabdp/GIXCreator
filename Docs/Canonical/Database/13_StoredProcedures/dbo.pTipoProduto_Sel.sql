SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pTipoProduto_Sel    Script Date: 17/10/2002 07:32:52 ******/
CREATE PROCEDURE pTipoProduto_Sel 
(
@Cd_Tp_Prod	 	Char(3)='', 
@Nome_Tp_Prod	VarChar(60)=''
)
 AS
	If @Cd_Tp_Prod <>  '' 
		Select 
			*
		From 
			Tipo_Produto
		Where
			Cd_Tp_Prod = @Cd_Tp_Prod
	Else
		Begin 
			If @Nome_Tp_Prod <> '' 
				Select 
					*
				From 
					Tipo_Produto
				Where				
					Nome_Tp_Prod = @Nome_Tp_Prod
			Else 
				Select 
					*
				From 
					Tipo_Produto
				Order by 
					Nome_Tp_Prod
		End 
		



GO
