SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE	PROCEDURE [dbo].[spHEO_Sel] 
(
@Processo		VarChar(16),
@Tipo			Char(1)
)
AS
	Select
--House_EXP_mar
		Dt_Emis_HEO,
		HOU.HAWB_HEO 		HAWB_HEO,
		Ship.Apelido 		Shipper,
		Consig.Apelido 		Consignee,
		Notify.Apelido 		Notify,
		Orig.Nome_Local 	Loading,
		Destin.Nome_Local 	Delivery,
		HOU.Voo_HEO 		Voo,
		Qtd_Tot_Vol_HEO,
		Peso_Bruto_HEO,
		Peso_Real_HEO,
		Vol_Tot_HEO, 
		Tp_Frete_HEO,
		TM.Nome_Tp_Moeda,
		Vlr_Frete_efet_HEO,
		SAP_ShipNumber 		SAP,
		TP.NOME_Tp_Oper 	Incoterm,
		Obs_HEO,
--LLP
		LLP.ETA_LEO 		ETA_LEO,
		LLP.ETD_LEO 		ETD_LEO,
		LLP.ATA_LEO 		ATA_LEO,
		LLP.ATD_LEO 		ATD_LEO,
		Planta.nome_local 	Planta,
		DstFinal.Nome_Local DstFinal,
		Forwarder.Apelido 	Forwarder,
		Carrier.Apelido		Carrier,
		CHB.Apelido 		CHB,
		LLP.Intl_Ref_LEO	Intl_ref,
		LLP.Peso_Cubado_LEO	Peso_cubado_LEO,
		LLP.DL_Cargo_LEO	DL_Cargo,
		Sales.Nome_Usuario	Vendedor,
		Agente.Apelido		Agente,
 		TERM.Nome_Terminal	Terminal,
		TTime_d				TTime_d,
		OD.Apelido			Order_Leo,
		CSR.Nome_Usuario	Customer,
		LLP.Canal_Leo		Canal_Leo,
		Courier.Apelido 	Courier,
		LLP.Courier_Number_LEO Courier_Number,
		LLP.Original_ETA_Leo Original_ETA_Leo,
		LLP.Tipo_LEO,
		Transp.Apelido		Transportadora,
		NTF.Apelido			Notify_2,
		MultiModal,
		Vlr_Invoice,
		TM_INV.Nome_Tp_Moeda	Moeda_INV,
		LLP.Comissao_Agente_Leo	Comissao_Agente_Leo,
		isnull(LLP.PO_Req_Date,LLP.ETA_LEO+10) PO_Req_Date,
--Nature_Gooods
		Descr.Descr Descr,
		Status_Descricao Status_Job,
		LLP.ID_Status	ID_Status
	From
		House_EXP_OUT HOU
		Left Outer Join Pessoa		Notify		on Cd_Notify_HEO = Notify.Cd_Pes
		Left Outer Join Pessoa		Consig		on Cd_Consig_HEO = Consig.Cd_Pes 
		Left Outer Join Pessoa		Ship		on Cd_Export_HEO = Ship.Cd_Pes	
		Left Outer Join LLP_EXP_OUT	LLP			on HOU.Num_proc_HEO = LLP.Num_proc_LEO
		Left Outer Join Pessoa		CHB			on LLP.Cd_Despachante = CHB.Cd_Pes	
		Left Outer Join Localidade	Planta		on LLP.cd_Planta_LEO = Planta.cd_local
		Left Outer Join Localidade	DstFinal	on LLP.cd_dstfinal_LEO = Dstfinal.cd_local
		Left Outer Join Pessoa		Carrier		on LLP.Cd_Carrier = Carrier.Cd_Pes
		Left Outer Join Pessoa		Agente		on LLP.Cd_Agente = Agente.Cd_Pes
		Left Outer Join Pessoa		Forwarder	on LLP.Cd_Forwarder = Forwarder.Cd_Pes
		Left Outer Join Usuario		Sales		on LLP.Cd_Vendedor = Sales.Cd_Usuario
		Left Outer Join Usuario		CSR			on LLP.Cd_Usuario = CSR.Cd_Usuario
		Left Outer Join Localidade	Orig		on Cd_Org_HEO = Orig.Cd_Local 
		Left Outer Join Localidade	Destin		on Cd_Dst_HEO = Destin.Cd_Local 
		Left Outer Join Tipo_Moeda	TM			on HOU.Cd_Tp_Moeda = TM.Cd_Tp_Moeda
		Left Outer Join Tipo_Moeda	TM_INV		on LLP.Cd_Moeda_Invoice	= TM_INV.Cd_Tp_Moeda
		Left Outer Join Terminal	TERM		on LLP.Cd_Terminal = TERM.Cd_Terminal
		Left Outer Join Pessoa		OD			on LLP.Cd_Order = OD.Cd_Pes
		Left Outer Join Pessoa		Courier		on LLP.Cd_Courier = Courier.Cd_Pes
		Left Outer Join Tipo_Oper	TP			on HOU.cd_tp_oper = TP.Cd_tp_oper
		Left Outer Join Pessoa		Transp		on LLP.Cd_Transportadora = Transp.Cd_Pes
		Left Outer Join Pessoa		NTF			on LLP.Cd_Notify_2 = NTF.Cd_Pes
		Left Outer Join Nature_Goods Descr		on HOU.Num_proc_heo = Descr.Num_Proc
		Left Outer Join Tipo_Status_Processo Status on STatus.id_status=LLP.id_status
	Where
		HOU.Num_Proc_HEO= @Processo and Tipo_LEO = @Tipo




































GO
