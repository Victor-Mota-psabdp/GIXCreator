SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help GTNEXUS_XML
--sp_help E_MIX_XML

--select * from GTNEXUS_XML where dt_ins> getdate() -1
CREATE Procedure [dbo].[spATL_GTNEXUS_XML_InsUpd]
(
	@ID_Smart			bigint,	
	@Id_GTNexus			bigint,
	@Num_Proc			Varchar(16),	
	@Type				Varchar(2),		
	--@XML_DOC2			XML,
	@XML_DOC			nvarchar(MAX),
	@Nome_Arquivo		Varchar(100),
	@Dt_Ins				Datetime,
	@Dt_Envio			Datetime
)

AS
BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help GTNEXUS_XML


/*
declare @Xml xml
declare @DataSheetXML NVARCHAR(max)
set @DataSheetXML = N'<?xml version="1.0" encoding="utf-8"?><q1:HouseManifest xmlns:q1="iata:housemanifest:1"><q1:MessageHeaderDocument><ID xmlns="iata:datamodel:3">1805831854_02085326382</ID><Name xmlns="iata:datamodel:3">House Manifest</Name><TypeCode xmlns="iata:datamodel:3">785</TypeCode><IssueDateTime xmlns="iata:datamodel:3">2021-12-02T13:46:27.9157068-03:00</IssueDateTime><PurposeCode xmlns="iata:datamodel:3">Creation</PurposeCode><VersionID xmlns="iata:datamodel:3">2.00</VersionID><SenderParty xmlns="iata:datamodel:3"><PrimaryID schemeID="C">RUSAGT82BDPI/ATL01</PrimaryID></SenderParty><SenderParty xmlns="iata:datamodel:3"><PrimaryID schemeID="O">01</PrimaryID></SenderParty><RecipientParty xmlns="iata:datamodel:3"><PrimaryID schemeID="C">DSGUNXA</PrimaryID></RecipientParty></q1:MessageHeaderDocument><q1:BusinessHeaderDocument><ID xmlns="iata:datamodel:3">1805831854</ID></q1:BusinessHeaderDocument><q1:MasterConsignment><IncludedTareGrossWeightMeasure unitCode="KGM" xmlns="iata:datamodel:3">31.1</IncludedTareGrossWeightMeasure><TotalPieceQuantity xmlns="iata:datamodel:3">1</TotalPieceQuantity><TransportContractDocument xmlns="iata:datamodel:3"><ID>02085326382</ID></TransportContractDocument><OriginLocation xmlns="iata:datamodel:3"><ID>FRA</ID><Name>FRANKFURT</Name></OriginLocation><FinalDestinationLocation xmlns="iata:datamodel:3"><ID>VCP</ID><Name>VIRACOPOS</Name></FinalDestinationLocation><IncludedCustomsNote xmlns="iata:datamodel:3"><ContentCode>DI</ContentCode><Content>NON-IATA</Content><SubjectCode>WBI</SubjectCode><CountryID>BR</CountryID></IncludedCustomsNote><IncludedCustomsNote xmlns="iata:datamodel:3"><ContentCode></ContentCode><Content>CARRIERDECLARATIONDATE20211130</Content><SubjectCode>WBI</SubjectCode><CountryID>BR</CountryID></IncludedCustomsNote><IncludedHouseConsignment xmlns="iata:datamodel:3"><SequenceNumeric>1</SequenceNumeric><GrossWeightMeasure unitCode="KGM">31.1</GrossWeightMeasure><TotalPieceQuantity>1</TotalPieceQuantity><SummaryDescription><![CDATA[FREIGHT PREPAID Ref No. 389021  TOP URGENT CARGO  TERMS: CPT VIRACOPOS 2111-150603/YNZ]]></SummaryDescription><TransportContractDocument><ID>1805831854</ID></TransportContractDocument><OriginLocation><ID>FRA</ID><Name>FRANKFURT</Name></OriginLocation><FinalDestinationLocation><ID>VCP</ID><Name>VIRACOPOS</Name></FinalDestinationLocation><HandlingSSRInstructions><Description><![CDATA[***SPX BY KC *** By DE/RA/00276-01  PLEASE IMMEDIATE INFORM CONSIGNEE UPON ARIVAL  MARKED: ADDRESS AND LABELS  EAP]]></Description></HandlingSSRInstructions><IncludedCustomsNote><ContentCode></ContentCode><Content>CARRIERDECLARATIONDATE20211130</Content><SubjectCode>WBI</SubjectCode><CountryID>BR</CountryID></IncludedCustomsNote></IncludedHouseConsignment></q1:MasterConsignment></q1:HouseManifest>'
set @Xml= CONVERT(XML,CONVERT(VARCHAR(MAX),@DataSheetXML))
*/
	BEGIN TRY

		BEGIN TRANSACTION;
	
		Declare @ID_New as bigint;
		
		IF @ID_Smart IS NULL
				BEGIN
				Insert GTNEXUS_XML 
				(
					Id_GTNexus,Num_Proc,Type,XML_DOC,Nome_Arquivo,Dt_Ins
				)
				Values
				(
					@Id_GTNexus,@Num_Proc,@Type,@XML_DOC,@Nome_Arquivo,getdate()
				)	
				set @ID_New = @@IDENTITY;			
			END	
		ELSE
			BEGIN
				Update
					GTNEXUS_XML
				set					
					Dt_Envio = @Dt_Envio
				where 
					ID_Smart = @ID_Smart and 
					Num_Proc = @Num_Proc
				set @ID_New = @ID_Smart
			End	
		
		Select @ID_New as Retorno;		
		
		COMMIT TRANSACTION;
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION
		SELECT ERROR_MESSAGE() as Retorno;
	END CATCH	

END

GO
