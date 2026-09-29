SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_HouseWaybill_Trigger_Rel]--'IAAPB202102001BR',''
(		
	@Num_Proc 	VarChar(16)
)	
AS	
	select
		HOU.ID,
		HOU.Num_Proc,	
		--MessageHeaderDocument_
		HOU.MessageHeaderDocument_ID,
		HOU.MessageHeaderDocument_Name,
		HOU.MessageHeaderDocument_TypeCode,
		HOU.MessageHeaderDocument_IssueDateTime,
		HOU.MessageHeaderDocument_PurposeCode,
		HOU.MessageHeaderDocument_VersionID,			
		HOU.MessageHeaderDocument_SenderParty_schemeID,
		HOU.MessageHeaderDocument_SenderParty_Value,
		HOU.MessageHeaderDocument_RecipientParty_schemeID,
		HOU.MessageHeaderDocument_RecipientParty_Value,

		--BusinessHeaderDocument
		HOU.BusinessHeaderDocument_ID,
		HOU.SignatoryConsignorAuthentication_Signatory,
		HOU.SignatoryCarrierAuthentication_ActualDateTime ,
		HOU.SignatoryCarrierAuthentication_Signatory,
		HOU.IssueAuthenticationLocation_Name,

		--MasterConsignment
		HOU.MasterConsignment_IncludedTareGrossWeightMeasure_UnitCode,
		HOU.MasterConsignment_IncludedTareGrossWeightMeasure_Value,
		HOU.MasterConsignment_TotalPieceQuantity,
		HOU.MasterConsignment_TransportContractDocument_ID,
		HOU.MasterConsignment_OriginLocation_ID,
		HOU.MasterConsignment_OriginLocation_Name,
		HOU.MasterConsignment_FinalDestinationLocation_ID,
		HOU.MasterConsignment_FinalDestinationLocation_Name,

		--HOU.IncludedHouseConsignmentItem_SequenceNumeric,

		--IncludedHouseConsigment
		HOU.MasterConsignment_NilCarriageValueIndicator						[MasterConsignment_IncludedHouseConsignment_NilCarriageValueIndicator],
		HOU.MasterConsignment_NilCustomsValueIndicator						[MasterConsignment_IncludedHouseConsignment_NilCustomsValueIndicator],
		HOU.MasterConsignment_NilInsuranceValueIndicator					[MasterConsignment_IncludedHouseConsignment_NilInsuranceValueIndicator],
		HOU.MasterConsignment_TotalChargePrepaidIndicator					[MasterConsignment_IncludedHouseConsignment_TotalChargePrepaidIndicator],
		HOU.MasterConsignment_WeightTotalChargeAmount_currencyID			[MasterConsignment_IncludedHouseConsignment_WeightTotalChargeAmount_currencyID],
		HOU.MasterConsignment_WeightTotalChargeAmount_Value					[MasterConsignment_IncludedHouseConsignment_WeightTotalChargeAmount_Value],
		HOU.MasterConsignment_TotalDisbursementPrepaidIndicator				[MasterConsignment_IncludedHouseConsignment_TotalDisbursementPrepaidIndicator],
		HOU.MasterConsignment_AgentTotalDisbursementAmount_currencyID		[MasterConsignment_IncludedHouseConsignment_AgentTotalDisbursementAmount_currencyID],
		HOU.MasterConsignment_AgentTotalDisbursementAmount_Value			[MasterConsignment_IncludedHouseConsignment_AgentTotalDisbursementAmount_Value],
		HOU.MasterConsignment_CarrierTotalDisbursementAmount_currencyID		[MasterConsignment_IncludedHouseConsignment_CarrierTotalDisbursementAmount_currencyID],
		HOU.MasterConsignment_CarrierTotalDisbursementAmount_Value			[MasterConsignment_IncludedHouseConsignment_CarrierTotalDisbursementAmount_Value], 
		HOU.MasterConsignment_TotalPrepaidChargeAmount_currencyID			[MasterConsignment_IncludedHouseConsignment_TotalPrepaidChargeAmount_currencyID],
		HOU.MasterConsignment_TotalPrepaidChargeAmount_Value				[MasterConsignment_IncludedHouseConsignment_TotalPrepaidChargeAmount_Value],
		HOU.MasterConsignment_TotalCollectChargeAmount_currencyID			[MasterConsignment_IncludedHouseConsignment_TotalCollectChargeAmount_currencyID],
		HOU.MasterConsignment_TotalCollectChargeAmount_Value				[MasterConsignment_IncludedHouseConsignment_TotalCollectChargeAmount_Value],
		HOU.MasterConsignment_IncludedHouseConsignment_IncludedTareGrossWeightMeasure_UnitCode,
		HOU.MasterConsignment_IncludedHouseConsignment_IncludedTareGrossWeightMeasure_Value,
		HOU.MasterConsignment_GrossVolumeMeasure_UnitCode					[MasterConsignment_IncludedHouseConsignment_GrossVolumeMeasure_UnitCode],
		HOU.MasterConsignment_GrossVolumeMeasure_Value						[MasterConsignment_IncludedHouseConsignment_GrossVolumeMeasure_Value],
		HOU.MasterConsignment_IncludedHouseConsignment_TotalPieceQuantity,
		HOU.SummaryDescription												[MasterConsignment_IncludedHouseConsignment_SummaryDescription],
		
			
		--ConsignorParty
		HOU.ConsignorParty_Name,
		HOU.ConsignorParty_AccountID,
		HOU.ConsignorParty_PostcodeCode,
		HOU.ConsignorParty_StreetName,
		HOU.ConsignorParty_CityName,
		HOU.ConsignorParty_CountryID,
		--ConsigneeParty
		HOU.ConsigneeParty_Name,
		HOU.ConsigneeParty_AccountID,
		HOU.ConsigneeParty_PostcodeCode,
		HOU.ConsigneeParty_StreetName,
		HOU.ConsigneeParty_CityName,
		HOU.ConsigneeParty_CountryID,
		--FreightForwarderParty
		HOU.FreightForwarderParty_Name,
		HOU.FreightForwarderParty_AccountID,
		HOU.FreightForwarderParty_PostcodeCode,
		HOU.FreightForwarderParty_StreetName,
		HOU.FreightForwarderParty_CityName,
		HOU.FreightForwarderParty_CountryID,

		--nao criado
		--HOU.MasterConsignment_IncludedHouseConsignment_OriginLocation_ID,
		--HOU.MasterConsignment_IncludedHouseConsignment_OriginLocation_Name,
		--HOU.MasterConsignment_IncludedHouseConsignment_FinalDestinationLocation_ID,
		--HOU.MasterConsignment_IncludedHouseConsignment_FinalDestinationLocation_Name,


		HOU.SpecifiedLogisticsTransportMovement_StageCode,
		HOU.SpecifiedLogisticsTransportMovement_ModeCode,
		HOU.SpecifiedLogisticsTransportMovement_Mode,
		HOU.SpecifiedLogisticsTransportMovement_ID,
		HOU.SpecifiedLogisticsTransportMovement_SequenceNumeric,
		HOU.UsedLogisticsTransportMeans_Name,

		HOU.ArrivalEvent_ScheduledOccurrenceDateTime,
		HOU.ArrivalEvent_TypeCode,
		HOU.ArrivalEvent_OriginLocation_ID,
		HOU.ArrivalEvent_OriginLocation_Name,

		HOU.DepartureEvent_ScheduledOccurrenceDateTime,
		HOU.DepartureEvent_TypeCode,
		HOU.DepartureEvent_FinalDestinationLocation_ID,
		HOU.DepartureEvent_FinalDestinationLocation_Name,

		HOU.HandlingSPHInstructions,
		HOU.IncludedHouseConsignmentItem_SequenceNumeric,
		HOU.IncludedHouseConsignmentItem_TypeCode,
		HOU.IncludedHouseConsignmentItem_GrossWeightMeasure_UnitCode,
		HOU.IncludedHouseConsignmentItem_GrossWeightMeasure_Value,

		HOU.IncludedHouseConsignmentItem_GrossVolumeMeasure_UnitCode,
		HOU.IncludedHouseConsignmentItem_GrossVolumeMeasure_Value,

		HOU.IncludedHouseConsignmentItem_PieceQuantity,
		HOU.NatureIdentificationTransportCargo_Information,
		HOU.ApplicableFreightRateServiceCharge_ChargeableWeightMeasure_UnitCode,
		HOU.ApplicableFreightRateServiceCharge_ChargeableWeightMeasure_Value
			
		,HOU.Cd_Pes_grupo 		[Group Code],
		PG.Apelido				[Group Name],
		HOU.Cd_Usuario			[User Code],
		US.Nome_Usuario			[User Name],
		HOU.Notes				[Notes]
	from 
		ATL_INT.dbo.Iata_HouseWaybill HOU with(nolock)	
		Left Join Pessoa		PG with(nolock)	on PG.Cd_Pes= HOU.Cd_Pes_grupo
		Left Join Usuario		US with(nolock)	on US.Cd_Usuario= HOU.Cd_Usuario
	Where
		hou.Num_Proc=@Num_Proc


GO
