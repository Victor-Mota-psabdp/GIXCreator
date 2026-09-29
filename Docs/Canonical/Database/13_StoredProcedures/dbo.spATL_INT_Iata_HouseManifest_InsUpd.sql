SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_INT_Iata_HouseManifest_InsUpd]
(
	@ID							BigInt,
	@Num_Proc					varchar(16),
	@MessageHeaderDocument_ID	varchar(200),
	@MessageHeaderDocument_Name	varchar(200),
	@MessageHeaderDocument_TypeCode	varchar(200),
	@MessageHeaderDocument_IssueDateTime	varchar(200),
	@MessageHeaderDocument_PurposeCode	varchar(200),
	@MessageHeaderDocument_VersionID	varchar(200),
	@MessageHeaderDocument_SenderParty_schemeID_0	varchar(200),
	@MessageHeaderDocument_SenderParty_Value_0	varchar(200),
	@MessageHeaderDocument_SenderParty_schemeID_1	varchar(200),
	@MessageHeaderDocument_SenderParty_Value_1	varchar(200),
	@MessageHeaderDocument_RecipientParty_schemeID	varchar(200),
	@MessageHeaderDocument_RecipientParty_Value	varchar(200),
	@BusinessHeaderDocument_ID	varchar(200),
	@MasterConsignment_IncludedTareGrossWeightMeasure_UnitCode	varchar(200),
	@MasterConsignment_IncludedTareGrossWeightMeasure_Value	varchar(200),
	@MasterConsignment_TotalPieceQuantity	varchar(200),
	@MasterConsignment_TransportContractDocument_ID	varchar(200),
	@MasterConsignment_OriginLocation_ID	varchar(200),
	@MasterConsignment_OriginLocation_Name	varchar(200),
	@MasterConsignment_FinalDestinationLocation_ID	varchar(200),
	@MasterConsignment_FinalDestinationLocation_Name	varchar(200),
	@IncludedHouseConsignment_SequenceNumeric	varchar(200),
	@SummaryDescription	varchar(200),
	@HandlingSPHInstructions	varchar(200),
	@cd_usuario varchar(6),
	@cd_pes_grupo varchar(10),
	@Notes  varchar(MAX)
)

AS

BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Iata_HouseManifest
	BEGIN TRY
		Declare @ID_New as bigint;
		set @ID_New = (select ID from ATL_INT.dbo.Iata_HouseManifest where Num_proc = @Num_Proc)

		IF exists(select ID from ATL_INT.dbo.Iata_HouseManifest where Num_proc = @Num_Proc)
			Begin
				Update
					ATL_INT.dbo.Iata_HouseManifest
				Set
					MessageHeaderDocument_ID=@MessageHeaderDocument_ID,
					MessageHeaderDocument_Name=@MessageHeaderDocument_Name,
					MessageHeaderDocument_TypeCode=@MessageHeaderDocument_TypeCode,
					MessageHeaderDocument_IssueDateTime = @MessageHeaderDocument_IssueDateTime,
					MessageHeaderDocument_PurposeCode=@MessageHeaderDocument_PurposeCode,
					MessageHeaderDocument_VersionID=@MessageHeaderDocument_VersionID,
					MessageHeaderDocument_SenderParty_schemeID_0=@MessageHeaderDocument_SenderParty_schemeID_0,
					MessageHeaderDocument_SenderParty_Value_0=@MessageHeaderDocument_SenderParty_Value_0,
					MessageHeaderDocument_SenderParty_schemeID_1=@MessageHeaderDocument_SenderParty_schemeID_1,
					MessageHeaderDocument_SenderParty_Value_1=@MessageHeaderDocument_SenderParty_Value_1,
					MessageHeaderDocument_RecipientParty_schemeID=@MessageHeaderDocument_RecipientParty_schemeID,
					MessageHeaderDocument_RecipientParty_Value=@MessageHeaderDocument_RecipientParty_Value,
					BusinessHeaderDocument_ID=@BusinessHeaderDocument_ID,
					MasterConsignment_IncludedTareGrossWeightMeasure_UnitCode=@MasterConsignment_IncludedTareGrossWeightMeasure_UnitCode,
					MasterConsignment_IncludedTareGrossWeightMeasure_Value=@MasterConsignment_IncludedTareGrossWeightMeasure_Value,
					MasterConsignment_TotalPieceQuantity=@MasterConsignment_TotalPieceQuantity,
					MasterConsignment_TransportContractDocument_ID=@MasterConsignment_TransportContractDocument_ID,
					MasterConsignment_OriginLocation_ID=@MasterConsignment_OriginLocation_ID,
					MasterConsignment_OriginLocation_Name=@MasterConsignment_OriginLocation_Name,
					MasterConsignment_FinalDestinationLocation_ID=@MasterConsignment_FinalDestinationLocation_ID,
					MasterConsignment_FinalDestinationLocation_Name=@MasterConsignment_FinalDestinationLocation_Name,
					IncludedHouseConsignment_SequenceNumeric=@IncludedHouseConsignment_SequenceNumeric,
					SummaryDescription=@SummaryDescription,
					HandlingSPHInstructions=@HandlingSPHInstructions,
					cd_usuario=@cd_usuario,
					cd_pes_grupo=@cd_pes_grupo,
					Notes=@Notes
				Where
					Num_proc = @Num_Proc			
			End
		Else
			BEGIN
				Insert ATL_INT.dbo.Iata_HouseManifest
				(
					MessageHeaderDocument_ID,MessageHeaderDocument_Name,MessageHeaderDocument_TypeCode,MessageHeaderDocument_PurposeCode,
					MessageHeaderDocument_IssueDateTime,
					MessageHeaderDocument_VersionID,MessageHeaderDocument_SenderParty_schemeID_0,MessageHeaderDocument_SenderParty_Value_0,
					MessageHeaderDocument_SenderParty_schemeID_1,MessageHeaderDocument_SenderParty_Value_1,MessageHeaderDocument_RecipientParty_schemeID,
					MessageHeaderDocument_RecipientParty_Value,BusinessHeaderDocument_ID,MasterConsignment_IncludedTareGrossWeightMeasure_UnitCode,
					MasterConsignment_IncludedTareGrossWeightMeasure_Value,MasterConsignment_TotalPieceQuantity,MasterConsignment_TransportContractDocument_ID,
					MasterConsignment_OriginLocation_ID,MasterConsignment_OriginLocation_Name,MasterConsignment_FinalDestinationLocation_ID,
					MasterConsignment_FinalDestinationLocation_Name,IncludedHouseConsignment_SequenceNumeric,SummaryDescription,HandlingSPHInstructions,
					cd_usuario,cd_pes_grupo,Notes,Num_Proc
				)
				Values
				(
					@MessageHeaderDocument_ID,@MessageHeaderDocument_Name,@MessageHeaderDocument_TypeCode,@MessageHeaderDocument_PurposeCode,
					@MessageHeaderDocument_IssueDateTime,
					@MessageHeaderDocument_VersionID,@MessageHeaderDocument_SenderParty_schemeID_0,@MessageHeaderDocument_SenderParty_Value_0,
					@MessageHeaderDocument_SenderParty_schemeID_1,@MessageHeaderDocument_SenderParty_Value_1,@MessageHeaderDocument_RecipientParty_schemeID,
					@MessageHeaderDocument_RecipientParty_Value,@BusinessHeaderDocument_ID,@MasterConsignment_IncludedTareGrossWeightMeasure_UnitCode,
					@MasterConsignment_IncludedTareGrossWeightMeasure_Value,@MasterConsignment_TotalPieceQuantity,@MasterConsignment_TransportContractDocument_ID,
					@MasterConsignment_OriginLocation_ID,@MasterConsignment_OriginLocation_Name,@MasterConsignment_FinalDestinationLocation_ID,
					@MasterConsignment_FinalDestinationLocation_Name,@IncludedHouseConsignment_SequenceNumeric,@SummaryDescription,@HandlingSPHInstructions,
					@cd_usuario,@cd_pes_grupo,@Notes,@Num_Proc
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
