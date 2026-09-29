SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



/****** Object:  Stored Procedure dbo.pUsuario_Sel    Script Date: 17/10/2002 07:32:52 ******/
CREATE PROCEDURE pUsuario_Sel 
(
@Cod_Usuario		VarChar(6)='',
@Nome_Usuario	VarChar(30)=''
)
AS
	If @Cod_Usuario <>  '' 
		Select 
			* 
		From 
			Usuario 
		Where 
			Cd_Usuario = @Cod_Usuario  and Ck_Ativo = 1
	Else 
		Begin 
			If @Nome_Usuario <> '' 
				Select 
					* 
				From 
					Usuario 
				Where 	
					Nome_Usuario = @Nome_Usuario  and Ck_Ativo = 1
			Else
				Select 
					*
				From 
					Usuario
				Where
					Ck_Ativo = 1
				Order by 
					Cd_Usuario 
		End

GO
