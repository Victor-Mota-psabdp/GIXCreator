SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from Voo_Exp
--[spVEA_Sel]'EAATL201806013BR'
CREate PROCEDURE [dbo].[spVEA_Sel]--'EAATL201806013BR'
(
	@Processo	VarChar(16)
)
AS
	Select 
		HOU.Item				Item,
		Orig.Nome_Local 		Loading,
		Destin.Nome_Local 		Delivery,
		Cia.Nome_Cia_Aer 		Cia_Aerea,
		HOU.Voo		 			Voo,		
		HOU.ETA 				ETA,
		HOU.ETD 				ETD,
		HOU.ATA 				ATA,
		HOU.ATD 				ATD,
		USR.Nome_Usuario		Usuario	
	From  
		Voo_Exp HOU
		Left Outer Join Cia_Aerea	Cia			on HOU.cd_CiaAerea		= Cia.Cd_Cia_Aer
		Left Outer Join Usuario		USR			on HOU.Cd_Usuario		= USR.Cd_Usuario
		Left Outer Join Localidade	Orig		on HOU.Cd_Org			= Orig.Cd_Local 
		Left Outer Join Localidade	Destin		on HOU.Cd_Dst			= Destin.Cd_Local 		
	Where
		HOU.Num_Proc= @Processo
	order by HOU.Item


GO
