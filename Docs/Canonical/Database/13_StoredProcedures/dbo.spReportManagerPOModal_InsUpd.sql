SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spReportManagerPOModal_InsUpd]
	
		@BDPRef						Varchar(16),
		@EntryNumber				Varchar(80),
		@Invoice					Varchar(80),
		@NFNumber					Varchar(180),
		@PONumber					Varchar(80),
		@SalesOrder					Varchar(80),
		@CustomsTransmissionDate	Datetime,
		@NFDate						Datetime,
		@OrderDate					Datetime,
		@ImportLicense				Varchar(80),
		@LIDate						Datetime,
		@ArtecNumber				Varchar(80)
	
AS

Begin
	if not exists(select * from dados_por_produto where [BDP REF.]=@BDPREF)
		Begin
			INSERT INTO dados_por_produto
				(
				[BDP REF.],[Entry Number],[Invoice],[NF Number],[PO Number],[Sales Order],[Customs Transmission Date],
				[NF Date],[Order Date],[Import License],[LI Date],[Artec Number]
				)
			VALUES
				(
				@BDPREF,@EntryNumber,@Invoice,@NFNumber,@PONumber,@SalesOrder,@CustomsTransmissionDate,
				@NFDate,@OrderDate,@ImportLicense,@LIDate,@ArtecNumber				
				)
		End
	ELSE
		BEGIN
			UPDATE 
				DADOS_POR_PRODUTO
			SET
				[Entry Number=@EntryNumber,
				[Invoice]=@Invoice,
				[NF Number]=@NFNumber,
				[PO Number]=@PONumber,
				[Sales Order]=@SalesOrder,
				[Customs Transmission Date]=@CustomsTransmissionDate,
				[NF Date]=@NFDate,
				[Order Date]=@OrderDate,
				[Import License]=@ImportLicense,
				[LI Date]=@LIDate,
				[Artec Number]=@ArtecNumber
			WHERE
				[BDP REF.]=@BDPREF
		END
END


		

	





GO
