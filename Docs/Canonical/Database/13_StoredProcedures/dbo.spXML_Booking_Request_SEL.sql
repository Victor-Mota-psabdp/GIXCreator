SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[spXML_Booking_Request_SEL]'11'

CREATE procedure [dbo].[spXML_Booking_Request_SEL]
(
	@strSystemCode varchar(10)
)
as
	select
		G.ID_Req,
        G.PrimaryKey								[BDPJobNumber],            
        BookingNumber.Ref_Number					[BookingNumber],
		OrderNumber.Ref_Number						[INTTRA_Ref],
		Notes.Notes									[Notes],			
        convert(datetime,OriginDate.Value,102)		[OriginDate],
		convert(datetime,DestinationDate.Value,102) [DestinationDate],
       	Vessel.VesselName							[VesselName],
		VoyageNumber.ReferenceNumber				[VoyageNumber],
		--Carrier.CarrierName							[CarrierName],
		--Carrier.Value								[SCAC],
		Origin.Origin_Name							[Origin_Name],
		--Cargo Dead Line = OrderReceiveDate
		--Draft Dead Line = CarrierDocCutoffDate
		--VGM Dead Line = SolasVrfdGrMassCutDt
		G.Header_Action									[Action],
		convert(datetime,convert(Varchar(25),convert(date,OrderReceiveDate.StatusDate,102)) + ' ' + left(OrderReceiveDate.StatusTime,2) + ':' +  right(OrderReceiveDate.StatusTime,2) ,102) [DL_Cargo_Lem],
		convert(datetime,convert(Varchar(25),convert(date,CarrierDocCutoffDate.StatusDate,102)) + ' ' + left(CarrierDocCutoffDate.StatusTime,2) + ':' +  right(CarrierDocCutoffDate.StatusTime,2) ,102)	[DL_Draft_Lem], 
		convert(datetime,convert(Varchar(25),convert(date,SolasVrfdGrMassCutDt.StatusDate,102)) + ' ' + left(SolasVrfdGrMassCutDt.StatusTime,2) + ':' +  right(SolasVrfdGrMassCutDt.StatusTime,2) ,102)	[DL_VGM_Lem]
    from ATL_INT.DBO.GIX_Request_Header G with(nolock)
		 join Booking_Request JOB with (nolock) on JOB.Num_Proc= G.PrimaryKey
		 left join ATL_INT.DBO.GIX_Header_References BookingNumber with(nolock) on G.ID_Req = BookingNumber.ID_Req AND BookingNumber.Ref_Type = 'BookingNumber'	
		 left join ATL_INT.DBO.GIX_Header_References OrderNumber with(nolock) on G.ID_Req = OrderNumber.ID_Req AND OrderNumber.Ref_Type = 'OrderNumber'	
		 left join ATL_INT.DBO.GIX_Header_References CarrierContractNbr with(nolock) on G.ID_Req = CarrierContractNbr.ID_Req AND CarrierContractNbr.Ref_Type = 'CarrierContractNbr'	

		left join ATL_INT.DBO.GIX_Header_Transportation Transportation with(nolock) on Transportation.ID_Req = G.ID_Req and Transportation.LegType = 'Primary'
		left join ATL_INT.DBO.GIX_Header_Transportation_Origin Origin with(nolock) on Transportation.ID_Req = Origin.ID_Req
			and Transportation.ID_Trans = Origin.ID_Trans AND Origen_Type ='PortofLoad'
		left join ATL_INT.DBO.GIX_Header_Transportation_OriginDate OriginDate with(nolock) on Transportation.ID_Req = OriginDate.ID_Req
			and Transportation.ID_Trans = OriginDate.ID_Trans
		left join ATL_INT.DBO.GIX_Header_Transportation_DestinationDate DestinationDate with(nolock) on Transportation.ID_Req = DestinationDate.ID_Req
			and Transportation.ID_Trans = DestinationDate.ID_Trans
        left join ATL_INT.DBO.GIX_Header_Transportation_Vessel Vessel with(nolock) on Transportation.ID_Req = Vessel.ID_Req
			and Transportation.ID_Trans = Vessel.ID_Trans
		left join ATL_INT.DBO.GIX_Header_Transportation_ReferenceType VoyageNumber with(nolock) on Transportation.ID_Req = VoyageNumber.ID_Req
            AND VoyageNumber.Type ='VoyageNumber'
		--left join ATL_INT.DBO.GIX_Header_Transportation_Carrier Carrier with(nolock) on Transportation.ID_Req = Carrier.ID_Req
  --          AND Carrier.Type ='SCAC'
		left join ATL_INT.DBO.GIX_Header_Notes Notes  with(nolock) on G.ID_Req = Notes.ID_Req AND Notes.Note_Type = 'Remarks'	

		left join ATL_INT.DBO.GIX_Header_Status CarrierDocCutoffDate	with(nolock) on G.ID_Req = CarrierDocCutoffDate.ID_Req	AND CarrierDocCutoffDate.StatusType = 'CarrierDocCutoffDate'
		left join ATL_INT.DBO.GIX_Header_Status SolasVrfdGrMassCutDt	with(nolock) on G.ID_Req = SolasVrfdGrMassCutDt.ID_Req	AND SolasVrfdGrMassCutDt.StatusType = 'SolasVrfdGrMassCutDt'
		left join ATL_INT.DBO.GIX_Header_Status OrderReceiveDate		with(nolock) on G.ID_Req = OrderReceiveDate.ID_Req		AND OrderReceiveDate.StatusType = 'OrderReceiveDate'
    where
		--G.PrimaryKey = 'EMATL202204001BR'

        SystemCode = @strSystemCode
        and G.DT_INS_JOB is null  
		--and Carrier.CarrierName is not null
          
    order by G.ID_Req
	

GO
