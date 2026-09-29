SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create view [dbo].[vwMasterIA_Sel]

AS
	Select
		LLP.Num_Proc_Master		[BDP Reference],
		MAS.MAWB_MIA			[MAWB Number],
		Ship.Apelido 			[Shipper Name],
		Consig.Apelido 			[Consignee Name],
		NTF.Apelido 			[Notify Name],
		Orig.Nome_Local 		[Airport of Loading],
		Destin.Nome_Local 		[Airport of Discharge],
		CAR.Nome_Cia_Aer		[Carrier Name],
		MAS.Voo_MIA 			[Flight #],
		LLP.ETD_Master			[ETD Date],
		LLP.ATD_Master			[ATD Date],
		LLP.ETA_Master			[ETA Date],
		LLP.ATA_Master			[ATA Date],
		MAS.Obs_MIA				[Note (OBS)]
	From
		Master_Imp_Aer  MAS
		Left Join LLP_Master		LLP		on MAS.Num_Proc_MIA	= LLP.Num_Proc_Master
		Left Join Pessoa			Ship	on Cd_Export_MIA 	= Ship.Cd_Pes
		Left Join Pessoa			Consig	on Cd_Consig_MIA 	= Consig.Cd_Pes
		Left Join Pessoa			NTF		on LLP.Cd_Notify 	= NTF.Cd_Pes
		Left Join Localidade		Orig	on Cd_Org_MIA 		= Orig.Cd_Local
		Left Join Localidade		Destin	on Cd_Dst_MIA 		= Destin.Cd_Local
		Left Join Cia_Aerea			CAR		on MAS.Cd_Cia_Aer	= CAR.Cd_Cia_Aer























GO
