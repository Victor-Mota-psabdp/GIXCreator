SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--incluido o ampo do MBL que tem nos outros modais

CREATE view [dbo].[vwMasterIM_Sel]

AS

	Select
		LLP.Num_Proc_Master		[BDP Reference],
		MAS.MAWB_MIM			[MBL Number],
		Ship.Apelido 			[Shipper Name],
		Consig.Apelido 			[Consignee Name],
		NTF.Apelido 			[Notify Name],
		Orig.Nome_Local 		[Port od Loading],
		Destin.Nome_Local 		[Port of Discharge],
		ARM.Nome_Armador		[Carrier Name],
		MAS.Viagem_MIM 			[Voyage],
		MAS.Navio_MIM 			[Vessel Name],
		LLP.ETD_Master			[ETD Date],
		LLP.ATD_Master			[ATD Date],
		LLP.ETA_Master			[ETA Date],
		LLP.ATA_Master			[ATA Date],
		MAS.Obs_MIM				[Note (OBS)]
	From  
		Master_Imp_Mar  MAS
		Left Join LLP_Master		LLP		on MAS.Num_Proc_MIM	= LLP.Num_Proc_Master
		Left Join Pessoa			Ship	on Cd_Export_MIM 	= Ship.Cd_Pes
		Left Join Pessoa			Consig	on Cd_Consig_MIM 	= Consig.Cd_Pes
		Left Join Pessoa			NTF		on LLP.Cd_Notify 	= NTF.Cd_Pes
		Left Join Localidade		Orig	on Cd_Org_MIM 		= Orig.Cd_Local
		Left Join Localidade		Destin	on Cd_Dst_MIM 		= Destin.Cd_Local
		Left Join Armador			ARM		on MAS.Cd_Armador	= ARM.Cd_Armador



GO
