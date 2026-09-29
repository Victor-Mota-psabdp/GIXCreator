SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[E_AirFreight_XML_Recebido](
	[Nome_Arquivo] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[HAWB_MAWB] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[MessageHeaderDocument_ID] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[MessageHeaderDocument_Name] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[MessageHeaderDocument_TypeCode] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[MessageHeaderDocument_IssueDateTime] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[MessageHeaderDocument_PurposeCode] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[MessageHeaderDocument_VersionID] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[MessageHeaderDocument_ConversationID] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[MessageHeaderDocument_SenderParty] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[MessageHeaderDocument_RecipientParty] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[BusinessHeaderDocument_ID] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[BusinessHeaderDocument_Name] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[BusinessHeaderDocument_TypeCode] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[BusinessHeaderDocument_StatusCode] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[ResponseStatus_ConditionCode] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[ResponseStatus_Reason] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Created Date] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[XML_DOC] [varchar](max) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ins_XML] [datetime] NULL,
	[SenderParty_PrimaryID] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[RecipientParty_PrimaryID] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[MasterConsignment_GrossWeightMeasure] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[MasterConsignment_PieceQuantity] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[MasterConsignment_TotalPieceQuantity] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[MasterConsignment_TransportSplitDescription] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[TransportContractDocument_ID] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[TransportContractDocument_TypeCode] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[OriginLocation_ID] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[FinalDestinationLocation_ID] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[ReportedStatus_ReasonCode] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[AssociatedStatusConsignment_PieceQuantity] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[AssociatedStatusConsignment_TransportSplitDescription] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[SpecifiedLocation_ID1] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[SpecifiedLocation_TypeCode1] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[SpecifiedLocation_FlightStatusTypeCode1] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[SpecifiedLocation_ID2] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[SpecifiedLocation_TypeCode2] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[SpecifiedLocation_FlightStatusTypeCode2] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[SpecifiedEvent_OccurrenceDateTime] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[SpecifiedEvent_DateTimeTypeCode] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[HandlingOSIInstructions_Description1] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[HandlingOSIInstructions_DescriptionCode1] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[HandlingOSIInstructions_Description2] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[HandlingOSIInstructions_DescriptionCode2] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[SpecifiedLogisticsTransportMovement_ID] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[ArrivalEvent_ArrivalOccurrenceDateTime] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[ArrivalEvent_ArrivalDateTimeTypeCode] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[DepartureEvent_DepartureOccurrenceDateTime] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[DepartureEvent_DepartureDateTimeTypeCode] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[DeliveryParty_Name] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[AssociatedReceivedFromParty_Name] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[AssociatedReceivedFromParty_RoleCode] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[NotifiedParty_Name] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[ScheduledArrivalEvent_ScheduledOccurrenceDateTime] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[AssociatedStatusConsignment_GrossWeightMeasure] [varchar](200) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
