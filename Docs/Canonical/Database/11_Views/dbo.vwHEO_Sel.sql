SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vwHEO_Sel] 

AS
	Select  
		HOU.Num_Proc_HEO		[01_BDP Reference],
		LLP.Canal_LEO 			[02_Channel],
		HOU.HAWB_HEO 			[03_TIF Number],
		''						[04_Consol Reference],
		Ship.Apelido 			[05_Shipper Name],
		Consig.Apelido 			[06_Consignee Name],
		Cia.Apelido 			[07_Carrier Name],
		Orig.Nome_Local 		[08_Loading],
		Destin.Nome_Local 		[09_Delivery],
		DstFinal.Nome_Local 	[10_Final Destination],
		HOU.Voo_HEO 			[11_Vagon #],
		LLP.Courier_Number_LEO	[12_Courier Number],
		LLP.ETD_LEO 			[13_ETD Date],
		LLP.ETA_LEO 			[14_ETA Date],
		LLP.ATD_LEO 			[15_ATD Date],
		LLP.ATA_LEO 			[16_ATA Date],
		Obs_HEO					[17_Note (OBS)],
		PO.Numero_PO_HEO		[18_PO Number],
		INV.Numero_PO_HEO		[19_Invoice Number],
		SO.Numero_PO_HEO		[20_Sales Order],
		RE.Numero_PO_HEO		[21_RE Number],
		Ship.Num_CPF_CNPJ		[22_CNPJ],
		NTF.Apelido				[23_Notify Name]		
	From
		House_exp_Out			HOU
		Join Pessoa				Consig		on Cd_Consig_HEO = Consig.Cd_Pes
		Join Pessoa				Ship		on Cd_Export_HEO = Ship.Cd_Pes
		Join Pessoa				NTF			on HOU.Cd_Notify_HEO = NTF.Cd_Pes
		Join Localidade			Orig		on Cd_Org_HEO = Orig.Cd_Local
		Join Localidade			Destin		on Cd_Dst_HEO = Destin.Cd_Local
		left Join PO_HEO		PO			on PO.Num_proc_HEO = HOU.Num_proc_HEO and PO.ID_DC='1'
		left Join PO_HEO		INV			on INV.Num_proc_HEO = HOU.Num_proc_HEO and INV.ID_DC='2'
		left Join PO_HEO		SO			on SO.Num_proc_HEO = HOU.Num_proc_HEO and SO.ID_DC='3'
		left Join PO_HEO		RE			on RE.Num_proc_HEO = HOU.Num_proc_HEO and RE.ID_DC='4'
		Join LLP_Exp_Out		LLP			on HOU.Num_proc_HEO = LLP.Num_proc_LEO
		Left Join Pessoa		Cia			on LLP.Cd_Carrier = Cia.Cd_Pes
		Left Join Localidade	DstFinal	on LLP.cd_dstfinal_LEO = Dstfinal.cd_local

GO
