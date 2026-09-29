SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--incluido o courier processo - cadu 05/10/2015
--[spSaidaReportManagerPOModal_Rel] 'EAOXT201704001BR'
CREATE Procedure [dbo].[spSaidaReportManagerPOModal_Rel] 
	@num_proc	varchar(16)
as

If left(@Num_Proc,2)='IM'
	Begin
		SELECT 
			NUM_PROC_LIM JOB,
			NULL ENTRYNUMBER,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIM,5) ENTRYNUMBER,
			NULL SALES_ORDER,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIM,3) SALES_ORDER, 
			NULL Invoice_Number,
			--left(dbo.fBusca_Docs_PO_Modal(@Num_Proc,2),80) Invoice_Number,
			NULL NotaFiscal,
			--dbo.fBusca_Docs_PO_Modal(NUM_PROC_LIM,'10') NotaFiscal, 
			NULL DataNF,
			--cast(dbo.fBusca_TipoDocCliente('D',NUM_PROC_LIM,10) as datetime) DataNF,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIM,1) PONumber
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIM,1)PONumber
			
			NULL PONumber, --left(dbo.fBusca_Docs_PO_Modal(NUM_PROC_LIM,1),500)PONumber, cadu 09/02/2015 - XML
			NULL DtOrder,
			--cast((dbo.fBusca_TipoDocCliente('D',NUM_PROC_LIM,3)) as datetime) DtOrder,
			NULL LI_Number,
			--dbo.fBusca_Docs_PO_Modal(NUM_PROC_LIM,'23') LI_Number,
			NULL LIDate,
			--cast(dbo.fBusca_TipoDocCliente('D',NUM_PROC_LIM,23) as datetime) LIDate,
			NULL Nec_LI,
			--isnull(dbo.fBusca_CampoCliente(NUM_PROC_LIM,5),3) Nec_LI, 
			NULL DataDI,
			--cast(dbo.fBusca_TipoDocCliente('D',NUM_PROC_LIM,5) as datetime) DataDI,
			NULL DeliveryNote,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIM,7) DeliveryNote,
			NULL Customer_PO,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIM,9) Customer_PO,
			NULL Volume_Santos,
			--dbo.fBusca_CampoCliente(NUM_PROC_LIM,37) Volume_Santos,
			NULL Liberacao_Laudo,
			--dbo.fBusca_CampoCliente(NUM_PROC_LIM,38) Liberacao_Laudo,
			NULL CE_Mercante,
			--left(dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIM,29),50) CE_Mercante,
			NULL Invoice_Agente,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIM,74)  Invoice_Agente,
			NULL Status,
			--dbo.fBusca_CampoCliente(NUM_PROC_LIM,79) Status,
			NULL CE_Mercante_Master,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIM,85) CE_Mercante_Master,
			NULL FirstVessel,
			--dbo.fBusca_CampoCliente(NUM_PROC_LIM,84) FirstVessel,- Desativado por Erbson - 27/04/2017 - Transferido para ReportManagerV2
			NULL ETATRanshipment,
			--convert(datetime,dbo.fBusca_CampoCliente(NUM_PROC_LIM,85),105) ETATranshipment,- Desativado por Erbson - 27/04/2017 - Transferido para ReportManagerV2
			NULL DDE_Numero, Null DDE_Data,
			NULL SC,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIM,91) SC, - Desativado por Erbson - 26/04/2017 - Transferido para ReportManagerV2
			null ArkTec, 
			NULL Invoice_Date,
			--cast(dbo.fBusca_TipoDocCliente('D',NUM_PROC_LIM,2) as datetime) Invoice_Date, - Desativado por Erbson - 20/04/2017 - Transferido para ReportManagerV2
			NULL DTA_Date,
			--cast(dbo.fBusca_TipoDocCliente('D',NUM_PROC_LIM,45) as datetime) DTA_Date,
			NULL Shipment_number,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIM,8) Shipment_Number,
			NULL Despacho,
			--isnull(dbo.fBusca_CampoCliente(NUM_PROC_LIM,32),1) Despacho, 
			NULL Urgente,
			--isnull(dbo.fBusca_CampoCliente(NUM_PROC_LIM,36),2) Urgente,
			NULL Divisao,
			--dbo.fBusca_CampoCliente(NUM_PROC_LIM,11) Divisao,- Desativado por Erbson - 20/04/2017 - Transferido para ReportManagerV2
			NULL Area,
			--dbo.fBusca_CampoCliente(NUM_PROC_LIM,24) Area, - Desativado por Erbson - 19/04/2017 - Transferido para ReportManagerV2
			NULL Departamento,
			--dbo.fBusca_CampoCliente(NUM_PROC_LIM,13) Departamento,-- Desativado por Erbson - 19/04/2017 - Transferido para ReportManagerV2
			Null Segunda_Referencia, Null Agenda,
			NULL Valor_Danfe,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIM,83) Valor_Danfe, -- Desativado por Erbson - 19/04/2017 - NUNCA PREENCHIDO
			NULL Horario_Agenda,
			--dbo.fBusca_CampoCliente(NUM_PROC_LIM,93) Horario_Agenda,-- Desativado por Erbson - 19/04/2017 - Transferido para ReportManagerV2
			NULL QTD_Veiculos,
			--dbo.fBusca_CampoCliente(NUM_PROC_LIM,94) QTD_Veiculos, -- Desativado por Erbson - 19/04/2017 - Transferido para ReportManagerV2
			dbo.fBusca_CampoCliente(NUM_PROC_LIM,95) Tipo_LI, 
			NULL Lote,
			--dbo.fBusca_CampoCliente(NUM_PROC_LIM,100) Lote, -- Desativado por Erbson - 17/04/2017 - Transferido para ReportManagerV2
			NULL COA_Number,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIM,16) COA_Number,
			Null  Status_Descricao,
			NULL RENumber,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIM,04) RENumber, -- Desativado por Erbson - 18/04/2017 - Transferido para ReportManagerV2
			NULL FormA,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIM,14) FormA, -- Desativado por Erbson - 17/04/2017 - Transferido para ReportManagerV2
			NULL DirectCollection,
			--left(dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIM,36),49) DirectCollection, -- Desativado por Erbson - 17/04/2017 - Transferido para ReportManagerV2
			NULL DirectCollection_Date,
			--cast(dbo.fBusca_TipoDocCliente('D',NUM_PROC_LIM,36) as datetime) DirectCollection_Date, -- Desativado por Erbson - 17/04/2017 - Transferido para ReportManagerV2
			NULL Cobranza,Null Cobranza_Date,
			NULL DSE,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIM,26) DSE,  -- Desativado por Erbson - 17/04/2017 - Transferido para ReportManagerV2
			NULL DSE_Date,
			--convert(datetime,dbo.fBusca_TipoDocCliente('D',NUM_PROC_LIM,26)) DSE_Date,  -- Desativado por Erbson - 17/04/2017 - Transferido para ReportManagerV2
			
			--dbo.fBusca_TipoDocCliente('N',@Num_Proc,110) Courier_2,			
			--cast(dbo.fBusca_TipoDocCliente('D',@Num_Proc,110) as datetime)Data_Courier_2,			
			--dbo.fBusca_TipoDocCliente('N',@Num_Proc,115) Courier_3,
			--cast(dbo.fBusca_TipoDocCliente('D',@Num_Proc,115) as datetime)Data_Courier_3,
			NULL Courier_2,
			--CP2.num_courier	Courier_2, -- Desativado por Erbson - 13/04/2017 - Transferido para ReportManagerV2
			NULL Data_Courier_2,
			--CP2.Dt_Courier	Data_Courier_2, -- Desativado por Erbson - 13/04/2017 - Transferido para ReportManagerV2
			NULL Courier_3,
			--CP3.num_courier	Courier_3, -- Desativado por Erbson - 13/04/2017 - Transferido para ReportManagerV2
			NULL Data_Courier_3,
			--CP3.Dt_Courier	Data_Courier_3, -- Desativado por Erbson - 13/04/2017 - Transferido para ReportManagerV2
			
			dbo.fBusca_TipoDocCliente('N',@Num_Proc,118) Cambio_Numero,
			cast(dbo.fBusca_TipoDocCliente('D',@Num_Proc,118) as datetime) Cambio_Date,
			NULL Avaria,
			--dbo.fBusca_CampoCliente(@Num_Proc,114) Avaria, -- Desativado por Erbson - 13/04/2017 - Transferido para ReportManagerV2
			NULL DeadLineRemocao,
			--convert(datetime,dbo.fBusca_CampoCliente(@Num_Proc,115),103) DeadLineRemocao, -- Desativado por Erbson - 13/04/2017 - Transferido para ReportManagerV2
			
			NULL EntregaAlfandega,
			--convert(datetime,dbo.fBusca_CampoCliente(@Num_Proc,116),103) EntregaAlfandega, -- Desativado por Erbson - 13/04/2017 - Transferido para ReportManagerV2
			Null USD_Exp_Tx, null USD_Exp_Date ,
			
			NULL DTA_Number
			--dbo.fBusca_TipoDocCliente('N',@Num_Proc,45) DTA_Number -- Desativado por Erbson - 11/04/2017 - Transferido para ReportManagerV2
			
		FROM
			LLP_IMP_MAR LLP with(nolock)
			--Left Join Tipo_Status_Processo TS on TS.id_status=LLP.id_status
			--left join Courier_Processo CP2 with(nolock) on CP2.num_proc = LLP.num_proc_lim and CP2.ID_Item = 2
			--left join Courier_Processo CP3 with(nolock) on CP3.num_proc = LLP.num_proc_lim and CP3.ID_Item = 3			
		WHERE 
			NUM_PROC_LIM=@Num_Proc	
	END
IF LEFT(@Num_Proc,2)='EM'
	Begin
		SELECT 
			NUM_PROC_LEM JOB,
			NULL ENTRYNUMBER,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LEM,4) ENTRYNUMBER,
			NULL SALES_ORDER,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LEM,3) SALES_ORDER,
			NULL Invoice_Number,
			--left(dbo.fBusca_Docs_PO_Modal(@Num_Proc,2),80) Invoice_Number,
			NULL NotaFiscal,
			--dbo.fBusca_Docs_PO_Modal(NUM_PROC_LEM,'10') NotaFiscal,
			NULL DataNF,
			--cast(dbo.fBusca_TipoDocCliente('D',NUM_PROC_LEM,10) as datetime) DataNF,
			--dbo.fBusca_TipoDocCliente('N',@Num_PRoc,1)PONumber ,
			
			NULL PONumber, --left(dbo.fBusca_Docs_PO_Modal(NUM_PROC_LEM,1),500)PONumber, cadu 09/02/2015 - XML
			NULL DtOrder,
			--cast(dbo.fBusca_TipoDocCliente('D',NUM_PROC_LEM,3) as datetime) DtOrder,
			NULL LI_Number,
			--dbo.fBusca_Docs_PO_Modal(NUM_PROC_LEM,'23') LI_Number,
			NULL LIDate,
			--cast(dbo.fBusca_TipoDocCliente('D',NUM_PROC_LEM,23) as datetime) LIDate,
			NULL Nec_LI,
			--isnull(dbo.fBusca_CampoCliente(NUM_PROC_LEM,5),3) Nec_LI, 
			NULL DataDI,
			--cast(dbo.fBusca_TipoDocCliente('D',NUM_PROC_LEM,4) as datetime) DataDI,
			NULL DeliveryNote,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LEM,7) DeliveryNote,
			NULL Customer_PO,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LEM,9) Customer_PO,
			NULL Volume_Santos,
			--dbo.fBusca_CampoCliente(NUM_PROC_LEM,37) Volume_Santos,
			NULL Liberacao_Laudo,
			--dbo.fBusca_CampoCliente(NUM_PROC_LEM,38) Liberacao_Laudo,
			NULL CE_Mercante,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LEM,29) CE_Mercante,
			NULL Invoice_Agente,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LEM,74)  Invoice_Agente,
			NULL Status,
			--dbo.fBusca_CampoCliente(NUM_PROC_LEM,79) Status,
			NULL CE_Mercante_Master,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LEM,85) CE_Mercante_Master,
			NULL FirstVessel,
			--dbo.fBusca_CampoCliente(NUM_PROC_LEM,84) FirstVessel,- Desativado por Erbson - 27/04/2017 - Transferido para ReportManagerV2
			NULL ETATranshipment,
			--cast(dbo.fBusca_CampoCliente(NUM_PROC_LEM,85) as datetime) ETATranshipment,- Desativado por Erbson - 27/04/2017 - Transferido para ReportManagerV2
			NULL DDE_Numero,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LEM,12) DDE_Numero, 
			NULL DDE_Data,
			--cast(dbo.fBusca_TipoDocCliente('D',NUM_PROC_LEM,12) as datetime) DDE_Data,
			NULL SC,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LEM,91) SC,- Desativado por Erbson - 26/04/2017 - Transferido para ReportManagerV2
			NULL ArkTec,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LEM,30) ArkTec, - Desativado por Erbson - 24/04/2017 - Transferido para ReportManagerV2
			NULL Invoice_Date,
			--cast(dbo.fBusca_TipoDocCliente('D',NUM_PROC_LEM,2) as datetime) Invoice_Date,- Desativado por Erbson - 20/04/2017 - Transferido para ReportManagerV2
			Null DTA_Date, 
			NULL Shipment_number,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LEM,8) Shipment_Number,
			NULL Despacho,
			--isnull(dbo.fBusca_CampoCliente(NUM_PROC_Lem,32),1) Despacho,
			NULL Urgente,
			--isnull(dbo.fBusca_CampoCliente(NUM_PROC_LEM,36),2) Urgente,
			NULL Divisao,
			--dbo.fBusca_CampoCliente(NUM_PROC_LEM,11) Divisao, - Desativado por Erbson - 20/04/2017 - Transferido para ReportManagerV2
			NULL Area,
			--dbo.fBusca_CampoCliente(NUM_PROC_LEM,24) Area, - Desativado por Erbson - 19/04/2017 - Transferido para ReportManagerV2
			NULL Departamento,
			--dbo.fBusca_CampoCliente(NUM_PROC_LEM,13) Departamento, - Desativado por Erbson - 19/04/2017 - Transferido para ReportManagerV2
			Null Segunda_Referencia, dbo.fBusca_CampoCliente(NUM_PROC_LEM,92) Agenda,
			NULL Valor_Danfe,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LeM,83) Valor_Danfe, -- Desativado por Erbson - 19/04/2017 - NUNCA PREENCHIDO
			null Horario_Agenda, Null QTD_Veiculos,null Tipo_LI, null Lote,
			NULL COA_Number,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LEM,16) COA_Number,
			Null Status_Descricao,
			NULL RENUMBER,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LEM,04) RENumber,- Desativado por Erbson - 18/04/2017 - Transferido para ReportManagerV2
			NULL FormA,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIM,14) FormA, -- Desativado por Erbson - 17/04/2017 - Transferido para ReportManagerV2
			NULL DirectCollection,
			--left(dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIM,36),49) DirectCollection, -- Desativado por Erbson - 17/04/2017 - Transferido para ReportManagerV2
			NULL DirectCollection_Date,
			--cast(dbo.fBusca_TipoDocCliente('D',NUM_PROC_LIM,36) as datetime) DirectCollection_Date, -- Desativado por Erbson - 17/04/2017 - Transferido para ReportManagerV2
			NULL Cobranza,Null Cobranza_Date,			
			NULL DSE,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIM,26) DSE,  -- Desativado por Erbson - 17/04/2017 - Transferido para ReportManagerV2
			NULL DSE_Date,
			--convert(datetime,dbo.fBusca_TipoDocCliente('D',NUM_PROC_LIM,26)) DSE_Date,  -- Desativado por Erbson - 17/04/2017 - Transferido para ReportManagerV2
			--dbo.fBusca_TipoDocCliente('N',@Num_Proc,94) Courier_2,
			--cast(dbo.fBusca_TipoDocCliente('D',@Num_Proc,94) as datetime)Data_Courier_2,
			--dbo.fBusca_TipoDocCliente('N',@Num_Proc,115) Courier_3,
			--cast(dbo.fBusca_TipoDocCliente('D',@Num_Proc,115) as datetime)Data_Courier_3,
			NULL Courier_2,		 	
			--CP2.num_courier	Courier_2, -- Desativado por Erbson - 13/04/2017 - Transferido para ReportManagerV2
			NULL Data_Courier_2,
			--CP2.Dt_Courier	Data_Courier_2, -- Desativado por Erbson - 13/04/2017 - Transferido para ReportManagerV2
			NULL Courier_3,
			--CP3.num_courier	Courier_3, -- Desativado por Erbson - 13/04/2017 - Transferido para ReportManagerV2
			NULL Data_Courier_3,
			--CP3.Dt_Courier	Data_Courier_3, -- Desativado por Erbson - 13/04/2017 - Transferido para ReportManagerV2
			
			dbo.fBusca_TipoDocCliente('N',@Num_Proc,118) Cambio_Numero,cast(dbo.fBusca_TipoDocCliente('D',@Num_Proc,118) as datetime) Cambio_Date,
			Null Avaria,Null DeadLineRemocao,Null EntregaAlfandega, 
			NULL USD_Exp_Tx,
			--dbo.fBusca_CampoCliente(@Num_Proc,111) USD_Exp_Tx,-- Desativado por Erbson - 12/04/2017 - Transferido para ReportManagerV2
			
			NULL USD_Exp_Date,
			--dbo.fBusca_CampoCliente(NUM_PROC_LEM,113) USD_Exp_Date, -- Desativado por Erbson - 12/04/2017 - Transferido para ReportManagerV2
			NULL DTA_Number
			--dbo.fBusca_TipoDocCliente('N',@Num_Proc,45) DTA_Number -- Desativado por Erbson - 11/04/2017 - Transferido para ReportManagerV2
		FROM 
			LLP_EXP_MAR LLP With (Nolock)
			--Left Join Tipo_Status_Processo TS on TS.id_status=LLP.id_status
			--left join Courier_Processo CP2 with(nolock) on CP2.num_proc = LLP.Num_Proc_Lem and CP2.ID_Item = 2
			--left join Courier_Processo CP3 with(nolock) on CP3.num_proc = LLP.Num_Proc_Lem and CP3.ID_Item = 3	
		WHERE 
			NUM_PROC_LEM=@num_proc
	End

IF left(@num_proc,2)='IA'

	Begin
		SELECT 
			Num_Proc_Lia JOB,
			NULL ENTRYNUMBER,
			--dbo.fBusca_TipoDocCliente('N',Num_Proc_Lia,5) ENTRYNUMBER,
			NULL SALES_ORDER,
			--dbo.fBusca_TipoDocCliente('N',Num_Proc_Lia,3) SALES_ORDER,
			NULL Invoice_Number,
			--left(dbo.fBusca_Docs_PO_Modal(@Num_Proc,2),80) Invoice_Number,
			NULL NotaFiscal,
			--dbo.fBusca_Docs_PO_Modal(Num_Proc_Lia,'10') NotaFiscal, 
			NULL DataNF,
			--cast(dbo.fBusca_TipoDocCliente('D',Num_Proc_Lia,10) as datetime) DataNF,
			--dbo.fBusca_TipoDocCliente('N',Num_Proc_Lia,1) PONumber,
			
			NULL PONumber, --left(dbo.fBusca_Docs_PO_Modal(Num_Proc_Lia,1),500)PONumber, cadu 09/02/2015 - XML
			NULL DtOrder,
			--cast(dbo.fBusca_TipoDocCliente('D',Num_Proc_Lia,3) as datetime) DtOrder,
			NULL LI_Number,
			--dbo.fBusca_Docs_PO_Modal(Num_Proc_Lia,'23') LI_Number,
			NULL LIDate,
			--cast(dbo.fBusca_TipoDocCliente('D',Num_Proc_Lia,23) as datetime) LIDate,
			NULl Nec_LI,
			--isnull(dbo.fBusca_CampoCliente(Num_Proc_Lia,5),3) Nec_LI, 
			NULL DataDI,
			--cast(dbo.fBusca_TipoDocCliente('D',Num_Proc_Lia,5) as datetime) DataDI,
			NULL DeliveryNote,
			--dbo.fBusca_TipoDocCliente('N',Num_Proc_Lia,7) DeliveryNote,
			NULL Customer_PO,
			--dbo.fBusca_TipoDocCliente('N',Num_Proc_Lia,9) Customer_PO,
			NULL Volume_Santos,
			--dbo.fBusca_CampoCliente(Num_Proc_Lia,37) Volume_Santos,
			NULL Liberacao_Laudo,
			--dbo.fBusca_CampoCliente(Num_Proc_Lia,38) Liberacao_Laudo,
			NULL CE_Mercante,
			--dbo.fBusca_TipoDocCliente('N',Num_Proc_Lia,29) CE_Mercante,
			NULL Invoice_Agente,
			--dbo.fBusca_TipoDocCliente('N',Num_Proc_Lia,74)  Invoice_Agente,
			NULL Status,
			--dbo.fBusca_CampoCliente(Num_Proc_Lia,79) Status,
			NULL CE_Mercante_Master,
			--dbo.fBusca_TipoDocCliente('N',Num_Proc_Lia,85) CE_Mercante_Master,
			NULL FirstVessel,
			--dbo.fBusca_CampoCliente(Num_Proc_Lia,84) FirstVessel,- Desativado por Erbson - 27/04/2017 - Transferido para ReportManagerV2
			NULL ETATranshipment,
			--convert(datetime,dbo.fBusca_CampoCliente(Num_Proc_Lia,85),103) ETATranshipment,- Desativado por Erbson - 27/04/2017 - Transferido para ReportManagerV2
			Null DDE_Numero,null DDE_Data,
			NULL SC,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIA,91) SC,- Desativado por Erbson - 26/04/2017 - Transferido para ReportManagerV2
			 null arktec, 
			NULL Invoice_Date,
			--cast(dbo.fBusca_TipoDocCliente('D',NUM_PROC_LIA,2) as datetime) Invoice_Date, - Desativado por Erbson - 20/04/2017 - Transferido para ReportManagerV2
			NULL DTA_Date,
			--cast(dbo.fBusca_TipoDocCliente('D',NUM_PROC_LIA,45) as datetime) DTA_Date,
			NULL Shipment_number,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIA,8) Shipment_Number,
			NULL Despacho,
			--isnull(dbo.fBusca_CampoCliente(NUM_PROC_LIA,32),1) Despacho,
			NULL Urgente,
			--isnull(dbo.fBusca_CampoCliente(NUM_PROC_LIA,36),2) Urgente,
			NULL Divisao,
			--dbo.fBusca_CampoCliente(NUM_PROC_LIA,11) Divisao,- Desativado por Erbson - 20/04/2017 - Transferido para ReportManagerV2
			NULL Area,
			--dbo.fBusca_CampoCliente(NUM_PROC_LIa,24) Area, - Desativado por Erbson - 19/04/2017 - Transferido para ReportManagerV2
			NULL Departamento,
			--dbo.fBusca_CampoCliente(NUM_PROC_LIA,13) Departamento,- Desativado por Erbson - 19/04/2017 - Transferido para ReportManagerV2
			Null Segunda_Referencia, dbo.fBusca_CampoCliente(NUM_PROC_LIA,92) Agenda,
			NULL Valor_Danfe,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIA,83) Valor_Danfe,  -- Desativado por Erbson - 19/04/2017 - NUNCA PREENCHIDO
			NULL Horario_Agenda,
			--dbo.fBusca_CampoCliente(NUM_PROC_LIA,93) Horario_Agenda, -- Desativado por Erbson - 19/04/2017 - Transferido para ReportManagerV2
			NULL QTD_Veiculos,
			--dbo.fBusca_CampoCliente(NUM_PROC_LIA,94) QTD_Veiculos,-- Desativado por Erbson - 19/04/2017 - Transferido para ReportManagerV2
			dbo.fBusca_CampoCliente(NUM_PROC_LIA,95) Tipo_LI, Null Lote ,
			NULL COA_Number,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIA,16) COA_Number,
			Null  Status_Descricao,
			NULL RENumber,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIA,04) RENumber, - Desativado por Erbson - 18/04/2017 - Transferido para ReportManagerV2
			NULL FormA,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIM,14) FormA, -- Desativado por Erbson - 17/04/2017 - Transferido para ReportManagerV2
			NULL DirectCollection,
			--left(dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIM,36),49) DirectCollection, -- Desativado por Erbson - 17/04/2017 - Transferido para ReportManagerV2
			NULL DirectCollection_Date,
			--cast(dbo.fBusca_TipoDocCliente('D',NUM_PROC_LIM,36) as datetime) DirectCollection_Date, -- Desativado por Erbson - 17/04/2017 - Transferido para ReportManagerV2
			NULL Cobranza,Null Cobranza_Date,
			NULL DSE,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIM,26) DSE,  -- Desativado por Erbson - 17/04/2017 - Transferido para ReportManagerV2
			NULL DSE_Date,
			--convert(datetime,dbo.fBusca_TipoDocCliente('D',NUM_PROC_LIM,26)) DSE_Date,  -- Desativado por Erbson - 17/04/2017 - Transferido para ReportManagerV2
			 
			--dbo.fBusca_TipoDocCliente('N',@Num_Proc,94) Courier_2,
			--cast(dbo.fBusca_TipoDocCliente('D',@Num_Proc,94) as datetime)Data_Courier_2,
			--dbo.fBusca_TipoDocCliente('N',@Num_Proc,115) Courier_3,
			--cast(dbo.fBusca_TipoDocCliente('D',@Num_Proc,115) as datetime)Data_Courier_3,
			NULL Courier_2,
			--CP2.num_courier	Courier_2, -- Desativado por Erbson - 13/04/2017 - Transferido para ReportManagerV2
			NULL Data_Courier_2,
			--CP2.Dt_Courier	Data_Courier_2, -- Desativado por Erbson - 13/04/2017 - Transferido para ReportManagerV2
			NULL Courier_3,
			--CP3.num_courier	Courier_3, -- Desativado por Erbson - 13/04/2017 - Transferido para ReportManagerV2
			NULL Data_Courier_3,
			--CP3.Dt_Courier	Data_Courier_3, -- Desativado por Erbson - 13/04/2017 - Transferido para ReportManagerV2
			
			dbo.fBusca_TipoDocCliente('N',@Num_Proc,118) Cambio_Numero,cast(dbo.fBusca_TipoDocCliente('D',@Num_Proc,118) as datetime) Cambio_Date,
			Null Avaria,Null DeadLineRemocao,Null EntregaAlfandega, Null USD_Exp_Tx, null USD_Exp_Date,
			NULL DTA_Number
			--dbo.fBusca_TipoDocCliente('N',@Num_Proc,45) DTA_Number -- Desativado por Erbson - 11/04/2017 - Transferido para ReportManagerV2
		FROM 
			LLP_IMP_AER LLP With(NoLock)
			--Left Join Tipo_Status_Processo TS on TS.id_status=LLP.id_status
			--left join Courier_Processo CP2 with(nolock) on CP2.num_proc = LLP.Num_Proc_Lia and CP2.ID_Item = 2
			--left join Courier_Processo CP3 with(nolock) on CP3.num_proc = LLP.Num_Proc_Lia and CP3.ID_Item = 3	
		WHERE 
			Num_Proc_Lia=@num_proc
	End

if left(@num_proc,2)='EA'
	Begin
		SELECT 
			Num_Proc_Lea JOB,
			NULL ENTRYNUMBER,
			--dbo.fBusca_TipoDocCliente('N',Num_Proc_Lea,4) ENTRYNUMBER,
			NULL SALES_ORDER,
			--dbo.fBusca_TipoDocCliente('N',Num_Proc_Lea,3) SALES_ORDER,
			NULL Invoice_Number,
			--left(dbo.fBusca_Docs_PO_Modal(@Num_Proc,2),80) Invoice_Number,
			NULL NotaFiscal,
			--dbo.fBusca_Docs_PO_Modal(Num_Proc_Lea,'10') NotaFiscal,
			NULL DataNF,
			--cast(dbo.fBusca_TipoDocCliente('D',Num_Proc_Lea,10) as datetime) DataNF,
			--dbo.fBusca_TipoDocCliente('N',Num_Proc_Lea,1) PONumber,
			
			NULL PONumber, --left(dbo.fBusca_Docs_PO_Modal(NUM_PROC_Lea,1),500)PONumber,  cadu 09/02/2015 - XML
			NULL DtOrder,
			--cast(dbo.fBusca_TipoDocCliente('D',Num_Proc_Lea,3) as datetime) DtOrder,
			NULL LI_Number,
			--dbo.fBusca_Docs_PO_Modal(Num_Proc_Lea,'23') LI_Number,
			NULL LIDate,
			--cast(dbo.fBusca_TipoDocCliente('D',Num_Proc_Lea,23) as datetime) LIDate,
			NULL Nec_LI,
			--isnull(dbo.fBusca_CampoCliente(Num_Proc_Lea,5),3) Nec_LI, 
			NULL DataDI,
			--cast(dbo.fBusca_TipoDocCliente('D',Num_Proc_Lea,4) as datetime) DataDI,
			NULL DeliveryNote,
			--dbo.fBusca_TipoDocCliente('N',Num_Proc_Lea,7) DeliveryNote,
			NULL Customer_PO,
			--dbo.fBusca_TipoDocCliente('N',Num_Proc_Lea,9) Customer_PO,
			NULL Volume_Santos,
			--dbo.fBusca_CampoCliente(Num_Proc_Lea,37) Volume_Santos,
			NULL Liberacao_Laudo,
			--dbo.fBusca_CampoCliente(Num_Proc_Lea,38) Liberacao_Laudo,
			NULL CE_Mercante,
			--dbo.fBusca_TipoDocCliente('N',Num_Proc_Lea,29) CE_Mercante,
			NULL Invoice_Agente,
			--dbo.fBusca_TipoDocCliente('N',Num_Proc_Lea,74)  Invoice_Agente,
			NULL Status,
			--dbo.fBusca_CampoCliente(Num_Proc_Lea,79) Status,
			NULL CE_Mercante_Master,
			--dbo.fBusca_TipoDocCliente('N',Num_Proc_Lea,85) CE_Mercante_Master,
			NULL FirstVessel,
			--dbo.fBusca_CampoCliente(Num_Proc_Lea,84) FirstVessel,- Desativado por Erbson - 27/04/2017 - Transferido para ReportManagerV2
			NULL ETATranshipment,
			--cast(dbo.fBusca_CampoCliente(Num_Proc_Lea,85) as datetime) ETATranshipment,
			NULL DDE_Numero,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LEA,12) DDE_Numero, 
			NULL DDE_Data,
			cast(dbo.fBusca_TipoDocCliente('D',NUM_PROC_LEA,12) as datetime) DDE_Data,
			NULL SC,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LEA,91) SC, - Desativado por Erbson - 26/04/2017 - Transferido para ReportManagerV2
			NULL ArkTec,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LEA,30) ArkTec,  - Desativado por Erbson - 24/04/2017 - Transferido para ReportManagerV2
			NULL Invoice_Date,
			--cast(dbo.fBusca_TipoDocCliente('D',NUM_PROC_LEA,2) as datetime) Invoice_Date,- Desativado por Erbson - 20/04/2017 - Transferido para ReportManagerV2
			Null DTA_Date, 
			NULL Shipment_number,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LEA,8) Shipment_Number,
			NULL Despacho,
			--isnull(dbo.fBusca_CampoCliente(NUM_PROC_LEA,32),1) Despacho, 
			NULL Urgente,
			--isnull(dbo.fBusca_CampoCliente(NUM_PROC_LEA,36),2) Urgente,
			NULL Divisao,
			--dbo.fBusca_CampoCliente(NUM_PROC_LEA,11) Divisao,- Desativado por Erbson - 20/04/2017 - Transferido para ReportManagerV2
			NULL Area,
			--dbo.fBusca_CampoCliente(NUM_PROC_LEA,24) Area, - Desativado por Erbson - 19/04/2017 - Transferido para ReportManagerV2
			NULL Departamento,
			--dbo.fBusca_CampoCliente(NUM_PROC_LEA,13) Departamento, - Desativado por Erbson - 19/04/2017 - Transferido para ReportManagerV2
			Null Segunda_Referencia, dbo.fBusca_CampoCliente(NUM_PROC_LEA,92) Agenda,
			null Valor_Danfe, Null Horario_Agenda, Null QTD_Veiculos,Null Tipo_LI, Null Lote,
			NULL COA_Number,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LEA,16) COA_Number,
			Null Status_Descricao,
			NULL RENumber,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LEA,04) RENumber,- Desativado por Erbson - 18/04/2017 - Transferido para ReportManagerV2
			NULL FormA,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIM,14) FormA, -- Desativado por Erbson - 17/04/2017 - Transferido para ReportManagerV2
			NULL DirectCollection,
			--left(dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIM,36),49) DirectCollection, -- Desativado por Erbson - 17/04/2017 - Transferido para ReportManagerV2
			NULL DirectCollection_Date,
			--cast(dbo.fBusca_TipoDocCliente('D',NUM_PROC_LIM,36) as datetime) DirectCollection_Date, -- Desativado por Erbson - 17/04/2017 - Transferido para ReportManagerV2
			NULL Cobranza,Null Cobranza_Date,
			NULL DSE,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIM,26) DSE,  -- Desativado por Erbson - 17/04/2017 - Transferido para ReportManagerV2
			NULL DSE_Date,
			--convert(datetime,dbo.fBusca_TipoDocCliente('D',NUM_PROC_LIM,26)) DSE_Date,  -- Desativado por Erbson - 17/04/2017 - Transferido para ReportManagerV2
			--dbo.fBusca_TipoDocCliente('N',@Num_Proc,94) Courier_2,
			--cast(dbo.fBusca_TipoDocCliente('D',@Num_Proc,94) as datetime)Data_Courier_2,
			--dbo.fBusca_TipoDocCliente('N',@Num_Proc,115) Courier_3,
			--cast(dbo.fBusca_TipoDocCliente('D',@Num_Proc,115) as datetime)Data_Courier_3,
			NULL Courier_2,
			--CP2.num_courier	Courier_2, -- Desativado por Erbson - 13/04/2017 - Transferido para ReportManagerV2
			NULL Data_Courier_2,
			--CP2.Dt_Courier	Data_Courier_2, -- Desativado por Erbson - 13/04/2017 - Transferido para ReportManagerV2
			NULL Courier_3,
			--CP3.num_courier	Courier_3, -- Desativado por Erbson - 13/04/2017 - Transferido para ReportManagerV2
			NULL Data_Courier_3,
			--CP3.Dt_Courier	Data_Courier_3, -- Desativado por Erbson - 13/04/2017 - Transferido para ReportManagerV2
			
			dbo.fBusca_TipoDocCliente('N',@Num_Proc,118) Cambio_Numero,cast(dbo.fBusca_TipoDocCliente('D',@Num_Proc,118) as datetime) Cambio_Date,
			Null Avaria,Null DeadLineRemocao,Null EntregaAlfandega,
			
			NULL USD_Exp_Tx,
			--dbo.fBusca_CampoCliente(@Num_Proc,111) USD_Exp_Tx,-- Desativado por Erbson - 12/04/2017 - Transferido para ReportManagerV2
			
			NULL USD_Exp_Date,
			--dbo.fBusca_CampoCliente(NUM_PROC_LEM,113) USD_Exp_Date, -- Desativado por Erbson - 12/04/2017 - Transferido para ReportManagerV2
			
			NULL DTA_Number
			--dbo.fBusca_TipoDocCliente('N',@Num_Proc,45) DTA_Number -- Desativado por Erbson - 11/04/2017 - Transferido para ReportManagerV2
		FROM 
			LLP_Exp_Aer LLP With(nolock)
			--Left Join Tipo_Status_Processo TS on TS.id_status=LLP.id_status
			--left join Courier_Processo CP2 with(nolock) on CP2.num_proc = LLP.Num_Proc_Lea and CP2.ID_Item = 2
			--left join Courier_Processo CP3 with(nolock) on CP3.num_proc = LLP.Num_Proc_Lea and CP3.ID_Item = 3				
		WHERE 
			Num_Proc_Lea=@num_proc
	End

if left(@num_proc,2)='EO'
	Begin
		SELECT 
			Num_Proc_Leo JOB,
			NULL ENTRYNUMBER,
			--dbo.fBusca_TipoDocCliente('N',Num_Proc_Leo,4) ENTRYNUMBER,
			NULL SALES_ORDER,
			--dbo.fBusca_TipoDocCliente('N',Num_Proc_Leo,3) SALES_ORDER,
			NULL Invoice_Number,
			--left(dbo.fBusca_Docs_PO_Modal(@Num_Proc,2),80) Invoice_Number,
			NULL NotaFiscal,
			--dbo.fBusca_Docs_PO_Modal(Num_Proc_Leo,'10') NotaFiscal, 
			NULL DataNF,
			--cast(dbo.fBusca_TipoDocCliente('D',Num_Proc_Leo,10) as datetime) DataNF,
			--dbo.fBusca_TipoDocCliente('N',Num_Proc_Leo,1) PONumber,
			
			NULL PONumber, --left(dbo.fBusca_Docs_PO_Modal(NUM_PROC_Leo,1),500)PONumber, cadu 09/02/2015 - XML
			NULL DtOrder,
			--cast(dbo.fBusca_TipoDocCliente('D',Num_Proc_Leo,3) as datetime) DtOrder,
			NULL LI_Number,
			--dbo.fBusca_Docs_PO_Modal(Num_Proc_Leo,'23') LI_Number,
			NULL LIDate,
			--cast(dbo.fBusca_TipoDocCliente('D',Num_Proc_Leo,23) as datetime) LIDate,
			NULL Nec_LI,
			--isnull(dbo.fBusca_CampoCliente(Num_Proc_Leo,5),3) Nec_LI, 
			NULL DataDI,
			--cast(dbo.fBusca_TipoDocCliente('D',Num_Proc_Leo,4) as datetime) DataDI,
			NULL DeliveryNote,
			--dbo.fBusca_TipoDocCliente('N',Num_Proc_Leo,7) DeliveryNote,
			NULL Customer_PO,
			--dbo.fBusca_TipoDocCliente('N',Num_Proc_Leo,9) Customer_PO,
			NULL Volume_Santos,
			--dbo.fBusca_CampoCliente(Num_Proc_Leo,37) Volume_Santos,
			NULL Liberacao_Laudo,
			--dbo.fBusca_CampoCliente(Num_Proc_Leo,38) Liberacao_Laudo,
			NULL CE_Mercante,
			--dbo.fBusca_TipoDocCliente('N',Num_Proc_Leo,29) CE_Mercante,
			NULL Invoice_Agente,
			--dbo.fBusca_TipoDocCliente('N',Num_Proc_Leo,74)  Invoice_Agente,
			NULL Status,
			--dbo.fBusca_CampoCliente(Num_Proc_Leo,79) Status,
			NULL CE_Mercante_Master,
			--dbo.fBusca_TipoDocCliente('N',Num_Proc_Leo,85) CE_Mercante_Master,
			NULL FirstVessel,
			--dbo.fBusca_CampoCliente(Num_Proc_Leo,84) FirstVessel,- Desativado por Erbson - 27/04/2017 - Transferido para ReportManagerV2
			NULL ETATranshipment,
			--cast(dbo.fBusca_CampoCliente(Num_Proc_Leo,85) as datetime) ETATranshipment,- Desativado por Erbson - 27/04/2017 - Transferido para ReportManagerV2
			NULL DDE_Numero,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LEo,12) DDE_Numero, 
			NULL DDE_Data,
			--cast(dbo.fBusca_TipoDocCliente('D',NUM_PROC_LEo,12) as datetime) DDE_Data,
			NULL SC,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LEO,91) SC, - Desativado por Erbson - 26/04/2017 - Transferido para ReportManagerV2
			NULL ArkTec,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LEO,30) ArkTec,- Desativado por Erbson - 24/04/2017 - Transferido para ReportManagerV2
			NULL Invoice_Date,
			--cast(dbo.fBusca_TipoDocCliente('D',NUM_PROC_LEO,2) as datetime) Invoice_Date, - Desativado por Erbson - 20/04/2017 - Transferido para ReportManagerV2
			Null DTA_Date, 
			NULL Shipment_number,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LEO,8) Shipment_Number,
			NULL Despacho,
			--isnull(dbo.fBusca_CampoCliente(NUM_PROC_Leo,32),1) Despacho,
			NULL Urgente,
			--isnull(dbo.fBusca_CampoCliente(NUM_PROC_LEO,36),2) Urgente,
			NULL Divisao,
			--dbo.fBusca_CampoCliente(NUM_PROC_LEO,11) Divisao, - Desativado por Erbson - 20/04/2017 - Transferido para ReportManagerV2
			NULL Area,
			--dbo.fBusca_CampoCliente(NUM_PROC_LEO,24) Area, - Desativado por Erbson - 19/04/2017 - Transferido para ReportManagerV2
			NULL Departamento,
			--dbo.fBusca_CampoCliente(NUM_PROC_LEO,13) Departamento,- Desativado por Erbson - 19/04/2017 - Transferido para ReportManagerV2
			Null Segunda_Referencia, dbo.fBusca_CampoCliente(NUM_PROC_LEO,92) Agenda,
			null Valor_Danfe, null Horario_Agenda, Null QTD_Veiculos, Null Tipo_LI, Null Lote,
			NULL COA_Number,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LEO,16) COA_Number,
			Null Status_Descricao,
			NULL RENumber,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LEO,04) RENumber,- Desativado por Erbson - 18/04/2017 - Transferido para ReportManagerV2
			NULL FormA,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIM,14) FormA, -- Desativado por Erbson - 17/04/2017 - Transferido para ReportManagerV2 
			NULL DirectCollection,
			--left(dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIM,36),49) DirectCollection, -- Desativado por Erbson - 17/04/2017 - Transferido para ReportManagerV2
			NULL DirectCollection_Date,
			--cast(dbo.fBusca_TipoDocCliente('D',NUM_PROC_LIM,36) as datetime) DirectCollection_Date, -- Desativado por Erbson - 17/04/2017 - Transferido para ReportManagerV2
			NULL Cobranza,Null Cobranza_Date,
			NULL DSE,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIM,26) DSE,  -- Desativado por Erbson - 17/04/2017 - Transferido para ReportManagerV2
			NULL DSE_Date,
			--convert(datetime,dbo.fBusca_TipoDocCliente('D',NUM_PROC_LIM,26)) DSE_Date,  -- Desativado por Erbson - 17/04/2017 - Transferido para ReportManagerV2
			--dbo.fBusca_TipoDocCliente('N',@Num_Proc,94) Courier_2,
			--cast(dbo.fBusca_TipoDocCliente('D',@Num_Proc,94) as datetime)Data_Courier_2,
			--dbo.fBusca_TipoDocCliente('N',@Num_Proc,115) Courier_3,
			--cast(dbo.fBusca_TipoDocCliente('D',@Num_Proc,115) as datetime)Data_Courier_3,
			NULL Courier_2,
			--CP2.num_courier	Courier_2, -- Desativado por Erbson - 13/04/2017 - Transferido para ReportManagerV2
			NULL Data_Courier_2,
			--CP2.Dt_Courier	Data_Courier_2, -- Desativado por Erbson - 13/04/2017 - Transferido para ReportManagerV2
			NULL Courier_3,
			--CP3.num_courier	Courier_3, -- Desativado por Erbson - 13/04/2017 - Transferido para ReportManagerV2
			NULL Data_Courier_3,
			--CP3.Dt_Courier	Data_Courier_3, -- Desativado por Erbson - 13/04/2017 - Transferido para ReportManagerV2
			
			dbo.fBusca_TipoDocCliente('N',@Num_Proc,118) Cambio_Numero,cast(dbo.fBusca_TipoDocCliente('D',@Num_Proc,118) as datetime) Cambio_Date,
			Null Avaria,Null DeadLineRemocao,Null EntregaAlfandega,
			
			NULL USD_Exp_Tx,
			--dbo.fBusca_CampoCliente(@Num_Proc,111) USD_Exp_Tx,-- Desativado por Erbson - 12/04/2017 - Transferido para ReportManagerV2
			
			NULL USD_Exp_Date,
			--dbo.fBusca_CampoCliente(NUM_PROC_LEM,113) USD_Exp_Date, -- Desativado por Erbson - 12/04/2017 - Transferido para ReportManagerV2
			
			NULL DTA_Number
			--dbo.fBusca_TipoDocCliente('N',@Num_Proc,45) DTA_Number -- Desativado por Erbson - 11/04/2017 - Transferido para ReportManagerV2
		FROM
			LLP_Exp_Out LLP With(nolock)
			--Left Join Tipo_Status_Processo TS on TS.id_status=LLP.id_status
			--left join Courier_Processo CP2 with(nolock) on CP2.num_proc = LLP.Num_Proc_Leo and CP2.ID_Item = 2
			--left join Courier_Processo CP3 with(nolock) on CP3.num_proc = LLP.Num_Proc_Leo and CP3.ID_Item = 3			
		WHERE 
			Num_Proc_Leo=@num_proc
	End

if left(@num_proc,2)='IO'
	Begin
		SELECT 
			Num_Proc_Lio JOB,
			NULL ENTRYNUMBER,
			--dbo.fBusca_TipoDocCliente('N',Num_Proc_Lio,5) ENTRYNUMBER,
			NULL SALES_ORDER,
			--dbo.fBusca_TipoDocCliente('N',Num_Proc_Lio,3) SALES_ORDER,
			NULL Invoice_Number,
			--left(dbo.fBusca_Docs_PO_Modal(@Num_Proc,2),80) Invoice_Number,
			NULL NotaFiscal,
			--dbo.fBusca_Docs_PO_Modal(Num_Proc_Lio,'10') NotaFiscal, 
			NULL DataNF,
			--cast(dbo.fBusca_TipoDocCliente('D',Num_Proc_Lio,10) as datetime) DataNF,
			--dbo.fBusca_TipoDocCliente('N',Num_Proc_Lio,1) PONumber,
			
			NULL PONumber, --left(dbo.fBusca_Docs_PO_Modal(NUM_PROC_LIo,1),500)PONumber, cadu 09/02/2015 - XML
			NULL DtOrder,
			--cast(dbo.fBusca_TipoDocCliente('D',Num_Proc_Lio,3) as datetime) DtOrder,
			NULL LI_Number,
			--dbo.fBusca_Docs_PO_Modal(Num_Proc_Lio,'23') LI_Number,
			NULL LIDate,
			--cast(dbo.fBusca_TipoDocCliente('D',Num_Proc_Lio,23) as datetime) LIDate,
			NULL Nec_LI,
			--isnull(dbo.fBusca_CampoCliente(Num_Proc_Lio,5),3) Nec_LI, 
			NULL DataDI,
			--cast(dbo.fBusca_TipoDocCliente('D',Num_Proc_Lio,5) as datetime) DataDI,
			NULL DeliveryNote,
			--dbo.fBusca_TipoDocCliente('N',Num_Proc_Lio,7) DeliveryNote,
			NULL Customer_PO,
			--dbo.fBusca_TipoDocCliente('N',Num_Proc_Lio,9) Customer_PO,
			NULL Volume_Santos,
			--dbo.fBusca_CampoCliente(Num_Proc_Lio,37) Volume_Santos,
			NULL Liberacao_Laudo,
			--dbo.fBusca_CampoCliente(Num_Proc_Lio,38) Liberacao_Laudo,
			NULL CE_Mercante,
			--dbo.fBusca_TipoDocCliente('N',Num_Proc_Lio,29) CE_Mercante,
			NULL Invoice_Agente,
			--dbo.fBusca_TipoDocCliente('N',Num_Proc_Lio,74)  Invoice_Agente,
			NULL Status,
			--dbo.fBusca_CampoCliente(Num_Proc_Lio,79) Status,
			NULL CE_Mercante_Master,
			--dbo.fBusca_TipoDocCliente('N',Num_Proc_Lio,85) CE_Mercante_Master,
			NULL FirstVessel,
			--dbo.fBusca_CampoCliente(Num_Proc_Lio,84) FirstVessel,- Desativado por Erbson - 27/04/2017 - Transferido para ReportManagerV2
			NULL ETATranshipment,
			--cast(dbo.fBusca_CampoCliente(Num_Proc_Lio,85) as datetime) ETATranshipment,- Desativado por Erbson - 27/04/2017 - Transferido para ReportManagerV2
			Null DDE_Numero, Null DDE_Data,
			NULL SC,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIO,91) SC,- Desativado por Erbson - 26/04/2017 - Transferido para ReportManagerV2
			null ArkTec ,
			NULL Invoice_Date,
			--cast(dbo.fBusca_TipoDocCliente('D',NUM_PROC_LIO,2) as datetime) Invoice_Date,- Desativado por Erbson - 20/04/2017 - Transferido para ReportManagerV2
			NULL DTA_Date,
			--cast(dbo.fBusca_TipoDocCliente('D',NUM_PROC_LIO,45) as datetime) DTA_Date, 
			NULL Shipment_number,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIO,8) Shipment_Number,
			NULL Despacho,
			--isnull(dbo.fBusca_CampoCliente(NUM_PROC_Lio,32),1) Despacho,
			NULL Urgente,
			--isnull(dbo.fBusca_CampoCliente(NUM_PROC_LIO,36),2) Urgente,
			NULL Divisao,
			--dbo.fBusca_CampoCliente(NUM_PROC_LIO,11) Divisao,- Desativado por Erbson - 20/04/2017 - Transferido para ReportManagerV2
			NULL Area,
			--dbo.fBusca_CampoCliente(NUM_PROC_LIO,24) Area,- Desativado por Erbson - 19/04/2017 - Transferido para ReportManagerV2
			NULL Departamento,
			--dbo.fBusca_CampoCliente(NUM_PROC_LIO,13) Departamento,- Desativado por Erbson - 19/04/2017 - Transferido para ReportManagerV2
			Null Segunda_Referencia, dbo.fBusca_CampoCliente(NUM_PROC_LIO,92) Agenda,
			NULL Valor_Danfe,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIO,83) Valor_Danfe, -- Desativado por Erbson - 19/04/2017 - NUNCA PREENCHIDO
			NULL Horario_Agenda,
			--dbo.fBusca_CampoCliente(NUM_PROC_LIO,93) Horario_Agenda, -- Desativado por Erbson - 19/04/2017 - Transferido para ReportManagerV2
			NULL QTD_Veiculos,
			--dbo.fBusca_CampoCliente(NUM_PROC_LIO,94) QTD_Veiculos, -- Desativado por Erbson - 19/04/2017 - Transferido para ReportManagerV2
			dbo.fBusca_CampoCliente(NUM_PROC_LIO,95) Tipo_LI, Null Lote,
			NULL COA_Number,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIO,16) COA_Number,
			Null Status_Descricao,
			NULL RENumber,
			dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIO,04) RENumber, -- Desativado por Erbson - 18/04/2017 - Transferido para ReportManagerV2
			NULL FormA,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIM,14) FormA, -- Desativado por Erbson - 17/04/2017 - Transferido para ReportManagerV2
			NULL DirectCollection,
			--left(dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIM,36),49) DirectCollection, -- Desativado por Erbson - 17/04/2017 - Transferido para ReportManagerV2
			NULL DirectCollection_Date,
			--cast(dbo.fBusca_TipoDocCliente('D',NUM_PROC_LIM,36) as datetime) DirectCollection_Date, -- Desativado por Erbson - 17/04/2017 - Transferido para ReportManagerV2
			NULL Cobranza,Null Cobranza_Date,
			NULL DSE,
			--dbo.fBusca_TipoDocCliente('N',NUM_PROC_LIM,26) DSE,  -- Desativado por Erbson - 17/04/2017 - Transferido para ReportManagerV2
			NULL DSE_Date,
			--convert(datetime,dbo.fBusca_TipoDocCliente('D',NUM_PROC_LIM,26)) DSE_Date,  -- Desativado por Erbson - 17/04/2017 - Transferido para ReportManagerV2
			--dbo.fBusca_TipoDocCliente('N',@Num_Proc,94) Courier_2,
			--cast(dbo.fBusca_TipoDocCliente('D',@Num_Proc,94) as datetime)Data_Courier_2,
			--dbo.fBusca_TipoDocCliente('N',@Num_Proc,115) Courier_3,
			--cast(dbo.fBusca_TipoDocCliente('D',@Num_Proc,115) as datetime)Data_Courier_3,
			NULL Courier_2,
			--CP2.num_courier	Courier_2, -- Desativado por Erbson - 13/04/2017 - Transferido para ReportManagerV2
			NULL Data_Courier_2,
			--CP2.Dt_Courier	Data_Courier_2, -- Desativado por Erbson - 13/04/2017 - Transferido para ReportManagerV2
			NULL Courier_3,
			--CP3.num_courier	Courier_3, -- Desativado por Erbson - 13/04/2017 - Transferido para ReportManagerV2
			NULL Data_Courier_3,
			--CP3.Dt_Courier	Data_Courier_3, -- Desativado por Erbson - 13/04/2017 - Transferido para ReportManagerV2
			
			dbo.fBusca_TipoDocCliente('N',@Num_Proc,118) Cambio_Numero,cast(dbo.fBusca_TipoDocCliente('D',@Num_Proc,118) as datetime) Cambio_Date,
			Null Avaria,Null DeadLineRemocao,Null EntregaAlfandega,		Null USD_Exp_Tx, null USD_Exp_Date,
			
			NULL DTA_Number
			--dbo.fBusca_TipoDocCliente('N',@Num_Proc,45) DTA_Number -- Desativado por Erbson - 11/04/2017 - Transferido para ReportManagerV2
		FROM 
			LLP_Imp_Out LLP With (Nolock)
			--Left Join Tipo_Status_Processo TS on TS.id_status=LLP.id_status
			--left join Courier_Processo CP2 with(nolock) on CP2.num_proc = LLP.Num_Proc_Lio and CP2.ID_Item = 2
			--left join Courier_Processo CP3 with(nolock) on CP3.num_proc = LLP.Num_Proc_Lio and CP3.ID_Item = 3
		WHERE 
			Num_Proc_Lio=@num_proc
	End



























GO
