SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE pNCM_Sel 
(
@NCM			VarChar(9)='', 
@Descr_NCM		VarChar(121)=''
)
AS
	If @NCM <> '' 
		Begin 
			If Len(@NCM) = 8 
				Select 
					*
				From 	
					NCM
				Where
					NCM = @NCM 
			Else 
				Select 
					*
				From 	
					NCM
				Where
					NCM like @NCM + '%'
		End 
	Else 
		Begin
			If @Descr_NCM <> ''
				Select 
					*
				From 
					NCM
				Where
					Descricao_NCM like  '%' + @Descr_NCM + '%'	
			Else 
				Select 
					*
				From 
					NCM
				Order by 
					NCM
		End



GO
