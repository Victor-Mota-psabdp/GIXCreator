SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vwHEM_Sel] 

AS
Select  DISTINCT
		HOU.Num_Proc_HEM		[01_BDP Reference],
		HOU.MAWB_HEM 			[02_MBL Number],
		HOU.HAWB_HEM 			[03_HBL Number],
		HOU.Num_Proc_MEM		[04_Consol Reference],
		Ship.Apelido 			[05_Shipper Name],
		Consig.Apelido 			[06_Consignee Name],
		Cia.Nome_Armador 		[07_Carrier Name],
		Orig.Nome_Local 		[08_Loading],
		Destin.Nome_Local 		[09_Delivery],
		DstFinal.Nome_Local 	[10_Final Destination],
		HOU.Navio_HEM 			[11_Vessel Name],
		LLP.Courier_Number_LEM	[12_Courier Number],
		LLP.ETD_LEM 			[13_ETD Date],
		LLP.ETA_LEM 			[14_ETA Date],
		LLP.ATD_LEM 			[15_ATD Date],
		LLP.ATA_LEM 			[16_ATA Date],
		Obs_HEM					[17_Note (OBS)],
		PO.Numero_PO_HEM		[18_PO Number],
		INV.Numero_PO_HEM		[19_Invoice Number],
		SO.Numero_PO_HEM		[20_Sales Order],
		RE.Numero_PO_HEM		[21_RE Number],
		CM.Num_cont_EM			[22_Container],
		Ship.Num_CPF_CNPJ		[23_CNPJ],
		JOB.Nr_Reserva			[24_Booking],
		NTF.Apelido				[25_Notify Name]		
	From
		House_exp_Mar			HOU		with(nolock)
		Join Pessoa				Consig	with(nolock)	on Cd_Consig_HEM = Consig.Cd_Pes
		Join Pessoa				Ship	with(nolock)	on Cd_Export_HEM = Ship.Cd_Pes
		Join Pessoa				NTF		with(nolock)	on HOU.Cd_Notify_HEM = NTF.Cd_Pes
		Join Localidade			Orig	with(nolock)	on Cd_Org_HEM = Orig.Cd_Local
		Join Localidade			Destin	with(nolock)	on Cd_Dst_HEM = Destin.Cd_Local
		left Join PO_HEM		PO		with(nolock)	on PO.Num_proc_HEM = HOU.Num_proc_HEM and PO.ID_DC='1'
		left Join PO_HEM		INV		with(nolock)	on INV.Num_proc_HEM = HOU.Num_proc_HEM and INV.ID_DC='2'
		left Join PO_HEM		SO		with(nolock)	on SO.Num_proc_HEM = HOU.Num_proc_HEM and SO.ID_DC='3'
		left Join PO_HEM		RE		with(nolock)	on RE.Num_proc_HEM = HOU.Num_proc_HEM and RE.ID_DC='4'
		Join LLP_Exp_Mar		LLP		with(nolock)	on HOU.Num_proc_HEM = LLP.Num_proc_LEM
		Join JOB_Exp_Mar		JOB		with(nolock)	on HOU.Num_proc_HEM = JOB.Num_proc_HEM
		Left Join Armador		Cia		with(nolock)	on LLP.cd_armador_LEM = Cia.Cd_armador
		Left Join Localidade	DstFinal	with(nolock) on LLP.cd_dstfinal_LEM = Dstfinal.cd_local
		Left Join Container_hou_exp_mar CH	with(nolock) on num_proc_lem=CH.num_proc_hem
		Left Join Container_mas_exp_mar CM	with(nolock) on CH.num_proc_mem=CM.num_proc_mem and CH.item_cont_em=CM.item_cont_em

GO
