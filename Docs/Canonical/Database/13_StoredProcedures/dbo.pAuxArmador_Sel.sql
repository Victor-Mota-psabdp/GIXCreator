SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pAuxArmador_Sel
(
@Cd_Arm_Ofc 			VarChar(4)='', 
@Descricao_Armador		VarChar(60)=''
)
AS
	If @Cd_Arm_Ofc <> '' 
		Select 
			*
		From 
			Aux_Armador 
		Where
			Cd_Arm_Ofc = @Cd_Arm_Ofc 
	Else
		Select 
			*
		From 
			Aux_Armador 
		Where
			Descricao_Armador like @Descricao_Armador



GO
