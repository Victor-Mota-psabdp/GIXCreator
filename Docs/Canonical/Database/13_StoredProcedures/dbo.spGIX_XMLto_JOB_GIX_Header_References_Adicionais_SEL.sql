SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spGIX_XMLto_JOB_GIX_Header_References_Adicionais_SEL]--43
	@ID_Req as BigInt
as

--MoedaConhec - Freight Currency
Select 	
	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],
	'Freight Currency'							[Tipo],
	MoedaConhec.AmountCurrency					[Dado],	
	'ATL System'								[Usuario],
	
	--TM.Nome_Tp_Moeda,
				
	Request.ID_Req
from ATL_INT.dbo.GIX_Request_Header Request
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type = 'ImportForwarderRefNbr'
	join vwHouse_Imp V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	join ATL_INT.dbo.GIX_Header_Amount MoedaConhec on MoedaConhec.ID_Req = Request.ID_Req
	and AmountType = 'TotalFreightBolAwbCollectAmount'
	join Tipo_Moeda TM on TM.Cd_Tp_Moeda = MoedaConhec.AmountCurrency
Where
	Request.ID_Req = @ID_Req
	and MoedaConhec.AmountCurrency is not null 
	--and V.[Moeda_Frete] is null
	

	
UNION ALL

--ValorConhec - Freight Value
Select 	
	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],
	'Freight Value'								[Tipo],
	Freight.AmountValue						[Dado],	
	'ATL System'								[Usuario],
				
	Request.ID_Req
from ATL_INT.dbo.GIX_Request_Header Request
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type = 'ImportForwarderRefNbr'
	join vwHouse_Imp V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	join ATL_INT.dbo.GIX_Header_Amount Freight on Freight.ID_Req = Request.ID_Req
	and Freight.AmountType = 'TotalFreightBolAwbCollectAmount'
Where
	Request.ID_Req = @ID_Req
	and Freight.AmountValue	 is not null
	--and V.[Frete_BL] is null
	
UNION ALL
--PesoBrutoConhec
Select 	
	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],
	'Gross Weight(KG)'							[Tipo],
	PesoBruto.MeasurementValue					[Dado],	
	'ATL System'								[Usuario],
				
	Request.ID_Req
from ATL_INT.dbo.GIX_Request_Header Request
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type = 'ImportForwarderRefNbr'
	join vwHouse_Imp V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	join ATL_INT.dbo.GIX_Footer_Measurements PesoBruto on PesoBruto.ID_Req = Request.ID_Req
	and PesoBruto.item = 'GrossWeightKilograms'
Where
	Request.ID_Req = @ID_Req
	and PesoBruto.MeasurementValue is not null

UNION ALL
--PesoLiquidoConhec
Select Distinct
	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],
	'Net Weight(KG)'							[Tipo],
	PesoLiquido.MeasurementValue				[Dado],	
	'ATL System'								[Usuario],
				
	Request.ID_Req
from ATL_INT.dbo.GIX_Request_Header Request
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type = 'ImportForwarderRefNbr'
	join vwHouse_Imp V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	join ATL_INT.dbo.GIX_Footer_Measurements PesoLiquido on PesoLiquido.ID_Req = Request.ID_Req
	and PesoLiquido.item = 'NetWeightKilograms'	
Where
	Request.ID_Req = @ID_Req
	and PesoLiquido.MeasurementValue is not null

UNION ALL

--Armazem - Terminal
Select 	
	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],
	'Terminal'									[Tipo],
	T.Cd_Terminal								[Dado],	
	'ATL System'								[Usuario],
				
	Request.ID_Req
from ATL_INT.dbo.GIX_Request_Header Request
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type = 'ImportForwarderRefNbr'
	join vwHouse_Imp V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	join ATL_INT.dbo.GIX_Header_Transportation Terminal on Terminal.ID_Req = Request.ID_Req
	and Method = 'Ocean'
	join Terminal T on T.Nome_Terminal = Terminal.TerminalName
Where
	Request.ID_Req = @ID_Req
	and Terminal.TerminalName	 is not null

UNION ALL	
--Invoice Currency
Select 	
	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],
	'Invoice Currency'							[Tipo],
	Invoice.CurrencyCode						[Dado],	
	'ATL System'								[Usuario],
				
	Request.ID_Req
from ATL_INT.dbo.GIX_Request_Header Request
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type = 'ImportForwarderRefNbr'
	join vwHouse_Imp V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	join ATL_INT.dbo.GIX_Header_Commercial_Invoice Invoice on Invoice.ID_Req = Request.ID_Req
	join Tipo_Moeda TM on TM.Cd_Tp_Moeda = Invoice.CurrencyCode
Where
	Request.ID_Req = @ID_Req
	and Invoice.CurrencyCode is not null
	
UNION ALL	
--Invoice Value
Select 	
	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],
	'Invoice Value'								[Tipo],
	replace(Invoice.Invoice_Amount,'.',',')						[Dado],	
	'ATL System'								[Usuario],
				
	Request.ID_Req
from ATL_INT.dbo.GIX_Request_Header Request
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type = 'ImportForwarderRefNbr'
	join vwHouse_Imp V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	join ATL_INT.dbo.GIX_Header_Commercial_Invoice Invoice on Invoice.ID_Req = Request.ID_Req
Where	
	Request.ID_Req = @ID_Req
	and Invoice.Invoice_Amount is not null
	
UNION ALL	
--Incoterm
Select 	
	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],
	'Incoterm'									[Tipo],
	Incoterm.TermsofSaleCode					[Dado],	
	'ATL System'								[Usuario],
				
	Request.ID_Req
from ATL_INT.dbo.GIX_Request_Header Request
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type = 'ImportForwarderRefNbr'
	join vwHouse_Imp V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	join ATL_INT.dbo.GIX_Header_Commercial_Invoice Incoterm on Incoterm.ID_Req = Request.ID_Req
	join dbo.Tipo_Oper TM on TM.Cd_Tp_Oper = Incoterm.TermsofSaleCode
Where
	Request.ID_Req =@ID_Req
	and Incoterm.TermsofSaleCode is not null
	
UNION ALL	
--Master BL
Select 	
	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],
	'MAWB'										[Tipo],
	R.ReferenceNumber							[Dado],	
	'ATL System'								[Usuario],
				
	Request.ID_Req
from ATL_INT.dbo.GIX_Request_Header Request
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type = 'ImportForwarderRefNbr'
	join vwHouse_Imp V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	join ATL_INT.dbo.GIX_Header_Transportation MAWB on MAWB.ID_Req = Request.ID_Req
	join ATL_INT.dbo.GIX_Header_Transportation_ReferenceType R on R.ID_Req = MAWB.ID_Req and R.ID_Trans = MAWB.ID_Trans
	and R.type = 'MasterBillofLadingNumber'
Where
	Request.ID_Req =@ID_Req
	and R.ReferenceNumber is not null
	
UNION ALL	
--House BL
Select 	
	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],
	'HAWB'										[Tipo],
	R.ReferenceNumber							[Dado],	
	'ATL System'								[Usuario],
				
	Request.ID_Req
from ATL_INT.dbo.GIX_Request_Header Request
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type = 'ImportForwarderRefNbr'
	join vwHouse_Imp V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	join ATL_INT.dbo.GIX_Header_Transportation HAWB on HAWB.ID_Req = Request.ID_Req
	join ATL_INT.dbo.GIX_Header_Transportation_ReferenceType R on R.ID_Req = HAWB.ID_Req and R.ID_Trans = HAWB.ID_Trans
	and R.type = 'HouseBillofLadingNumber'
Where
	Request.ID_Req =@ID_Req
	and R.ReferenceNumber is not null

UNION ALL

--ETA
--When Tipo=Chegada and Prevista is not blank then "StatusType"=EstPortofArrivalDate - ETA
Select 	
	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],
	'ETA'										[Tipo],
	(case when 
		(ETA.StatusDate	= '' OR ETA.StatusDate  IS NULL) then ''
		else  
		RIGHT(ETA.StatusDate,4)+'-'+ left(ETA.StatusDate,2) + '-'
			+ substring(ETA.StatusDate,3,2) end)	[Dado],	
		'ATL System'								[Usuario],	
	Request.ID_Req
from ATL_INT.dbo.GIX_Request_Header Request
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type = 'ImportForwarderRefNbr'
	join dbo.vwHouse_Imp V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	join ATL_INT.dbo.GIX_Header_Status ETA on ETA.ID_Req = Request.ID_Req 
		--and ETA.StatusType = 'EstimatedPortofDischargeDate'
		and ETA.StatusType = 'EstPortofArrivalDate'
Where
	Request.ID_Req =@ID_Req
	and ETA.StatusDate is not null

UNION ALL
--ATA
--When Tipo=Chegada and Realizada is not blank then "StatusType"=ActualPortofArrivalDate - ATA
select 	
	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],
	'ATA'										[Tipo],
	(case when 
		(ATA.StatusDate	= '' OR ATA.StatusDate  IS NULL) then ''
		else  
		RIGHT(ATA.StatusDate,4)+'-'+ left(ATA.StatusDate,2) + '-'
			+ substring(ATA.StatusDate,3,2) end)	[Dado],	
		'ATL System'								[Usuario],	
	Request.ID_Req
from ATL_INT.dbo.GIX_Request_Header Request
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type = 'ImportForwarderRefNbr'
	join .vwHouse_Imp V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	join ATL_INT.dbo.GIX_Header_Status ATA on ATA.ID_Req = Request.ID_Req 
		--and ETA.StatusType = 'ActualPortofDischargeDate'
		and ATA.StatusType = 'ActualPortofArrivalDate'
Where
	Request.ID_Req =@ID_Req
	and ATA.StatusDate is not null
	
UNION ALL


--ETD
--When Tipo=DTEMBARQUE and Realizada is not blank then "StatusType"=EstPortofDepartureDate  - ETD
Select 	
	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],
	'ETD'										[Tipo],
	(case when 
		(ETD.StatusDate	= '' OR ETD.StatusDate  IS NULL) then ''
		else  
		RIGHT(ETD.StatusDate,4)+'-'+ left(ETD.StatusDate,2) + '-'
			+ substring(ETD.StatusDate,3,2) end)	[Dado],	
		'ATL System'								[Usuario],	
	Request.ID_Req
from ATL_INT.dbo.GIX_Request_Header Request
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type = 'ImportForwarderRefNbr'
	join dbo.vwHouse_Imp V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	join ATL_INT.dbo.GIX_Header_Status ETD on ETD.ID_Req = Request.ID_Req 
		and ETD.StatusType = 'EstPortofDepartureDate'
		
Where
	Request.ID_Req =@ID_Req
	and ETD.StatusDate is not null

UNION ALL
--ATD
--When Tipo=DTEMBARQUE and Realizada is not blank then "StatusType"=ActPortofDepartureDate" - ATD
Select 	
	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],
	'ATD'										[Tipo],
	(case when 
		(ATD.StatusDate	= '' OR ATD.StatusDate  IS NULL) then ''
		else  
		RIGHT(ATD.StatusDate,4)+'-'+ left(ATD.StatusDate,2) + '-'
			+ substring(ATD.StatusDate,3,2) end)	[Dado],	
		'ATL System'								[Usuario],	
	Request.ID_Req
from ATL_INT.dbo.GIX_Request_Header Request
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type = 'ImportForwarderRefNbr'
	join .vwHouse_Imp V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	join ATL_INT.dbo.GIX_Header_Status ATD on ATD.ID_Req = Request.ID_Req 
		and ATD.StatusType = 'ActPortofDepartureDate'	
Where
	Request.ID_Req =@ID_Req
	and ATD.StatusDate is not null
	
UNION ALL	
--Navio
Select 	
	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],
	'Navio'										[Tipo],
	Vessel.VesselName							[Dado],	
	'ATL System'								[Usuario],
				
	Request.ID_Req
from ATL_INT.dbo.GIX_Request_Header Request
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type = 'ImportForwarderRefNbr'
	join vwHouse_Imp V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	join ATL_INT.dbo.GIX_Header_Transportation Terminal on Terminal.ID_Req = Request.ID_Req
	and Method = 'Ocean'
	join ATL_INT.dbo.GIX_Header_Transportation_Vessel Vessel on Vessel.ID_Req = Terminal.ID_Req 
		and Vessel.ID_Trans = Terminal.ID_Trans
Where
	Request.ID_Req = @ID_Req
	and Vessel.VesselName is not null



GO
