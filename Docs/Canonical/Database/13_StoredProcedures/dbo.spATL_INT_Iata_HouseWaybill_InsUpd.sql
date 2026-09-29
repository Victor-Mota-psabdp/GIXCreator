SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_INT_Iata_HouseWaybill_InsUpd]
(
	@ID							BigInt,
	@Num_Proc					varchar(16),
	@MessageHeaderDocument_ID	varchar(200),
	@MessageHeaderDocument_Name	varchar(200),
	@MessageHeaderDocument_TypeCode	varchar(200),
	@MessageHeaderDocument_IssueDateTime	varchar(200),
	@MessageHeaderDocument_PurposeCode	varchar(200),
	@MessageHeaderDocument_VersionID	varchar(200),
	@MessageHeaderDocument_SenderParty_schemeID	varchar(200),
	@MessageHeaderDocument_SenderParty_Value	varchar(200),
	@MessageHeaderDocument_RecipientParty_schemeID	varchar(200),
	@MessageHeaderDocument_RecipientParty_Value	varchar(200),
	@BusinessHeaderDocument_ID	varchar(200),
	@SignatoryConsignorAuthentication_Signatory	varchar(200),
	@SignatoryCarrierAuthentication_ActualDateTime 	varchar(200),
	@SignatoryCarrierAuthentication_Signatory	varchar(200),
	@IssueAuthenticationLocation_Name	varchar(200),
	@MasterConsignment_IncludedTareGrossWeightMeasure_UnitCode	varchar(200),
	@MasterConsignment_IncludedTareGrossWeightMeasure_Value	varchar(200),
	@MasterConsignment_TotalPieceQuantity	varchar(200),
	@MasterConsignment_TransportContractDocument_ID	varchar(200),
	@MasterConsignment_OriginLocation_ID	varchar(200),
	@MasterConsignment_OriginLocation_Name	varchar(200),
	@MasterConsignment_FinalDestinationLocation_ID	varchar(200),
	@MasterConsignment_FinalDestinationLocation_Name	varchar(200),
	@MasterConsignment_NilCarriageValueIndicator	varchar(200),
	@MasterConsignment_NilCustomsValueIndicator	varchar(200),
	@MasterConsignment_NilInsuranceValueIndicator	varchar(200),
	@MasterConsignment_TotalChargePrepaidIndicator	varchar(200),
	@MasterConsignment_WeightTotalChargeAmount_currencyID	varchar(200),
	@MasterConsignment_WeightTotalChargeAmount_Value	varchar(200),
	@MasterConsignment_TotalDisbursementPrepaidIndicator	varchar(200),
	@MasterConsignment_AgentTotalDisbursementAmount_currencyID	varchar(200),
	@MasterConsignment_AgentTotalDisbursementAmount_Value	varchar(200),
	@MasterConsignment_CarrierTotalDisbursementAmount_currencyID	varchar(200),
	@MasterConsignment_CarrierTotalDisbursementAmount_Value 	varchar(200),
	@MasterConsignment_TotalPrepaidChargeAmount_currencyID	varchar(200),
	@MasterConsignment_TotalPrepaidChargeAmount_Value	varchar(200),
	@MasterConsignment_TotalCollectChargeAmount_currencyID	varchar(200),
	@MasterConsignment_TotalCollectChargeAmount_Value	varchar(200),
	@MasterConsignment_GrossVolumeMeasure_UnitCode	varchar(200),
	@MasterConsignment_GrossVolumeMeasure_Value	varchar(200),
	@MasterConsignment_IncludedHouseConsignment_IncludedTareGrossWeightMeasure_UnitCode 	varchar(200),
	@MasterConsignment_IncludedHouseConsignment_IncludedTareGrossWeightMeasure_Value 	varchar(200),
	@MasterConsignment_IncludedHouseConsignment_TotalPieceQuantity 	varchar(200),
	@SummaryDescription	varchar(200),
	@ConsignorParty_Name	varchar(200),
	@ConsignorParty_AccountID	varchar(200),
	@ConsignorParty_PostcodeCode	varchar(200),
	@ConsignorParty_StreetName	varchar(200),
	@ConsignorParty_CityName	varchar(200),
	@ConsignorParty_CountryID	varchar(200),
	@ConsigneeParty_Name	varchar(200),
	@ConsigneeParty_AccountID	varchar(200),
	@ConsigneeParty_PostcodeCode	varchar(200),
	@ConsigneeParty_StreetName	varchar(200),
	@ConsigneeParty_CityName	varchar(200),
	@ConsigneeParty_CountryID	varchar(200),
	@FreightForwarderParty_Name	varchar(200),
	@FreightForwarderParty_AccountID	varchar(200),
	@FreightForwarderParty_PostcodeCode	varchar(200),
	@FreightForwarderParty_StreetName	varchar(200),
	@FreightForwarderParty_CityName	varchar(200),
	@FreightForwarderParty_CountryID	varchar(200),
	@SpecifiedLogisticsTransportMovement_StageCode	varchar(200),
	@SpecifiedLogisticsTransportMovement_ModeCode	varchar(200),
	@SpecifiedLogisticsTransportMovement_Mode	varchar(200),
	@SpecifiedLogisticsTransportMovement_ID	varchar(200),
	@SpecifiedLogisticsTransportMovement_SequenceNumeric	varchar(200),
	@UsedLogisticsTransportMeans_Name	varchar(200),
	@ArrivalEvent_ScheduledOccurrenceDateTime	varchar(200),
	@ArrivalEvent_TypeCode	varchar(200),
	@ArrivalEvent_OriginLocation_ID varchar(200),
	@ArrivalEvent_OriginLocation_Name varchar(200),
	@DepartureEvent_ScheduledOccurrenceDateTime	varchar(200),
	@DepartureEvent_TypeCode	varchar(200),
	@DepartureEvent_FinalDestinationLocation_ID varchar(200),
	@DepartureEvent_FinalDestinationLocation_Name varchar(200),
	@HandlingSPHInstructions	varchar(200),
	@IncludedHouseConsignmentItem_SequenceNumeric	varchar(200),
	@IncludedHouseConsignmentItem_TypeCode	varchar(200),
	@IncludedHouseConsignmentItem_GrossWeightMeasure_UnitCode	varchar(200),
	@IncludedHouseConsignmentItem_GrossWeightMeasure_Value	varchar(200),
	@IncludedHouseConsignmentItem_GrossVolumeMeasure_UnitCode 	varchar(200),
	@IncludedHouseConsignmentItem_GrossVolumeMeasure_Value 	varchar(200),
	@IncludedHouseConsignmentItem_PieceQuantity	varchar(200),
	@NatureIdentificationTransportCargo_Information	varchar(200),
	@ApplicableFreightRateServiceCharge_ChargeableWeightMeasure_UnitCode	varchar(200),
	@ApplicableFreightRateServiceCharge_ChargeableWeightMeasure_Value	varchar(200),
	@cd_usuario varchar(6),
	@cd_pes_grupo varchar(10),
	@Notes  varchar(MAX)
)

AS

BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Iata_HouseWaybill
	BEGIN TRY
		Declare @ID_New as bigint;
		set @ID_New = (select ID from ATL_INT.dbo.Iata_HouseWaybill where Num_proc = @Num_Proc)
			
		IF exists(select ID from ATL_INT.dbo.Iata_HouseWaybill where Num_proc = @Num_Proc)
			Begin
				Update
					ATL_INT.dbo.Iata_HouseWaybill
				Set
					MessageHeaderDocument_ID=@MessageHeaderDocument_ID,
					MessageHeaderDocument_Name=@MessageHeaderDocument_Name,
					MessageHeaderDocument_TypeCode=@MessageHeaderDocument_TypeCode,
					MessageHeaderDocument_IssueDateTime = @MessageHeaderDocument_IssueDateTime,
					MessageHeaderDocument_PurposeCode=@MessageHeaderDocument_PurposeCode,
					MessageHeaderDocument_VersionID=@MessageHeaderDocument_VersionID,
					MessageHeaderDocument_SenderParty_schemeID=@MessageHeaderDocument_SenderParty_schemeID,
					MessageHeaderDocument_SenderParty_Value=@MessageHeaderDocument_SenderParty_Value,
					MessageHeaderDocument_RecipientParty_schemeID=@MessageHeaderDocument_RecipientParty_schemeID,
					MessageHeaderDocument_RecipientParty_Value=@MessageHeaderDocument_RecipientParty_Value,
					BusinessHeaderDocument_ID=@BusinessHeaderDocument_ID,
					SignatoryConsignorAuthentication_Signatory=@SignatoryConsignorAuthentication_Signatory,
					SignatoryCarrierAuthentication_ActualDateTime =@SignatoryCarrierAuthentication_ActualDateTime ,
					SignatoryCarrierAuthentication_Signatory=@SignatoryCarrierAuthentication_Signatory,
					IssueAuthenticationLocation_Name=@IssueAuthenticationLocation_Name,
					MasterConsignment_IncludedTareGrossWeightMeasure_UnitCode=@MasterConsignment_IncludedTareGrossWeightMeasure_UnitCode,
					MasterConsignment_IncludedTareGrossWeightMeasure_Value=@MasterConsignment_IncludedTareGrossWeightMeasure_Value,
					MasterConsignment_TotalPieceQuantity=@MasterConsignment_TotalPieceQuantity,
					MasterConsignment_TransportContractDocument_ID=@MasterConsignment_TransportContractDocument_ID,
					MasterConsignment_OriginLocation_ID=@MasterConsignment_OriginLocation_ID,
					MasterConsignment_OriginLocation_Name=@MasterConsignment_OriginLocation_Name,
					MasterConsignment_FinalDestinationLocation_ID=@MasterConsignment_FinalDestinationLocation_ID,
					MasterConsignment_FinalDestinationLocation_Name=@MasterConsignment_FinalDestinationLocation_Name,
					MasterConsignment_NilCarriageValueIndicator=@MasterConsignment_NilCarriageValueIndicator,
					MasterConsignment_NilCustomsValueIndicator=@MasterConsignment_NilCustomsValueIndicator,
					MasterConsignment_NilInsuranceValueIndicator=@MasterConsignment_NilInsuranceValueIndicator,
					MasterConsignment_TotalChargePrepaidIndicator=@MasterConsignment_TotalChargePrepaidIndicator,
					MasterConsignment_WeightTotalChargeAmount_currencyID=@MasterConsignment_WeightTotalChargeAmount_currencyID,
					MasterConsignment_WeightTotalChargeAmount_Value=@MasterConsignment_WeightTotalChargeAmount_Value,
					MasterConsignment_TotalDisbursementPrepaidIndicator=@MasterConsignment_TotalDisbursementPrepaidIndicator,
					MasterConsignment_AgentTotalDisbursementAmount_currencyID=@MasterConsignment_AgentTotalDisbursementAmount_currencyID,
					MasterConsignment_AgentTotalDisbursementAmount_Value=@MasterConsignment_AgentTotalDisbursementAmount_Value,
					MasterConsignment_CarrierTotalDisbursementAmount_currencyID=@MasterConsignment_CarrierTotalDisbursementAmount_currencyID,
					MasterConsignment_CarrierTotalDisbursementAmount_Value =@MasterConsignment_CarrierTotalDisbursementAmount_Value ,
					MasterConsignment_TotalPrepaidChargeAmount_currencyID=@MasterConsignment_TotalPrepaidChargeAmount_currencyID,
					MasterConsignment_TotalPrepaidChargeAmount_Value=@MasterConsignment_TotalPrepaidChargeAmount_Value,
					MasterConsignment_TotalCollectChargeAmount_currencyID=@MasterConsignment_TotalCollectChargeAmount_currencyID,
					MasterConsignment_TotalCollectChargeAmount_Value=@MasterConsignment_TotalCollectChargeAmount_Value,
					MasterConsignment_GrossVolumeMeasure_UnitCode=@MasterConsignment_GrossVolumeMeasure_UnitCode,
					MasterConsignment_GrossVolumeMeasure_Value=@MasterConsignment_GrossVolumeMeasure_Value,
					MasterConsignment_IncludedHouseConsignment_IncludedTareGrossWeightMeasure_UnitCode = @MasterConsignment_IncludedHouseConsignment_IncludedTareGrossWeightMeasure_UnitCode,
					MasterConsignment_IncludedHouseConsignment_IncludedTareGrossWeightMeasure_Value=@MasterConsignment_IncludedHouseConsignment_IncludedTareGrossWeightMeasure_Value,
					MasterConsignment_IncludedHouseConsignment_TotalPieceQuantity=@MasterConsignment_IncludedHouseConsignment_TotalPieceQuantity,
					SummaryDescription=@SummaryDescription,
					ConsignorParty_Name=@ConsignorParty_Name,
					ConsignorParty_AccountID=@ConsignorParty_AccountID,
					ConsignorParty_PostcodeCode=@ConsignorParty_PostcodeCode,
					ConsignorParty_StreetName=@ConsignorParty_StreetName,
					ConsignorParty_CityName=@ConsignorParty_CityName,
					ConsignorParty_CountryID=@ConsignorParty_CountryID,
					ConsigneeParty_Name=@ConsigneeParty_Name,
					ConsigneeParty_AccountID=@ConsigneeParty_AccountID,
					ConsigneeParty_PostcodeCode=@ConsigneeParty_PostcodeCode,
					ConsigneeParty_StreetName=@ConsigneeParty_StreetName,
					ConsigneeParty_CityName=@ConsigneeParty_CityName,
					ConsigneeParty_CountryID=@ConsigneeParty_CountryID,
					FreightForwarderParty_Name=@FreightForwarderParty_Name,
					FreightForwarderParty_AccountID=@FreightForwarderParty_AccountID,
					FreightForwarderParty_PostcodeCode=@FreightForwarderParty_PostcodeCode,
					FreightForwarderParty_StreetName=@FreightForwarderParty_StreetName,
					FreightForwarderParty_CityName=@FreightForwarderParty_CityName,
					FreightForwarderParty_CountryID=@FreightForwarderParty_CountryID,
					SpecifiedLogisticsTransportMovement_StageCode=@SpecifiedLogisticsTransportMovement_StageCode,
					SpecifiedLogisticsTransportMovement_ModeCode=@SpecifiedLogisticsTransportMovement_ModeCode,
					SpecifiedLogisticsTransportMovement_Mode=@SpecifiedLogisticsTransportMovement_Mode,
					SpecifiedLogisticsTransportMovement_ID=@SpecifiedLogisticsTransportMovement_ID,
					SpecifiedLogisticsTransportMovement_SequenceNumeric=@SpecifiedLogisticsTransportMovement_SequenceNumeric,
					UsedLogisticsTransportMeans_Name=@UsedLogisticsTransportMeans_Name,
					ArrivalEvent_ScheduledOccurrenceDateTime=@ArrivalEvent_ScheduledOccurrenceDateTime,
					ArrivalEvent_TypeCode=@ArrivalEvent_TypeCode,
					ArrivalEvent_OriginLocation_ID = @ArrivalEvent_OriginLocation_ID,
					ArrivalEvent_OriginLocation_Name = @ArrivalEvent_OriginLocation_Name,
					DepartureEvent_ScheduledOccurrenceDateTime=@DepartureEvent_ScheduledOccurrenceDateTime,
					DepartureEvent_TypeCode=@DepartureEvent_TypeCode,
					DepartureEvent_FinalDestinationLocation_ID=@DepartureEvent_FinalDestinationLocation_ID ,
					DepartureEvent_FinalDestinationLocation_Name=@DepartureEvent_FinalDestinationLocation_Name,
					HandlingSPHInstructions=@HandlingSPHInstructions,
					IncludedHouseConsignmentItem_SequenceNumeric=@IncludedHouseConsignmentItem_SequenceNumeric,
					IncludedHouseConsignmentItem_TypeCode=@IncludedHouseConsignmentItem_TypeCode,
					IncludedHouseConsignmentItem_GrossWeightMeasure_UnitCode=@IncludedHouseConsignmentItem_GrossWeightMeasure_UnitCode,
					IncludedHouseConsignmentItem_GrossWeightMeasure_Value=@IncludedHouseConsignmentItem_GrossWeightMeasure_Value,
					IncludedHouseConsignmentItem_GrossVolumeMeasure_UnitCode=@IncludedHouseConsignmentItem_GrossVolumeMeasure_UnitCode,
					IncludedHouseConsignmentItem_GrossVolumeMeasure_Value=@IncludedHouseConsignmentItem_GrossVolumeMeasure_Value,
					IncludedHouseConsignmentItem_PieceQuantity=@IncludedHouseConsignmentItem_PieceQuantity,
					NatureIdentificationTransportCargo_Information=@NatureIdentificationTransportCargo_Information,
					ApplicableFreightRateServiceCharge_ChargeableWeightMeasure_UnitCode=@ApplicableFreightRateServiceCharge_ChargeableWeightMeasure_UnitCode,
					ApplicableFreightRateServiceCharge_ChargeableWeightMeasure_Value=@ApplicableFreightRateServiceCharge_ChargeableWeightMeasure_Value,
					cd_usuario=@cd_usuario,
					cd_pes_grupo=@cd_pes_grupo,
					Notes=@Notes
				Where
					Num_proc = @Num_Proc				
			
			End
		Else
			BEGIN
				Insert ATL_INT.dbo.Iata_HouseWaybill
				(
					MessageHeaderDocument_ID,MessageHeaderDocument_Name,MessageHeaderDocument_TypeCode,MessageHeaderDocument_PurposeCode,MessageHeaderDocument_VersionID,
					MessageHeaderDocument_SenderParty_schemeID,MessageHeaderDocument_SenderParty_Value,MessageHeaderDocument_RecipientParty_schemeID,MessageHeaderDocument_RecipientParty_Value,
					BusinessHeaderDocument_ID,SignatoryConsignorAuthentication_Signatory,SignatoryCarrierAuthentication_ActualDateTime ,SignatoryCarrierAuthentication_Signatory,IssueAuthenticationLocation_Name,
					MasterConsignment_IncludedTareGrossWeightMeasure_UnitCode,MasterConsignment_IncludedTareGrossWeightMeasure_Value,MasterConsignment_TotalPieceQuantity,MasterConsignment_TransportContractDocument_ID,
					MasterConsignment_OriginLocation_ID,MasterConsignment_OriginLocation_Name,MasterConsignment_FinalDestinationLocation_ID,MasterConsignment_FinalDestinationLocation_Name,MasterConsignment_NilCarriageValueIndicator,
					MasterConsignment_NilCustomsValueIndicator,MasterConsignment_NilInsuranceValueIndicator,MasterConsignment_TotalChargePrepaidIndicator,MasterConsignment_WeightTotalChargeAmount_currencyID,
					MasterConsignment_WeightTotalChargeAmount_Value,MasterConsignment_TotalDisbursementPrepaidIndicator,MasterConsignment_AgentTotalDisbursementAmount_currencyID,MasterConsignment_AgentTotalDisbursementAmount_Value,
					MasterConsignment_CarrierTotalDisbursementAmount_currencyID,MasterConsignment_CarrierTotalDisbursementAmount_Value,MasterConsignment_TotalPrepaidChargeAmount_currencyID,MasterConsignment_TotalPrepaidChargeAmount_Value,
					MasterConsignment_TotalCollectChargeAmount_currencyID,MasterConsignment_TotalCollectChargeAmount_Value,MasterConsignment_GrossVolumeMeasure_UnitCode,MasterConsignment_GrossVolumeMeasure_Value,					
					MasterConsignment_IncludedHouseConsignment_IncludedTareGrossWeightMeasure_UnitCode,MasterConsignment_IncludedHouseConsignment_IncludedTareGrossWeightMeasure_Value,MasterConsignment_IncludedHouseConsignment_TotalPieceQuantity,					
					SummaryDescription,
					ConsignorParty_Name,ConsignorParty_AccountID,ConsignorParty_PostcodeCode,ConsignorParty_StreetName,	ConsignorParty_CityName,ConsignorParty_CountryID,ConsigneeParty_Name,ConsigneeParty_AccountID,
					ConsigneeParty_PostcodeCode,ConsigneeParty_StreetName,ConsigneeParty_CityName,ConsigneeParty_CountryID,FreightForwarderParty_Name,FreightForwarderParty_AccountID,FreightForwarderParty_PostcodeCode,
					FreightForwarderParty_StreetName,FreightForwarderParty_CityName,FreightForwarderParty_CountryID,SpecifiedLogisticsTransportMovement_StageCode,SpecifiedLogisticsTransportMovement_ModeCode,
					SpecifiedLogisticsTransportMovement_Mode,SpecifiedLogisticsTransportMovement_ID,SpecifiedLogisticsTransportMovement_SequenceNumeric,UsedLogisticsTransportMeans_Name,
					ArrivalEvent_ScheduledOccurrenceDateTime,ArrivalEvent_TypeCode,ArrivalEvent_OriginLocation_ID,ArrivalEvent_OriginLocation_Name,
					DepartureEvent_ScheduledOccurrenceDateTime,DepartureEvent_TypeCode,DepartureEvent_FinalDestinationLocation_ID,DepartureEvent_FinalDestinationLocation_Name,	
					HandlingSPHInstructions,IncludedHouseConsignmentItem_SequenceNumeric,IncludedHouseConsignmentItem_TypeCode,
					IncludedHouseConsignmentItem_GrossWeightMeasure_UnitCode,IncludedHouseConsignmentItem_GrossWeightMeasure_Value,
					IncludedHouseConsignmentItem_GrossVolumeMeasure_UnitCode,IncludedHouseConsignmentItem_GrossVolumeMeasure_Value,
					IncludedHouseConsignmentItem_PieceQuantity,NatureIdentificationTransportCargo_Information,
					ApplicableFreightRateServiceCharge_ChargeableWeightMeasure_UnitCode,ApplicableFreightRateServiceCharge_ChargeableWeightMeasure_Value,
					cd_usuario,cd_pes_grupo,Notes,Num_Proc,
					MessageHeaderDocument_IssueDateTime
				)
				Values
				(
					@MessageHeaderDocument_ID,@MessageHeaderDocument_Name,@MessageHeaderDocument_TypeCode,@MessageHeaderDocument_PurposeCode,@MessageHeaderDocument_VersionID,
					@MessageHeaderDocument_SenderParty_schemeID,@MessageHeaderDocument_SenderParty_Value,@MessageHeaderDocument_RecipientParty_schemeID,@MessageHeaderDocument_RecipientParty_Value,
					@BusinessHeaderDocument_ID,@SignatoryConsignorAuthentication_Signatory,@SignatoryCarrierAuthentication_ActualDateTime ,@SignatoryCarrierAuthentication_Signatory,@IssueAuthenticationLocation_Name,
					@MasterConsignment_IncludedTareGrossWeightMeasure_UnitCode,@MasterConsignment_IncludedTareGrossWeightMeasure_Value,@MasterConsignment_TotalPieceQuantity,@MasterConsignment_TransportContractDocument_ID,
					@MasterConsignment_OriginLocation_ID,@MasterConsignment_OriginLocation_Name,@MasterConsignment_FinalDestinationLocation_ID,@MasterConsignment_FinalDestinationLocation_Name,@MasterConsignment_NilCarriageValueIndicator,
					@MasterConsignment_NilCustomsValueIndicator,@MasterConsignment_NilInsuranceValueIndicator,@MasterConsignment_TotalChargePrepaidIndicator,@MasterConsignment_WeightTotalChargeAmount_currencyID,
					@MasterConsignment_WeightTotalChargeAmount_Value,@MasterConsignment_TotalDisbursementPrepaidIndicator,@MasterConsignment_AgentTotalDisbursementAmount_currencyID,@MasterConsignment_AgentTotalDisbursementAmount_Value,
					@MasterConsignment_CarrierTotalDisbursementAmount_currencyID,@MasterConsignment_CarrierTotalDisbursementAmount_Value,@MasterConsignment_TotalPrepaidChargeAmount_currencyID,@MasterConsignment_TotalPrepaidChargeAmount_Value,
					@MasterConsignment_TotalCollectChargeAmount_currencyID,@MasterConsignment_TotalCollectChargeAmount_Value,@MasterConsignment_GrossVolumeMeasure_UnitCode,@MasterConsignment_GrossVolumeMeasure_Value,
					@MasterConsignment_IncludedHouseConsignment_IncludedTareGrossWeightMeasure_UnitCode,@MasterConsignment_IncludedHouseConsignment_IncludedTareGrossWeightMeasure_Value,@MasterConsignment_IncludedHouseConsignment_TotalPieceQuantity,
					@SummaryDescription,
					@ConsignorParty_Name,@ConsignorParty_AccountID,@ConsignorParty_PostcodeCode,@ConsignorParty_StreetName,@ConsignorParty_CityName,@ConsignorParty_CountryID,@ConsigneeParty_Name,@ConsigneeParty_AccountID,
					@ConsigneeParty_PostcodeCode,@ConsigneeParty_StreetName,@ConsigneeParty_CityName,@ConsigneeParty_CountryID,@FreightForwarderParty_Name,@FreightForwarderParty_AccountID,@FreightForwarderParty_PostcodeCode,
					@FreightForwarderParty_StreetName,@FreightForwarderParty_CityName,@FreightForwarderParty_CountryID,@SpecifiedLogisticsTransportMovement_StageCode,@SpecifiedLogisticsTransportMovement_ModeCode,
					@SpecifiedLogisticsTransportMovement_Mode,@SpecifiedLogisticsTransportMovement_ID,@SpecifiedLogisticsTransportMovement_SequenceNumeric,@UsedLogisticsTransportMeans_Name,
					@ArrivalEvent_ScheduledOccurrenceDateTime,@ArrivalEvent_TypeCode,@ArrivalEvent_OriginLocation_ID,@ArrivalEvent_OriginLocation_Name,
					@DepartureEvent_ScheduledOccurrenceDateTime,@DepartureEvent_TypeCode,@DepartureEvent_FinalDestinationLocation_ID,@DepartureEvent_FinalDestinationLocation_Name,						
					@HandlingSPHInstructions,@IncludedHouseConsignmentItem_SequenceNumeric,@IncludedHouseConsignmentItem_TypeCode,
					@IncludedHouseConsignmentItem_GrossWeightMeasure_UnitCode,@IncludedHouseConsignmentItem_GrossWeightMeasure_Value,
					@IncludedHouseConsignmentItem_GrossVolumeMeasure_UnitCode,@IncludedHouseConsignmentItem_GrossVolumeMeasure_Value,
					@IncludedHouseConsignmentItem_PieceQuantity,@NatureIdentificationTransportCargo_Information,
					@ApplicableFreightRateServiceCharge_ChargeableWeightMeasure_UnitCode,@ApplicableFreightRateServiceCharge_ChargeableWeightMeasure_Value,
					@cd_usuario,@cd_pes_grupo,@Notes,@Num_Proc,
					@MessageHeaderDocument_IssueDateTime
				)
				set @ID_New = @@IDENTITY;
			END	

		Select @ID_New as Retorno;
		
		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	

END

GO
