SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE pTipoMoeda_Sel
(
@Cd_Tp_Moeda	VarChar(3)=''
)
AS
	If @Cd_Tp_Moeda = ''
		Select 
			TM.*, AM.Nome_Moeda as Nome_Moeda_Oficial
		From 
			Tipo_Moeda as TM Left Outer Join Aux_Moeda as AM on TM.Cd_Moeda_Ofc = AM.Cd_Moeda_Ofc
		Order by 
			Cd_Tp_Moeda
	Else
		Select 
			TM.*, AM.Nome_Moeda as Nome_Moeda_Oficial
		From 
			Tipo_Moeda as TM Left Outer Join Aux_Moeda as AM on TM.Cd_Moeda_Ofc = AM.Cd_Moeda_Ofc
		Where
			Cd_Tp_Moeda = @Cd_Tp_Moeda
		Order by 
			Cd_Tp_Moeda
		



GO
