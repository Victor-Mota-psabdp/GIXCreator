SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pTipoComunicacao_Sel    Script Date: 17/10/2002 07:32:52 ******/
CREATE PROCEDURE pTipoComunicacao_Sel 
(
@Cd_Tp_Com 		VarChar(3)='', 
@Nome_Tp_Com	VarChar(30)=''
)
 AS	
	If @Cd_Tp_Com <>  '' 
		Select 
			*
		From 
			Tipo_Comunicacao 
		Where
			Cd_Tp_Com = @Cd_Tp_Com
	Else
		Begin 
			If @Nome_Tp_Com <> ''
				Select 
					*
				From 	
					Tipo_Comunicacao 
				Where
					Nome_Tp_Com = @Nome_Tp_Com
			Else
				Select 
					*
				From 	
					Tipo_Comunicacao 
				Order by
					Nome_Tp_Com
		End



GO
