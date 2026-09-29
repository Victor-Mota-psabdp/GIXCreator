SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[vwMasterEM_Sel]

AS
	Select
		LLP.Num_Proc_Master		[01 BDP Reference],
		MAS.MAWB_MEM			[02 MBL Number],
		Ship.Apelido 			[03 Shipper Name],
		Consig.Apelido 			[04 Consignee Name],
		NTF.Apelido 			[05 Notify Name],
		Orig.Nome_Local 		[06 Port of Loading],
		Destin.Nome_Local 		[07 Port of Discharge],
		ARM.Nome_Armador		[08 Carrier Name],
		LLP.Num_Viagem 			[09 Voyage],
		LLP.Navio				[Vessel Name],
		LLP.ETD_Master			[ETD Date],
		LLP.ATD_Master			[ATD Date],
		LLP.ETA_Master			[ETA Date],
		LLP.ATA_Master			[ATA Date],
		MAS.Obs_MEM				[Note (OBS)]
	From  
		Master_Exp_Mar  MAS
		Left Join LLP_Master		LLP		on MAS.Num_Proc_MEM	= LLP.Num_Proc_Master
		Left Join Pessoa			Ship	on Cd_Export_MEM 	= Ship.Cd_Pes
		Left Join Pessoa			Consig	on Cd_Consig_MEM 	= Consig.Cd_Pes
		Left Join Pessoa			NTF		on LLP.Cd_Notify 	= NTF.Cd_Pes
		Left Join Localidade		Orig	on Cd_Org_MEM 		= Orig.Cd_Local
		Left Join Localidade		Destin	on Cd_Dst_MEM 		= Destin.Cd_Local
		Left Join Armador			ARM		on MAS.Cd_Armador	= ARM.Cd_Armador




GO
