SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE    PROCEDURE [dbo].[spHIA_Sel]
(
@Num_Job	VarChar(16)
)
AS
	Select  
		Dt_Emis_HIA,
		HOU.MAWB_HIA,
		HAWB_HIA,
		Ship.Apelido 		Shipper,
		Consig.Apelido 		Consignee,
		Import.Apelido 		Notify,
		Partida.Nome_Local 	Partida,
		Orig.Nome_Local 	Loading,
		Destin.Nome_Local 	Delivery,
		DstFinal.Nome_Local	FinalDest,
		CiaAER.Nome_Cia_Aer	CiaAerea,
		Voo_HIA 			Voo,
		LLP.ETD_LIA			ETD,
		LLP.ATD_LIA			ATD,
		LLP.ETA_LIA			ETA,
		LLP.ATA_LIA			ATA,
		Qtd_Tot_Vol_HIA,
		Peso_Real_HIA,
		Peso_Bruto_HIA,
		LLP.Peso_Cubado_LIA,
		Vol_Tot_HIA,
		Tp_Frete_HIA,
		TM.Nome_Tp_Moeda,
		Vlr_Frete_Efet_HIA,
		Obs_HIA,
		CHB.Apelido 		CHB,
		SAP_ShipNumber		Sap_Number,
		AG.Apelido			Agente,
		SAL.Nome_Usuario	Sales,
		TP.NOME_Tp_Oper		Incoterm,
		FORW.Apelido		Forwarder,
		TERM.Nome_Terminal	Terminal,
		TTime_d				TTime_d,
		LLP.Intl_Ref_Lia	Intl_Ref,
		OD.Apelido			Order_Lia,
		CSR.Nome_Usuario	Customer,
		LLP.Canal_Lia		Canal_Lia,
		Courier.Apelido 	Courier,
		LLP.Courier_Number_LIA Courier_Number,
		LLP.DL_Cargo_Lia	DL_Cargo,
		LLP.Original_ETA_LIA Original_ETA_LIA,
		isnull(LLP.PO_Req_Date,LLP.ETA_LIA+10) PO_Req_Date,
		Transp.Apelido		Transportadora,
		Descr.Descr 		Descr,
		MultiModal,
		Vlr_Invoice,
		TM_INV.Nome_Tp_Moeda	Moeda_INV,
		NUM_PROC_MIA		Ref_Consolidada,
		Status_Descricao Status_Job,
		LLP.ID_Status	ID_Status
	From  
		House_Imp_Aer as HOU
		Left Outer Join Job_Imp_Aer	JOB			on HOU.Num_Proc_HIA = JOB.Num_Proc_HIA
		Left Outer Join LLP_Imp_Aer LLP			on HOU.Num_Proc_HIA	= LLP.Num_Proc_Lia
		Left Outer Join Pessoa		Ship		on Cd_Export_HIA 	= Ship.Cd_Pes
		Left Outer Join Pessoa		Consig		on Cd_Consig_HIA 	= Consig.Cd_Pes 
		Left Outer Join Pessoa		Import		on Cd_Import_HIA 	= Import.Cd_Pes
		Left Outer Join Pessoa		CHB			on Cd_Dsp_HIA		= CHB.Cd_Pes
		Left Outer Join Localidade	Orig		on Cd_Org_HIA 		= Orig.Cd_Local 
		Left Outer Join Localidade	Destin		on Cd_Dst_HIA 		= Destin.Cd_Local 
		Left Outer Join Localidade	Partida		on Cd_Planta_Lia 	= Partida.Cd_Local
		Left Outer Join Localidade	DstFinal	on Cd_DstFinal_LIA 	= DstFinal.Cd_Local
		Left Outer Join Cia_Aerea	CiaAER		on JOB.Cd_Cia_Aer	= CiaAER.Cd_Cia_Aer
		Left Outer Join Tipo_Moeda	TM			on HOU.Cd_Tp_Moeda 	= TM.Cd_Tp_Moeda
		Left Outer Join Tipo_Moeda	TM_INV		on LLP.Cd_Moeda_Invoice	= TM_INV.Cd_Tp_Moeda
		Left Outer Join Pessoa		AG			on JOB.Cd_Agente	= AG.Cd_Pes
		Left Outer Join Pessoa		FORW		on LLP.Cd_Forwarder	= FORW.Cd_Pes
		Left Outer Join Usuario		SAL			on JOB.Cd_Vendedor	= SAL.Cd_Usuario
		Left Outer Join Usuario		CSR			on JOB.Cd_Usuario	= CSR.Cd_Usuario
		Left Outer Join Nature_Goods Descr		on HOU.Num_proc_hia = Descr.Num_Proc 
		Left Outer Join Pessoa		OD			on LLP.Cd_Order		= OD.Cd_Pes
		Left Outer Join Terminal	TERM		on LLP.Cd_Terminal	= TERM.Cd_Terminal
		Left Outer Join Pessoa		Courier		on LLP.Cd_Courier 	= Courier.Cd_Pes
		Left Outer Join Tipo_Oper	TP			on HOU.cd_tp_oper 	= TP.Cd_tp_oper
		Left Outer Join Pessoa		Transp		on LLP.Cd_Transportadora = Transp.Cd_Pes
		Left Outer Join Tipo_Status_Processo Status on STatus.id_status=LLP.id_status
	Where
		HOU.Num_Proc_HIA = @Num_Job

























GO
