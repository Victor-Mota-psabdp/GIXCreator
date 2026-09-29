SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[vwMasterEA_Sel]

AS
Select
		LLP.Num_Proc_Master		[01 BDP Reference],
		MAS.MAWB_MEA			[02 MAWB Number],
		Ship.Apelido 			[03 Shipper Name],
		Consig.Apelido 			[04 Consignee Name],
		NTF.Apelido 			[05 Notify Name],
		Orig.Nome_Local 		[06 Airport of Loading],
		Destin.Nome_Local 		[07 Airport of Departure],
		CAR.Nome_Cia_Aer		[08 Carrier Name],
		MAS.Voo_MEA 			[09 Flight #],
		LLP.ETD_Master			[10 ETD Date],
		LLP.ATD_Master			[11 ATD Date],
		LLP.ETA_Master			[12 ETA Date],
		LLP.ATA_Master			[13 ATA Date],
		MAS.Obs_MEA				[14 Note (OBS)]
	From
		Master_Exp_Aer  MAS
		Join LLP_Master		LLP		on MAS.Num_Proc_MEA	= LLP.Num_Proc_Master
		Join Pessoa			Ship	on Cd_Export_MEA 	= Ship.Cd_Pes
		Join Pessoa			Consig	on Cd_Consig_MEA 	= Consig.Cd_Pes
		Left Join Pessoa			NTF		on LLP.Cd_Notify 	= NTF.Cd_Pes
		Join Localidade		Orig	on Cd_Org_MEA 		= Orig.Cd_Local
		Join Localidade		Destin	on Cd_Dst_MEA 		= Destin.Cd_Local
		Left Join Cia_Aerea			CAR		on MAS.Cd_Cia_Aer	= CAR.Cd_Cia_Aer

GO
