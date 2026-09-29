SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE	PROCEDURE [dbo].[spHIO_Sel]
(
@Processo		VarChar(16),
@Tipo			Char(1)
)
AS
	Select  
--House_IMP_out
		Dt_Emis_HIO,
		HOU.HAWB_HIO 		HAWB_HIO,
		Ship.Apelido 		Shipper,
		Consig.Apelido 		Consignee,
		Notify.Apelido 		Notify,
		Orig.Nome_Local 	Loading,
		Destin.Nome_Local 	Delivery,
		HOU.Voo_HIO 		Voo,
		Qtd_Tot_Vol_HIO,
		Peso_Bruto_HIO,
		Peso_Real_HIO,
		Vol_Tot_HIO, 
		Tp_Frete_HIO,
		TM.Nome_Tp_Moeda,
		Vlr_Frete_efet_HIO,
		SAP_ShipNumber 		SAP,
		TP.NOMe_Tp_Oper 	Incoterm,
		Obs_HIO,
--LLP_imp_out
		LLP.ETA_LIO 		ETA_LIO,
		LLP.ETD_LIO 		ETD_LIO,
		LLP.ATA_LIO 		ATA_LIO,
		LLP.ATD_LIO 		ATD_LIO,
		Planta.nome_local 	Planta,
		DstFinal.Nome_Local DstFinal,
		Forwarder.Apelido 	Forwarder,
		Carrier.Apelido		Carrier,
		CHB.Apelido 		CHB,
		LLP.Intl_Ref_LIO	Intl_ref,
		LLP.Peso_Cubado_LIO	Peso_cubado_LIO,
		LLP.DL_Cargo_LIO	DL_Cargo,
		Sales.Nome_Usuario	Vendedor,
		CSR.Nome_Usuario	Customer,
		Agente.Apelido		Agente,
		Term.Nome_Terminal	Terminal,
		TTime_d				TTime_d, 
		OD.Apelido			Order_Lio,
		LLP.Canal_Lio		Canal_Lio,
		Courier.Apelido		Courier,
		LLP.Courier_Number_LIO 	Courier_Number,
		LLP.Original_ETA_Lio	Original_ETA_Lio,
		LLP.Tipo_Lio,
		isnull(LLP.PO_Req_Date,LLP.ETA_LIO+10) PO_Req_Date,
		MultiModal,
		Vlr_Invoice,
		TM_INV.Nome_Tp_Moeda	Moeda_INV,
		Transp.Apelido		Transportadora,
--Nature_Gooods
		Descr.Descr Descr,
		Status_Descricao Status_Job,
		LLP.ID_Status	ID_Status
	From  
		House_IMP_OUT HOU
		Left Outer Join Pessoa		Notify		on Cd_Import_HIO = Notify.Cd_Pes
		Left Outer Join Pessoa		Consig		on Cd_Consig_HIO = Consig.Cd_Pes 
		Left Outer Join Pessoa		Ship		on Cd_Export_HIO = Ship.Cd_Pes	
		Left Outer Join LLP_IMP_OUT	LLP			on HOU.Num_proc_HIO = LLP.Num_proc_LIO
		Left Outer Join Pessoa		CHB			on LLP.Cd_Despachante = CHB.Cd_Pes	
		Left Outer Join Localidade	Planta		on LLP.cd_Planta_LIO = Planta.cd_local
		Left Outer Join Localidade	DstFinal	on LLP.cd_dstfinal_LIO = Dstfinal.cd_local
		Left Outer Join Pessoa		Carrier		on LLP.Cd_Carrier = Carrier.Cd_Pes
		Left Outer Join Pessoa		Agente		on LLP.Cd_Agente = Agente.Cd_Pes
		Left Outer Join Pessoa		Forwarder	on LLP.Cd_Forwarder = Forwarder.Cd_Pes
		Left Outer Join Usuario		Sales		on LLP.Cd_Vendedor = Sales.Cd_Usuario
		Left Outer Join Usuario		CSR			on LLP.Cd_Usuario = CSR.Cd_Usuario
		Left Outer Join Localidade	Orig		on Cd_Org_HIO = Orig.Cd_Local 
		Left Outer Join Localidade	Destin		on Cd_Dst_HIO = Destin.Cd_Local 
		Left Outer Join Tipo_Moeda	TM			on HOU.Cd_Tp_Moeda = TM.Cd_Tp_Moeda
		Left Outer Join Tipo_Moeda	TM_INV		on LLP.Cd_Moeda_Invoice = TM_INV.Cd_Tp_Moeda
		Left Outer Join Pessoa		OD			on LLP.Cd_Order = OD.Cd_Pes
		Left Outer Join Terminal	TERM		on LLP.Cd_Terminal = TERM.Cd_Terminal
		Left Outer Join Pessoa		Courier		on LLP.Cd_Courier = Courier.Cd_Pes
		Left Outer Join Tipo_Oper	TP			on HOU.cd_tp_oper = TP.Cd_tp_oper
		Left Outer Join Pessoa		Transp		on LLP.Cd_Transportadora = Transp.Cd_Pes
		Left Outer Join Nature_Goods Descr		on HOU.Num_proc_hio = Descr.Num_Proc
		Left Outer Join Tipo_Status_Processo Status on STatus.id_status=LLP.id_status
	Where
		HOU.Num_Proc_HIO= @Processo and Tipo_Lio = @Tipo






























GO
