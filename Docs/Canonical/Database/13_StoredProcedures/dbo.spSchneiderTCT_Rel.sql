SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSchneiderTCT_Rel]
AS

/* -------------------------------------------------------------------------------------------------------------------------
HISTORY CHANGE
. Date:
. Applicant: 
. Developer: Alessandra Suzuki Mariano
. Request:	
-------------------------------------------------------------------------------------------------------------------------
EXECUTION EXECUTION
exec  spSchneiderTCT_Rel
-------------------------------------------------------------------------------------------------------------------------

*/
DECLARE @qtd_dias_ATA INT 
DECLARE @qtd_dias_ETA INT 

DECLARE @PAIS			VARCHAR(2)
DECLARE	@TEST			BIT

SET @PAIS = (SELECT TOP 1 CD_VERSAO FROM VERSAO (NOLOCK))
SET @TEST = 0

IF (@@SERVERNAME = 'WUSPQASQL08' )
	BEGIN
		SET @TEST = 1
	END
ELSE IF (DB_NAME() <> 'Atlantis' and DB_NAME() <> 'ATL_CL'  )
	BEGIN
		SET @TEST = 1
	END

--29/10/2020
IF @TEST = 1
	BEGIN
		SET @qtd_dias_ATA = 720
		SET @qtd_dias_ETA = 720
	END
ELSE
	BEGIN
		SET @qtd_dias_ATA = 60 -- ATA plus 30 days to drop files.
		SET @qtd_dias_ETA = 90 -- Change ETA to drop file to 60days	 

		--SET @qtd_dias_ATA = 2275 -- ATA plus 30 days to drop files.
		--SET @qtd_dias_ETA = 2275 -- Change ETA to drop file to 60days	 
	END

	IF OBJECT_ID('dbo.tmp_Schneider_TCT', 'u') IS NOT NULL 
		DROP TABLE tmp_Schneider_TCT

	CREATE TABLE [dbo].[tmp_Schneider_TCT](
	[ServiceCodeIndicator]				VARCHAR(1)		NOT NULL,
	[LLP]								VARCHAR(3)		NOT NULL,
	[Input Date Time]					DATETIME		NULL,
	[Job Number]						VARCHAR(16)		NOT NULL,
	[Transport Mode]					VARCHAR(10)		NOT NULL,
	[MAWB]								VARCHAR(25)		NULL,
	[Housebill / Shipment]				VARCHAR(25)		NULL,
	[Vessel name]						VARCHAR(50)		NULL,
	[Origin Station]					VARCHAR(6)		NULL,
	[Origin Country Code]				VARCHAR(2)		NULL,
	[Origin Region]						VARCHAR(10)		NULL,
	[Shipper Name]						VARCHAR(60)		NOT NULL,
	[Destination Station]				VARCHAR(6)		NULL,
	[Destination Country Code]			VARCHAR(2)		NULL,
	[Destination Region]				VARCHAR(10)		NULL,
	[Consignee Name]					VARCHAR(60)		NOT NULL,
	[Transport Lane ID]					VARCHAR(20)		NULL,
	[Lane]								VARCHAR(12)		NULL,
	[LCL/FCL]							VARCHAR(30)		NOT NULL,
	[Loading Type]						VARCHAR(7)		NOT NULL,
	[Container Number]					VARCHAR(15)		NULL,
	[Container Size]					VARCHAR(30)		NULL,
	[Container Type]					VARCHAR(30)		NULL,
	[TEU]								FLOAT			NULL,
	[No of Packages]					FLOAT			NULL,
	[Gross Weight]						FLOAT			NULL,
	[Chargeable Weight]					FLOAT			NULL,
	[Volume]							FLOAT			NULL,
	[Scope]								VARCHAR(4)		NULL,
	[Shipment Status]					VARCHAR(10)		NOT NULL,

	[Booking date]						DATETIME		NULL,
	[Cargo ready date]					DATETIME		NULL,
	[Pre-alert date]					DATETIME		NULL,

	[Shipment Pickup]					DATETIME		NULL,
	[Received at Origin]				DATETIME		NULL,
	[MB ETD 1]							DATETIME		NULL,
	[MB ETD 2]							DATETIME		NULL,
	[MB ETD 3]							DATETIME		NULL,
	[MB ETA 1]							DATETIME		NULL,
	[MB ETA 2]							DATETIME		NULL,
	[MB ETA 3]							DATETIME		NULL,
	[Actual Time Departure]				DATETIME		NULL,
	[Actual Time Arrival]				DATETIME		NULL,

	[CALC ARRIVAL DATE]					int				NOT NULL,
	[QTY DAYS TO DROP]					INT				NOT NULL,

	[Broker Notified]					DATETIME		NULL,
	[Shipment Hand-Over To the broker]	DATETIME		NULL,
	[Estimated Customs Clearance]		DATETIME		NULL,
	[Actual Customs Completion]			DATETIME		NULL,
	[Estimated Delivery Date]			DATETIME		NULL,
	[Actual Delivery Date]				DATETIME		NULL,
	[Estimated Completion Date]			DATETIME		NULL,
	[Actual Completion Date]			DATETIME		NULL,
	[TT1 Benchmark]						INT				NOT NULL,
	[TT2 Benchmark]						INT				NOT NULL,
	[TT3 Benchmark]						INT				NOT NULL,
	[TT4 Benchmark]						INT				NOT NULL,
	[Total TT Benchmark]				INT				NOT NULL,
	[TT1 Planned/Actual]				INT				NOT NULL,
	[TT2 Planned/Actual]				INT				NOT NULL,
	[TT3 Planned/Actual]				INT				NOT NULL,
	[TT4 Planned/Actual]				INT				NOT NULL,
	[Total TT Planned/Actual]			INT				NOT NULL,
	[TT1 status]						VARCHAR(15)		NOT  NULL,
	[TT2 status]						VARCHAR(15)		NOT  NULL,
	[TT3 status]						VARCHAR(15)		NOT  NULL,
	[TT4 status]						VARCHAR(15)		NOT  NULL,
	[Total Status]						VARCHAR(15)		NOT  NULL,
	[Delay Responsibility]				VARCHAR(50)		NULL,
	[Delay Code]						VARCHAR(40)		NULL,
	[Reason of Delay]					VARCHAR(300)	NULL,
	[CO2 emission]						VARCHAR(1)		NULL,
	[Track and trace URL address]		VARCHAR(100)	NULL,
	[Shipper Address]					VARCHAR(8000)	NULL,
	[Shipper City]						VARCHAR(8000)	NULL,
	[Shipper Postcode]					VARCHAR(8000)	NULL,
	[Consignee Address]					VARCHAR(8000)	NULL,
	[Consignee City]					VARCHAR(8000)	NULL,
	[Consignee Postcode]				VARCHAR(8000)	NULL,
	[Shipper Reference BIT_Invoice]		VARCHAR(400)	NULL,
	[Itinerary ID]						VARCHAR(400)	NULL,
	[Plant of origin ID]				VARCHAR(20)		NULL,
	[Plant of origin]					VARCHAR(50)		NULL,
	[Plant of Destination ID]			VARCHAR(20)		NULL,
	[Plant of Destination]				VARCHAR(50)		NULL,
	[Incoterm]							VARCHAR(3)		NULL,
	[Source Sytem]						VARCHAR(15)		NOT NULL,
	
	[Flight 1]							VARCHAR(13)		NULL,
	[Flight 2]							VARCHAR(13)		NULL,

	[Voyage Number]						VARCHAR(10)		NULL,
	[Seal Number]						VARCHAR(50)		NULL,
	[Master Carrier]					VARCHAR(30)		NULL
	) ON [PRIMARY]

	INSERT INTO tmp_Schneider_TCT
	 SELECT DISTINCT
		SUBSTRING(HOU.Num_Proc_HIM,1,1)									AS [ServiceCodeIndicator]
		,'BDP'															AS [LLP]
		,GETDATE()														AS [Input Date Time]
		,HOU.Num_Proc_HIM												AS [Job Number]
		,CASE
			WHEN SUBSTRING(HOU.Num_Proc_HIM,2,1) = 'M' THEN 'Sea'
			WHEN SUBSTRING(HOU.Num_Proc_HIM,2,1) = 'A' THEN 'Air'
			ELSE 'Truck/Rail'
		END																AS [Transport Mode]
		,HOU.MAWB_HIM													AS [MAWB]
		,HOU.HAWB_HIM													AS [Housebill / Shipment]
		,CASE 
			WHEN convert(DATETIME,HOU.Dt_Emis_HIM,105)  < '2020-06-01 00:00:00.000' THEN 'Cancelled'
			WHEN ISNULL(ID_Status,0) = 9 THEN 'Cancelled'
			ELSE HOU.Navio_HIM													
		END		

		--ORIGIN
		,UPPER(ISNULL(ORI.SCAC,ORI.CD_LOCAL))							AS [Origin Station]
		,PRSO.Cd_IATA_Pais												AS [Origin Country Code]
		,PRSO.Regiao_Pais												AS [Origin Region]

		--SHIPPER / EXPORTADOR
		,SHIP.Nome_Raz_Soc												AS [Shipper Name]

		--Destination
		,UPPER(ISNULL(DEST.SCAC,DEST.CD_LOCAL))							AS [Destination Station]
		,PRSD.Cd_IATA_Pais												AS [Destination Country Code]
		,PRSD.Regiao_Pais												AS [Destination Region]

		--CONSIGNEE / IMPORTADOR
		,CONS.Nome_Raz_Soc												AS [Consignee Name]
		,NULL															AS [Transport Lane ID]
		,UPPER(ISNULL(ORI.SCAC,ORI.CD_LOCAL)
		+ISNULL(DEST.SCAC,DEST.CD_LOCAL))								AS [Lane]
		,TC.Nome_Tp_Carga												AS [LCL/FCL]

		,CASE WHEN ISNULL(TC.Nome_Tp_Carga,'')='FCL' 
			THEN 'CY/CY'
			ELSE 'CFS/CFS'
		END																AS [Loading Type]
		,CONTM.NUM_CONT_IM												AS [Container Number]
		,DBO.fSchneider_split_Container_tp(TCONT.Nome_Tp_cont,'-','S')	AS [Container Size]
		,DBO.fSchneider_split_Container_tp(TCONT.Nome_Tp_cont,'-','T')	AS [Container Type]

		--dbo.fBusca_TEUS(HOU.Num_Proc_HIM)	
		--Number: 
		--0 for LCL, 
		--1 for 20ft, 
		--2 for 40ft AND 
		--2.25 for 40ft HC

		,CASE 
			WHEN ISNULL(TC.Nome_Tp_Carga,'')='LCL'	THEN	CONVERT(FLOAT,0)
			WHEN LEFT(CONTM.cd_tp_cont,1)='2'		THEN CONVERT(FLOAT,1)
			WHEN LEFT(CONTM.cd_tp_cont,1)='4' 
			AND DBO.fSchneider_split_Container_tp(TCONT.Nome_Tp_cont,'-','T') = 'HC' THEN CONVERT(FLOAT,2.25)
			WHEN LEFT(CONTM.cd_tp_cont,1)='4'		THEN CONVERT(FLOAT,2)
			ELSE CONVERT(FLOAT,0)
		END																AS [TEU]
		,VOL.Qtd_Vol_IM													AS [No of Packages]
		,CONTM.Peso_Bruto_IM											AS [Gross Weight]
		,CONTM.Peso_Bruto_IM											AS [Chargeable Weight] -- Aereo não sera nivel de container e ai tem o campo.
		,CONTM.VolumeM3													AS [Volume]

		,dbo.fSchneider_scope(HOU.Num_Proc_HIM)							AS [Scope]
		,CASE 
			WHEN GETDATE()>LLP.ATA_Lim THEN 'Delivered' 
			ELSE 'In Transit'
		END																AS [Shipment Status]


		,CASE
			WHEN @PAIS = 'BR'	THEN TP005.Dt_Conclusao
			WHEN @PAIS = 'AR'	THEN TP211.Dt_Conclusao
			WHEN @PAIS = 'CL'	THEN TP005.Dt_Conclusao 
		END																AS [Booking date]
		,CASE

			WHEN @PAIS = 'BR'	THEN TP050.Dt_Conclusao 
			WHEN @PAIS = 'AR'	THEN TP212.Dt_Conclusao 
			WHEN @PAIS = 'CL'	THEN TP049.Dt_Conclusao 													 
		END																AS [Cargo ready date]
		,CASE
			WHEN @PAIS = 'BR'	THEN TP001.Dt_Conclusao
			WHEN @PAIS = 'AR'	THEN NULL
			WHEN @PAIS = 'CL'	THEN TP012.Dt_Conclusao 
		END																AS [Pre-alert date]
		,CASE
			WHEN @PAIS = 'BR'	THEN TP010.Dt_Conclusao
			WHEN @PAIS = 'AR'	THEN TP212.Dt_Conclusao 
			WHEN @PAIS = 'CL'	THEN TP010.Dt_Conclusao
		END																AS [Shipment Pickup]

		,CASE
			WHEN @PAIS = 'BR'	THEN TP010.Dt_Conclusao --Ale 29/04
			WHEN @PAIS = 'AR'	THEN TP212.Dt_Conclusao 
			WHEN @PAIS = 'CL'	THEN TP049.Dt_Conclusao --Ale 29/04
		END																AS [Received at Origin]

		,LLP.ETD_Lim													AS [MB ETD 1]
		,NULL															AS [MB ETD 2]
		,NULL															AS [MB ETD 3]

		,LLP.ETA_Lim													AS [MB ETA 1]
		,NULL															AS [MB ETA 2]
		,NULL															AS [MB ETA 3]

		,LLP.ATD_Lim													AS [Actual Time Departure]
		,LLP.ATA_Lim													AS [Actual Time Arrival]

		,DATEDIFF(D,ISNULL(LLP.ATA_Lim,LLP.ETA_Lim),GETDATE())			AS [CALC ARRIVAL DATE]
		,CASE 
			WHEN LLP.ATA_Lim is not NULL THEN @qtd_dias_ATA
			WHEN LLP.ETA_Lim IS NOT NULL THEN @qtd_dias_ETA
			ELSE 999
		END 															AS [QTY DAYS TO DROP]




		,CASE
			WHEN @PAIS = 'BR'	THEN TP001.Dt_Conclusao 
			WHEN @PAIS = 'AR'	THEN TP019.Dt_Conclusao 
			WHEN @PAIS = 'CL'	THEN TP001.Dt_Conclusao -- Ale 29/04
		END																AS [Broker Notified]


		,CASE
			WHEN @PAIS = 'BR'	THEN TP021.Dt_Conclusao 
			WHEN @PAIS = 'AR'	THEN TP205.Dt_Conclusao 
			WHEN @PAIS = 'CL'	THEN TP047.Dt_Conclusao -- Ale 29/04
		END																AS [Shipment Hand-Over To the broker]

		,null															AS [Estimated Customs Clearance]
		,null															AS [Actual Customs Completion]
		,null															AS [Estimated Delivery Date]

		,CASE
			WHEN @PAIS = 'BR'	THEN TP013.Dt_Conclusao 
			WHEN @PAIS = 'AR'	THEN TP013.Dt_Conclusao  -- Ale 29/04 
			WHEN @PAIS = 'CL'	THEN TP013.Dt_Conclusao  -- Ale 29/04
		END																AS [Actual Delivery Date]

		,null															AS [Estimated Completion Date]
		,null															AS [Actual Completion Date]

		,0																AS [TT1 Benchmark]
		,DATEDIFF(D,LLP.ETD_Lim,LLP.ETA_Lim)							AS [TT2 Benchmark]
		,0																AS [TT3 Benchmark]
		,0																AS [TT4 Benchmark]
		,0																AS [Total TT Benchmark]

		,0																AS [TT1 Planned/Actual]
		,0																AS [TT2 Planned/Actual]
		,0																AS [TT3 Planned/Actual]
		,0																AS [TT4 Planned/Actual]
		,0																AS [Total TT Planned/Actual]


		,'Out of scope'													AS [TT1 status]
		,'Out of scope'													AS [TT2 status]
		,'Out of scope'													AS [TT3 status]
		,'Out of scope'													AS [TT4 status]
		,'Out of scope'													AS [Total Status]

		,NULL															AS [Delay Responsibility]
		,NULL															AS [Delay Code]
		,NULL															AS [Reason of Delay]
		,NULL															AS [CO2 emission]
		,'https://www.bdpsmart.com/tracking/detail?refnum=' 
		+ ltrim(rtrim(ISNULL(HOU.Num_Proc_HIM,'')))
		+ '&ss=' + '01BDPBRSAO'
		+ '&snp=000000000'
																		AS [Track and trace URL address]

		,SHIPEND.RUA
		+ ' ' + SHIPEND.NUMERO 											AS [Shipper Address]
		,SHIPEND.cidade													AS [Shipper City]
		,SHIPEND.cep													AS [Shipper Postcode]

		,CONSEND.RUA 
		+ ' ' + CONSEND.NUMERO 											AS [Consignee Address]
		,CONSEND.cidade 												AS [Consignee City]
		,CONSEND.cep													AS [Consignee Postcode]

		,dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,2)					AS [Shipper Reference BIT_Invoice]
		,ISNULL(CONTHAI.Itinerary_ID,CP202.Campo_Dados)					AS [Itinerary ID]

		,NULL															AS [Plant of origin ID]
		,NULL															AS [Plant of origin]
		,NULL															AS [Plant of Destination ID]
		,NULL															AS [Plant of Destination]

		,HOU.cd_tp_oper													AS [Incoterm]
		,CASE
			WHEN @PAIS = 'BR' AND  @TEST = 1	THEN 'ATL BR TEST'
			WHEN @PAIS = 'CL' AND  @TEST = 1	THEN 'ATL CL TEST'
			WHEN @PAIS = 'AR' AND  @TEST = 1	THEN 'ATL AR TEST'
			WHEN @PAIS = 'BR'					THEN 'ATL BR'
			WHEN @PAIS = 'CL'					THEN 'ATL CL'
			WHEN @PAIS = 'AR'					THEN 'ATL AR'			
		END																AS [Source Sytem]												
		
	,NULL																AS [Flight 1]	
	,NULL																AS [Flight 2]

	,HOU.Viagem_HIM														AS [Voyage Number] -- spNavio_LLP_Sel					
	,CONTM.Num_Lacre_IM													AS [Seal Number]						
	,CAR.Nome_Armador													AS [Master Carrier] -- from armador order by nome_armador -- Select top 1 cd_armador from armador with(nolock) where Nome_Armador = @Armador

	FROM House_Imp_Mar HOU (nolock)  
	INNER JOIN Job_Imp_Mar JOB (nolock)   
		ON HOU.Num_Proc_HIM  = JOB.Num_Proc_HIM  
	INNER JOIN LLP_Imp_Mar LLP (nolock)  
		ON HOU.Num_Proc_HIM = LLP.Num_Proc_Lim  

	--ORIGIN / SHIPPER
	INNER JOIN Localidade ORI (nolock)  
		ON HOU.Cd_Org_HIM = ORI.Cd_Local 
	LEFT JOIN Pais_Regiao_SCHNEIDER PRSO (NOLOCK)
		ON ORI.Pais_Local = PRSO.Nome_Pais_ATL

	INNER JOIN Pessoa SHIP (nolock)  
		ON HOU.Cd_Export_HIM  = SHIP.Cd_Pes  
	LEFT JOIN Endereco SHIPEND (nolock) 
		ON SHIPEND.cd_pes=SHIP.cd_pes AND SHIPEND.cd_tp_end='COM'  
	LEFT JOIN Pessoa_LLP PLLORI  (nolock) 
		ON PLLORI.Cd_Pes=SHIP.Cd_Pes  

	--Destination / CONSIGNEE 
	INNER JOIN Localidade DEST (nolock)  
		ON HOU.Cd_Dst_HIM   = DEST.Cd_Local  
	LEFT JOIN Pais_Regiao_SCHNEIDER PRSD (NOLOCK)
		ON DEST.Pais_Local = PRSD.Nome_Pais_ATL
	INNER JOIN Pessoa CONS (nolock)  
		ON HOU.Cd_Consig_HIM  = CONS.Cd_Pes
	LEFT JOIN Endereco CONSEND (nolock) 
		ON CONSEND.cd_pes=CONS.cd_pes AND CONSEND.cd_tp_end='COM' 
	LEFT JOIN Pessoa_LLP PLLDES  (nolock) 
		ON PLLDES.Cd_Pes=CONS.Cd_Pes  

	-- Itinerary ID
	LEFT JOIN Campo_Processo CP202 (nolock)  
		ON HOU.Num_Proc_HIM collate SQL_Latin1_General_CP1_CI_AS = CP202.Num_Proc collate SQL_Latin1_General_CP1_CI_AS  AND CP202.Id_Campo = 202 


	LEFT JOIN Tarefas_Processos TP005 (nolock) 
		ON HOU.NUM_PROC_HIM = TP005.Num_Proc AND TP005.ID_Task = 5 

	LEFT JOIN Tarefas_Processos TP001 (nolock) 
		ON HOU.NUM_PROC_HIM = TP001.Num_Proc AND TP001.ID_Task = 1
	LEFT JOIN Tarefas_Processos TP010 (nolock) 
		ON HOU.NUM_PROC_HIM = TP010.Num_Proc AND TP010.ID_Task = 10
	LEFT JOIN Tarefas_Processos TP012 (nolock) 
		ON HOU.NUM_PROC_HIM = TP012.Num_Proc AND TP012.ID_Task = 12
	LEFT JOIN Tarefas_Processos TP013 (nolock) 
		ON HOU.NUM_PROC_HIM = TP013.Num_Proc AND TP013.ID_Task = 13
	LEFT JOIN Tarefas_Processos TP019 (nolock) 
		ON HOU.NUM_PROC_HIM = TP019.Num_Proc AND TP019.ID_Task = 19
	LEFT JOIN Tarefas_Processos TP021 (nolock) 
		ON HOU.NUM_PROC_HIM = TP021.Num_Proc AND TP021.ID_Task = 21
	LEFT JOIN Tarefas_Processos TP047 (nolock) 
		ON HOU.NUM_PROC_HIM = TP047.Num_Proc AND TP047.ID_Task = 47
	LEFT JOIN Tarefas_Processos TP049 (nolock) 
		ON HOU.NUM_PROC_HIM = TP049.Num_Proc AND TP049.ID_Task = 49
	LEFT JOIN Tarefas_Processos TP050 (nolock) 
		ON HOU.NUM_PROC_HIM = TP050.Num_Proc AND TP050.ID_Task = 50
	LEFT JOIN Tarefas_Processos TP205 (nolock) 
		ON HOU.NUM_PROC_HIM = TP205.Num_Proc AND TP205.ID_Task = 205
	LEFT JOIN Tarefas_Processos TP211 (nolock) 
		ON HOU.NUM_PROC_HIM = TP211.Num_Proc AND TP211.ID_Task = 211 
	LEFT JOIN Tarefas_Processos TP212 (nolock) 
		ON HOU.NUM_PROC_HIM = TP212.Num_Proc AND TP212.ID_Task = 212

	--LCL/FCL
	LEFT JOIN Tipo_Carga  TC (NOLOCK)   
		ON LLP.Cd_Tp_Carga = TC.Cd_Tp_Carga  

	-- CONTAINER
	LEFT JOIN Container_Hou_Imp_Mar CONTH (nolock) 
		ON HOU.Num_Proc_HIM = CONTH.num_proc_him

	LEFT JOIN container_mas_imp_mar CONTM (nolock) 
		ON CONTH.item_cont_im = CONTM.item_cont_im AND CONTH.Num_Proc_MIM = CONTM.Num_Proc_MIM

	LEFT JOIN container_additional_info CONTHAI (NOLOCK)
		ON CONTH.num_proc_him = CONTHAI.NUM_PROC
		AND REPLACE(CONTM.Num_Cont_IM ,'-','') = REPLACE(CONTHAI.num_cont,'-','')

	LEFT JOIN Volume_Imp_Mar VOL (nolock) 
	  ON VOL.Num_Proc_HIM = CONTH.Num_Proc_HIM AND VOL.Item_Cont_IM = CONTH.Item_Cont_IM

	LEFT JOIN Tipo_Container TCONT (nolock) 
		ON TCONT.cd_tp_cont=CONTM.cd_tp_cont  

	LEFT JOIN armador CAR (NOLOCK)
		ON JOB.Cd_Armador = CAR.CD_ARMADOR

	WHERE SUBSTRING(HOU.Num_Proc_HIM,2,1) = 'M' -- somente maritimo
	AND SUBSTRING(HOU.Num_Proc_HIM,1,1) = 'I' 
	AND DBO.FBusca_GrupoporJOB(HOU.Num_Proc_HIM) = 'GRUPO SCHNEIDER'
	ORDER BY HOU.Num_Proc_HIM


	

	INSERT INTO tmp_Schneider_TCT
	 SELECT  DISTINCT--top 5 
		SUBSTRING(HOU.Num_Proc_HEM,1,1)								AS [ServiceCodeIndicator]
		,'BDP'														AS [LLP]
		,GETDATE()													AS [Input Date Time]
		,HOU.Num_Proc_HEM											AS [Job Number]
		,CASE
			WHEN SUBSTRING(HOU.Num_Proc_HEM,2,1) = 'M' THEN 'Sea'
			WHEN SUBSTRING(HOU.Num_Proc_HEM,2,1) = 'A' THEN 'Air'
			ELSE 'Truck/Rail'
		END															AS [Transport Mode]
		, HOU.MAWB_HEM									AS [MAWB]
		, HOU.HAWB_HEM									AS [Housebill / Shipment]
		
		,CASE 
			WHEN convert(DATETIME,HOU.Dt_Emis_HEM,105)  < '2020-06-01 00:00:00.000' THEN 'Cancelled'
			WHEN ISNULL(ID_Status,0) = 9 THEN 'Cancelled'
			ELSE HOU.Navio_HEM													
		END		

		--ORIGIN
		,UPPER(ISNULL(ORI.SCAC,ORI.CD_LOCAL)) 						AS [Origin Station]
		,PRSO.Cd_IATA_Pais								AS [Origin Country Code]
		,PRSO.Regiao_Pais								AS [Origin Region]

		--SHIPPER / EXPORTADOR
		,SHIP.Nome_Raz_Soc								AS [Shipper Name]

		--Destination
		,UPPER(ISNULL(DEST.SCAC,DEST.CD_LOCAL))	 		AS [Destination Station]
		,PRSD.Cd_IATA_Pais								AS [Destination Country Code]
		,PRSD.Regiao_Pais								AS [Destination Region]

		--CONSIGNEE / IMPORTADOR
		,CONS.Nome_Raz_Soc								AS [Consignee Name]
		,NULL											AS [Transport Lane ID]
		,UPPER(ISNULL(ORI.SCAC,ORI.CD_LOCAL)
		+ISNULL(DEST.SCAC,DEST.CD_LOCAL))				AS [Lane]
		,TC.Nome_Tp_Carga					AS [LCL/FCL]

		,CASE 
			WHEN ISNULL(TC.Nome_Tp_Carga,'')='FCL' THEN	'CY/CY'
			ELSE 'CFS/CFS'
		END																	AS [Loading Type]

		,CONTM.NUM_CONT_EM													AS [Container Number]
		,DBO.fSchneider_split_Container_tp(TCONT.Nome_Tp_cont,'-','S')		AS [Container Size]
		,DBO.fSchneider_split_Container_tp(TCONT.Nome_Tp_cont,'-','T')		AS [Container Type]

		--dbo.fBusca_TEUS(HOU.Num_Proc_HIM)								
		,CASE 
			WHEN ISNULL(TC.Nome_Tp_Carga,'')='LCL' THEN	0
			WHEN LEFT(CONTM.cd_tp_cont,1)='2' THEN 1
			WHEN LEFT(CONTM.cd_tp_cont,1)='4' AND DBO.fSchneider_split_Container_tp(TCONT.Nome_Tp_cont,'-','T') = 'HC' THEN 2.25
			WHEN LEFT(CONTM.cd_tp_cont,1)='4' THEN 2
			ELSE CONVERT(FLOAT,0)
		END																AS [TEU]
		,VOL.Qtd_Vol_EM										AS [No of Packages]
		,CONTM.Peso_Bruto_EM							AS [Gross Weight]
		,CONTM.Peso_Bruto_EM							AS [Chargeable Weight] -- Aereo não sera nivel de container e ai tem o campo.
		,CONTM.VolumeM3								AS [Volume]

		,dbo.fSchneider_scope(HOU.Num_Proc_HEM)							AS [Scope]
		,CASE 
			WHEN GETDATE()>LLP.ATA_LEm THEN 'Delivered' 
			ELSE 'In Transit'
		END																AS [Shipment Status]

		,CASE
			WHEN @PAIS = 'BR'	THEN TP215.Dt_Conclusao
			WHEN @PAIS = 'AR'	THEN TP211.Dt_Conclusao 
			WHEN @PAIS = 'CL'	THEN TP005.Dt_Conclusao 
			ELSE NULL 
		END																AS [Booking date]
		,CASE
			WHEN @PAIS = 'BR'	THEN TP050.Dt_Conclusao 
			WHEN @PAIS = 'AR'	THEN TP212.Dt_Conclusao 
			WHEN @PAIS = 'CL'	THEN TP049.Dt_Conclusao 
			ELSE NULL															
		END																 AS [Cargo ready date]
		,CASE
			WHEN @PAIS = 'BR'	THEN TP001.Dt_Conclusao 
			WHEN @PAIS = 'AR'	THEN TP019.Dt_Conclusao 
			WHEN @PAIS = 'CL'	THEN TP012.Dt_Conclusao 
		END																 AS [Pre-alert date]


		,CASE
			WHEN @PAIS = 'BR'	THEN TP010.Dt_Conclusao 
			WHEN @PAIS = 'AR'	THEN TP212.Dt_Conclusao 
			WHEN @PAIS = 'CL'	THEN TP010.Dt_Conclusao 
		END																 AS [Shipment Pickup]


		,CASE
			WHEN @PAIS = 'BR'	THEN TP189.Dt_Conclusao 
			WHEN @PAIS = 'AR'	THEN TP212.Dt_Conclusao 
			WHEN @PAIS = 'CL'	THEN TP049.Dt_Conclusao --Ale 29/04
		END																 AS [Received at Origin]

		,LLP.ETD_LEM				AS [MB ETD 1]
		,NULL						AS [MB ETD 2]
		,NULL						AS [MB ETD 3]

		,LLP.ETA_LEm				AS [MB ETA 1]
		,NULL						AS [MB ETA 2]
		,NULL						AS [MB ETA 3]

		,LLP.ATD_Lem				AS [Actual Time Departure]
		,LLP.ATA_Lem				AS [Actual Time Arrival]

		,DATEDIFF(D,ISNULL(LLP.ATA_Lem,LLP.ETA_Lem),GETDATE())		AS [CALC ARRIVAL DATE]
		,CASE 
			WHEN LLP.ATA_Lem is not NULL THEN @qtd_dias_ATA
			WHEN LLP.ETA_Lem IS NOT NULL THEN @qtd_dias_ETA
			ELSE 999
		END 															AS [QTY DAYS TO DROP]

		,CASE
			WHEN @PAIS = 'BR'	THEN TP001.Dt_Conclusao 
			WHEN @PAIS = 'AR'	THEN NULL 
			WHEN @PAIS = 'CL'	THEN TP001.Dt_Conclusao -- Ale 29/04
		END																 AS [Broker Notified]
		,CASE
			WHEN @PAIS = 'BR'	THEN TP021.Dt_Conclusao 
			WHEN @PAIS = 'AR'	THEN NULL 
			WHEN @PAIS = 'CL'	THEN TP047.Dt_Conclusao -- Ale 29/04
		END																 AS [Shipment Hand-Over To the broker]
		,null						AS [Estimated Customs Clearance]
		,null						AS [Actual Customs Completion]

		,null						AS [Estimated Delivery Date]
		,CASE
			WHEN @PAIS = 'BR'	THEN TP013.Dt_Conclusao 
			WHEN @PAIS = 'AR'	THEN TP013.Dt_Conclusao  -- Ale 29/04  
			WHEN @PAIS = 'CL'	THEN TP013.Dt_Conclusao  -- Ale 29/04
		END																 AS [Actual Delivery Date]
		,null						AS [Estimated Completion Date]
		,null						AS [Actual Completion Date]

		,0																AS [TT1 Benchmark]
		,DATEDIFF(D,LLP.ETD_Lem,LLP.ETA_Lem)							AS [TT2 Benchmark]
		,0																AS [TT3 Benchmark]
		,0																AS [TT4 Benchmark]
		,0																AS [Total TT Benchmark]

		,0																AS [TT1 Planned/Actual]
		,0																AS [TT2 Planned/Actual]
		,0																AS [TT3 Planned/Actual]
		,0																AS [TT4 Planned/Actual]
		,0																AS [Total TT Planned/Actual]


		,'Out of scope'													AS [TT1 status]
		,'Out of scope'													AS [TT2 status]
		,'Out of scope'													AS [TT3 status]
		,'Out of scope'													AS [TT4 status]
		,'Out of scope'													AS [Total Status]

		,null															AS [Delay Responsibility]
		,null															AS [Delay Code]
		,null															AS [Reason of Delay]
		,NULL												AS [CO2 emission]
		,'https://www.bdpsmart.com/tracking/detail?refnum=' 
		+ ltrim(rtrim(ISNULL(HOU.Num_Proc_HEM,'')))
		+ '&ss=' + '01BDPBRSAO'
		+ '&snp=000000000'
		AS [Track and trace URL address]

		,replace(SHIPEND.RUA,',',' ') 
		+ ' ' + replace(SHIPEND.NUMERO,',',' ') 		AS [Shipper Address]
		,replace(SHIPEND.cidade,',',' ') 				AS [Shipper City]
		,replace(SHIPEND.cep,',',' ') 					AS [Shipper Postcode]

		,replace(CONSEND.RUA,',',' ') 
		+ ' ' + replace(CONSEND.NUMERO,',',' ')						AS [Consignee Address]
		,replace(CONSEND.cidade,',',' ')							AS [Consignee City]
		,replace(CONSEND.cep,',',' ')								AS [Consignee Postcode]

		,dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEM,2)				AS [Shipper Reference BIT_Invoice]
		,ISNULL(CONTHAI.Itinerary_ID,CP202.Campo_Dados)				AS [Itinerary ID]

		,NULL														AS [Plant of origin ID]
		,NULL														AS [Plant of origin]
		,NULL														AS [Plant of Destination ID]
		,NULL														AS [Plant of Destination]
		,HOU.cd_tp_oper									AS [Incoterm]
		,CASE
			WHEN @PAIS = 'BR' AND  @TEST = 1	THEN 'ATL BR TEST'
			WHEN @PAIS = 'CL' AND  @TEST = 1	THEN 'ATL CL TEST'
			WHEN @PAIS = 'AR' AND  @TEST = 1	THEN 'ATL AR TEST'
			WHEN @PAIS = 'BR'					THEN 'ATL BR'
			WHEN @PAIS = 'CL'					THEN 'ATL CL'
			WHEN @PAIS = 'AR'					THEN 'ATL AR'			
		END															AS [Source Sytem]
	,NULL															AS [Flight 1]	
	,NULL															AS [Flight 2]

	,HOU.Viagem_HEM													AS [Voyage Number] -- spNavio_LLP_Sel					
	,CONTM.Num_Lacre_EM												AS [Seal Number]						
	,CAR.Nome_Armador 												AS [Master Carrier] -- from armador order by nome_armador -- Select top 1 cd_armador from armador with(nolock) where Nome_Armador = @Armador

	FROM House_Exp_Mar  HOU (nolock)  
	INNER JOIN Job_EXP_Mar  JOB (nolock)   
		ON HOU.Num_Proc_HEM = JOB.Num_Proc_HEM  
	INNER JOIN   LLP_EXP_Mar  LLP (nolock)  
		ON HOU.Num_Proc_HEM = LLP.Num_Proc_Lem 

	--ORIGIN / SHIPPER
	INNER JOIN Localidade ORI (nolock)  
		--ON LLP.Cd_Planta_Lem  = ORI.Cd_Local  
		ON HOU.Cd_Org_HEM  = ORI.Cd_Local  

	LEFT JOIN Pais_Regiao_SCHNEIDER PRSO (NOLOCK)
		ON ORI.Pais_Local = PRSO.Nome_Pais_ATL
	INNER JOIN Pessoa SHIP (nolock)  
		ON HOU.Cd_Export_HEM  = SHIP.Cd_Pes  
	LEFT JOIN Endereco SHIPEND (nolock) 
		ON SHIPEND.cd_pes=SHIP.cd_pes AND SHIPEND.cd_tp_end='COM'  
	LEFT JOIN Pessoa_LLP PLLORI  (nolock) 
		ON PLLORI.Cd_Pes=SHIP.Cd_Pes  


	--Destination / CONSIGNEE 
	INNER JOIN Localidade DEST (nolock)  
		ON HOU.Cd_Dst_HEM   = DEST.Cd_Local   
	LEFT JOIN Pais_Regiao_SCHNEIDER PRSD (NOLOCK)
		ON DEST.Pais_Local = PRSD.Nome_Pais_ATL
	INNER JOIN Pessoa CONS (nolock)  
		ON HOU.Cd_Consig_HEM  = CONS.Cd_Pes
	LEFT JOIN Endereco CONSEND (nolock) 
		ON CONSEND.cd_pes=CONS.cd_pes AND CONSEND.cd_tp_end='COM' 
	LEFT JOIN Pessoa_LLP PLLDES  (nolock) 
		ON PLLDES.Cd_Pes=CONS.Cd_Pes  

	-- Itinerary ID
	LEFT JOIN Campo_Processo CP202 (nolock)  
		ON HOU.Num_Proc_HEM collate SQL_Latin1_General_CP1_CI_AS  = CP202.Num_Proc collate SQL_Latin1_General_CP1_CI_AS  AND CP202.Id_Campo = 202 

	LEFT JOIN Tarefas_Processos TP005 (nolock) 
		ON HOU.Num_Proc_HEM = TP005.Num_Proc AND TP005.ID_Task = 5 

	LEFT JOIN Tarefas_Processos TP001 (nolock) 
		ON HOU.Num_Proc_HEM = TP001.Num_Proc AND TP001.ID_Task = 1
	LEFT JOIN Tarefas_Processos TP010 (nolock) 
		ON HOU.Num_Proc_HEM = TP010.Num_Proc AND TP010.ID_Task = 10
	LEFT JOIN Tarefas_Processos TP012 (nolock) 
		ON HOU.Num_Proc_HEM = TP012.Num_Proc AND TP012.ID_Task = 12
	LEFT JOIN Tarefas_Processos TP013 (nolock) 
		ON HOU.Num_Proc_HEM = TP013.Num_Proc AND TP013.ID_Task = 13
	LEFT JOIN Tarefas_Processos TP019 (nolock) 
		ON HOU.Num_Proc_HEM = TP019.Num_Proc AND TP019.ID_Task = 19
	LEFT JOIN Tarefas_Processos TP021 (nolock) 
		ON HOU.Num_Proc_HEM = TP021.Num_Proc AND TP021.ID_Task = 21
	LEFT JOIN Tarefas_Processos TP047 (nolock) 
		ON HOU.Num_Proc_HEM = TP047.Num_Proc AND TP047.ID_Task = 47
	LEFT JOIN Tarefas_Processos TP049 (nolock) 
		ON HOU.Num_Proc_HEM = TP049.Num_Proc AND TP049.ID_Task = 49
	LEFT JOIN Tarefas_Processos TP050 (nolock) 
		ON HOU.Num_Proc_HEM = TP050.Num_Proc AND TP050.ID_Task = 50

	LEFT JOIN Tarefas_Processos TP189 (nolock) 
		ON HOU.Num_Proc_HEM = TP189.Num_Proc AND TP189.ID_Task = 189 
	LEFT JOIN Tarefas_Processos TP211 (nolock) 
		ON HOU.Num_Proc_HEM = TP211.Num_Proc AND TP211.ID_Task = 211 
	LEFT JOIN Tarefas_Processos TP212 (nolock) 
		ON HOU.Num_Proc_HEM = TP212.Num_Proc AND TP212.ID_Task = 212

	LEFT JOIN Tarefas_Processos TP215 (nolock) 
		ON HOU.Num_Proc_HEM = TP215.Num_Proc AND TP215.ID_Task = 215

	--LCL/FCL
	LEFT JOIN Tipo_Carga  TC (NOLOCK)   
		ON LLP.Cd_Tp_Carga = TC.Cd_Tp_Carga  

	-- CONTAINER
	LEFT JOIN Container_Hou_EXP_Mar CONTH (nolock) 
		ON HOU.Num_Proc_HEM = CONTH.Num_Proc_HEM
	LEFT JOIN container_mas_EXP_mar CONTM (nolock) 
		ON CONTH.Item_Cont_EM = CONTM.item_cont_Em AND CONTH.Num_Proc_MEM = CONTM.Num_Proc_MEM

	LEFT JOIN container_additional_info CONTHAI (NOLOCK)
		ON CONTH.Num_Proc_HEM = CONTHAI.NUM_PROC
		AND REPLACE(CONTM.Num_Cont_EM ,'-','') = REPLACE(CONTHAI.num_cont,'-','')


	LEFT JOIN Volume_EXP_Mar VOL (nolock) 
	  ON VOL.Num_Proc_HEM = CONTH.Num_Proc_HEM AND VOL.Item_Cont_EM = CONTH.Item_Cont_EM

	LEFT JOIN Tipo_Container TCONT (nolock) 
		ON TCONT.cd_tp_cont=CONTM.cd_tp_cont  

	LEFT JOIN armador CAR (NOLOCK)
		ON LLP.Cd_Armador_LEm = CAR.CD_ARMADOR

	WHERE SUBSTRING(HOU.Num_Proc_HeM,2,1) = 'M' -- somente maritimo
	AND SUBSTRING(HOU.Num_Proc_HeM,1,1) = 'E'  
	AND DBO.FBusca_GrupoporJOB(HOU.Num_Proc_HEM) = 'GRUPO SCHNEIDER'
	ORDER BY HOU.Num_Proc_HeM


		INSERT INTO tmp_Schneider_TCT
		SELECT DISTINCT --top 1-- DISTINCT
		SUBSTRING(HOU.Num_Proc_HIA,1,1)									AS [ServiceCodeIndicator]
		,'BDP'															AS [LLP]
		,GETDATE()														AS [Input Date Time]
		,HOU.Num_Proc_HIA												AS [Job Number]
		,CASE
			WHEN SUBSTRING(HOU.Num_Proc_HIA,2,1) = 'M' THEN 'Sea'
			WHEN SUBSTRING(HOU.Num_Proc_HIA,2,1) = 'A' THEN 'Air'
			ELSE 'Truck/Rail'
		END																AS [Transport Mode]
		,HOU.MAWB_HIA													AS [MAWB]
		,HOU.HAWB_HIA													AS [Housebill / Shipment]
		

		,CASE 
			WHEN convert(DATETIME,HOU.Dt_Emis_HIA,105)  < '2020-06-01 00:00:00.000' THEN 'Cancelled'
			WHEN ISNULL(ID_Status,0) = 9 THEN 'Cancelled'
			ELSE ''													
		END																AS [Vessel name]

		--ORIGIN
		,UPPER(ISNULL(ORI.SCAC,ORI.CD_LOCAL))							AS [Origin Station]
		,PRSO.Cd_IATA_Pais												AS [Origin Country Code]
		,PRSO.Regiao_Pais												AS [Origin Region]

		--SHIPPER / EXPORTADOR
		,SHIP.Nome_Raz_Soc												AS [Shipper Name]

		--Destination
		,UPPER(ISNULL(DEST.SCAC,DEST.CD_LOCAL))							AS [Destination Station]
		,PRSD.Cd_IATA_Pais												AS [Destination Country Code]
		,PRSD.Regiao_Pais												AS [Destination Region]

		--CONSIGNEE / IMPORTADOR
		,CONS.Nome_Raz_Soc												AS [Consignee Name]
		,NULL															AS [Transport Lane ID]
		,UPPER(ISNULL(ORI.SCAC,ORI.CD_LOCAL)
		+ISNULL(DEST.SCAC,DEST.CD_LOCAL))								AS [Lane]
		,'LCL'															AS [LCL/FCL]
		,'CFS/CFS'														AS [Loading Type]
		,NULL															AS [Container Number]
		,NULL															AS [Container Size]
		,NULL															AS [Container Type]
		,0																AS [TEU]
		,Qtd_Tot_Vol_HIA												AS [No of Packages]
		,Peso_Bruto_HIA													AS [Gross Weight]
		,Peso_Cubado_LIA												AS [Chargeable Weight] -- Aereo não sera nivel de container e ai tem o campo.
		,Vol_Tot_HIA													AS [Volume]

		,dbo.fSchneider_scope(HOU.Num_Proc_HIA)							AS [Scope]
		,CASE 
			WHEN GETDATE()>LLP.ATA_LIA THEN 'Delivered' 
			ELSE 'In Transit'
		END																AS [Shipment Status]

		,CASE
			WHEN @PAIS = 'BR'	THEN TP005.Dt_Conclusao
			WHEN @PAIS = 'AR'	THEN TP211.Dt_Conclusao
			WHEN @PAIS = 'CL'	THEN TP005.Dt_Conclusao 
		END																AS [Booking date]
		,CASE
			WHEN @PAIS = 'BR'	THEN TP050.Dt_Conclusao
			WHEN @PAIS = 'AR'	THEN TP212.Dt_Conclusao
			WHEN @PAIS = 'CL'	THEN TP049.Dt_Conclusao 
		END																AS [Cargo ready date]
		,CASE
			WHEN @PAIS = 'BR'	THEN TP001.Dt_Conclusao
			WHEN @PAIS = 'AR'	THEN NULL 
			WHEN @PAIS = 'CL'	THEN TP012.Dt_Conclusao 
		END																AS [Pre-alert date]
		,CASE
			WHEN @PAIS = 'BR'	THEN TP010.Dt_Conclusao
			WHEN @PAIS = 'AR'	THEN TP212.Dt_Conclusao 
			WHEN @PAIS = 'CL'	THEN TP010.Dt_Conclusao 
		END																AS [Shipment Pickup]
		,CASE
			WHEN @PAIS = 'BR'	THEN TP010.Dt_Conclusao
			WHEN @PAIS = 'AR'	THEN TP212.Dt_Conclusao 
			WHEN @PAIS = 'CL'	THEN TP049.Dt_Conclusao --Ale 29/04 
		END																AS [Received at Origin]

		,LLP.ETD_LIA													AS [MB ETD 1]
		,NULL															AS [MB ETD 2]
		,NULL															AS [MB ETD 3]

		,LLP.ETA_LIA													AS [MB ETA 1]
		,NULL															AS [MB ETA 2]
		,NULL															AS [MB ETA 3]
		,LLP.ATD_LIA													AS [Actual Time Departure]
		,LLP.ATA_LIA													AS [Actual Time Arrival]

		,DATEDIFF(D,ISNULL(LLP.ATA_Lia,LLP.ETA_Lia),GETDATE())			AS [CALC ARRIVAL DATE]
		,CASE 
			WHEN LLP.ATA_Lia is not NULL THEN @qtd_dias_ATA
			WHEN LLP.ETA_Lia IS NOT NULL THEN @qtd_dias_ETA
			ELSE 999
		END 															AS [QTY DAYS TO DROP]

		--'ATL AR'
		,CASE
			WHEN @PAIS = 'BR'	THEN TP001.Dt_Conclusao
			WHEN @PAIS = 'AR'	THEN TP019.Dt_Conclusao 
			WHEN @PAIS = 'CL'	THEN TP001.Dt_Conclusao -- Ale 29/04 
		END																AS [Broker Notified]

		,CASE
			WHEN @PAIS = 'BR'	THEN TP147.Dt_Conclusao
			WHEN @PAIS = 'AR'	THEN TP205.Dt_Conclusao 
			WHEN @PAIS = 'CL'	THEN TP047.Dt_Conclusao -- Ale 29/04 
		END																AS [Shipment Hand-Over To the broker]

		,null															AS [Estimated Customs Clearance]
		,null															AS [Actual Customs Completion]


		,null															AS [Estimated Delivery Date]
		,CASE
			WHEN @PAIS = 'BR'	THEN TP013.Dt_Conclusao
			WHEN @PAIS = 'AR'	THEN TP013.Dt_Conclusao  -- Ale 29/04 
			WHEN @PAIS = 'CL'	THEN TP013.Dt_Conclusao  -- Ale 29/04 
		END																AS [Actual Delivery Date]
		,null															AS [Estimated Completion Date]
		,null															AS [Actual Completion Date]

		,0																AS [TT1 Benchmark]
		,DATEDIFF(D,LLP.ETD_LIA,LLP.ETA_LIA)							AS [TT2 Benchmark]
		,0																AS [TT3 Benchmark]
		,0																AS [TT4 Benchmark]
		,0																AS [Total TT Benchmark]

		,0																AS [TT1 Planned/Actual]
		,0																AS [TT2 Planned/Actual]
		,0																AS [TT3 Planned/Actual]
		,0																AS [TT4 Planned/Actual]
		,0																AS [Total TT Planned/Actual]


		,'Out of scope'													AS [TT1 status]
		,'Out of scope'													AS [TT2 status]
		,'Out of scope'													AS [TT3 status]
		,'Out of scope'													AS [TT4 status]
		,'Out of scope'													AS [Total Status]

		,NULL															AS [Delay Responsibility]
		,NULL															AS [Delay Code]
		,NULL															AS [Reason of Delay]
		,NULL															AS [CO2 emission]
		,'https://www.bdpsmart.com/tracking/detail?refnum=' 
		+ ltrim(rtrim(ISNULL(HOU.Num_Proc_HIA,'')))
		+ '&ss=' + '01BDPBRSAO'
		+ '&snp=000000000'
																		AS [Track and trace URL address]

		,SHIPEND.RUA
		+ ' ' + SHIPEND.NUMERO 											AS [Shipper Address]
		,SHIPEND.cidade													AS [Shipper City]
		,SHIPEND.cep													AS [Shipper Postcode]

		,CONSEND.RUA 
		+ ' ' + CONSEND.NUMERO 											AS [Consignee Address]
		,CONSEND.cidade 												AS [Consignee City]
		,CONSEND.cep													AS [Consignee Postcode]

		,dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIA,2)					AS [Shipper Reference BIT_Invoice]
		,ISNULL(CP202.Campo_Dados,'')									AS [Itinerary ID]

		,NULL															AS [Plant of origin ID]
		,NULL															AS [Plant of origin]
		,NULL															AS [Plant of Destination ID]
		,NULL															AS [Plant of Destination]

		,HOU.cd_tp_oper													AS [Incoterm]
		,CASE
			WHEN @PAIS = 'BR' AND  @TEST = 1	THEN 'ATL BR TEST'
			WHEN @PAIS = 'CL' AND  @TEST = 1	THEN 'ATL CL TEST'
			WHEN @PAIS = 'AR' AND  @TEST = 1	THEN 'ATL AR TEST'
			WHEN @PAIS = 'BR'					THEN 'ATL BR'
			WHEN @PAIS = 'CL'					THEN 'ATL CL'
			WHEN @PAIS = 'AR'					THEN 'ATL AR'			
		END																AS [Source Sytem]												
	
	,Voo_HIA 																AS [Flight 1]	
	,null																	AS [Flight 2]	

	,NULL																AS [Voyage Number] -- spNavio_LLP_Sel					
	,NULL																AS [Seal Number]						
	,CIA.Nome_Cia_Aer													AS [Master Carrier] 


	FROM House_Imp_Aer HOU (nolock)  
	INNER JOIN Job_Imp_Aer JOB (nolock)   
		ON HOU.Num_Proc_HIA  = JOB.Num_Proc_HIA  
	INNER JOIN LLP_Imp_Aer LLP (nolock)  
		ON HOU.Num_Proc_HIA = LLP.Num_Proc_LIA  

	--ORIGIN / SHIPPER
	INNER JOIN Localidade ORI (nolock)  
		ON HOU.Cd_Org_HIA = ORI.Cd_Local 
	LEFT JOIN Pais_Regiao_SCHNEIDER PRSO (NOLOCK)
		ON ORI.Pais_Local = PRSO.Nome_Pais_ATL

	INNER JOIN Pessoa SHIP (nolock)  
		ON HOU.Cd_Export_HIA  = SHIP.Cd_Pes  
	LEFT JOIN Endereco SHIPEND (nolock) 
		ON SHIPEND.cd_pes=SHIP.cd_pes AND SHIPEND.cd_tp_end='COM'  
	LEFT JOIN Pessoa_LLP PLLORI  (nolock) 
		ON PLLORI.Cd_Pes=SHIP.Cd_Pes  

	--Destination / CONSIGNEE 
	INNER JOIN Localidade DEST (nolock)  
		ON HOU.Cd_Dst_HIA   = DEST.Cd_Local  
	LEFT JOIN Pais_Regiao_SCHNEIDER PRSD (NOLOCK)
		ON DEST.Pais_Local = PRSD.Nome_Pais_ATL
	INNER JOIN Pessoa CONS (nolock)  
		ON HOU.Cd_Consig_HIA  = CONS.Cd_Pes
	LEFT JOIN Endereco CONSEND (nolock) 
		ON CONSEND.cd_pes=CONS.cd_pes AND CONSEND.cd_tp_end='COM' 
	LEFT JOIN Pessoa_LLP PLLDES  (nolock) 
		ON PLLDES.Cd_Pes=CONS.Cd_Pes  

	-- Itinerary ID
	LEFT JOIN Campo_Processo CP202 (nolock)  
		ON HOU.Num_Proc_HIA collate SQL_Latin1_General_CP1_CI_AS = CP202.Num_Proc collate SQL_Latin1_General_CP1_CI_AS  AND CP202.Id_Campo = 202 

	LEFT JOIN Tarefas_Processos TP005 (nolock) 
		ON HOU.Num_Proc_HIA = TP005.Num_Proc AND TP005.ID_Task = 5 

	LEFT JOIN Tarefas_Processos TP001 (nolock) 
		ON HOU.Num_Proc_HIA = TP001.Num_Proc AND TP001.ID_Task = 1
	LEFT JOIN Tarefas_Processos TP010 (nolock) 
		ON HOU.Num_Proc_HIA = TP010.Num_Proc AND TP010.ID_Task = 10
	LEFT JOIN Tarefas_Processos TP012 (nolock) 
		ON HOU.Num_Proc_HIA = TP012.Num_Proc AND TP012.ID_Task = 12
	LEFT JOIN Tarefas_Processos TP013 (nolock) 
		ON HOU.Num_Proc_HIA = TP013.Num_Proc AND TP013.ID_Task = 13
	LEFT JOIN Tarefas_Processos TP019 (nolock) 
		ON HOU.Num_Proc_HIA = TP019.Num_Proc AND TP019.ID_Task = 19
	LEFT JOIN Tarefas_Processos TP047 (nolock) 
		ON HOU.Num_Proc_HIA = TP047.Num_Proc AND TP047.ID_Task = 47
	LEFT JOIN Tarefas_Processos TP049 (nolock) 
		ON HOU.Num_Proc_HIA = TP049.Num_Proc AND TP049.ID_Task = 49
	LEFT JOIN Tarefas_Processos TP050 (nolock) 
		ON HOU.Num_Proc_HIA = TP050.Num_Proc AND TP050.ID_Task = 50
	LEFT JOIN Tarefas_Processos TP147 (nolock) 
		ON HOU.Num_Proc_HIA = TP147.Num_Proc AND TP147.ID_Task = 147 	
	LEFT JOIN Tarefas_Processos TP205 (nolock) 
		ON HOU.Num_Proc_HIA = TP205.Num_Proc AND TP205.ID_Task = 205 
	LEFT JOIN Tarefas_Processos TP211 (nolock) 
		ON HOU.Num_Proc_HIA = TP211.Num_Proc AND TP211.ID_Task = 211 
	LEFT JOIN Tarefas_Processos TP212 (nolock) 
		ON HOU.Num_Proc_HIA = TP212.Num_Proc AND TP212.ID_Task = 212

	LEFT JOIN Cia_Aerea CIA (NOLOCK)
		ON JOB.Cd_Cia_Aer = CIA.Cd_Cia_Aer

	WHERE SUBSTRING(HOU.Num_Proc_HIA,2,1) = 'A' 
	AND SUBSTRING(HOU.Num_Proc_HIA,1,1) = 'I' 
	AND DBO.FBusca_GrupoporJOB(HOU.Num_Proc_HIA) = 'GRUPO SCHNEIDER'
	ORDER BY HOU.Num_Proc_HIA


		INSERT INTO tmp_Schneider_TCT
		SELECT DISTINCT --top 1-- DISTINCT
		SUBSTRING(HOU.Num_Proc_HEA,1,1)									AS [ServiceCodeIndicator]
		,'BDP'															AS [LLP]
		,GETDATE()														AS [Input Date Time]
		,HOU.Num_Proc_HEA												AS [Job Number]
		,CASE
			WHEN SUBSTRING(HOU.Num_Proc_HEA,2,1) = 'M' THEN 'Sea'
			WHEN SUBSTRING(HOU.Num_Proc_HEA,2,1) = 'A' THEN 'Air'
			ELSE 'Truck/Rail'
		END																AS [Transport Mode]
		,HOU.MAWB_HEA													AS [MAWB]
		,HOU.HAWB_HEA													AS [Housebill / Shipment]
		
		,CASE 
			WHEN convert(DATETIME,HOU.Dt_Emis_HEA,105)  < '2020-06-01 00:00:00.000' THEN 'Cancelled'
			WHEN ISNULL(ID_Status,0) = 9 THEN 'Cancelled'
			ELSE ''													
		END																AS [Vessel name]

		--ORIGIN
		,UPPER(ISNULL(ORI.SCAC,ORI.CD_LOCAL))							AS [Origin Station]
		,PRSO.Cd_IATA_Pais												AS [Origin Country Code]
		,PRSO.Regiao_Pais												AS [Origin Region]

		--SHIPPER / EXPORTADOR
		,SHIP.Nome_Raz_Soc												AS [Shipper Name]

		--Destination
		,UPPER(ISNULL(DEST.SCAC,DEST.CD_LOCAL))							AS [Destination Station]
		,PRSD.Cd_IATA_Pais												AS [Destination Country Code]
		,PRSD.Regiao_Pais												AS [Destination Region]

		--CONSIGNEE / IMPORTADOR
		,CONS.Nome_Raz_Soc												AS [Consignee Name]
		,NULL															AS [Transport Lane ID]
		,UPPER(ISNULL(ORI.SCAC,ORI.CD_LOCAL)
		+ISNULL(DEST.SCAC,DEST.CD_LOCAL))								AS [Lane]
		,'LCL'															AS [LCL/FCL]
		,'CFS/CFS'														AS [Loading Type]
		,NULL															AS [Container Number]
		,NULL															AS [Container Size]
		,NULL															AS [Container Type]
		,0																AS [TEU]
		,Qtd_Tot_Vol_HEA												AS [No of Packages]
		,Peso_Bruto_HEA													AS [Gross Weight]
		,Peso_Cubado_LEA												AS [Chargeable Weight] -- Aereo não sera nivel de container e ai tem o campo.
		,Vol_Tot_HEA													AS [Volume]

		,dbo.fSchneider_scope(HOU.Num_Proc_HEA)							AS [Scope]
		,CASE 
			WHEN GETDATE()>LLP.ATA_LEA THEN 'Delivered' 
			ELSE 'In Transit'
		END																AS [Shipment Status]


		,CASE
			WHEN @PAIS = 'BR'	THEN TP005.Dt_Conclusao
			WHEN @PAIS = 'AR'	THEN TP211.Dt_Conclusao	
			WHEN @PAIS = 'CL'	THEN TP005.Dt_Conclusao 
		END																AS [Booking date]
		,CASE
			WHEN @PAIS = 'BR'	THEN TP050.Dt_Conclusao
			WHEN @PAIS = 'AR'	THEN TP212.Dt_Conclusao	
			WHEN @PAIS = 'CL'	THEN TP049.Dt_Conclusao 
		END																AS [Cargo ready date]
		,CASE
			WHEN @PAIS = 'BR'	THEN TP001.Dt_Conclusao
			WHEN @PAIS = 'AR'	THEN TP012.Dt_Conclusao 
			WHEN @PAIS = 'CL'	THEN TP012.Dt_Conclusao 
		END																AS [Pre-alert date]

		,CASE
			WHEN @PAIS = 'BR'	THEN TP010.Dt_Conclusao
			WHEN @PAIS = 'AR'	THEN TP212.Dt_Conclusao 
			WHEN @PAIS = 'CL'	THEN TP010.Dt_Conclusao 
		END																AS [Shipment Pickup]
		,CASE
			WHEN @PAIS = 'BR'	THEN TP189.Dt_Conclusao
			WHEN @PAIS = 'AR'	THEN TP212.Dt_Conclusao 
			WHEN @PAIS = 'CL'	THEN TP049.Dt_Conclusao --Ale 29/04
		END																AS [Received at Origin]
		,LLP.ETD_LEA													AS [MB ETD 1]
		,NULL															AS [MB ETD 2]
		,NULL															AS [MB ETD 3]
		,LLP.ETA_LEA													AS [MB ETA 1]
		,NULL															AS [MB ETA 2]
		,NULL															AS [MB ETA 3]
		,LLP.ATD_LEA													AS [Actual Time Departure]
		,LLP.ATA_LEA													AS [Actual Time Arrival]

		,DATEDIFF(D,ISNULL(LLP.ATA_Lea,LLP.ETA_Lea),GETDATE())			AS [CALC ARRIVAL DATE]
		,CASE 
			WHEN LLP.ATA_Lea is not NULL THEN @qtd_dias_ATA
			WHEN LLP.ETA_Lea IS NOT NULL THEN @qtd_dias_ETA
			ELSE 999
		END 															AS [QTY DAYS TO DROP]


		--'ATL AR'
		,CASE
			WHEN @PAIS = 'BR'	THEN TP001.Dt_Conclusao
			WHEN @PAIS = 'AR'	THEN NULL 
			WHEN @PAIS = 'CL'	THEN TP001.Dt_Conclusao -- Ale 29/04
		END																AS [Broker Notified]
		,CASE
			WHEN @PAIS = 'BR'	THEN TP147.Dt_Conclusao
			WHEN @PAIS = 'AR'	THEN NULL 
			WHEN @PAIS = 'CL'	THEN TP047.Dt_Conclusao -- Ale 29/04
		END																AS [Shipment Hand-Over To the broker]
		,null															AS [Estimated Customs Clearance]
		,null															AS [Actual Customs Completion]

		,null															AS [Estimated Delivery Date]
		,CASE
			WHEN @PAIS = 'BR'	THEN TP013.Dt_Conclusao
			WHEN @PAIS = 'AR'	THEN TP013.Dt_Conclusao  -- Ale 29/04 
			WHEN @PAIS = 'CL'	THEN TP013.Dt_Conclusao  -- Ale 29/04
		END																AS [Actual Delivery Date]
		,null															AS [Estimated Completion Date]
		,null															AS [Actual Completion Date]

		,0																AS [TT1 Benchmark]
		,DATEDIFF(D,LLP.ETD_LEA,LLP.ETA_LEA)							AS [TT2 Benchmark]
		,0																AS [TT3 Benchmark]
		,0																AS [TT4 Benchmark]
		,0																AS [Total TT Benchmark]

		,0																AS [TT1 Planned/Actual]
		,0																AS [TT2 Planned/Actual]
		,0																AS [TT3 Planned/Actual]
		,0																AS [TT4 Planned/Actual]
		,0																AS [Total TT Planned/Actual]


		,'Out of scope'													AS [TT1 status]
		,'Out of scope'													AS [TT2 status]
		,'Out of scope'													AS [TT3 status]
		,'Out of scope'													AS [TT4 status]
		,'Out of scope'													AS [Total Status]

		,NULL															AS [Delay Responsibility]
		,NULL															AS [Delay Code]
		,NULL															AS [Reason of Delay]
		,NULL															AS [CO2 emission]
		,'https://www.bdpsmart.com/tracking/detail?refnum=' 
		+ ltrim(rtrim(ISNULL(HOU.Num_Proc_HEA,'')))
		+ '&ss=' + '01BDPBRSAO'
		+ '&snp=000000000'
																		AS [Track and trace URL address]

		,SHIPEND.RUA
		+ ' ' + SHIPEND.NUMERO 											AS [Shipper Address]
		,SHIPEND.cidade													AS [Shipper City]
		,SHIPEND.cep													AS [Shipper Postcode]

		,CONSEND.RUA 
		+ ' ' + CONSEND.NUMERO 											AS [Consignee Address]
		,CONSEND.cidade 												AS [Consignee City]
		,CONSEND.cep													AS [Consignee Postcode]

		,dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEA,2)					AS [Shipper Reference BIT_Invoice]
		,ISNULL(CP202.Campo_Dados,'')									AS [Itinerary ID]

		,NULL															AS [Plant of origin ID]
		,NULL															AS [Plant of origin]
		,NULL															AS [Plant of Destination ID]
		,NULL															AS [Plant of Destination]

		,HOU.cd_tp_oper													AS [Incoterm]
		,CASE
			WHEN @PAIS = 'BR' AND  @TEST = 1	THEN 'ATL BR TEST'
			WHEN @PAIS = 'CL' AND  @TEST = 1	THEN 'ATL CL TEST'
			WHEN @PAIS = 'AR' AND  @TEST = 1	THEN 'ATL AR TEST'
			WHEN @PAIS = 'BR'					THEN 'ATL BR'
			WHEN @PAIS = 'CL'					THEN 'ATL CL'
			WHEN @PAIS = 'AR'					THEN 'ATL AR'			
		END																AS [Source Sytem]												
	
	,Voo_HEA 																AS [Flight 1]	
	,NULL																	AS [Flight 2]

	,NULL																AS [Voyage Number] -- spNavio_LLP_Sel					
	,NULL																AS [Seal Number]						
	,Nome_Cia_Aer														AS [Master Carrier] 


	FROM House_Exp_Aer HOU (nolock)  
	INNER JOIN Job_Exp_Aer JOB (nolock)   
		ON HOU.Num_Proc_HEA  = JOB.Num_Proc_HEA  
	INNER JOIN LLP_Exp_Aer LLP (nolock)  
		ON HOU.Num_Proc_HEA = LLP.Num_Proc_LEA  

	--ORIGIN / SHIPPER
	INNER JOIN Localidade ORI (nolock)  
		ON HOU.Cd_Org_HEA = ORI.Cd_Local 
	LEFT JOIN Pais_Regiao_SCHNEIDER PRSO (NOLOCK)
		ON ORI.Pais_Local = PRSO.Nome_Pais_ATL

	INNER JOIN Pessoa SHIP (nolock)  
		ON HOU.Cd_Export_HEA  = SHIP.Cd_Pes  
	LEFT JOIN Endereco SHIPEND (nolock) 
		ON SHIPEND.cd_pes=SHIP.cd_pes AND SHIPEND.cd_tp_end='COM'  
	LEFT JOIN Pessoa_LLP PLLORI  (nolock) 
		ON PLLORI.Cd_Pes=SHIP.Cd_Pes  

	--Destination / CONSIGNEE 
	INNER JOIN Localidade DEST (nolock)  
		ON HOU.Cd_Dst_HEA   = DEST.Cd_Local  
	LEFT JOIN Pais_Regiao_SCHNEIDER PRSD (NOLOCK)
		ON DEST.Pais_Local = PRSD.Nome_Pais_ATL
	INNER JOIN Pessoa CONS (nolock)  
		ON HOU.Cd_Consig_HEA  = CONS.Cd_Pes
	LEFT JOIN Endereco CONSEND (nolock) 
		ON CONSEND.cd_pes=CONS.cd_pes AND CONSEND.cd_tp_end='COM' 
	LEFT JOIN Pessoa_LLP PLLDES  (nolock) 
		ON PLLDES.Cd_Pes=CONS.Cd_Pes  

	-- Itinerary ID
	LEFT JOIN Campo_Processo CP202 (nolock)  
		ON HOU.Num_Proc_HEA collate SQL_Latin1_General_CP1_CI_AS = CP202.Num_Proc collate SQL_Latin1_General_CP1_CI_AS  AND CP202.Id_Campo = 202 

	LEFT JOIN Tarefas_Processos TP005 (nolock) 
		ON HOU.Num_Proc_HEA = TP005.Num_Proc AND TP005.ID_Task = 5 

	LEFT JOIN Tarefas_Processos TP001 (nolock) 
		ON HOU.Num_Proc_HEA = TP001.Num_Proc AND TP001.ID_Task = 1
	LEFT JOIN Tarefas_Processos TP010 (nolock) 
		ON HOU.Num_Proc_HEA = TP010.Num_Proc AND TP010.ID_Task = 10
	LEFT JOIN Tarefas_Processos TP012 (nolock) 
		ON HOU.Num_Proc_HEA = TP012.Num_Proc AND TP012.ID_Task = 12
	LEFT JOIN Tarefas_Processos TP013 (nolock) 
		ON HOU.Num_Proc_HEA = TP013.Num_Proc AND TP013.ID_Task = 13
	LEFT JOIN Tarefas_Processos TP047 (nolock) 
		ON HOU.Num_Proc_HEA = TP047.Num_Proc AND TP047.ID_Task = 47
	LEFT JOIN Tarefas_Processos TP049 (nolock) 
		ON HOU.Num_Proc_HEA = TP049.Num_Proc AND TP049.ID_Task = 49
	LEFT JOIN Tarefas_Processos TP050 (nolock) 
		ON HOU.Num_Proc_HEA = TP050.Num_Proc AND TP050.ID_Task = 50
	LEFT JOIN Tarefas_Processos TP147 (nolock) 
		ON HOU.Num_Proc_HEA = TP147.Num_Proc AND TP147.ID_Task = 147 	
	LEFT JOIN Tarefas_Processos TP189 (nolock) 
		ON HOU.Num_Proc_HEA = TP189.Num_Proc AND TP189.ID_Task = 189 
	LEFT JOIN Tarefas_Processos TP211 (nolock) 
		ON HOU.Num_Proc_HEA = TP211.Num_Proc AND TP211.ID_Task = 211 
	LEFT JOIN Tarefas_Processos TP212 (nolock) 
		ON HOU.Num_Proc_HEA = TP212.Num_Proc AND TP212.ID_Task = 212

	LEFT JOIN Cia_Aerea CIA (NOLOCK)
		ON LLP.Cd_CiaAerea_Lea = CIA.Cd_Cia_Aer

	WHERE SUBSTRING(HOU.Num_Proc_HEA,2,1) = 'A' 
	AND SUBSTRING(HOU.Num_Proc_HEA,1,1) = 'E' 
	AND DBO.FBusca_GrupoporJOB(HOU.Num_Proc_HEA) = 'GRUPO SCHNEIDER'
	ORDER BY HOU.Num_Proc_HEA



	--===========================================================================================================================================
	--=====================================     TRATAMENTO DOS CAMPOS DE TTX BEMCHMARK          =================================================
	--===========================================================================================================================================
	UPDATE tmp_Schneider_TCT
	SET [TT1 Planned/Actual] = 
	CASE 
		WHEN CONVERT(VARCHAR(15),[TT1 Benchmark]) = 0
		THEN 0
		ELSE	
				ISNULL(
				CASE 
					WHEN [Actual Time Departure] IS NULL
					THEN CONVERT(VARCHAR(15),(DATEDIFF(D,ISNULL([MB ETD 3],ISNULL([MB ETD 2],[MB ETD 1])),ISNULL([Shipment Pickup],[Received at Origin]))))
					ELSE CONVERT(VARCHAR(15),(DATEDIFF(D,[Actual Time Departure],ISNULL([Shipment Pickup] ,[Received at Origin]))))
					END
				,0)
	END 
	,[TT2 Planned/Actual] =
	CASE 
		WHEN  [Actual Time Arrival] IS NULL 
		THEN  DATEDIFF(D,ISNULL([MB ETA 3],ISNULL([MB ETA 2],[MB ETA 1])),ISNULL([Actual Time Departure],ISNULL([MB ETD 3],ISNULL([MB ETD 2],[MB ETD 1]))))
		ELSE  DATEDIFF(D,[Actual Time Arrival],(ISNULL([Actual Time Departure],ISNULL([MB ETD 3],ISNULL([MB ETD 2],[MB ETD 1])))))
	END *-1
	, [TT3 Planned/Actual] =
	CASE 
	WHEN [TT3 Benchmark] = 0 OR ([Estimated Customs Clearance] is null AND [Actual Customs Completion] IS NULL)
	THEN 0
	ELSE 
		DATEDIFF
		(D,
		ISNULL([Actual Customs Completion],[Actual Customs Completion])
		,ISNULL([Actual Time Arrival],ISNULL([MB ETA 3],ISNULL([MB ETA 2],[MB ETA 1])))
		)
	END


	UPDATE tmp_Schneider_TCT
	SET [Total TT Benchmark]  = [TT1 Benchmark] + [TT2 Benchmark] + [TT3 Benchmark] + [TT4 Benchmark]
	,[Total TT Planned/Actual]  = [TT1 Planned/Actual] + [TT2 Planned/Actual] + [TT3 Planned/Actual] + [TT4 Planned/Actual]
	,[TT2 status] = 
		(
		CASE 
			WHEN convert(VARCHAR(15),[TT2 Planned/Actual])='Out of Scope'
			THEN 'Out of Scope'
			ELSE	(
					CASE 
						WHEN [TT2 Planned/Actual]<>''
						THEN	(
								CASE 
									WHEN ([TT2 Planned/Actual] - [TT2 Benchmark]<=0)
									THEN 'On time'
									ELSE	(
											CASE 
												WHEN ([TT2 Planned/Actual] - [TT2 Benchmark]<=3)
												THEN 'Delay 1-3 days'
												ELSE 'Delay >3 days'	
											END
											) 	
								END
								) 
						ELSE 'No update'	
					END
					) 
		END
		) 

	-- Olha os totais calculados acima, por isso outro update
	UPDATE tmp_Schneider_TCT
	SET [Total Status] = 
	(
	CASE 
		WHEN CONVERT(VARCHAR(15),[Total TT Planned/Actual]) = 'Out of Scope'
		THEN 'Out of Scope'
		ELSE	(
				CASE 
					WHEN [Total TT Planned/Actual] <> ''
					THEN	(
							CASE 
								WHEN ([Total TT Planned/Actual]-[Total TT Benchmark] <=0)
								THEN 'On time'
								ELSE	(
										CASE 
											WHEN ([Total TT Planned/Actual]-[Total TT Benchmark] <=3)
											THEN 'Delay 1-3 days'
											ELSE 'Delay >3 days'	
										END
										) 	
							END
							) 
					ELSE 'No update'	
				END
				) 	
	END
	) 


	IF OBJECT_ID('dbo.tmp_Schneider_TCT_GNC', 'u') IS NOT NULL 
		DROP TABLE tmp_Schneider_TCT_GNC

	 SELECT DISTINCT 
	hsgprocesso
	,hsgseq
	,ID_NC
	,cd_nc
	,parte_resp
	,CASE WHEN ISNULL(historico_padrao,'') = ''
	THEN SUBSTRING(HSDDescricao,1,charindex(HSDDescricao,','))
	ELSE ISNULL(historico_padrao,'')
	END AS historico
	INTO tmp_Schneider_TCT_GNC
	FROM hist_geral H (NOLOCK)
	INNER JOIN tipo_nc_cliente N (NOLOCK)
		ON H.id_nc collate SQL_Latin1_General_CP1_CI_AS = N.cd_nc collate SQL_Latin1_General_CP1_CI_AS
	INNER JOIN tmp_Schneider_TCT T  (NOLOCK) 
		ON T.[Job Number] collate SQL_Latin1_General_CP1_CI_AS = H.HSGPROCESSO collate SQL_Latin1_General_CP1_CI_AS
	WHERE id_nc is not null
	ORDER BY hsgseq desc

	UPDATE tmp_Schneider_TCT
	SET [Delay Responsibility] = ( SELECT TOP 1 parte_resp FROM tmp_Schneider_TCT_GNC WHERE HSGProcesso = [Job Number] ORDER BY hsgseq desc)
	,[Delay Code] = ( SELECT TOP 1 id_nc FROM tmp_Schneider_TCT_GNC WHERE HSGProcesso = [Job Number] ORDER BY hsgseq desc)
	,[Reason of Delay] = ( SELECT TOP 1 historico FROM tmp_Schneider_TCT_GNC WHERE HSGProcesso = [Job Number] ORDER BY hsgseq desc)
	--where [Total Status] <> 'On time'

	--select count(*) FROM tmp_Schneider_TCT

	UPDATE tmp_Schneider_TCT
	SET 
	[ServiceCodeIndicator] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([ServiceCodeIndicator]),',','.'),
	[LLP] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([LLP]),',','.'),
	--[Input Date Time] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Input Date Time]),',','.'),
	[Job Number] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Job Number]),',','.'),
	[Transport Mode] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Transport Mode]),',','.'),
	[MAWB] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([MAWB]),',','.'),
	--[Housebill / Shipment] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Housebill / Shipment]),',','.'),
	[Housebill / Shipment] = ISNULL([Housebill / Shipment],''),
	[Vessel name] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Vessel name]),',','.'),
	[Origin Station] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Origin Station]),',','.'),
	[Origin Country Code] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Origin Country Code]),',','.'),
	[Origin Region] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Origin Region]),',','.'),
	[Shipper Name] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Shipper Name]),',','.'),
	[DestinatiON Station] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([DestinatiON Station]),',','.'),
	[DestinatiON Country Code] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([DestinatiON Country Code]),',','.'),
	[DestinatiON Region] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([DestinatiON Region]),',','.'),
	[Consignee Name] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Consignee Name]),',','.'),
	--[Transport Lane ID] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Transport Lane ID]),',','.'),
	[Transport Lane ID] = ISNULL(REPLACE([Transport Lane ID],',','.'),''),
	[Lane] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Lane]),',','.'),
	[LCL/FCL] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([LCL/FCL]),',','.'),
	--[Loading Type] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Loading Type]),',','.'),
	[Container Number] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Container Number]),',','.'),
	--[Container Size] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Container Size]),',','.'),
	[Container Type] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Container Type]),',','.'),
	[TEU] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([TEU]),',','.'),
	[No of Packages] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([No of Packages]),',','.'),
	[Gross Weight] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Gross Weight]),',','.'),
	[Chargeable Weight] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Chargeable Weight]),',','.'),
	[Volume] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Volume]),',','.'),
	[Scope] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Scope]),',','.'),
	[Shipment Status] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Shipment Status]),',','.'),
	--[Booking date] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Booking date]),',','.'),
	--[Cargo ready date] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Cargo ready date]),',','.'),
	--[Pre-alert date] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Pre-alert date]),',','.'),
	--[Shipment Pickup] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Shipment Pickup]),',','.'),
	--[MB ETD 1] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([MB ETD 1]),',','.'),
	--[MB ETD 2] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([MB ETD 2]),',','.'),
	--[MB ETD 3] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([MB ETD 3]),',','.'),
	--[MB ETA 1] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([MB ETA 1]),',','.'),
	--[MB ETA 2] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([MB ETA 2]),',','.'),
	--[MB ETA 3] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([MB ETA 3]),',','.'),
	--[Actual Time Departure] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Actual Time Departure]),',','.'),
	--[Actual Time Arrival] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Actual Time Arrival]),',','.'),
	--[Estimated Customs Clearance] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Estimated Customs Clearance]),',','.'),
	--[Actual Customs Completion] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Actual Customs Completion]),',','.'),
	--[Estimated Delivery Date] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Estimated Delivery Date]),',','.'),
	--[Estimated Completion Date] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Estimated Completion Date]),',','.'),
	--[Actual Completion Date] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Actual Completion Date]),',','.'),
	--[TT1 Benchmark] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([TT1 Benchmark]),',','.'),
	--[TT2 Benchmark] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([TT2 Benchmark]),',','.'),
	--[TT3 Benchmark] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([TT3 Benchmark]),',','.'),
	--[TT4 Benchmark] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([TT4 Benchmark]),',','.'),
	--[Total TT Benchmark] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Total TT Benchmark]),',','.'),
	--[TT1 Planned/Actual] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([TT1 Planned/Actual]),',','.'),
	--[TT2 Planned/Actual] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([TT2 Planned/Actual]),',','.'),
	--[TT3 Planned/Actual] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([TT3 Planned/Actual]),',','.'),
	--[TT4 Planned/Actual] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([TT4 Planned/Actual]),',','.'),
	--[Total TT Planned/Actual] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Total TT Planned/Actual]),',','.'),
	--[TT1 status] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([TT1 status]),',','.'),
	--[TT2 status] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([TT2 status]),',','.'),
	--[TT3 status] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([TT3 status]),',','.'),
	--[TT4 status] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([TT4 status]),',','.'),
	--[Total Status] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Total Status]),',','.'),
	[Delay Responsibility] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Delay Responsibility]),',','.'),
	[Delay Code] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Delay Code]),',','.'),
	[Reason of Delay] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Reason of Delay]),',','.'),
	[CO2 emission] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([CO2 emission]),',','.'),
	--[Track and trace URL address] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Track and trace URL address]),',','.'),
	[Track and trace URL address] = isnull([Track and trace URL address],''),
	[Shipper Address] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Shipper Address]),',','.'),
	[Shipper City] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Shipper City]),',','.'),
	[Shipper Postcode] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Shipper Postcode]),',','.'),
	[Consignee Address] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Consignee Address]),',','.'),
	[Consignee City] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Consignee City]),',','.'),
	[Consignee Postcode] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Consignee Postcode]),',','.'),
	--[Shipper Reference BIT_Invoice] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Shipper Reference BIT_Invoice]),',','.'),
	[Shipper Reference BIT_Invoice] = isnull([Shipper Reference BIT_Invoice],''),
	--[Itinerary ID] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Itinerary ID]),',','.'),
	[Itinerary ID] = ISNULL(REPLACE(REPLACE(REPLACE(REPLACE([Itinerary ID],',','.'),char(10),''),char(32),''),char(13)+char(10),''),''),
	[Plant of origin ID] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Plant of origin ID]),',','.'),
	[Plant of origin] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Plant of origin]),',','.'),
	[Plant of destinatiON ID] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Plant of destinatiON ID]),',','.'),
	[Plant of destination] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Plant of destination]),',','.'),
	[Incoterm] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Incoterm]),',','.'),
	[Source Sytem] = REPLACE(dbo.FRemoveCaracteresEspeciais_Schneider([Source Sytem]),',','.')
	,[Flight 1] = ISNULL(replace([Flight 1],',','.'),'')				
	,[Flight 2]	 = ISNULL(replace([Flight 2]	,',','.'),'')							 						
	,[Voyage Number] = ISNULL(replace([Voyage Number],',','.'),'')						 					
	,[Seal Number]	 = ISNULL(replace([Seal Number],',','.'),'')							 				
	,[Master Carrier]	= ISNULL(replace([Master Carrier],',','.'),'')						 	


	--===========================================================================================================================================
	--=====================================     EXIBIÇÃO DOS DADOS + TRATAMENTO FORMATO         =================================================
	--===========================================================================================================================================
	SELECT 
	replace([ServiceCodeIndicator],',','.')							AS [ServiceCodeIndicator]
	,replace([LLP],',','.')												AS [LLP]
	,replace(CONVERT(VARCHAR(10),[Input Date Time],105),',','.')			AS [Input Date Time]
	,replace([Job Number],',','.')										AS [Job Number]
	,replace([Transport Mode],',','.')									AS [Transport Mode]
	,replace([MAWB],',','.')												AS [MAWB]
	,replace([Housebill / Shipment],',','.')								AS [Housebill / Shipment]
	,replace([Vessel name],',','.')										AS [Vessel name]
	,replace([Origin Station],',','.')									AS [Origin Station]
	,replace([Origin Country Code],',','.')								AS [Origin Country Code]
	,replace([Origin Region],',','.')										AS [Origin Region]
	,replace([Shipper Name]	,',','.')									AS [Shipper Name]
	,replace([Destination Station],',','.')								AS [Destination Station]
	,replace([Destination Country Code],',','.')							AS [Destination Country Code]
	,replace([Destination Region],',','.')								AS [Destination Region]
	,replace([Consignee Name],',','.')									AS [Consignee Name]
	,replace([Itinerary ID],',','.')										AS [Transport Lane ID]
	,replace([Lane],',','.')												AS [Lane]
	,replace([LCL/FCL],',','.')											AS [LCL/FCL]
	,replace([Loading Type],',','.')										AS [Loading Type]
	,replace([Container Number],',','.')									AS [Container Number]
	,replace([Container Size],',','.')									AS [Container Size]
	,replace([Container Type],',','.')									AS [Container Type]
	,replace([TEU],',','.')								AS [TEU]
	,replace([No of Packages],',','.')					AS [No of Packages]
	,replace([Gross Weight],',','.')						AS [Gross Weight]
	,replace([Chargeable Weight],',','.')				AS [Chargeable Weight]
	,replace([Volume],',','.')							AS [Volume]
	,replace([Scope],',','.')												AS [Scope]
	,replace([Shipment Status],',','.')									AS [Shipment Status]

	,ISNULL(CONVERT(VARCHAR(10),[Booking date],105),'')								AS [Booking date]
	,ISNULL(CONVERT(VARCHAR(10),[Cargo ready date],105),'')							AS [Cargo ready date]
	,ISNULL(CONVERT(VARCHAR(10),[Pre-alert date],105),'')							AS [Pre-alert date]

	,ISNULL(CONVERT(VARCHAR(10),[Shipment Pickup],105),'')						AS [Shipment Pickup]
	,ISNULL(CONVERT(VARCHAR(10),[Received at Origin],105),'')						AS [Received at Origin]
	,ISNULL(CONVERT(VARCHAR(10),[MB ETD 1],105),'')									AS [MB ETD 1]
	,ISNULL(CONVERT(VARCHAR(10),[MB ETD 2],105),'')									AS [MB ETD 2]
	,ISNULL(CONVERT(VARCHAR(10),[MB ETD 3],105),'')									AS [MB ETD 3]
	,ISNULL(CONVERT(VARCHAR(10),[MB ETA 1],105),'')									AS [MB ETA 1]
	,ISNULL(CONVERT(VARCHAR(10),[MB ETA 2],105),'')									AS [MB ETA 2]
	,ISNULL(CONVERT(VARCHAR(10),[MB ETA 3],105),'')									AS [MB ETA 3]
	,ISNULL(CONVERT(VARCHAR(10),[Actual Time Departure],105),'')					AS [Actual Time Departure]
	,ISNULL(CONVERT(VARCHAR(10),[Actual Time Arrival],105),'')						AS [Actual Time Arrival]
	,ISNULL(CONVERT(VARCHAR(10),[Broker Notified],105),'')							AS [Broker Notified]
	,ISNULL(CONVERT(VARCHAR(10),[Shipment Hand-Over To the broker],105),'')			AS [Shipment Hand-Over To the broker]
	,ISNULL(CONVERT(VARCHAR(10),[Estimated Customs Clearance],105),'')				AS [Estimated Customs Clearance]
	,ISNULL(CONVERT(VARCHAR(10),[Actual Customs Completion],105),'')				AS [Actual Customs Completion]
	,ISNULL(CONVERT(VARCHAR(10),[Estimated Delivery Date],105),'')					AS [Estimated Delivery Date]
	,ISNULL(CONVERT(VARCHAR(10),[Actual Delivery Date],105),'')						AS [Actual Delivery Date]
	,ISNULL(CONVERT(VARCHAR(10),[Estimated Completion Date],105),'')				AS [Estimated Completion Date]
	,ISNULL(CONVERT(VARCHAR(10),[Actual Completion Date],105),'')				AS [Actual Completion Date]
	,replace(dbo.fSchneider_OOS([TT1 Benchmark]),',','.')				AS [TT1 Benchmark]
	,replace(dbo.fSchneider_OOS([TT2 Benchmark]) ,',','.')				AS [TT2 Benchmark]
	,replace(dbo.fSchneider_OOS([TT3 Benchmark]),',','.')	 			AS [TT3 Benchmark]
	,replace(dbo.fSchneider_OOS([TT4 Benchmark]),',','.')	 			AS [TT4 Benchmark]
	,replace([Total TT Benchmark],',','.')								as [Total TT Benchmark]
	,replace(dbo.fSchneider_OOS([TT1 Planned/Actual]),',','.')	 		AS [TT1 Planned/Actual]
	,replace(dbo.fSchneider_OOS([TT2 Planned/Actual]),',','.')	 		AS [TT2 Planned/Actual]
	,replace(dbo.fSchneider_OOS([TT3 Planned/Actual]),',','.')	 		AS [TT3 Planned/Actual]
	,replace(dbo.fSchneider_OOS([TT4 Planned/Actual]),',','.')		 	AS [TT4 Planned/Actual]
	,replace([Total TT Planned/Actual],',','.')							as [Total TT Planned/Actual]
	,replace([TT1 status],',','.')										as [TT1 status]
	,replace([TT2 status],',','.')										AS [TT2 status]
	,replace([TT3 status],',','.')										AS [TT3 status]
	,replace([TT4 status],',','.')										AS [TT4 status]
	,replace([Total Status],',','.')									AS [Total Status]
	,replace([Delay Responsibility],',','.')					AS [Delay Responsibility]
	,replace([Delay Code],',','.')							AS  [Delay Code]
	,replace([Reason of Delay],',','.')						AS [Reason of Delay]
	,replace([CO2 emission],',','.')							AS [CO2 emission]
	,replace([Track and trace URL address],',','.')			AS [Track and trace URL address]
	,replace([Shipper Address],',','.')						AS [Shipper Address]
	,replace([Shipper City]	,',','.')						AS [Shipper City]
	,replace([Shipper Postcode]	,',','.')					AS [Shipper Postcode]
	,replace([Consignee Address],',','.')					AS[Consignee Address]
	,replace([Consignee City],',','.')						AS [Consignee City]
	,replace([Consignee Postcode],',','.')					AS [Consignee Postcode]
	,replace([Shipper Reference BIT_Invoice],',','.')		AS [Shipper Reference BIT_Invoice]
	,replace([Itinerary ID]	,',','.')						AS [Itinerary ID]
	,replace([Plant of origin ID],',','.')					AS [Plant of origin ID]
	,replace([Plant of origin],',','.')						AS [Plant of origin]
	,replace([Plant of Destination ID],',','.')				AS [Plant of Destination ID]
	,replace([Plant of Destination]	,',','.')				AS [Plant of Destination]
	,replace([Incoterm]		,',','.')						AS [Incoterm]
	,replace([Source Sytem]	,',','.')						AS [Source Sytem]
	,replace([Flight 1],',','.')							AS [Flight 1]							
	,replace([Flight 2]	,',','.')							AS [Flight 2]							
	,replace([Voyage Number],',','.')						AS [Voyage Number]					
	,replace([Seal Number],',','.')							AS [Seal Number]					
	,replace([Master Carrier],',','.')						AS [Master Carrier]					


	FROM tmp_Schneider_TCT 
	WHERE [CALC ARRIVAL DATE] <= [QTY DAYS TO DROP] -- 29/10/2020
	--WHERE [Job Number]  IN ('IMATL202005002BR')
	ORDER BY [ServiceCodeIndicator] DESC, [Loading Type],[JOB NUMBER] ASC



GO
