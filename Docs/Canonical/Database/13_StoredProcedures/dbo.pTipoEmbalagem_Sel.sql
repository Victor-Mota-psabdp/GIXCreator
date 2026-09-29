SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE pTipoEmbalagem_Sel 
(
@Cd_Tp_Embal		VarChar(3)='', 
@Nome_Tp_Embal	VarChar(30)=''
)
 AS
	If @Cd_Tp_Embal <> '' 
		Select 
			* , Nome_Embalagem
		From 
			Tipo_Embalagem Left Outer Join Aux_Embalagem on Tipo_Embalagem.Cd_Embal_Ofc = Aux_Embalagem.Cd_Embal_Ofc
		Where
			Cd_Tp_Embal = @Cd_Tp_Embal
	Else
		Begin 
			If @Nome_Tp_Embal <>  '' 
				Select 
					* , Nome_Embalagem
				From 
					Tipo_Embalagem Left Outer Join Aux_Embalagem on Tipo_Embalagem.Cd_Embal_Ofc = Aux_Embalagem.Cd_Embal_Ofc
				Where
					Nome_Tp_Embal = @Nome_Tp_Embal
			Else
				Select 
					* , Nome_Embalagem
				From 
					Tipo_Embalagem Left Outer Join Aux_Embalagem on Tipo_Embalagem.Cd_Embal_Ofc = Aux_Embalagem.Cd_Embal_Ofc
				Order by 
					Nome_Tp_Embal
		End



GO
