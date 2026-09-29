SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pItemDemurrage_Sel 
(
@Armador		VarChar(3),
@Cd_Tp_Cont		VarChar(3)
)
AS

	Select 
		Dem.*, Arm.Nome_Armador, TM.Nome_Tp_Moeda, IDM.*
	From 
		demurrage dem join armador arm on arm.cd_armador = dem.cd_armador 
		Join item_demurrage IDM on IDM.Cd_Armador = dem.Cd_Armador and IDM.Cd_Tp_Cont = dem.Cd_Tp_Cont 
		join tipo_moeda tm on TM.Cd_Tp_Moeda = dem.cd_tp_moeda
	Where 
		Dem.Cd_Armador = @Armador  and 
		Dem.Cd_Tp_Cont = @Cd_Tp_Cont
	Order by 
		Idm_Seq

GO
