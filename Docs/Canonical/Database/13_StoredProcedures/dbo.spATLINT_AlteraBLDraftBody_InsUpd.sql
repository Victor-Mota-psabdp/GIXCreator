SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   procedure [dbo].[spATLINT_AlteraBLDraftBody_InsUpd]

	@ID_ADBB                        [bigint],
	@HblNo                          [varchar](200) NULL,
	@ShipperExporter                [varchar](200) NULL,
	@Consignee                      [varchar](200) NULL,
	@NotifyParty                    [varchar](200) NULL,
	@ExportReferencesFatura         [varchar](200) NULL,
	@ExportreferencesBooking        [varchar](200) NULL,
	@ForwardingAgentReferences      [varchar](200) NULL,
	@PlaceOfReceipt                 [varchar](200) NULL,
	@Vessel                         [varchar](200) NULL,
	@Voyage                         [varchar](200) NULL,
	@PortOfLoading                  [varchar](200) NULL,
	@PierTerminal                   [varchar](200) NULL,
	@PortOfDischarge                [varchar](200) NULL,
	@ForTransShipmentTo             [varchar](200) NULL,
	@PalceOfDelivery                [varchar](200) NULL,
	@EmissaoBl                      [varchar](200) NULL,
	@FreteBl                        [varchar](200) NULL,
	@Bl                             [varchar](200) NULL,
	@SystemCode                     [varchar](200) NULL,
	@Nome_Excel_Lido                [varchar](500) NULL,
	@Message		                [varchar](MAX) NULL,
	@dt_atualizacao_bl              [datetime] NULL

AS
BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help spATLINT_AlteraBLDraftBody_InsUpd 
	BEGIN TRY
		Declare @ID_New as bigint;
			
		IF exists(select ID_ADBB from ATL_INT.dbo.AlteraBLDraftBody where ID_ADBB = @ID_ADBB)
			Begin
				Update
					ATL_INT.dbo.AlteraBLDraftBody
				set 
					ForwardingAgentReferences = @ForwardingAgentReferences,
					dt_atualizacao_bl=@dt_atualizacao_bl,
					[Message] = @Message
				Where ID_ADBB = @ID_ADBB
		        set @ID_NEW = @ID_ADBB         
			End
		Else
			BEGIN
				
				SET @ID_New=(SELECT ISNULL(MAX(ID_ADBB),0)+1 FROM ATL_INT.dbo.AlteraBLDraftBody where ID_ADBB = @ID_ADBB) 
				
				Insert ATL_INT.dbo.AlteraBLDraftBody 
				(   
						HblNo,
						ShipperExporter,
						Consignee,
						NotifyParty,
						ExportReferencesFatura,
						ExportreferencesBooking,
						ForwardingAgentReferences,
						PlaceOfReceipt,
						Vessel,
						Voyage,
						PortOfLoading,
						PierTerminal,
						PortOfDischarge,
						ForTransShipmentTo,
						PalceOfDelivery,
						EmissaoBl,
						FreteBl,
						Bl,
						SystemCode,
						dt_atualizacao_bl,
						Nome_Excel_Lido,
						[Message]
   					)
				Values
				(
						@HblNo,
						@ShipperExporter,
						@Consignee,
						@NotifyParty,
						@ExportReferencesFatura,
						@ExportreferencesBooking,
						@ForwardingAgentReferences,
						@PlaceOfReceipt,
						@Vessel,
						@Voyage,
						@PortOfLoading,
						@PierTerminal,
						@PortOfDischarge,
						@ForTransShipmentTo,
						@PalceOfDelivery,
						@EmissaoBl,
						@FreteBl,
						@Bl,
						@SystemCode,
						null,
						@Nome_Excel_Lido,
						@Message
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
