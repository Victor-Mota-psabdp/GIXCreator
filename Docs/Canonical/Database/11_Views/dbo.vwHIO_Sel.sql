SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vwHIO_Sel] 

AS
	Select  
		HOU.Num_Proc_HIO		[01_BDP Reference],
		LLP.Canal_LIO 			[02_Channel],
		HOU.HAWB_HIO 			[03_HAWB Number],
		''						[04_Consol Reference],
		Ship.Apelido 			[05_Shipper Name],
		Consig.Apelido 			[06_Consignee Name],
		Cia.Apelido 			[07_Carrier Name],
		Orig.Nome_Local 		[08_Loading],
		Destin.Nome_Local 		[09_Delivery],
		DstFinal.Nome_Local 	[10_Final Destination],
		HOU.Voo_HIO 			[11_Vagon #],
		LLP.Courier_Number_LIO	[12_Courier Number],
		LLP.ETD_LIO 			[13_ETD Date],
		LLP.ETA_LIO 			[14_ETA Date],
		LLP.ATD_LIO 			[15_ATD Date],
		LLP.ATA_LIO 			[16_ATA Date],
		Obs_HIO					[17_Note (OBS)],
		PO.Numero_PO_HIO		[18_PO Number],
		INV.Numero_PO_HIO		[19_Invoice Number],
		SO.Numero_PO_HIO		[20_Sales Order],
		DI.Numero_PO_HIO		[21_DI Number],
		LI.Numero_PO_HIO		[22_LI Number],
		Consig.Num_CPF_CNPJ		[23_CNPJ],
		NTF.Apelido				[24_Notify Name]
	From
		House_IMP_Out			HOU
		Join Pessoa				Consig		on Cd_Consig_HIO = Consig.Cd_Pes
		Join Pessoa				Ship		on Cd_IMPort_HIO = Ship.Cd_Pes
		Join Pessoa				NTF			on HOU.Cd_Import_HIO = NTF.Cd_Pes
		Join Localidade			Orig		on Cd_Org_HIO = Orig.Cd_Local
		Join Localidade			Destin		on Cd_Dst_HIO = Destin.Cd_Local
		left Join PO_HIO		PO			on PO.Num_proc_HIO = HOU.Num_proc_HIO and PO.ID_DC='1'
		left Join PO_HIO		INV			on INV.Num_proc_HIO = HOU.Num_proc_HIO and INV.ID_DC='2'
		left Join PO_HIO		SO			on SO.Num_proc_HIO = HOU.Num_proc_HIO and SO.ID_DC='3'
		left Join PO_HIO		DI			on DI.Num_proc_HIO = HOU.Num_proc_HIO and DI.ID_DC='5'
		left Join PO_HIO		LI			on LI.Num_proc_HIO = HOU.Num_proc_HIO and LI.ID_DC='23'
		Join LLP_IMP_Out		LLP			on HOU.Num_proc_HIO = LLP.Num_proc_LIO
		Left Join Pessoa		Cia			on LLP.Cd_Carrier = Cia.Cd_Pes
		Left Join Localidade	DstFinal	on LLP.cd_dstfinal_LIO = Dstfinal.cd_local

GO
