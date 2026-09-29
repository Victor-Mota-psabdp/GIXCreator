SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure spReportManagerHist_InsUpd
		@BDPRef						Varchar(16),
		@CustomsClearanceDate		Datetime,
		@GoodReceiptDateActual		Datetime,
		@GoodReceiptDateEstimated	Datetime,
		@PlantExitDateActual		Datetime,
		@PlantExitDateEstimated		Datetime,
		@PortEntryDate				Datetime,
		@TransportDocDeliveryDate	Datetime,
		@UnloadedDate				Datetime,
		@PREDIDate					Datetime,
		@RemocaoDate				Datetime,
		@DocstoBDPBillingDate		Datetime

AS
BEGIN
	IF NOT EXISTS(SELECT * FROM DADOS_POR_PRODUTO WHERE [BDP REF.]=@BDPREF)
		BEGIN
			INSERT INTO
					DADOS_POR_PRODUTO
				(
					[BDP REF.],[Customs Clearance Date],[Good Receipt Date - Estimated],[Good Receipt Date - Estimated],
					[Plant Exit Date - Actual],[Plant Exit Date - Estimated],[Port Entry Date],[Transport. Doc Delivery Date],
					[Transport. Doc Delivery Date],[Unloaded Date], [PRE DI Date],[Remocao Date],[Docs to BDP Billing Date]				
				)
			VALUES
				(
					@BDPREF,@CustomsClearanceDate,@GoodReceiptDateEstimated,@GoodReceiptDateEstimated,
					@PlantExitDateActual,@PlantExitDateEstimated,@PortEntryDate,@TransportDocDeliveryDate,
					@TransportDocDeliveryDate,@UnloadedDate,@PREDIDate,@RemocaoDate,@DocstoBDPBillingDate				
				)
				
		END
	ELSE
		BEGIN
			UPDATE 
				DADOS_POR_PRODUTO
					SET
						[Customs Clearance Date]=@CustomsClearanceDate,
						[Good Receipt Date - Actual]=@GoodReceiptDateActual,
						[Good Receipt Date - Estimated]=@GoodReceiptDateEstimated,
						[Plant Exit Date - Actual]=@PlantExitDateActual,
						[Plant Exit Date - Estimated]=@PlantExitDateEstimated,
						[Port Entry Date]=@PortEntryDate,
						[Transport. Doc Delivery Date]=@TransportDocDeliveryDate,
						[Unloaded Date]=@UnloadedDate,
						[PRE DI Date]=@PREDIDate,
						[Remocao Date]=@RemocaoDate,
						[Docs to BDP Billing Date]=@DocstoBDPBillingDate
				WHERE
					[BDP REF.]=@BDPREF

		END
END




GO
