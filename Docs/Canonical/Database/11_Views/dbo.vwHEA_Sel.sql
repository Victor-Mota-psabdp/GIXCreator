SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vwHEA_Sel] 

AS
Select
		HOU.Num_Proc_HEA		[01_BDP Reference],
		HOU.MAWB_HEA 			[02_MAWB Number],
		HOU.HAWB_HEA 			[03_HAWB Number],
		Num_Proc_MEA			[04_Consol Reference],
		Ship.Apelido 			[05_Shipper Name],
		Consig.Apelido 			[06_Consignee Name],
		Cia.Nome_Cia_Aer 		[07_Air Company],
		Orig.Nome_Local 		[08_Loading],
		Destin.Nome_Local 		[09_Delivery],
		DstFinal.Nome_Local 	[10_Final Destination],
		HOU.Voo_HEA 			[11_Flight #],
		LLP.Courier_Number_LEA	[12_Courier Number],
		LLP.ETD_LEA 			[13_ETD Date],
		LLP.ETA_LEA 			[14_ETA Date],
		LLP.ATD_LEA 			[15_ATD Date],
		LLP.ATA_LEA 			[16_ATA Date],
		Obs_HEA					[17_Note (OBS)],
		PO.Numero_PO_HEA		[18_PO Number],
		INV.Numero_PO_HEA		[19_Invoice Number],
		SO.Numero_PO_HEA		[20_Sales Order],
		RE.Numero_PO_HEA		[21_RE Number],
		Ship.Num_CPF_CNPJ		[22_CNPJ],
		NTF.Apelido				[23_Notify Name]
	From
		House_exp_Aer			HOU
		Join Pessoa				Consig		on Cd_Consig_HEA = Consig.Cd_Pes
		Join Pessoa				Ship		on Cd_Export_HEA = Ship.Cd_Pes
		Join Pessoa				NTF			on HOU.Cd_Notify_HEA = NTF.Cd_Pes
		Join Localidade			Orig		on Cd_Org_HEA = Orig.Cd_Local
		Join Localidade			Destin		on Cd_Dst_HEA = Destin.Cd_Local
		left Join PO_HEA		PO			on PO.Num_proc_HEA = HOU.Num_proc_HEA and PO.ID_DC='1'
		left Join PO_HEA		INV			on INV.Num_proc_HEA = HOU.Num_proc_HEA and INV.ID_DC='2'
		left Join PO_HEA		SO			on SO.Num_proc_HEA = HOU.Num_proc_HEA and SO.ID_DC='3'
		left Join PO_HEA		RE			on RE.Num_proc_HEA = HOU.Num_proc_HEA and RE.ID_DC='4'
		Join LLP_Exp_Aer		LLP			on HOU.Num_proc_HEA = LLP.Num_proc_LEA
		Left Join Cia_Aerea		Cia			on LLP.cd_CiaAerea_LEA = Cia.Cd_Cia_Aer
		Left Join Localidade	DstFinal	on LLP.cd_dstfinal_LEA = Dstfinal.cd_local

GO
