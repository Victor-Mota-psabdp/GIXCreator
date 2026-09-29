SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[spHIM_Sel] --spHIM_Sel 'IMCSR201508625BR'	

(
@Num_Job	VarChar(16)
)
AS
	Select  

		Dt_Emis_HIM,
		HOU.Num_Proc_MIM		Ref_Consolidada,
		HOU.MAWB_HIM,
		HAWB_HIM,
		Ship.Apelido 			Shipper,
		Consig.Apelido 			Consignee,
		Import.Apelido 			Notify,
		Origin.Nome_Local 		Origin,
		Orig.Nome_Local 		Loading,
		Destin.Nome_Local 		Delivery,
		DstFinal.Nome_Local		FinalDest,
		ARM.Nome_Armador		Carrier,
		Viagem_HIM 				Voyage,
		Navio_HIM 				Vessel,
		LLP.ETD_Lim				ETD,
		LLP.ATD_Lim				ATD,
		LLP.ETA_Lim				ETA,
		LLP.ATA_Lim				Arrival,
		TC.Nome_Tp_Carga,
		Qtd_Tot_Vol_HIM,
		Peso_Liquido_HIM,
		Peso_Bruto_HIM,
		Vol_Tot_HIM,
		Tp_Frete_HIM,
		TM.Nome_Tp_Moeda,
		Vlr_Frete_Efet_HIM,
		Obs_HIM,
		CHB.Apelido 			CHB,
		SAP_ShipNumber			Sap_Number,
		TERM.Nome_Terminal		Terminal,
		AG.Apelido				Agente,
		SAL.Nome_Usuario		Sales,
		TP.Nome_tp_Oper			Incoterm,
		FORW.Apelido			Forwarder,
		LLP.Canal_Lim,
		TTime_d					TTime_d,
		LLP.Nr_Reserva			Nr_Reserva,
		LLP.Intl_Ref_Lim		Intl_Ref,
		OD.Apelido				Order_Lim,
		CSR.Nome_Usuario		Customer,
		Courier.Apelido 		Courier,
		LLP.Courier_Number_LIM 	Courier_Number,
		LLP.DL_Cargo_Lim		DL_Cargo,
		Transp.Apelido			Transportadora,
		LLP.Original_ETA_LIM	Original_ETA_LIM,
		isnull(LLP.PO_Req_Date,LLP.ETA_LIM+10) PO_Req_Date,
		MultiModal,
		Vlr_Invoice,
		TM_INV.Nome_Tp_Moeda	Moeda_INV,
		Descr.Descr 			Descr,
		Status_Descricao Status_Job,
		LLP.ID_Status	ID_Status,
		llp.ID_Viagem			id_viagem,
		Descr.Header 			Header
	From  
		House_Imp_Mar  HOU with(nolock)
		Left Outer Join Job_Imp_Mar 	JOB with(nolock)			on HOU.Num_Proc_HIM 	= JOB.Num_Proc_HIM
		Left Outer Join LLP_Imp_Mar		LLP with(nolock)			on HOU.Num_Proc_HIM	= LLP.Num_Proc_Lim
		Left Outer Join Pessoa			Ship with(nolock)		on Cd_Export_HIM 	= Ship.Cd_Pes
		Left Outer Join Pessoa			Consig with(nolock)		on Cd_Consig_HIM 	= Consig.Cd_Pes 
		Left Outer Join Pessoa			Import with(nolock)		on Cd_Import_HIM 	= Import.Cd_Pes
		Left Outer Join Pessoa			CHB with(nolock)			on Cd_Despachante	= CHB.Cd_Pes
		Left Outer Join Localidade		Orig with(nolock)		on Cd_Org_HIM 		= Orig.Cd_Local 
		Left Outer Join Localidade		Destin with(nolock)		on Cd_Dst_HIM 		= Destin.Cd_Local 
		Left Outer Join Localidade		Origin with(nolock)		on Cd_Planta_Lim 	= Origin.Cd_Local
		Left Outer Join Localidade		DstFinal with(nolock)	on Cd_DstFinal_LIM 	= DstFinal.Cd_Local
		Left Outer Join Armador			ARM with(nolock)			on JOB.Cd_Armador	= Arm.Cd_Armador
		Left Outer Join Tipo_Moeda		TM with(nolock)			on HOU.Cd_Tp_Moeda 	= TM.Cd_Tp_Moeda
		Left Outer Join Tipo_Moeda		TM_INV with(nolock)		on LLP.Cd_Moeda_Invoice	= TM_INV.Cd_Tp_Moeda
		Left Outer Join Tipo_Carga		TC with(nolock)			on LLP.Cd_Tp_Carga	= TC.Cd_Tp_Carga
		Left Outer Join Terminal		TERM with(nolock)		on LLP.Cd_Terminal	= TERM.Cd_Terminal
		Left Outer Join Pessoa			AG with(nolock)			on JOB.Cd_Agente	= AG.Cd_Pes
		Left Outer Join Pessoa			FORW with(nolock)		on LLP.Cd_Forwarder	= FORW.Cd_Pes
		Left Outer Join Usuario			SAL with(nolock)			on JOB.Cd_Vendedor	= SAL.Cd_Usuario
		Left Outer Join Usuario			CSR with(nolock)			on JOB.Cd_Usuario	= CSR.Cd_Usuario
		Left Outer Join Pessoa			OD with(nolock)			on LLP.Cd_Order		= OD.Cd_Pes
		Left Outer Join Nature_Goods	Descr with(nolock)		on HOU.Num_proc_him 	= Descr.Num_Proc 
		Left Outer Join Tipo_Oper		TP with(nolock)			on HOU.Cd_Tp_Oper 	= TP.Cd_Tp_Oper
		Left Outer Join Pessoa			Courier with(nolock)		on LLP.Cd_Courier 	= Courier.Cd_Pes
		Left Outer Join Pessoa			Transp with(nolock)		on LLP.Cd_Transportadora = Transp.Cd_Pes
		Left Outer Join Tipo_Status_Processo Status with(nolock) on STatus.id_status=LLP.id_status
	Where
		HOU.Num_Proc_HIM		= @Num_Job




GO
