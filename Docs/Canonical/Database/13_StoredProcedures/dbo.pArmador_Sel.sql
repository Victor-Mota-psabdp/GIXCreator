SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pArmador_Sel 
(
@Codigo 	Char(3)='', 
@Armador 	VarChar(30)=''
)
 AS
	If @Codigo <> '' 
		Select 
			Armador.*, Aux_Armador.Descricao_Armador
		From 
			Armador Left Outer Join 	Aux_Armador on Armador.Cd_Arm_Ofc = Aux_Armador.Cd_Arm_Ofc 
		Where
			Cd_Armador = @Codigo 
	Else
		Begin 
			If @Armador <> '' 
				Select 
					Armador.*, Aux_Armador.Descricao_Armador
				From 
					Armador Left Outer Join 	Aux_Armador on Armador.Cd_Arm_Ofc = Aux_Armador.Cd_Arm_Ofc 
				Where
					Nome_Armador = @Armador 
			Else
		
				Select 
					Armador.*, Aux_Armador.Descricao_Armador
				From 
					Armador Left Outer Join 	Aux_Armador on Armador.Cd_Arm_Ofc = Aux_Armador.Cd_Arm_Ofc 
				Order by 
					Nome_Armador 
		End



GO
