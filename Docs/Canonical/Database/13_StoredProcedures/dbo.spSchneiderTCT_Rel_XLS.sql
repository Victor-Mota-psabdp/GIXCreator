SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE spSchneiderTCT_Rel_XLS
	@Grupo varchar(20)
AS
/* 
========================================================================================================================= 
HISTORY CHANGE (From most recent to less recent)

. Date (YYYY/MM/DD):	2020/11/11 
. Ticket:				Schneider project
. Business:				- 
. Dept:					- 
. Quality:				-
. Developer:			Alessandra Suzuki Mariano (alessandra.mariano@bdpint.com)
. Developer review:		-
========================================================================================================================= 
EXECUTION EXAMPLES  

exec spSchneiderTCT_Rel_XLS 'GRUPO SCHNEIDER'
========================================================================================================================= 
*/ 

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
	FROM tmp_Schneider_TCT 
	WHERE [CALC ARRIVAL DATE] <= [QTY DAYS TO DROP] -- 29/10/2020
	--WHERE [Job Number]  IN ('IMATL202005002BR')
	ORDER BY [ServiceCodeIndicator] DESC, [Loading Type],[JOB NUMBER] ASC



GO
