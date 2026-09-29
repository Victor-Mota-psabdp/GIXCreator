SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vwHIA_Sel] 

AS
Select  
--House_exp_mar
		HOU.Num_Proc_HIA		[01_BDP Reference],
		HOU.MAWB_HIA 			[02_MAWB Number],
		HOU.HAWB_HIA 			[03_HAWB Number],
		Num_Proc_MIA			[04_Consol Reference],
		Ship.Apelido 			[05_Shipper Name],
		Consig.Apelido 			[06_Consignee Name],
		LI.Numero_PO_HIA		[07_LI Number],
		Orig.Nome_Local 		[08_Loading],
		Destin.Nome_Local 		[09_Delivery],
		DstFinal.Nome_Local 	[10_Final Destination],
		HOU.Voo_HIA 			[11_Flight #],
		LLP.Courier_Number_LIA	[12_Courier Number],
		LLP.ETD_LIA 			[13_ETD Date],
		LLP.ETA_LIA 			[14_ETA Date],
		LLP.ATD_LIA 			[15_ATD Date],
		LLP.ATA_LIA 			[16_ATA Date],
		Obs_HIA					[17_Note (OBS)],
		PO.Numero_PO_HIA		[18_PO Number],
		INV.Numero_PO_HIA		[19_Invoice Number],
		SO.Numero_PO_HIA		[20_Sales Order],
		DI.Numero_PO_HIA		[21_DI Number],
		Consig.Num_CPF_CNPJ		[22_CNPJ],
		NTF.Apelido				[23_Notify Name]
	From
		House_Imp_Aer			HOU
		Join Pessoa				Consig		on Cd_Consig_HIA = Consig.Cd_Pes
		Join Pessoa				Ship		on Cd_Export_HIA = Ship.Cd_Pes
		Join Pessoa				NTF			on HOU.Cd_Import_HIA = NTF.Cd_Pes
		Join Localidade			Orig		on Cd_Org_HIA = Orig.Cd_Local
		Join Localidade			Destin		on Cd_Dst_HIA = Destin.Cd_Local
		left Join PO_HIA		PO			on PO.Num_proc_HIA = HOU.Num_proc_HIA and PO.ID_DC='1'
		left Join PO_HIA		INV			on INV.Num_proc_HIA = HOU.Num_proc_HIA and INV.ID_DC='2'
		left Join PO_HIA		SO			on SO.Num_proc_HIA = HOU.Num_proc_HIA and SO.ID_DC='3'
		left Join PO_HIA		DI			on DI.Num_proc_HIA = HOU.Num_proc_HIA and DI.ID_DC='5'
		left Join PO_HIA		LI			on LI.Num_proc_HIA = HOU.Num_proc_HIA and LI.ID_DC='23'
		Join LLP_Imp_Aer		LLP			on HOU.Num_proc_HIA = LLP.Num_proc_LIA
		Left Join Localidade	DstFinal	on LLP.cd_dstfinal_LIA = Dstfinal.cd_local

GO
