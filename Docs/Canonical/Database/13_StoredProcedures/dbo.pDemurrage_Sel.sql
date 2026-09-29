SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pDemurrage_Sel 
(
@Armador		VarChar(3),
@Cd_Tp_Cont		VarChar(3)=''
)
AS

	If @Cd_Tp_Cont = ''
		Select 
			Dem.*, Arm.Nome_Armador, TM.Nome_Tp_Moeda, TC.*
		From 
			demurrage dem join armador arm on arm.cd_armador = dem.cd_armador 
			join tipo_moeda tm on TM.Cd_Tp_Moeda = dem.cd_tp_moeda
			Join Tipo_Container TC on TC.Cd_Tp_Cont = Dem.Cd_Tp_Cont 
		Where 
			Arm.Cd_Armador = @Armador 
	Else
		Select 
			Dem.*, Arm.Nome_Armador, TM.Nome_Tp_Moeda , TC.*
		From 
			demurrage dem join armador arm on arm.cd_armador = dem.cd_armador 
			join tipo_moeda tm on TM.Cd_Tp_Moeda = dem.cd_tp_moeda
			Join Tipo_Container TC on TC.Cd_Tp_Cont = Dem.Cd_Tp_Cont 
		Where 
			Dem.Cd_Armador = @Armador  and 
			Dem.Cd_Tp_Cont = @Cd_Tp_Cont

GO
