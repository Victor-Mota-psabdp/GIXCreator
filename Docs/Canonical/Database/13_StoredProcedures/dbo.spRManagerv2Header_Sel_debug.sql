SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*    
spRManagerv2Header_Sel_debug 'IMSWB202003073BR'    
    
spRManagerv2Header_Sel 'IMATL201504116BR'    
*/    
--05,6,e,8/2/2015 incluido os tasks - Cadu    
--09/2/2015 - incluido o PO Number - Cadu    
--09/2/2015 - incluido o campo:    
--11/2/2015 - Incluido os campos: com o 8 e com AA e AB    
--11/2/2015 - Alterado o campo Liberação de BL    
--13/2/2015 - alterado o [Qtty of Units] pra pegar o total da quantidade     
--19/2/2015 - Incluido [Country Manufacturer]     
--23/02/2015 - Alterado o nome dos Campos Danfe Request e Receipt para Date -     
--17-06-2015 - Desabilitado o Manufacturer e Country of Manufacturer - incluido nos detalhes da PO - Cadu Ticket: 100-22655    
--desabilitado o campo: @CIFValue,o calculo será feito direto no RM -  CIF Value = FOB Value+Insurance Value+Freight Value - 27/11/2015 - Ticket: 100-37205    
--09/11/2016 - incluido as contas Total  Taxes Value by Shipment e Total Siscomex Value by Shipment    
--[dbo].[spRManagerv2Header_Sel] 'EASUN201610001BR'    
--spRManagerv2Header_Sel 'EOCSR201608001BR'    
--spRManagerv2Header_TESTE_Sel 'IAGVD201611004BR'    
--spRManagerv2Header_Sel 'IMAMZ201705002BR'    
--spRManagerv2Header_Sel 'EACSR201707010BR'    
--spRManagerv2Header_TaskTST_Sel 'IMAMZ201705002BR'    
--spRManagerv2Header_Sel 'BOCBT201811003BR'    
    
--incluido o if= BO and vwHouse_BDP_Out - 04-01-2019 cadu    
    
CREATE Procedure [dbo].[spRManagerv2Header_Sel_debug]--'EMRHO201702101BR'    
 @Num_Proc Varchar(16)    
as    
    
--declare @Num_Proc Varchar(16)    
--set @Num_Proc ='IACSR201903037BR'    
    
 declare @Task_Temp table(    
 ID_TP int,    
 Num_Proc varchar(16),    
 ID_Task int,    
 Dt_Conclusao datetime,    
 Dt_Previsao datetime,    
 Cd_Usuario varchar(15),    
 Dt_Insert datetime    
)    
insert @Task_Temp    
select ID_TP,Num_Proc,ID_Task,Dt_Conclusao,Dt_Previsao,Cd_Usuario,Dt_Insert     
 from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc     
    
declare @CampoProcesso_Temp table(    
 Num_Proc varchar(16),    
 Id_Campo int,    
 Campo_Dados varchar(500),    
 Dt_Ins datetime,    
 cd_usuario varchar(20)    
)    
    
insert @CampoProcesso_Temp    
select Num_Proc,Id_Campo,Campo_Dados,Dt_Ins,cd_usuario from Campo_processo with (nolock) where Num_Proc = @Num_Proc    
    
--declare @Num_Proc Varchar(16)    
--set @Num_Proc = 'IAHEX201610002BR'    
    
/*    
    
 Definição:    
 _ = ' - '    
 1 = Espaço    
 @ = 1    
 9 = _    
 8 = – traço grande    
 A0 = 1Espaço ( 1 )    
 A2 = 2Espaço ( 2 )    
 A3 = Aspas Simples (')    
 P0 = Percentual (%)    
 A4 = 1    
 A5 = ?    
 A6 = /    
 A7 = .    
 A8 = - traço    
*/    
    
--Declare @Num_Proc Varchar(16)    
--set @Num_Proc = 'IMUPL201501017BR'    
    
Declare @DataSyncro      Datetime  --Imports    
Declare @DemurrageHistoric    Varchar(500) --IM    
Declare @DemurragePeriod    Varchar(20)  --IM    
Declare @WarehousePeriod    Varchar(20)  --IM    
Declare @LiExpiredDate     Datetime  --Imports    
Declare @LIType       Varchar(30)  --Imports    
Declare @Usuario      Varchar(30)  --Account Manager informado no Grupo     
Declare @ICMSexonerationDate   Datetime  -- Task Manager Data de Exoneração de ICMS      
Declare @ICMSExonerationPDF    Varchar(3)  --Indicação se PDF foi anexado no sistema    
Declare @WarehousePaymentDate   Datetime  --Data de Pagamento da Armazenagem 08-11-2011    
Declare @ExchangeRatesValue    Varchar(15)  --Imports    
DEclare @DemurrageInvoiceNumber   Varchar(50)  --IM    
Declare @DemurrageInvoiceDate   Datetime  --IM    
Declare @AntiDumpingValuebyShipment  float    
Declare @AFRMMValuebyShipment   float   --IM    
Declare @ICMSPaymentDate    Datetime    
Declare @PDFRequerimento    VarChar(3)    
Declare @Forwarder      Varchar(30)  --Imports: Incluso para todos os Modais: 02/04/2013    
Declare @ShipperMaster     Varchar(30)    
Declare @FreightType     Varchar(30)    
Declare @WarehouseHistoric    Varchar(255) --IM    
Declare @InvoiceapprovalbycustomerDate datetime    
Declare @ExportRegisterReceiptDate  Datetime    
DEclare @TerminalmoverequestbyCustomerDate Datetime --IM    
Declare @PDFSolRedestinaçãoCliente  Varchar(3)  --IM    
Declare @BookingConfirmationDate  Datetime    
Declare @CustomsClearanceDate   Datetime    
Declare @GoodReceiptDateActual   Datetime    
Declare @GoodReceiptDateEstimated  Datetime    
Declare @PlantExitDateActual   Datetime    
Declare @PlantExitDateEstimated   Datetime    
Declare @DocSentDate     Datetime    
Declare @NFEDraftDate     Datetime    
Declare @BillofLadingBackDate   Datetime    
Declare @EnvioCHBFaturamentoDate  Datetime    
Declare @OrderReceivedDate     Datetime    
Declare @BDPInvoiceCreationDate    Datetime    
Declare @PositioningContainerRequireDate Datetime    
Declare @TerminalEntryDate   Datetime    
Declare @AverbacaoEXPDate   Datetime    
DEclare @WoodInspectionDate   Datetime    
Declare @DocSentBLBRDate   Datetime    
Declare @DocsToCambioDate   Datetime    
Declare @DocsToBDPBillingDate  Datetime    
Declare @AFRMMPaymentDate   Datetime    
Declare @EntryrequirementDate  Datetime    
Declare @DueDateSupplier   Datetime    
Declare @SurveyRequestDate   Datetime    
Declare @IMOApprovalDate   Datetime    
Declare @PDF_NF_omplementar   Varchar(3)    
Declare @ArrivalattheborderDate  Datetime    
Declare @AuthorizationCrossDate  Datetime    
Declare @PDFRemittance    VArchar(3)    
Declare @ETD1Original_Date   Datetime    
Declare @Withdrawalof1Samples_Date Datetime    
Declare @DANumber     Varchar(40)    
Declare @DA_Date     Datetime    
Declare @PDF_DA      Varchar(3)    
Declare @NFIssueValue    Varchar(40)    
Declare @Invoice1Currency   Varchar(3)    
Declare @Invoice1Currency1Val  Varchar(50)    
Declare @Invoice1Value    Varchar(40)    
DEclare @FinalDestination   Varchar(40)    
Declare @Notify      Varchar(50)    
Declare @Incoterm     Varchar(3)    
Declare @Consignee     Varchar(50)    
Declare @Shipper     Varchar(50)    
Declare @CNPJ      Varchar(20)    
Declare @ConsigneeAddress     Varchar(500)    
Declare @CityofConsignee     Varchar(25)    
Declare @Terminal       Varchar(50)    
--Declare @CIFValue       Varchar(40)    
Declare @BL1Payment1Date     datetime    
Declare @BDP1Invoice1Date     Datetime    
Declare @Process1Status      Varchar(40)    
Declare @PDF_Protocolo1Transporte   Varchar(3)    
Declare @Reason1Code1Events     Varchar(300)    
Declare @Drawback1Number     Varchar(30)    
Declare @Certified1Of1Origin1Number   Varchar(30)    
Declare @Products1by1Shipment    Varchar(500)    
Declare @Product1IDs1by1Shipment   Varchar(200)    
Declare @IPI1Value1by1Shipment    decimal(18,2)     
Declare @Cofins1Value1by1Shipment   decimal(18,2)    
Declare @PIS1Value1by1Shipment    decimal(18,2)    
Declare @Import1Duties1Value1by1Shipment decimal(18,2)    
Declare @Siscomex1Debit1Value1by1Shipment decimal(18,2)    
Declare @Terminal1Pier1Name     Varchar(50)  
--New Fields Ticket 100-232189  
Declare @Report1DamagedY6AN     Varchar(1)
Declare @Cargo1Damaged1Description Varchar(40)
Declare @Insurance1Letter_Sent1Date datetime
--End Ticket 100-232189

--Terminal Pier Name    
 Set @Terminal1Pier1Name=(select Descricao_Op from @CampoProcesso_Temp Join Tipo_operador_Portuario T with(nolock)  on T.id_op=campo_dados where num_proc=@num_proc and id_Campo=139)    
     
-- NC    
 Set @Reason1Code1Events=(select  [dbo].[fBusca_ListNC](@Num_PRoc))    
    
--30/10/2013 - Anderson    
 --IPI Por job    
  SEt @IPI1Value1by1Shipment=(select DBO.[fBusca_CustoProcessoTAB](@Num_Proc,'IPI%'))    
 --Cofins por job    
  set @Cofins1Value1by1Shipment=(DBO.[fBusca_CustoProcessoTAB](@Num_Proc,'Cofins%'))    
 --PIS por job    
  set @PIS1Value1by1Shipment=(DBO.[fBusca_CustoProcessoTAB](@Num_Proc,'PIS%'))     
 --II por job    
  set @Import1Duties1Value1by1Shipment=(DBO.[fBusca_CustoProcessoTAB](@Num_Proc,'Imposto de %') )     
 --Siscomex por job    
  set @Siscomex1Debit1Value1by1Shipment=(DBO.[fBusca_CustoProcessoTAB](@Num_Proc,'%siscomex%') )     
     
 --Lista de Produtos por Job    
  set @Products1by1Shipment=(select dbo.fBusca_GMID(@Num_Proc))    
  set @Product1IDs1by1Shipment=(select  replace(dbo.fBusca_PRODUTO(@Num_PRoc),'''',''))    
      
 --Numero do Drawback    
  set @Drawback1Number= (select [dbo].[fBusca_TipoDocCliente]('N',@num_proc,24))    
    
     
 --Numero do Cerfificado de Origem    
  set @Certified1Of1Origin1Number= (select [dbo].[fBusca_TipoDocCliente]('N',@num_proc,13))    
  Declare @Certified1Of1Origin1Date datetime    
  set @Certified1Of1Origin1Date= (select [dbo].[fBusca_TipoDocCliente]('D',@num_proc,13))    
    
--FIM 30/10/2013    
    
--Informações do House    
 Declare @Shipper1Address Varchar(150)    
 Declare @Volume1M3 Decimal(10,2)    
 Declare @Seller1Code Varchar(15)    
 Declare @Freight1Currency varchar(30)    
 Declare @Notes varchar(400)    
 Declare @Region1of1Origin varchar(50)    
 Declare @Region1of1Destination varchar(50)    
 Declare @LLP1UNIT varchar(20)    
 Declare @Vessel varchar(50)    
     
 exec spRManagerv2House_Sel @Num_Proc,@Notify output,@Incoterm output,@Consignee output,@Shipper output, @CNPJ output,@ConsigneeAddress output,     
 @CityofConsignee output, @Shipper1Address Output, @Volume1M3 output,@Seller1Code output,@Freight1Currency output, @Notes output,    
 @Region1of1Origin output,@Region1of1Destination output,@LLP1UNIT output,@Vessel output    
     
 if len(@CNPJ) = 15    
  Begin    
   set @CNPJ=  substring(@CNPJ,2,2) + '.' + substring(@CNPJ,4,3) + '.' + substring(@CNPJ,7,3) + '/' + substring(@CNPJ,10,4) + '-' + substring(@CNPJ,14,2)    
  End    
      
 if len(@CNPJ) = 14    
  Begin    
   set @CNPJ=  substring(@CNPJ,1,2) + '.' + substring(@CNPJ,3,3) + '.' + substring(@CNPJ,6,3) + '/' + substring(@CNPJ,9,4) + '-' + substring(@CNPJ,13,2)    
  End    
      
     
 SEt @Consignee=replace(@Consignee,char(39),' ')    
 SEt @Shipper=replace(@Shipper,char(39),' ')    
 Set @Notify=replace(@notify,char(39),' ')    
 Set @ConsigneeAddress=replace(@ConsigneeAddress,char(39),' ')    
 Set @CityofConsignee=replace(@CityofConsignee,char(39),' ')    
 Set @Shipper1Address=replace(@Shipper1Address,char(39),' ')    
    
-- Invoices    
exec spReportManagerInvoiceValorMoeda_Sel @Num_Proc,@Invoice1Currency output,@Invoice1Value output,@Invoice1Currency1Val output    
    
    
set @BDP1Invoice1Date=(select top 1 isnull(fatdtemissao,fatdtvenc) from vwFaturasValidas  where  Num_Proc=@num_proc order by 1 desc)    
    
Declare @Bank varchar(30)    
Declare @Dead1at1Terminal_Date datetime    
Declare @Country1of1Final1Destination varchar(30)    
Declare @Inland1Trucker varchar(50)    
Declare @Original1ETA_Date datetime    
Declare @PO1Request1Del1Date datetime    
Declare @ETA1Date datetime     
Declare @ETD1Date datetime     
Declare @ATA1Date datetime     
Declare @ATD1Date datetime     
Declare @Month1of1Arrival varchar(20)    
Declare @Intl1Reference varchar(40)    
Declare @Type1Of1Cargo varchar(5)    
Declare @Channel varchar(10)    
--Informações LLP    
exec SpReportManagerV2_LLP @Num_PRoc,@FinalDestination output,@Terminal output,@Bank output, @Dead1at1Terminal_Date output,    
 @Country1of1Final1Destination output, @Inland1Trucker output, @Original1ETA_Date output, @PO1Request1Del1Date output,    
 @ETA1Date output,@ETD1Date output,@ATA1Date output,@ATD1Date output, @Month1of1Arrival output, @Intl1Reference output,    
 @Type1Of1Cargo output, @Channel output    
 Set @Terminal=replace(@Terminal,char(39),' ')    
    
--@CampoProcesso_Temp    
 --Declare @Manufacturer Varchar(50)    
 Declare @Return1Terminal Varchar(50)    
 Declare @Controlled1Goods varchar(3)    
 Declare @Free1Time varchar(50)    
 Declare @DJAI1Approval varchar(50)    
 Declare @Delivery1of1Documents varchar(50)    
 --Set @Manufacturer = (select top 1 nome_raz_Soc from pessoa with (nolock) join @CampoProcesso_Temp CP on CP.campo_dados=cd_pes and id_Campo=1 where num_proc=@Num_Proc)     
    
     
 Set @Return1Terminal = (select top 1 nome_terminal from Terminal with (nolock) join @CampoProcesso_Temp CP on CP.campo_dados=cd_terminal and id_Campo=3 where num_proc=@Num_Proc)     
     
 Set @Controlled1Goods = (select (case Campo_Dados when '1' then 'YES' when '2' then 'NO' end) from @CampoProcesso_Temp  where id_campo = '123' and num_proc=@Num_Proc)    
     
 Set @Free1Time = (select Campo_Dados from @CampoProcesso_Temp  where id_campo = '138' and num_proc=@Num_Proc)    
     
 Set @DJAI1Approval = (select Campo_Dados from @CampoProcesso_Temp  where id_campo = '140' and num_proc=@Num_Proc)    
 Set @Delivery1of1Documents = (select (case Campo_Dados when 'BNC' then 'Bank' when 'DPC' then 'Customer Brokerage' when 'DRT' then 'Direct' end) from @CampoProcesso_Temp where id_campo ='141' and num_proc=@num_proc)    
    
 --Cadu = 09/2/2015    
 Declare @ParteLote varchar(3)    
 Set @ParteLote = (select (case Campo_Dados when '1' then 'YES' when '2' then 'NO' end) from @CampoProcesso_Temp  where id_campo = '144' and num_proc=@Num_Proc)    
     
 --cadu = 26/10/2017    
 Declare @Partner varchar(20)    
 Set @Partner = (select apelido from @CampoProcesso_Temp CP join vwPessoa_Partner_Sel V with(nolock) on V.cd_pes = cP.Campo_Dados where id_campo = '166' and num_proc=@Num_Proc)    
     
 Declare @Agricultural1Batch varchar(50)    
 Set @Agricultural1Batch = (select Campo_Dados from @CampoProcesso_Temp  where id_campo = '191' and num_proc=@Num_Proc)    
     
 --Cadu = 09/2/2015 - desabilitado 17-6 - cadu    
 --Declare @Country1Manufacturer varchar(50)    
 --Set @Country1Manufacturer = (select top 1 Nome_Pais from Pais with (nolock) join @CampoProcesso_Temp CP on CP.campo_dados=Cd_Pais and id_Campo=145 where num_proc=@Num_Proc)     
--TASKS    
 Declare @ClosingSpreadsheettocustomer_Date datetime    
    
 set @ClosingSpreadsheettocustomer_Date=(select dt_conclusao from @Task_Temp where id_task=123 and num_proc=@num_proc)    
     
 Declare @BL1Released_Date Datetime    
 set @BL1Released_Date=(select dt_conclusao from @Task_Temp where id_task=21 and num_proc=@num_proc)    
     
     
 Set @IMOApprovalDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=122 and dt_conclusao is not null)    
    
 Set @ArrivalattheborderDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=107 and dt_conclusao is not null)    
 Set @AuthorizationCrossDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=112 and dt_conclusao is not null)    
    
    
 Set @BookingConfirmationDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=5 and dt_conclusao is not null)    
 Set @CustomsClearanceDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=4 and dt_conclusao is not null)    
 Select top 1  @GoodReceiptDateEstimated=Dt_Previsao,@GoodReceiptDateActual=dt_conclusao from @Task_Temp where num_proc=@Num_Proc and id_task=13    
 Select top 1  @PlantExitDateEstimated=Dt_Previsao,@PlantExitDateActual=dt_conclusao from @Task_Temp where num_proc=@Num_Proc and id_task=10    
 Set @DocSentDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=12 and dt_conclusao is not null)    
 Set @DocsToCambioDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=23 and dt_conclusao is not null)    
 Set @DocsToBDPBillingDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=26 and dt_conclusao is not null)    
     
 Declare @DocsSentToForeignBank DateTime    
 Set @DocsSentToForeignBank= (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=139 and dt_conclusao is not null)    
 Declare @DocsDeliveredToForeignBank DateTime    
 Set @DocsDeliveredToForeignBank=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=140 and dt_conclusao is not null)    
    
 --Cadu - 04/02/2015    
 Declare @DraftApprovalImportDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,41) Draft_Imp,    
 Set @DraftApprovalImportDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=41 and dt_conclusao is not null)    
     
 Declare @LIRequest DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,46) SolLI,Cadu 04/02/2015    
 Set @LIRequest=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=46 and dt_conclusao is not null)    
      
 Declare @DTAClearanceDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,18) LibDTA    
 Set @DTAClearanceDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=18 and dt_conclusao is not null)    
      
 --Incluido para Exportação - Ticket #100-57752    
 Declare @PortEntryDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,15) Presenca    
 if LEFT(@Num_Proc,1) ='I'    
  begin     
   Set @PortEntryDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=15 and dt_conclusao is not null)    
  End    
 if LEFT(@num_proc,1)='E'    
  begin     
   Set @PortEntryDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=189 and dt_conclusao is not null)    
  End    
      
 Declare @TransportDocDeliveryDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,7) Doc_Deliv    
 Set @TransportDocDeliveryDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=7 and dt_conclusao is not null)    
     
 Declare @UnloadedDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,29) Desova    
 Set @UnloadedDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=29 and dt_conclusao is not null)    
      
 Declare @PREDIDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,27) Digitacao_DI    
 Set @PREDIDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=27 and dt_conclusao is not null)    
     
 Declare @RemocaoDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,19) Remocao    
 Set @RemocaoDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=19 and dt_conclusao is not null)    
      
 Declare @FileOpen DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,60) FileOpen    
 Set @FileOpen=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=60 and dt_conclusao is not null)    
      
 Declare @ContainerYardRequestDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,42) Redistinacao    
 Set @ContainerYardRequestDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=42 and dt_conclusao is not null)    
     
 Declare @DocsReceivedDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,16) DocsReceived    
 Set @DocsReceivedDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=16 and dt_conclusao is not null)    
     
 Declare @NFBDPDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,78) EnvioCobranca,    
 Set @NFBDPDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=78 and dt_conclusao is not null)    
     
 Declare @AdvancedRequestDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,59) SolAdto    
 Set @AdvancedRequestDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=59 and dt_conclusao is not null)    
     
 Declare @Dt_SI DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,45) Dt_SI    
 Set @Dt_SI=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=45 and dt_conclusao is not null)    
     
 Declare @DtGreenLight DateTime --[[dbo].[fBusca_Tarefa](@Num_Proc,39) Dt_Aut    
 Set @DtGreenLight=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=39 and dt_conclusao is not null)    
      
 Declare @DefLI DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,20) Def_LI,    
 Set @DefLI=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=20 and dt_conclusao is not null)    
      
 Declare @InvoiceSentDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,40) Envio_Prestacao    
 Set @InvoiceSentDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=40 and dt_conclusao is not null)    
     
 Declare @BRIssuedDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,80) Emissao_BLBR    
 Set @BRIssuedDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=80 and dt_conclusao is not null)    
     
 Declare @DraftSentCustomerDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,84) Envio_Draft_Cliente    
 Set @DraftSentCustomerDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=84 and dt_conclusao is not null)    
     
 Declare @DraftReceivedDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,83) Recebimento_Draft    
 Set @DraftReceivedDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=83 and dt_conclusao is not null)    
     
 Declare @DraftBackDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,85) Retorno_Draft_Cliente    
 Set @DraftBackDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=85 and dt_conclusao is not null)    
     
 Declare @BDPPreInvoice DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,79) PREFaturamento    
 Set @BDPPreInvoice=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=79 and dt_conclusao is not null)    
     
 Declare @EnvioShipping DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,45) EnvioShipping    
 Set @EnvioShipping=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=45 and dt_conclusao is not null)    
     
 Declare @TruckLoading DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,100) Confirmacao_Carregamento    
 Set @TruckLoading=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=100 and dt_conclusao is not null)    
     
 Declare @DraftExport DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,66) Draft_Exp    
 Set @DraftExport=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=66 and dt_conclusao is not null)    
     
 Declare @AverbacaoImpDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,68) Averbacao_imp    
 Set @AverbacaoImpDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=68 and dt_conclusao is not null)    
     
 Declare @PosicionamentoEfetivo DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,104) Posicionamento_Efetivo,    
 Set @PosicionamentoEfetivo=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=104 and dt_conclusao is not null)    
     
 Declare @InspMAPA DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,105)InspMAPA    
 Set @InspMAPA=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=105 and dt_conclusao is not null)    
     
 Declare @ProftRegister DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,905) RegProft    
 Set @ProftRegister=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=905 and dt_conclusao is not null)    
     
 Declare @TransmissionValue DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,87) EnvioVlores    
 Set @TransmissionValue=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=87 and dt_conclusao is not null)    
     
 Declare @ProcessOKpaymentHBL DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,88) ProcessoOKPPG,    
 Set @ProcessOKpaymentHBL=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=88 and dt_conclusao is not null)    
     
 Declare @ManifestDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,8) Manifesto    
 Set @ManifestDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=8 and dt_conclusao is not null)    
     
 Declare @SiscargaRegister DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,903) RegSiscarga    
 Set @SiscargaRegister=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=903 and dt_conclusao is not null)    
     
 Declare @DocsOKregister DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,63) DocsPRestrito,    
 Set @DocsOKregister=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=63 and dt_conclusao is not null)    
     
 Declare @PreAlertSending DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,1) EnvioPreAlerta    
 Set @PreAlertSending=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=1 and dt_conclusao is not null)    
     
 --**************    
 Declare @ChegadaFronteira DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,31) ChegadaFronteira    
 Set @ChegadaFronteira=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=31 and dt_conclusao is not null)    
     
 Declare @Cumplido DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,6) Cumplido    
 Set @Cumplido=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=6 and dt_conclusao is not null)    
     
 Declare @Cumplido_Est DateTime --[dbo].[fBusca_Tarefa_Prev](@Num_Proc,6) Cumplido_Est    
 Set @Cumplido_Est=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=6 and dt_conclusao is not null)    
     
 Declare @AnticipoDOC DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,202) AnticipoDOC    
 Set @AnticipoDOC=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=202 and dt_conclusao is not null)    
     
 Declare @InvoiceController DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,203) Invoice_SentC,    
 Set @InvoiceController=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=203 and dt_conclusao is not null)    
     
 Declare @EntrCobranca DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,201) Entrega_Cobr    
 Set @EntrCobranca=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=201 and dt_conclusao is not null)    
     
 Declare @BDPCambio DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,86)  Cambio_BDP    
 Set @BDPCambio=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=86 and dt_conclusao is not null)    
     
 Declare @DIDraftOKDateBRonly DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,65)  Conf_DI    
 Set @DIDraftOKDateBRonly=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=65 and dt_conclusao is not null)    
     
 Declare @DanfeReceiptDateBRonly DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,108)  DANFE_Recebe    
 Set @DanfeReceiptDateBRonly=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=108 and dt_conclusao is not null)    
     
 Declare @BDPInvoiceReceiptDateBRonly DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,77)  PrestacaoRecibo    
 Set @BDPInvoiceReceiptDateBRonly=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=77 and dt_conclusao is not null)    
     
 Declare @ReceivedMBLDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,110) Receb_MBL    
 Set @ReceivedMBLDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=110 and dt_conclusao is not null)    
     
 Declare @ReceivedHBLDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,111) Receb_HBL    
 Set @ReceivedHBLDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=111 and dt_conclusao is not null)    
     
 Declare @SurveyDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,114) Receb_LaudoArqueacao    
 Set @SurveyDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=114 and dt_conclusao is not null)    
     
 Declare @TransshipmentArrivalDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,38) TransshipmentArrival    
 Set @TransshipmentArrivalDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=38 and dt_conclusao is not null)    
     
 Declare @TransshipmentDepartureDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,37) TransshipmentDeparture    
 Set @TransshipmentDepartureDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=37 and dt_conclusao is not null)    
     
 Declare @BookingRequestDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,58) Solic_Booking    
 Set @BookingRequestDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=58 and dt_conclusao is not null)    
     
     
      
     
 --Cadu - 11/02/2015      
 --*********************************     
 Declare @EnvioDoc1 DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,89) Doc_1,    
 Set @EnvioDoc1=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=89 and dt_conclusao is not null)    
     
 Declare @RecDoc1 DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,90) Rec_Doc_1,    
 Set @RecDoc1=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=90 and dt_conclusao is not null)    
      
 Declare @Def1 DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,91) Def_1,    
 Set @Def1=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=91 and dt_conclusao is not null)    
      
 Declare @EnvioDoc2 DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,92) Doc_2,    
 Set @EnvioDoc2=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=92 and dt_conclusao is not null)    
      
 Declare @Def2 DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,93) Def_2,    
 Set @Def2=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=93 and dt_conclusao is not null)    
 --*********************************    
       
 Declare @DanfeRequest DateTime -- solicitação por ticket - 300-5854    
 Set @DanfeRequest=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=142 and dt_conclusao is not null)    
     
 Declare @DanfeReceipt DateTime    
 Set @DanfeReceipt=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=143 and dt_conclusao is not null)    
     
 --Tasks Especifico do BR    
     
  Declare @Sending1Of1Invoice1Amount1Date Datetime ---ID Task=87    
  Declare @Sending1Of1Banking1Collection1Date Datetime --ID Task=124    
  Declare @Warehouse1Expiration1Date Datetime -- ID campo=131      
  Declare @DeadLine1Loading1Date  Datetime -- ID Campo=130    
  Declare @Docs1ok1to1Delivery1Inland1Trucker1Date Datetime -- ID task=125    
  Declare @CRT1Received1Date  Datetime -- ID=127    
  Declare @Export1Voucher1Sending_Date Datetime -- ID=197    
  Declare @Freight1Receipt1A61Delivery1Fee_Date Datetime -- ID=199    
  Declare @BL1Sent_Express1Mail1SP_Date Datetime -- ID=200    
  Declare @Freight1Payment1and1Fees_Date Datetime -- ID=150    
  Declare @Draft1Review_Date Datetime -- ID=158    
  Declare @Terminal1Container1Delivery_Date Datetime -- ID=161    
  Declare @Opening1Gate_Date Datetime -- ID=160    
  Declare @MDGF1Protocol_Date Datetime -- ID=157    
  Declare @VGM1Transmission_Date Datetime -- ID=186    
  Declare @VGM1Retransmission_Date Datetime -- ID=187    
  Declare @VGM1Carrier1Receipt_Date Datetime -- ID=188    
  Declare @JOB1Reopenning_Additional1Billing_Date datetime -- ID=201    
  Declare @Additional1Billing1Sending_Date datetime -- ID=202    
  Declare @Shipment1Departure1Confirmation_Date datetime -- ID=134    
  Declare @BL1Fee1Payment_Date datetime -- ID=94    
  Declare @DDE1Terminal1Protocol_Date datetime -- ID=198    
  Declare @Pre1Import1License1Release_Date datetime -- ID=20    
  Declare @Post1Import1License1Release_Date datetime -- ID=175    
  Declare @Docs1Delivery1for1Customs1Clearance_Date datetime --ID=147    
  Declare @Wood1Released_Date datetime --ID=164    
  Declare @Terminal1Nomination_Date datetime --ID=171    
  Declare @Original1Docs1Received_CHB_Date datetime --ID=155    
  Declare @Original1Docs1Received_CSR_Date datetime --ID=174    
  Declare @Copy1of1Docs1Received_Date datetime --ID=109    
  Declare @Wood1Inspection1Selected_Date datetime --ID=163    
  Declare @Discharge1Conclusion_Date datetime --ID=136    
  Declare @Operation1Audit_Date datetime --ID=194    
  Declare @Quota1Reestablishment_Date datetime --ID=203    
  Declare @COA1Sent1for1Transp_Date datetime --ID=173    
  Declare @Cargo1Manifest1for1Import1Declaration_Date datetime --ID=156    
  Declare @Billing1Receipt_Date datetime --ID=35    
  Declare @DRAFTBDPInvoice_Date datetime --ID=211    
  Declare @Service1BDP1Invoice1Sent_Date datetime --ID=209    
  Declare @Delivery1for1Pre1Import1Declaration_Date datetime --ID=168    
  Declare @Protocol1at1the1Tax1Office_Date datetime --ID=204    
  Declare @Shipment1with1Loss_Date datetime --ID=192    
  Declare @Shipment1without1Profit_Date datetime --ID=193    
  Declare @PreAlert1Sent1Agent_Date datetime --ID=190    
  Declare @Receipt1and1NF1Sent_Date datetime --ID=128    
  Declare @Siscoserv1Sent_Date datetime --ID=182    
  Declare @ISF1Sent_Date datetime --ID=179    
  Declare @ISF1Sent1to1Destination_Date datetime --ID=152    
  Declare @AMSENS1Sent1to1Destination_Date datetime --ID=151    
  Declare @AMS1Registration_Date datetime --ID=178    
      
  Set @Sending1Of1Invoice1Amount1Date=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=87 and dt_conclusao is not null)    
  Set @Sending1Of1Banking1Collection1Date=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=124 and dt_conclusao is not null)    
  SEt @Warehouse1Expiration1Date=(select convert(Datetime,campo_dados,103) from @CampoProcesso_Temp where id_campo=131 and campo_dados is not null and num_proc=@Num_Proc)    
  SEt @DeadLine1Loading1Date=(select convert(Datetime,campo_dados,103) from @CampoProcesso_Temp where id_campo=130 and campo_dados is not null and num_proc=@Num_Proc)    
    
  Set @CRT1Received1Date=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=127 and dt_conclusao is not null)    
    
  Set @Docs1ok1to1Delivery1Inland1Trucker1Date=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=125 and dt_conclusao is not null)    
     
  Set @NFEDraftDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=67 and dt_conclusao is not null)    
  Set @BillofLadingBackDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=82 and dt_conclusao is not null)    
  Set @EnvioCHBFaturamentoDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=62 and dt_conclusao is not null)    
  Set @OrderReceivedDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=50 and dt_conclusao is not null)    
  Set @BDPInvoiceCreationDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=76 and dt_conclusao is not null)    
  Set @InvoiceapprovalbycustomerDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_Proc and id_Task=117)    
  Set @PositioningContainerRequireDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=103 and dt_conclusao is not null)    
  Set @TerminalEntryDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=28 and dt_conclusao is not null)    
  Set @AverbacaoEXPDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=15 and dt_conclusao is not null)    
  Set @WoodInspectionDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=30 and dt_conclusao is not null)    
  Set @DocSentBLBRDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=81 and dt_conclusao is not null)    
  Set @AFRMMPaymentDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=25 and dt_conclusao is not null)    
  Set @EntryrequirementDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=51 and dt_conclusao is not null)    
  SEt @ETD1Original_Date=(select convert(Datetime,campo_dados,103) from @CampoProcesso_Temp where id_campo=127 and campo_dados is not null and num_proc=@Num_Proc)    
  Set @Withdrawalof1Samples_Date=(select top 1 dt_conclusao from @Task_Temp where num_proc=@num_proc and id_task=113 and dt_conclusao is not null)    
  SEt @NFIssueValue= (select campo_Dados from @CampoProcesso_Temp where id_Campo=117 and num_proc=@num_proc and campo_dados is not null)    
  --SEt @CIFValue= (select campo_Dados from @CampoProcesso_Temp where id_Campo=110 and num_proc=@num_proc and campo_dados is not null)    
  Set @Export1Voucher1Sending_Date= (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=197 and dt_conclusao is not null)    
  Set @Freight1Receipt1A61Delivery1Fee_Date= (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=199 and dt_conclusao is not null)    
  Set @BL1Sent_Express1Mail1SP_Date= (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=200 and dt_conclusao is not null)    
  Set @Freight1Payment1and1Fees_Date= (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=150 and dt_conclusao is not null)    
  Set @Draft1Review_Date= (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=158 and dt_conclusao is not null)    
  Set @Terminal1Container1Delivery_Date= (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=161 and dt_conclusao is not null)    
  Set @Opening1Gate_Date= (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=160 and dt_conclusao is not null)    
  Set @MDGF1Protocol_Date= (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=157 and dt_conclusao is not null)    
  Set @VGM1Transmission_Date= (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=186 and dt_conclusao is not null)    
  Set @VGM1Retransmission_Date= (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=187 and dt_conclusao is not null)    
  Set @VGM1Carrier1Receipt_Date= (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=188 and dt_conclusao is not null)    
  Set @JOB1Reopenning_Additional1Billing_Date= (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=201 and dt_conclusao is not null)    
  Set @Additional1Billing1Sending_Date= (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=202 and dt_conclusao is not null)    
  Set @Shipment1Departure1Confirmation_Date= (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=134 and dt_conclusao is not null)    
  Set @BL1Fee1Payment_Date= (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=94 and dt_conclusao is not null)    
  Set @DDE1Terminal1Protocol_Date= (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=198 and dt_conclusao is not null)    
  Set @Pre1Import1License1Release_Date= (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=20 and dt_conclusao is not null)    
  Set @Post1Import1License1Release_Date = (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=175 and dt_conclusao is not null)    
  Set @Docs1Delivery1for1Customs1Clearance_Date = (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=147 and dt_conclusao is not null)    
  Set @Wood1Released_Date = (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=164 and dt_conclusao is not null)    
  Set @Terminal1Nomination_Date = (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=171 and dt_conclusao is not null)    
  Set @Original1Docs1Received_CHB_Date = (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=155 and dt_conclusao is not null)    
  Set @Original1Docs1Received_CSR_Date = (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=174 and dt_conclusao is not null)    
  Set @Copy1of1Docs1Received_Date = (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=109 and dt_conclusao is not null)    
  Set @Wood1Inspection1Selected_Date = (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=163 and dt_conclusao is not null)    
  Set @Discharge1Conclusion_Date = (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=136 and dt_conclusao is not null)    
  Set @Operation1Audit_Date = (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=194 and dt_conclusao is not null)    
  Set @Quota1Reestablishment_Date = (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=203 and dt_conclusao is not null)    
  Set @COA1Sent1for1Transp_Date = (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=173 and dt_conclusao is not null)    
  Set @Cargo1Manifest1for1Import1Declaration_Date = (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=156 and dt_conclusao is not null)    
  Set @Billing1Receipt_Date = (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=35 and dt_conclusao is not null)    
  Set @DRAFTBDPInvoice_Date = (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=211 and dt_conclusao is not null)    
  Set @Service1BDP1Invoice1Sent_Date = (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=209 and dt_conclusao is not null)    
  Set @Delivery1for1Pre1Import1Declaration_Date = (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=168 and dt_conclusao is not null)    
  Set @Protocol1at1the1Tax1Office_Date = (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=204 and dt_conclusao is not null)    
  Set @Shipment1with1Loss_Date = (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=192 and dt_conclusao is not null)    
  Set @Shipment1without1Profit_Date = (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=193 and dt_conclusao is not null)    
  Set @PreAlert1Sent1Agent_Date = (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=190 and dt_conclusao is not null)    
  Set @Receipt1and1NF1Sent_Date = (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=128 and dt_conclusao is not null)    
  Set @Siscoserv1Sent_Date = (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=182 and dt_conclusao is not null)    
  Set @ISF1Sent_Date = (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=179 and dt_conclusao is not null)    
  Set @ISF1Sent1to1Destination_Date = (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=152 and dt_conclusao is not null)    
  Set @AMSENS1Sent1to1Destination_Date = (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=151 and dt_conclusao is not null)    
  Set @AMS1Registration_Date = (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=178 and dt_conclusao is not null)    
  Set @Insurance1Letter_Sent1Date = (select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=251 and dt_conclusao is not null)    --Ticket 100-232189

 --Doc Especifico BR    
   if exists(select Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=15)    
    Begin    
     Set @PDFRemittance='YES'    
    End    
   Else    
    Begin    
     Set @PDFRemittance ='NO'    
    End    
    
 --Doc Especifico BR - DOCS PARA TRANSPORTE    
   if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=90)    
    Begin    
     Set @PDF_Protocolo1Transporte='YES'    
    End    
   Else    
    Begin    
     Set @PDF_Protocolo1Transporte ='NO'    
    End    
 --BL PDF     
   Declare @PDF_BL Varchar(3)    
   if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=20)    
    Begin    
     Set @PDF_BL='YES'    
    End    
   Else    
    Begin    
     Set @PDF_BL ='NO'    
    End       
        
 -- Invoice         
   Declare @PDF_Invoice Varchar(3)    
   if exists(select Nome_Arquivo from doc_anexos with(nolock) where num_proc=@Num_Proc and id_dc=2)    
    Begin    
     Set @PDF_Invoice='YES'    
     --print @PDF_Invoice    
    End    
   Else    
    Begin    
     Set @PDF_Invoice ='NO'    
     --print @PDF_Invoice    
    End          
       
   Declare @PDF_RE Varchar(4)    
    
   if LEFT(@Num_Proc,1)='I'     
    Begin    
     Set @PDF_RE='N/A'    
     --print @PDF_Invoice    
    End    
   else    
    Begin    
     if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=4)    
      Begin    
       Set @PDF_RE='YES'    
       --print @PDF_Invoice    
      End    
     Else    
     Begin    
      Set @PDF_RE ='NO'    
      --print @PDF_Invoice    
     End      
    End    
        
   Declare @PDF_DDE Varchar(4)    
   if LEFT(@Num_Proc,1)='I'     
    Begin    
     Set @PDF_DDE='N/A'    
    End    
   else    
    Begin    
     if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=12)    
      Begin    
       Set @PDF_DDE='YES'    
      End    
     Else    
     Begin    
      Set @PDF_DDE ='NO'    
     End      
    End      
          
   Declare @PDF_Form1A Varchar(4)    
   if LEFT(@Num_Proc,1)='I'     
    Begin    
     Set @PDF_Form1A='N/A'    
    End    
   else    
    Begin    
     if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=14)    
      Begin    
       Set @PDF_Form1A='YES'    
      End    
     Else    
     Begin    
      Set @PDF_Form1A ='NO'    
     End      
    End    
        
   Declare @PDF_Insurance Varchar(4)    
   if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=21)    
    Begin    
     Set @PDF_Insurance='YES'    
    End    
   Else    
    Begin    
     Set @PDF_Insurance ='NO'    
    End      
       
   Declare @PDF_Fumigacao Varchar(4)    
   if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=22)    
    Begin    
     Set @PDF_Fumigacao='YES'    
    End    
   Else    
    Begin    
     Set @PDF_Fumigacao='NO'    
    End      
    
   Declare @PDF_Arqueacao Varchar(4)    
   if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=27)    
    Begin    
     Set @PDF_Arqueacao='YES'    
    End    
   Else    
    Begin    
     Set @PDF_Arqueacao ='NO'    
    End      
    
    
   Declare @PDF_Saque Varchar(4)    
   if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=65)    
    Begin    
     Set @PDF_Saque='YES'    
    End    
   Else    
    Begin    
     Set @PDF_Saque ='NO'    
    End      
    
   Declare @PDF_Courier Varchar(4)    
   if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=103)    
    Begin    
     Set @PDF_Courier='YES'    
    End    
   Else    
    Begin    
     Set @PDF_Courier ='NO'    
    End      
    
    
   Declare @PDF_Courier12 Varchar(4)    
   if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=94)    
    Begin    
     Set @PDF_Courier12='YES'    
    End    
   Else    
    Begin    
     Set @PDF_Courier12 ='NO'    
    End      
     
   Declare @PDF_COA Varchar(3)    
   if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=16)    
    Begin    
     Set @PDF_COA='YES'    
    End    
   Else    
    Begin    
     Set @PDF_COA ='NO'    
    End            
    
   Declare @PDF_COO Varchar(3)    
       
   if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=13)    
    Begin    
     Set @PDF_COO='YES'    
    End    
   Else    
    Begin    
     Set @PDF_COO ='NO'    
    End            
    
        
   Declare @PDF_PL Varchar(3)    
   if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=11)    
    Begin    
     Set @PDF_PL='YES'    
    End    
   Else    
    Begin    
     Set @PDF_PL ='NO'    
    End            
    
        
   Declare @PDF_NF Varchar(3)    
   if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=10)    
    Begin    
     Set @PDF_NF='YES'    
    End    
   Else    
    Begin    
     Set @PDF_NF ='NO'    
    End            
        
        
   Declare @PDF_PC Varchar(3)    
   if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=60)    
    Begin    
     Set @PDF_PC='YES'    
    End    
   Else    
    Begin    
     Set @PDF_PC ='NO'    
    End           
    
   Declare @PDF_DI Varchar(4)    
    
   if LEFT(@Num_Proc,1)='E'     
    Begin    
     Set @PDF_DI='N/A'    
    End    
   else    
    Begin    
     if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=5)    
      Begin    
       Set @PDF_DI='YES'    
      End    
     Else    
     Begin    
      Set @PDF_DI ='NO'    
     End      
    End    
    
   Declare @PDF_CAPA Varchar(4)    
    
   if LEFT(@Num_Proc,1)='E'     
    Begin    
     Set @PDF_CAPA='N/A'    
    End    
   else    
    Begin    
     if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=48)    
      Begin    
       Set @PDF_CAPA='YES'    
      End    
     Else    
     Begin    
      Set @PDF_CAPA ='NO'    
     End      
    End    
   --PDF - BL Original    
   Declare @PDF_BL1Original Varchar(4)    
    
   if LEFT(@Num_Proc,1)='E'     
    Begin    
     Set @PDF_BL1Original ='N/A'    
    End    
   else    
    Begin    
     if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=44)    
      Begin    
       Set @PDF_BL1Original='YES'    
      End    
     Else    
     Begin    
      Set @PDF_BL1Original ='NO'    
     End      
    End    
       
   Declare @PDF_AFRMM Varchar(4)    
    
   if LEFT(@Num_Proc,1)='E'     
    Begin    
     Set @PDF_AFRMM='N/A'    
    End    
   else    
    Begin    
     if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=41)    
      Begin    
       Set @PDF_AFRMM='YES'    
      End    
     Else    
     Begin    
      Set @PDF_AFRMM ='NO'    
     End      
    End    
    
    
   Declare @PDF_ICMS Varchar(4)    
    
   if LEFT(@Num_Proc,1)='E'     
    Begin    
     Set @PDF_ICMS='N/A'    
    End    
   else    
    Begin    
     if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=40)    
      Begin    
       Set @PDF_ICMS='YES'    
      End    
     Else    
     Begin    
      Set @PDF_ICMS ='NO'    
     End      
    End    
    
        
   Declare @PDF_LI Varchar(4)    
    
   if LEFT(@Num_Proc,1)='E'     
    Begin    
     Set @PDF_LI='N/A'    
    End    
   else    
    Begin    
     if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=23)    
      Begin    
       Set @PDF_LI='YES'    
      End    
     Else    
     Begin    
      Set @PDF_LI ='NO'    
     End      
    End    
    
    
   Declare @PDF_CI Varchar(4)    
    
   if LEFT(@Num_Proc,1)='E'     
    Begin    
     Set @PDF_CI='N/A'    
    End    
   else    
    Begin    
     if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=6)    
      Begin    
       Set @PDF_CI='YES'    
      End    
     Else    
     Begin    
      Set @PDF_CI ='NO'    
     End      
    End    
    
    
 --Ticket do Andre Souza - 100-14750    
  --029-Ce Mercante      
   Declare @PDF_CE1Mercante Varchar(3)    
   if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=29)    
    Begin    
     Set @PDF_CE1Mercante='YES'    
    End    
   Else    
    Begin    
     Set @PDF_CE1Mercante ='NO'    
    End    
      
  --153-Termo correção siscarga    
   Declare @PDF_Termo1correção1siscarga Varchar(3)    
   if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=153)    
    Begin    
     Set @PDF_Termo1correção1siscarga='YES'    
    End    
   Else    
    Begin    
     Set @PDF_Termo1correção1siscarga='NO'    
    End    
        
  --Incluido por Rafael Lindenberg - 11/08/2017     
  --26 - DSE    
   Declare @PDF_DSE Varchar(3)    
   if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=26)    
    Begin    
     Set @PDF_DSE='YES'    
    End    
   Else    
    Begin    
     Set @PDF_DSE='NO'    
    End    
        
  --134 - MDGF    
   Declare @PDF_MDGF Varchar(3)    
   if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=134)    
    Begin    
     Set @PDF_MDGF='YES'   
    End    
   Else    
    Begin    
     Set @PDF_MDGF='NO'    
    End    
        
  --183 - Recibo de CO    
   Declare @PDF_CO1Receipt Varchar(3)    
   if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=183)    
    Begin    
     Set @PDF_CO1Receipt='YES'    
    End    
   Else    
    Begin    
     Set @PDF_CO1Receipt='NO'    
    End    
      
  --72 - Recibo de frete e taxas    
   Declare @PDF_Freight1and1Fees1Receipt Varchar(3)    
   if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=72)    
    Begin    
     Set @PDF_Freight1and1Fees1Receipt='YES'    
    End    
   Else    
    Begin    
     Set @PDF_Freight1and1Fees1Receipt='NO'    
    End    
        
  --62 - Comprovante de Exportação    
   Declare @PDF_CEXP Varchar(3)    
   if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=62)    
    Begin    
     Set @PDF_CEXP='YES'    
    End    
   Else    
    Begin    
     Set @PDF_CEXP='NO'    
    End    
        
  --204 - DUE    
   Declare @PDF_DUE Varchar(3)    
   if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=204)    
    Begin    
     Set @PDF_DUE='YES'    
    End    
   Else    
    Begin    
     Set @PDF_DUE='NO'    
    End    
      
  --207 - DAT    
   Declare @PDF_DAT Varchar(3)    
   if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=207)    
    Begin    
     Set @PDF_DAT='YES'    
    End    
   Else    
    Begin    
     Set @PDF_DAT='NO'    
    End    
      
  --147 - BDP NF    
   Declare @PDF_BDP1NF Varchar(3)    
   if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=147)    
    Begin    
     Set @PDF_BDP1NF='YES'    
    End    
   Else    
    Begin    
     Set @PDF_BDP1NF='NO'    
    End     
      
  --100 - Prest. de Contas - Compl    
   Declare @PDF_PCC Varchar(3)    
   if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=100)    
    Begin    
     Set @PDF_PCC='YES'    
    End    
   Else    
    Begin    
     Set @PDF_PCC='NO'    
    End    
      
  --172 - Capacitação do Isotank    
   Declare @PDF_Tank1Inspection Varchar(3)    
   if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=172)    
    Begin    
     Set @PDF_Tank1Inspection='YES'    
    End    
   Else    
    Begin    
     Set @PDF_Tank1Inspection='NO'    
    End     
    
    
---- Pagamento de Liberação de BL    
-- if substring(@Num_proc,2,1)='M'    
--  Begin    
--   Set @BL1Payment1Date=(select top 1  convert(datetime,dt_pgto_rcto_hia,105) from vwcxas cxa with (nolock) join tipo_taxa tt with (nolock) on tt.cd_tp_tx=cxa.cd_tp_tx where num_proc_hia=@Num_proc and nome_tp_tx like 'Liberação de BL%' and dc_hia='D') 
  
    
    
--  End    
     
--alterei pra ver antes no task, se não tiver pega no vwcxas - cadu 11/2/2015    
 BEGIN    
  --Este codigo era feito no vb6     
  Declare @BLPaymentDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,21) LibBL    
  Set @BL1Payment1Date=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=21 and dt_conclusao is not null)    
 END    
     
 if (@BL1Payment1Date is null and substring(@Num_proc,2,1)='M')    
  Begin    
   Set @BL1Payment1Date=(select top 1  convert(datetime,dt_pgto_rcto_hia,105) from vwcxas cxa with (nolock) join tipo_taxa tt with (nolock) on tt.cd_tp_tx=cxa.cd_tp_tx where num_proc_hia=@Num_proc and nome_tp_tx like 'Liberação de BL%' and dc_hia='D')    
 
  End      
    
    
--Separação por Import/Export    
     
 Declare @RE1Value Varchar(30)    
 Declare @Siscomex1Destination1Code Varchar(10)    
 Declare @BPS1COD1SISCOMEX varchar(10)    
 Declare @DDE1or1DSE1Value Varchar(30)    
 Declare @NFSerie Varchar(10)    
 Declare @USD1Exch1Date_BR1Exp1only datetime    
 Declare @USD1Exch1Rate_BR1Exp1only varchar(40)    
 Declare @DSE_Number varchar(80)    
 Declare @DSE181Date  datetime    
     
 if left(@Num_proc,1)='E'    
  Begin      
   Set @DDE1or1DSE1Value=(select top 1 campo_Dados from @CampoProcesso_Temp where id_campo=137 and num_proc=@Num_Proc)    
   Set @NFSerie=(select top 1 left(campo_Dados,10) from @CampoProcesso_Temp where id_campo=112 and num_proc=@Num_Proc)    
    
   Set @ExportRegisterReceiptDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_Proc and id_Task=119)    
   Set @RE1Value=(select top 1 campo_Dados from @CampoProcesso_Temp where id_campo=71 and num_proc=@Num_Proc)    
   Set @Siscomex1Destination1Code=(select top 1 left(campo_Dados,10) from @CampoProcesso_Temp where id_campo=136 and num_proc=@Num_Proc)    
   Set @BPS1COD1SISCOMEX=(select top 1 left(campo_Dados,10) from @CampoProcesso_Temp where id_campo=135 and num_proc=@Num_Proc)    
   SET DATEFORMAT dmy;    
   Set @USD1Exch1Date_BR1Exp1only =(select CONVERT(datetime,campo_dados,103) from @CampoProcesso_Temp where num_proc= @Num_proc and id_campo=113 and ISDATE(campo_dados) = 1)    
   SET DATEFORMAT mdy;    
   Set @USD1Exch1Rate_BR1Exp1only=(select top 1 campo_Dados from @CampoProcesso_Temp where id_campo=111 and num_proc=@Num_Proc)    
   set @DSE_Number = dbo.fBusca_TipoDocCliente('N',@Num_Proc,26)    
   set @DSE181Date =dbo.fBusca_TipoDocCliente('D',@Num_Proc,26)    
    
    
  End    
    
 if left(@num_proc,1)='I'    
  Begin    
    
   if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=59)    
    Begin    
     Set @PDF_DA='YES'    
    End    
   Else    
    Begin    
     Set @PDF_DA ='NO'    
    End    
    
    
   if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=54)    
    Begin    
     Set @PDF_NF_omplementar='YES'    
    End    
   Else    
    Begin    
     Set @PDF_NF_omplementar ='NO'    
    End    
    
    
   Set @ICMSPaymentDate = (select top 1 dt_conclusao from @Task_Temp where num_proc=@num_proc and id_task=24 and dt_conclusao is not null)    
   Set @AntiDumpingValuebyShipment=(select sum(valor) from custo_processo with(nolock) where cd_tp_tx in (select cd_tp_Tx from tipo_taxa with(nolock) where nome_tp_tx like '%Dumping%') and num_proc=@Num_PRoc)    
   Set @ExchangeRatesValue=(select campo_dados Paridade from @CampoProcesso_Temp where  id_campo=31 and num_proc=@Num_Proc)    
   Set @DataSyncro = (select top 1 data_envio from nota_cliente with(nolock) where num_proc=@Num_Proc)    
   Declare @Danfe1Value varchar(40)     
   Set @Danfe1Value = (select cast(cast(sum(Vlr_NF) as decimal(18,2)) as varchar(40)) from nota_cliente with(nolock) where num_proc=@Num_Proc)    
   Set @LiExpiredDate=(select max(dt_vencimento) from solicitacao_li with(nolock) where num_proc=@Num_Proc)    
   Set @LIType=(select top 1 cast(id_tipo as varchar(2)) + '-' + Nome_Tp_LI from solicitacao_li SL with(nolock) Join Tipo_LI TL on TL.id_Tipo=SL.id_tipo_li where num_proc=@num_proc order by dt_solicitacao desc)    
   Set @ICMSexonerationDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_Proc and id_Task=61 and dt_conclusao is not null)    
   if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=75)    
    Begin    
     Set @ICMSExonerationPDF='YES'    
    End    
   Else    
    Begin    
     Set @ICMSExonerationPDF='NO'    
    End    
   if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=25)    
    Begin    
     Set @PDFRequerimento='YES'    
    End    
   Else    
    Begin    
     Set @PDFRequerimento='NO'    
    End    
  End    
      
  Declare @Doc1Delivery1to1Customs1House_Date datetime    
  Declare @Dead1Line1Transf_Date datetime    
  Declare @Damage_Details varchar(150)    
  Declare @Batch1Number varchar(500)    
--Separação por Modal    
 if left(@Num_Proc,2)='IM'    
  Begin    
   Set @DemurrageHistoric = (select top 1 campo_dados from @CampoProcesso_Temp where num_proc=@Num_Proc and id_Campo=105)    
   Set @DemurragePeriod=(select top 1 campo_dados from @CampoProcesso_Temp where num_proc=@Num_Proc and id_Campo=102)    
   Set @WarehousePeriod=(select top 1 campo_dados from @CampoProcesso_Temp where num_proc=@Num_Proc and id_Campo=108)    
   Set @WarehouseHistoric=(select left(campo_dados,255) from @CampoProcesso_Temp where id_Campo=120 and num_proc=@Num_Proc)    
   Set @DemurrageInvoiceNumber=(select top 1 numero_po_him from po_him  with(nolock) where id_dc=106 and num_proc_him=@Num_Proc)    
   set @DemurrageInvoiceDate=(select top 1 data_po_him from po_him with(nolock) where id_dc=106 and num_proc_him=@Num_Proc)    
   Set @AFRMMValuebyShipment=(select sum(valor) from custo_processo with(nolock) where cd_tp_tx in (select cd_tp_Tx from tipo_taxa with(nolock) where nome_tp_tx like '%AFRMM%') and num_proc=@Num_PRoc)    
   SEt @TerminalmoverequestbyCustomerDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_Proc and id_task=118)    
   Set @FreightType=(Select case tp_frete_him when 'P' then 'Prepaid' when 'C' then 'Collect' End from house_imp_mar with(nolock) where num_proc_him=@Num_Proc)    
   set @SurveyRequestDate=(select top 1 convert(Datetime,campo_dados,103) from @CampoProcesso_Temp where num_proc=@Num_Proc and id_campo=124 and campo_dados is not null)    
        
    
   if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=126)    
    Begin    
     set @PDFSolRedestinaçãoCliente='YES'    
    End    
   Else    
    Begin    
     set @PDFSolRedestinaçãoCliente='NO'    
    End    
   Set @Doc1Delivery1to1Customs1House_Date=(select top 1 convert(Datetime,campo_dados,103) from @CampoProcesso_Temp where num_proc=@Num_Proc and id_Campo=116)    
   set @Dead1Line1Transf_Date =(select top 1 convert(Datetime,campo_dados,103) from @CampoProcesso_Temp where num_proc=@Num_Proc and id_Campo=115)    
   set @Damage_Details = (select top 1 campo_dados from @CampoProcesso_Temp where num_proc=@Num_Proc and id_Campo=114)    
   set @Batch1Number = (select top 1 campo_dados from @CampoProcesso_Temp where num_proc=@Num_Proc and id_Campo=100)     
    
  End    
    
    
--INFORMAÇÕES DO MASTER    
     
    
 Declare @ShipperTb Table    
  (    
   Master Varchar(40)    
  )    
    
 insert @ShipperTb    
 exec spSaidaRMShipperMAster_Rel @Num_PRoc    
    
 set @ShipperMaster = ( select top 1 master from @shippertb)    
     
--INFORMACOES DA TABELA LLP    
--@Process1Status    
Declare @PlaceofReceipt varchar(50)    
Declare @Container1Type varchar(120)    
Declare @Dispatch1Type varchar(30)    
Declare @Container1Qty int    
Declare @Carrier varchar(30)    
Declare @Containers varchar(2000)    
Declare @TEUS1Qtys int    
    
---VOLUME    
Declare @Packing varchar(30)    
 if left(@num_proc,2)='IA'    
   Begin    
    Select  @Forwarder=Apelido,    
     @process1Status=    
     (    
      case    
       when Status_Descricao is not null then cast(TSP.id_status as varchar(2)) + ' - ' + Status_Descricao    
       else Null    
      End     
     ),    
     @PlaceofReceipt = LC.Nome_Local,    
     @Dispatch1Type = 'Air'      
    from LLP_Imp_aer  LLP with(nolock)    
    Left Join Pessoa PP with(nolock) on pp.cd_pes=cd_forwarder     
    Left Join Tipo_Status_Processo TSP with(nolock) on LLP.id_status=TSP.id_Status    
    Left Join Localidade LC with(nolock) on LLP.Cd_Planta_LIA = LC.Cd_Local    
    Where Num_proc_lia=@Num_Proc    
        
    Select Distinct @Packing=TE.Nome_Tp_Embal from Volume_imp_Aer EMB with(nolock)    
    left join tipo_embalagem TE with(nolock) on TE.Cd_tp_Embal = EMB.Cd_Tp_Embal    
    where EMB.Num_Proc_HIA = @Num_Proc    
        
    Select @Carrier = left(CIa.Nome_Cia_Aer,30) from Job_Imp_Aer JOB with(nolocK)    
    Left Join Cia_Aerea CIA with(nolock) on CIA.cd_cia_Aer=job.cd_cia_aer    
    where Num_Proc_HIA = @Num_Proc    
        
   End    
    
 if left(@num_proc,2)='IM'    
   Begin    
    Select  @Forwarder=Apelido,    
     @process1Status=    
     (    
      case    
       when Status_Descricao is not null then cast(TSP.id_status as varchar(2)) + ' - ' + Status_Descricao    
       else Null    
      End     
     ),    
     @PlaceofReceipt = LC.Nome_Local,    
     @Dispatch1Type =(Case when LLP.Cd_Tp_Carga = '1' then 'Vessel-Container' else --FCL    
          Case when LLP.Cd_Tp_Carga = '2' then 'Vessel-Container' else --LCL    
          Case when LLP.Cd_Tp_Carga = '3' then 'BULK' --BULK    
          else NULL end end end)    
    from LLP_Imp_Mar  LLP with(nolock)    
    Left Join Pessoa PP with(nolock) on pp.cd_pes=cd_forwarder     
    Left Join Tipo_Status_Processo TSP with(nolock) on LLP.id_status=TSP.id_Status    
    Left Join Localidade LC with(nolock) on LLP.Cd_Planta_LIM = LC.Cd_Local    
    Where Num_proc_lim=@Num_Proc    
        
    set @Container1Type = left([dbo].[fBusca_Containers_TP](@Num_Proc),120)    
        
    Select Distinct @Packing =TE.Nome_Tp_Embal from Volume_imp_Mar EMB with(nolock)    
    left join tipo_embalagem TE with(nolock) on TE.Cd_tp_Embal = EMB.Cd_Tp_Embal    
    where EMB.Num_Proc_HIM = @Num_Proc    
    set @Container1Qty =[dbo].[Qty_Container](@Num_Proc)    
        
    Select @Carrier = left(CIa.Nome_Armador,30) from Job_Imp_mar JOB with(nolocK)    
    Join Armador CIA with(nolock) on CIA.cd_armador=job.cd_armador    
    where JOB.Num_Proc_HIM = @Num_Proc    
        
    set @Containers = left(dbo.[fBusca_Containers_IM](@Num_Proc),2000)    
    set @TEUS1Qtys = dbo.fBusca_TEUS(@Num_Proc)    
   End    
    
 if left(@num_proc,2)='IO'    
   Begin    
    Select  @Forwarder=PP.Apelido,    
     @process1Status=    
     (    
      case    
       when Status_Descricao is not null then cast(TSP.id_status as varchar(2)) + ' - ' + Status_Descricao    
       else Null    
      End     
     ),    
     @PlaceofReceipt = LC.Nome_Local,    
     @Dispatch1Type =(Case when LLP.Tipo_Lio = 'R' then 'Rail' else     
          Case when LLP.Tipo_Lio = 'T' then 'Truck' else     
          NULL end end),    
     @Carrier = left(CIA.Apelido,30)    
    from LLP_Imp_out  LLP with(nolock)    
    Left Join Pessoa PP with(nolock) on pp.cd_pes=cd_forwarder     
    Left Join Tipo_Status_Processo TSP with(nolock) on LLP.id_status=TSP.id_Status    
    Left Join Localidade LC with(nolock) on LLP.Cd_Planta_LIO = LC.Cd_Local    
    LEft Join Pessoa CIA with(nolock)  on CIA.cd_pes=LLP.cd_carrier    
    Where Num_proc_lio=@Num_Proc    
        
    Select Distinct @Packing=TE.Nome_Tp_Embal from Volume_imp_OUT EMB with(nolock)    
    left join tipo_embalagem TE with(nolock) on TE.Cd_tp_Embal = EMB.Cd_Tp_Embal    
    where EMB.Num_Proc_HIO = @Num_Proc    
   End    
 if left(@num_proc,2)='EO'    
   Begin    
    Select  @Forwarder=PP.Apelido,    
     @process1Status=    
     (    
      case    
       when Status_Descricao is not null then cast(TSP.id_status as varchar(2)) + ' - ' + Status_Descricao    
       else Null    
      End     
     ),    
     @PlaceofReceipt = LC.Nome_Local,    
     @Dispatch1Type =(Case when LLP.Tipo_Leo = 'R' then 'Rail' else     
          Case when LLP.Tipo_Leo = 'T' then 'Truck' else     
          NULL end end),    
     @Carrier = left(CIA.Apelido ,30)    
    from LLP_exp_out  LLP with(nolock)    
    Left Join Pessoa PP with(nolock) on pp.cd_pes=cd_forwarder     
    Left Join Tipo_Status_Processo TSP with(nolock) on LLP.id_status=TSP.id_Status    
    Left Join Localidade LC with(nolock) on LLP.Cd_Planta_LEO = LC.Cd_Local    
    Left Join Pessoa CIA with(nolock) on CIA.cd_pes=LLP.cd_carrier    
    Where Num_proc_leo=@Num_Proc    
        
    Select Distinct @Packing=TE.Nome_Tp_Embal from Volume_Exp_OUT EMB with(nolock)    
    left join tipo_embalagem TE with(nolock) on TE.Cd_tp_Embal = EMB.Cd_Tp_Embal    
    where EMB.Num_Proc_HEO = @Num_Proc    
   End    
--Declare @Dead1Line1Draft_Date datetime    
Declare @Dead1Line1Draft_DT datetime    
--Declare @Cut1off_Date datetime    
Declare @Cut1off_DT datetime    
    
Declare @VGM1DeadLine_DT datetime    
 if left(@num_proc,2)='EM'    
   Begin    
    Select  @Forwarder=Apelido,    
     @process1Status=    
     (    
      case    
       when Status_Descricao is not null then cast(TSP.id_status as varchar(2)) + ' - ' + Status_Descricao    
       else Null    
      End     
     ),    
     @PlaceofReceipt = LC.Nome_Local,     
     @Dispatch1Type =(Case when LLP.Cd_Tp_Carga = '1' then 'Vessel-Container' else --FCL    
          Case when LLP.Cd_Tp_Carga = '2' then 'Vessel-Container' else --LCL    
          Case when LLP.Cd_Tp_Carga = '3' then 'BULK' --BULK    
          else NULL end end end),    
     @Carrier = left(CIA.Nome_Armador,30),    
     @Dead1Line1Draft_DT = LLP.DL_Draft_Lem,    
     @Cut1off_DT  = LLP.DL_Cargo_Lem,    
     @VGM1DeadLine_DT = LLP.DL_VGM_Lem    
    from LLP_exp_mar  LLP with(nolock)    
    Left Join Pessoa PP with(nolock) on pp.cd_pes=cd_forwarder     
    Left Join Tipo_Status_Processo TSP with(nolock) on LLP.id_status=TSP.id_Status    
    Left Join Localidade LC with(nolock) on LLP.Cd_Planta_LEM = LC.Cd_Local    
    LEFT Join Armador CIA with(nolock) on CIA.cd_armador=cd_armador_lem    
    Where Num_proc_lem=@Num_Proc    
    set @Container1Type = left([dbo].[fBusca_Containers_TP](@Num_Proc),120)    
        
    Select Distinct @Packing =TE.Nome_Tp_Embal from Volume_Exp_Mar EMB with(nolock)    
    left join tipo_embalagem TE with(nolock) on TE.Cd_tp_Embal = EMB.Cd_Tp_Embal    
    where EMB.Num_Proc_HEM = @Num_Proc    
    set @Container1Qty =[dbo].[Qty_Container](@Num_Proc)    
    set @Containers = left(DBO.fBusca_Containers(@Num_Proc),2000)    
    set @TEUS1Qtys = dbo.fBusca_TEUS(@Num_Proc)    
   End    
    
 if left(@num_proc,2)='EA'    
   Begin    
    Select  @Forwarder=Apelido,    
     @process1Status=    
     (    
      case    
       when Status_Descricao is not null then cast(TSP.id_status as varchar(2)) + ' - ' + Status_Descricao    
       else Null    
      End     
     ),    
     @PlaceofReceipt = LC.Nome_Local,     
     @Dispatch1Type = 'Air',    
     @Carrier=left(CIA.Nome_Cia_Aer,30)    
    from LLP_exp_aer  LLP with(nolock)    
    Left Join Pessoa PP with(nolock) on pp.cd_pes=cd_forwarder     
    Left Join Tipo_Status_Processo TSP with(nolock) on LLP.id_status=TSP.id_Status    
    Left Join Localidade LC with(nolock) on LLP.Cd_Planta_LEA = LC.Cd_Local    
    Left Join Cia_Aerea CIA with(nolock) on CIA.cd_cia_Aer=LLP.Cd_CiaAerea_Lea    
    Where Num_proc_lea=@Num_Proc    
        
    Select Distinct @Packing=TE.Nome_Tp_Embal from Volume_Exp_Aer EMB with(nolock)    
    left join tipo_embalagem TE with(nolock) on TE.Cd_tp_Embal = EMB.Cd_Tp_Embal    
    where EMB.Num_Proc_HEA = @Num_Proc       
   End    
    
    
--@AdvancementValue,@AdvancementValue    
 Declare @Adiantamento Table    
  (    
   AdvancementReceivedDate Datetime,    
   AdvancementValue  Varchar(15)    
       
  )    
 Insert @Adiantamento    
 select max(convert(datetime,dt_pgto_rcto_hia,105)) data,cast(sum(vlr_pgto_Rcto_hia) as varchar(15)) Valor from vwcxas with (nolock) where num_proc_hia=@Num_Proc and dc_hia='C' and cd_tp_Tx in (select cd_tp_Tx from tipo_taxa with(nolock)  where CD_AX_Resultado = '900.1' and nome_tp_Tx not like 'Presta%')     
--FIM    
    
--@WarehousePaymentDate    
  Set @WarehousePaymentDate=(select max(convert(datetime,dt_pgto_rcto_hia,105)) data from vwcxas with (nolock) where num_proc_hia=@Num_Proc and dc_hia='D' and cd_tp_Tx in (select cd_tp_Tx from tipo_taxa with(nolock) where nome_tp_tx like 'Armazenagem%')) 
  
    
     
    
--Pagamento SDA    
    
Declare @SDA1Payment1Date Datetime    
    
  Set @SDA1Payment1Date=(select max(convert(datetime,dt_pgto_rcto_hia,105)) data from vwcxas with (nolock) where num_proc_hia=@Num_Proc and dc_hia='D' and cd_tp_Tx in (select cd_tp_Tx from tipo_taxa with(nolock) where nome_tp_tx like 'SDA%'))    
    
    
Set @Usuario=    
 (    
  Select Top 1 Nome_usuario from vwcliente with(nolock)    
  Join Pessoa_LLP PP with(nolock) on pp.cd_pes=cd_cliente    
  Join Campo_Pessoa CP with(nolock) on CP.cd_pes=cd_pes_grupo and id_campo=6    
  Join Usuario US with(nolock) on campo_dados=US.cd_usuario    
  Where    
   Num_Proc=@Num_Proc    
  )    
    
    
    
Declare @BL1Pieces varchar(40)    
    
    
if left(@Num_Proc,2)='EM'    
 Begin    
  Set @FreightType=(Select case tp_frete_hem when 'P' then 'Prepaid' when 'C' then 'Collect' End from house_exp_mar with (nolock) where num_proc_hem=@Num_Proc)    
  Set @SurveyRequestDate=(select top 1 convert(Datetime,campo_dados,103) from @CampoProcesso_Temp where num_proc=@Num_Proc and id_campo=124 and campo_dados is not null)    
  Set @BL1Pieces=(Select Qtd_Tot_Vol_HEM from house_exp_mar with (nolock) where num_proc_hem=@Num_Proc)    
 End    
 if left(@Num_Proc,2)='IM'    
  Begin    
   Set @BL1Pieces=(Select Qtd_Tot_Vol_HIM from House_Imp_Mar with (nolock) where Num_Proc_HIM=@Num_Proc)    
  End    
if left(@Num_Proc,2)='IO'    
 Begin    
  Set @FreightType=(Select case tp_frete_hio when 'P' then 'Prepaid' when 'C' then 'Collect' End from house_imp_out with (nolock) where num_proc_hio=@Num_Proc)    
  Set @BL1Pieces=(Select Qtd_Tot_Vol_HIO from House_Imp_Out with (nolock) where Num_Proc_HIO=@Num_Proc)    
 End    
    
if left(@Num_Proc,2)='EO'    
 Begin    
  Set @FreightType=(Select case tp_frete_heo when 'P' then 'Prepaid' when 'C' then 'Collect' End from house_exp_out with (nolock) where num_proc_heo=@Num_Proc)    
  Set @BL1Pieces=(Select Qtd_Tot_Vol_HEO from House_Exp_Out with (nolock) where Num_Proc_HEO=@Num_Proc)    
 End    
     
    
    
if left(@Num_Proc,2)='IA'    
 Begin    
  Set @FreightType=(Select case tp_frete_hia when 'P' then 'Prepaid' when 'C' then 'Collect' End from house_imp_aer with (nolock) where num_proc_hia=@Num_Proc)    
  Set @BL1Pieces=(Select Qtd_Tot_Vol_HIA from House_Imp_Aer with (nolock) where Num_Proc_HIA=@Num_Proc)    
 End    
    
if left(@Num_Proc,2)='EA'    
 Begin    
  Set @FreightType=(Select case tp_frete_hea when 'P' then 'Prepaid' when 'C' then 'Collect' End from house_exp_aer with (nolock) where num_proc_hea=@Num_Proc)    
  Set @BL1Pieces=(Select Qtd_Tot_Vol_HEA from House_Exp_Aer with (nolock) where Num_Proc_HEA=@Num_Proc)    
 End    
    
Set @DueDateSupplier=(select top 1 convert(datetime,campo_dados,105) from @CampoProcesso_Temp where num_proc=@num_proc and id_campo=29)    
    
    
Declare @Invoice varchar(80)    
Set @Invoice = (Select left(dbo.fBusca_Docs_PO_Modal(@Num_Proc,2),80))    
    
--cadu 09/02/2015    
Declare @QttyofUnits float    
 BEGIN    
  Set @QttyofUnits = (select sum(Quantidade)from DI_Item_BR with(nolock) Where Num_Proc=@Num_Proc)    
 END    
--Select replace(cast(@QttyofUnits as varchar(40)),',','.') Qtty1of1Units    
    
Declare @Courier varchar(20)    
 BEGIN    
  Set @Courier =     
   (    
    select top 1 Apelido from Courier_Processo CP with(nolock)    
    left join Pessoa P with(nolock) on CP.Cd_Pes = P.Cd_Pes    
    where     
     CP.Num_Proc =@Num_Proc    
   )    
 END    
    
Declare @Courier1Number varchar(50)    
 BEGIN    
  Set @Courier1Number =     
   (    
    select top 1 Num_Courier from Courier_Processo with(nolock)    
    where Num_Proc=@Num_Proc and ID_Tp_Courier = 1    
   )    
 END    
     
     
--Campos que eram direto no Report Manager - agora sao feitos aqui    
Declare @Total1Siscomex1Value1by1Shipment decimal(18,2)    
Declare @Total11Taxes1Value1by1Shipment decimal(18,2)    
if LEFT(@Num_Proc,1) = 'I'    
 BEGIN    
  --[Total Siscomex Value by Shipment]=isnull([Fines by Shipment],0)+isnull([Cofins Value by Shipment],0)+isnull([PIS Value by Shipment],0)+isnull([IPI Value by Shipment],0)+isnull([Import Duties Value by Shipment],0)+isnull([Siscomex Debit Value by Shipment],0),    
  set @Total1Siscomex1Value1by1Shipment = isnull(@Cofins1Value1by1Shipment,0)+isnull(@PIS1Value1by1Shipment,0)+isnull(@IPI1Value1by1Shipment,0)+    
  isnull(@Import1Duties1Value1by1Shipment,0)+isnull(@Siscomex1Debit1Value1by1Shipment,0)    
  --obs: nao encontrei este campo isnull([Fines by Shipment],0)+    
    
  --[Total  Taxes Value by Shipment]=Isnull([State Tax by Shipment],0)+Isnull([Total Siscomex Value by Shipment],0)    
  set @Total11Taxes1Value1by1Shipment = Isnull(@Total1Siscomex1Value1by1Shipment,0)     
 END    
    
--Declare @Insurance1Value float    
-- set @Insurance1Value =(select top 1 vlr_seguro from invoice_cliente with(nolock)     
-- where num_proc = @Num_Proc and left(@Num_Proc,1) = 'E'    
-- order by id_inv desc)    
    
Declare @BankerA3s1Draft varchar(50)    
set @BankerA3s1Draft=(select campo_dados from @CampoProcesso_Temp where num_proc=@Num_Proc and id_campo=118)    
    
Declare @BB1Protocol varchar(50)    
Declare @Government1Agency varchar(50)    
Declare @DTA1Clearance_Number varchar(50)    
Declare @Qty_Truck int    
Declare @Time1to1Delivery varchar(100)    
Declare @Entry1Number varchar(100)    
Declare @Customs1Transmission1Date datetime    
Declare @Transit1Register1DTA_Date datetime    
Declare @CSR1Name varchar(30)    
Declare @Agent varchar(50)    
Declare @Freight1BL varchar(20)    
Declare @Consol1RefA7 varchar(16)    
Declare @ChargA71Weight_Shipment_Value float    
Declare @Gross1Weight_Shipment_Value float    
Declare @Netweight1KG81Shipment float    
Declare @Voyage varchar(30)    
Declare @Cd_Grupo varchar(12)    
Declare @Register1Date datetime    
Declare @Origin varchar(50)    
Declare @Country1of1Origin varchar(50)    
Declare @Destination varchar(50)    
Declare @Country1of1Destination varchar(50)    
Declare @Master varchar(30)    
Declare @House varchar(30)    
Declare @Group1Name varchar(40)    
Declare @Sales1Person varchar(50)    
Declare @Modal varchar(20)    
Declare @Import1A61Export varchar(15)    
Declare @Booking1Number varchar(80)    
if LEFT(@Num_Proc,1) = 'I'    
 BEGIN    
   select  @Government1Agency = COALESCE(@Government1Agency +';','')+ ltrim(rtrim(nome_orgao_anuente)) from solicitacao_li_orgao_anuente SLA with(nolock)    
   Join Solicitacao_LI SL with(nolock) on SL.num_solicitacao=SLA.num_solicitacao    
   Join Orgao_Anuente OA with(nolock) on OA.ID_orgao=SLA.id_orgao_anuente    
   Where num_proc=@Num_Proc group by nome_orgao_anuente    
      
   set @BB1Protocol = (select top 1 protocolo_transmissao from solicitacao_li with(nolock) where num_proc=@num_proc)    
   set @Transit1Register1DTA_Date =  cast(dbo.fBusca_TipoDocCliente('D',@num_proc,45) as datetime)    
   select @DTA1Clearance_Number = dbo.fBusca_TipoDocCliente('N',@Num_Proc,45)     
   set @Qty_Truck = (select top 1 campo_Dados from @CampoProcesso_Temp where id_campo=94 and num_proc=@Num_Proc)    
   set @Time1to1Delivery = (select top 1 campo_Dados from @CampoProcesso_Temp where id_campo=93 and num_proc=@Num_Proc)    
   set @Entry1Number = left(dbo.fBusca_TipoDocCliente('N',@Num_Proc,5),100)    
   set @Customs1Transmission1Date = cast(dbo.fBusca_TipoDocCliente('D',@Num_Proc,5) as datetime)    
       
   select @CSR1Name = U.Nome_Usuario, @Agent = AGT.Apelido,    
   --@Freight1BL = HOU.Moeda_Frete +  replace(cast(cast(HOU.Frete_BL as decimal(18,2)) as varchar(20)),'.',','),    
   @Freight1BL = HOU.Moeda_Frete +  REPLACE(REPLACE(REPLACE(CONVERT(varchar(20),CONVERT(money,Frete_BL), 1),'.','?'),',','.'),'?',','), --Incluido Por Rafael Lindenberg - Formato BLR    
   @Consol1RefA7 = (Case when HOU.Master = 'JOB' then NULL else HOU.Master End),    
   @ChargA71Weight_Shipment_Value = HOU.Peso_Cubado, @Gross1Weight_Shipment_Value =HOU.Peso_Bruto, @Netweight1KG81Shipment = HOU.Peso_Liquido,    
   @Voyage = HOU.Viagem,@Cd_Grupo = PL.Cd_Pes_Grupo, @Register1Date = convert(Datetime,HOU.dt_emis,105),@Origin = Org.Nome_Local,    
   @Country1of1Origin = POrigem.Nome_Pais,@Master = left(HOU.MAWB,30),@HOUSE= left(HOU.HAWB,30),@Destination = Dst.Nome_Local,    
   @Country1of1Destination = PDestino.Nome_Pais,@Group1Name=GRP.Apelido, @Sales1Person = V.Nome_Usuario, @Modal = HOU.Modal, @Booking1Number = HOU.Booking_Number    
   from vwHouse_Imp HOU with(nolock)    
   left join Usuario U with(nolock) on HOU.cd_usuario = U.Cd_Usuario    
   Left Join Pessoa AGT with(nolock) on AGT.cd_pes=HOU.cd_agente    
   Left join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig = PL.Cd_Pes    
   left Join Localidade Org with(nolock) on Org.cd_local=cd_org    
   left Join Pais POrigem with(nolock) on POrigem.cd_pais=Org.cd_pais    
   left Join Localidade Dst with(nolock) on DST.cd_local=cd_dst    
   left Join Pais PDestino with(nolock) on PDestino.cd_pais=DST.cd_pais    
   Left Join Pessoa GRP with(nolock) on PL.Cd_Pes_Grupo = GRP.Cd_Pes    
   Left Join Usuario V with(nolock) on HOU.Cd_Vendedor=V.Cd_Usuario    
   where Num_Proc = @Num_Proc    
    
   set @Import1A61Export = 'Import'    
       
 END    
    
Declare @ArkTec1Number varchar(30)    
Declare @DDE1Number varchar(80)    
Declare @DDE_Date datetime    
    
if LEFT(@Num_Proc,1) = 'E'    
 BEGIN     
     
  set @Government1Agency = (select nome_orgao_anuente from @CampoProcesso_Temp CP    
  join orgao_anuente OA with(nolock) on OA.id_orgao = CP.campo_dados    
  where CP.id_campo = 122 and CP.num_proc = @Num_Proc)    
  Set @ArkTec1Number = dbo.fBusca_TipoDocCliente('N',@Num_Proc,30)    
  set @Entry1Number = left(dbo.fBusca_TipoDocCliente('N',@Num_Proc,4),100)    
  set @Customs1Transmission1Date = cast(dbo.fBusca_TipoDocCliente('D',@Num_Proc,4) as datetime)    
  set @DDE_Date = cast(dbo.fBusca_TipoDocCliente('D',@Num_Proc,12) as datetime)    
  set @DDE1Number = left(dbo.fBusca_TipoDocCliente('N',@Num_Proc,12),80)    
      
  select @CSR1Name = U.Nome_Usuario, @Agent = (Case when LEFT(@Num_Proc,2) = 'EM' then left(AGT.Nome_Raz_Soc,50) else AGT.Apelido End),     
  --@Freight1BL = HOU.Moeda_Frete +  replace(cast(cast(HOU.Frete_BL as decimal(18,2)) as varchar(20)),'.',','),    
  @Freight1BL = HOU.Moeda_Frete + REPLACE(REPLACE(REPLACE(CONVERT(varchar(20),CONVERT(money,Frete_BL), 1),'.','?'),',','.'),'?',','), --Incluido Por Rafael Lindenberg - Formato BLR    
  @Consol1RefA7 = (Case when HOU.Master = 'JOB' then NULL else HOU.Master End),    
  @ChargA71Weight_Shipment_Value = HOU.Peso_Cubado,@Gross1Weight_Shipment_Value =HOU.Peso_Bruto, @Netweight1KG81Shipment = HOU.Peso_Liquido,    
  @Voyage = HOU.Viagem, @Cd_Grupo = PL.Cd_Pes_Grupo, @Register1Date = convert(Datetime,HOU.dt_emis,105),@Origin = Org.Nome_Local,    
  @Country1of1Origin = POrigem.Nome_Pais,@Master = left(HOU.MAWB,30),@HOUSE= left(HOU.HAWB,30),@Destination = Dst.Nome_Local,    
  @Country1of1Destination = PDestino.Nome_Pais,@Booking1Number=replace(replace(left(HOU.Booking_Number,40),'=',''),'/',''),    
  @Group1Name=GRP.Apelido,@Sales1Person = V.Nome_Usuario,@Modal = HOU.Modal    
  from vwHouse_Exp HOU with(nolock)    
  left Join Usuario U with(nolock) on HOU.cd_usuario = U.Cd_Usuario    
  Left Join Pessoa AGT with(nolock) on AGT.cd_pes=HOU.cd_agente    
  Left join Pessoa_LLP PL with(nolock) on HOU.Cd_Export = PL.Cd_Pes    
  left Join Localidade Org with(nolock) on Org.cd_local=cd_org    
  left Join Pais POrigem with(nolock) on POrigem.cd_pais=Org.cd_pais    
  left Join Localidade Dst with(nolock) on DST.cd_local=cd_dst    
  left Join Pais PDestino with(nolock) on PDestino.cd_pais=DST.cd_pais    
  Left Join Pessoa GRP with(nolock) on PL.Cd_Pes_Grupo = GRP.Cd_Pes    
  Left Join Usuario V with(nolock) on HOU.Cd_Vendedor=V.Cd_Usuario    
  where Num_Proc = @Num_Proc    
  set @Import1A61Export = 'Export'    
 END    
     
if LEFT(@Num_Proc,1) = 'B'    
 BEGIN    
  select     
   @CSR1Name = U.Nome_Usuario,     
   @Cd_Grupo = PL.Cd_Pes_Grupo,     
   @Register1Date = convert(Datetime,HOU.dt_emis,105),       
   @Modal = HOU.Modal,    
   @Group1Name=GRP.Apelido    
  from vwHouse_BDP_OUT HOU with(nolock)    
  left Join Usuario U with(nolock) on HOU.cd_usuario = U.Cd_Usuario    
  Left join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig = PL.Cd_Pes      
  Left Join Pessoa GRP with(nolock) on PL.Cd_Pes_Grupo = GRP.Cd_Pes    
  where Num_Proc = @Num_Proc    
  set @Import1A61Export = 'BDP Others'    
 END     
Declare @Payment1Term varchar(100)    
set @Payment1Term =( select ISNULL(TMI.descricao_Termo,TMC.Descricao_Termo) from vwCliente C With(nolock)    
 left join  @CampoProcesso_Temp CP on C.num_proc = CP.Num_Proc and id_campo=87    
 Left Join Termo_Pagamento TMC with(nolock) on TMC.cd_termo=CP.campo_Dados    
 Left Join invoice_cliente INV With(nolock) on C.num_proc = INV.Num_Proc    
 Left Join Termo_Pagamento TMI with(nolock) on TMI.cd_termo=INV.cd_termo    
where C.num_proc=@num_Proc)    
    
Declare @BL1Description varchar(400)    
Set @BL1Description = (select Left(Replace(descr, '''', ''), 400) descr  from nature_goods With(nolock) where num_proc=@num_proc)    
    
    
Declare @Last1Historic varchar(2000)    
 select @Last1Historic = dbo.fBusca_HistoricoDescr(@Num_Proc,0,getdate())      
Declare @Real1Deposit_Date datetime    
 select @Real1Deposit_Date = dbo.fBusca_Historico(@Num_Proc,56,getdate())    
Declare @Volume1Description varchar(600)    
 select @Volume1Description =dbo.fBusca_Volumes(@Num_Proc)     
Declare @Cd9BDP1Last1Historic varchar(2000)    
 select @Cd9BDP1Last1Historic = dbo.fBusca_HistoricoDescr_Completo(@Num_Proc)    
    
Declare @Last1Historic1Client varchar(600)    
 select @Last1Historic1Client = [dbo].[fBusca_HistoricoDescr](@Num_Proc,116,GETDATE())    
    
Declare @Courier1Number_2nd varchar(40)--=@CourierNumber2nd,    
Declare @Courier1Number12nd_Date datetime--=@CourierNumber2ndDate    
Declare @cd9Courier13rd1Number varchar(40)--=@CourierNumber3rd,    
Declare @cd9Courier13rd1Date datetime--=@CourierNumber3rdDate,    
    
select @Courier1Number_2nd = num_courier,@Courier1Number12nd_Date=Dt_Courier from  Courier_Processo  with(nolock) where num_proc = @Num_Proc and ID_Item = 2    
select @cd9Courier13rd1Number=num_courier,@cd9Courier13rd1Date=Dt_Courier from  Courier_Processo  with(nolock) where num_proc = @Num_Proc and ID_Item = 3    
    
Declare @Form1A varchar(30)    
set @Form1A = dbo.fBusca_TipoDocCliente('N',@Num_Proc,14)    
    
Declare @RE1Number varchar(100)    
set @RE1Number = dbo.fBusca_TipoDocCliente('N',@Num_Proc,04)    
    
Declare @Department1WM varchar(40)    
set @Department1WM = (select campo_Dados from @CampoProcesso_Temp where id_campo=13 and num_proc=@Num_Proc)    
    
Declare @Area varchar(30)    
set @Area = (select campo_Dados from @CampoProcesso_Temp where id_campo=24 and num_proc=@Num_Proc)    
    
Declare @Division varchar(30)    
set @Division = (select campo_Dados from @CampoProcesso_Temp where id_campo=11 and num_proc=@Num_Proc)    
    
Declare @Invoice1Date datetime    
set @Invoice1Date = dbo.fBusca_TipoDocCliente('D',@Num_Proc,2)    
    
Declare @RC1Number varchar(30)    
set @RC1Number = dbo.fBusca_TipoDocCliente('N',@Num_Proc,91)    
    
Declare @ETA1Transhipment1Port_Date datetime    
set @ETA1Transhipment1Port_Date = (select convert(datetime,Campo_Dados,105) from @CampoProcesso_Temp where id_campo=85 and num_proc=@Num_Proc)    
    
Declare @A4st1Vessel1Voyage varchar(50)    
set  @A4st1Vessel1Voyage = (select campo_Dados from @CampoProcesso_Temp where id_campo=84 and num_proc=@Num_Proc)    
    
Declare @CE1Mercante1Master varchar(40)    
set @CE1Mercante1Master = dbo.fBusca_TipoDocCliente('N',@Num_Proc,85)    
Declare @CE1Mercante varchar(50)    
set @CE1Mercante = left(dbo.fBusca_TipoDocCliente('N',@Num_Proc,29),50)    
    
Declare @Agent1Invoice1Number varchar(40)    
set @Agent1Invoice1Number = dbo.fBusca_TipoDocCliente('N',@Num_Proc,74)    
    
Declare @Liberação1Laudo varchar(50)    
set @Liberação1Laudo = (select campo_Dados from @CampoProcesso_Temp where id_campo=38 and num_proc=@Num_Proc)    
    
Declare @Volume1descarregado1em1Santos float    
set @Volume1descarregado1em1Santos = (select campo_Dados from @CampoProcesso_Temp where id_campo=37 and num_proc=@Num_Proc)    
    
Declare @Customer1PO varchar(30)    
set @Customer1PO = left(dbo.fBusca_TipoDocCliente('N',@Num_Proc,9),30)    
    
Declare @LI1Date datetime    
set @LI1Date = cast(dbo.fBusca_TipoDocCliente('D',@Num_Proc,23) as datetime)    
    
    
    
Declare @Import1License varchar(500)    
set @Import1License = dbo.fBusca_Docs_PO_Modal(@Num_Proc,'23')    
    
    
Declare @Necessidade1de1LIA5 varchar(3)    
Set @Necessidade1de1LIA5 = (select (case Campo_Dados when '1' then 'SIM' when '2' then 'NÃO' end) from @CampoProcesso_Temp  where id_campo = '5' and num_proc=@Num_Proc)    
    
Declare @Sales1Order varchar(80)    
set @Sales1Order = dbo.fBusca_TipoDocCliente('N',@Num_Proc,3)    
    
Declare @Order1Date datetime    
set @Order1Date = cast((dbo.fBusca_TipoDocCliente('D',@Num_Proc,3)) as datetime)    
    
Declare @NF1Date datetime    
Declare @NF1Number varchar(500)    
set @NF1Number = dbo.fBusca_Docs_PO_Modal(@Num_Proc,'10')    
set @NF1Date = cast(dbo.fBusca_TipoDocCliente('D',@Num_Proc,10) as datetime)    
    
Declare @Shipment1Number varchar(80)    
set @Shipment1Number=  left(dbo.fBusca_TipoDocCliente('N',@Num_Proc,8),80)    
    
Declare @COA1Number varchar(50)    
set @COA1Number =  left(dbo.fBusca_TipoDocCliente('N',@Num_Proc,16),50)    
    
--Incluido por Rafael Lindenberg - 11/08/2017    
    
Declare @DUE1Number varchar(500) --204     
Declare @DUE1Date datetime --204    
set @DUE1Number =  left(dbo.fBusca_TipoDocCliente('N',@Num_Proc,204),500)    
set @DUE1Date =  left(dbo.fBusca_TipoDocCliente('D',@Num_Proc,204),500)    
    
Declare @RUC1Number varchar(500)--205    
set @RUC1Number =  left(dbo.fBusca_TipoDocCliente('N',@Num_Proc,205),500)    
    
Declare @MRUC1Number varchar(500)--206    
set @MRUC1Number =  left(dbo.fBusca_TipoDocCliente('N',@Num_Proc,206),500)    
    
Declare @DAT1Number varchar(500)--207    
Declare @DAT1Date datetime --207    
set @DAT1Number =  left(dbo.fBusca_TipoDocCliente('N',@Num_Proc,207),500)    
set @DAT1Date =  left(dbo.fBusca_TipoDocCliente('D',@Num_Proc,207),500)    
    
Declare @Permiso1de1Embarque_Number varchar(500)--207    
set @Permiso1de1Embarque_Number =  left(dbo.fBusca_TipoDocCliente('N',@Num_Proc,117),500)    
    
Declare @MICA6DTA_Number varchar(500)--207    
set @MICA6DTA_Number =  left(dbo.fBusca_TipoDocCliente('N',@Num_Proc,116),500)    
    
Declare @Urgent1YA6N char(1)    
--set @Urgent1YA6N = isnull(dbo.fBusca_CampoCliente(@Num_Proc,36),'N')    
set @Urgent1YA6N =(select (case isnull(dbo.fBusca_CampoCliente(@Num_Proc,36),'N') when '1' then 'Y' when '2' then 'N' else isnull(dbo.fBusca_CampoCliente(@Num_Proc,36),'N')  end))    
    
Declare @CHB1YA6N char(1)    
set @CHB1YA6N = (select (case isnull(dbo.fBusca_CampoCliente(@Num_Proc,32),'N') when '1' then 'Y' when '2' then 'N' else isnull(dbo.fBusca_CampoCliente(@Num_Proc,32),'N')  end)CHB)    
    
Declare @BDP1Product varchar(50)    
set @BDP1Product = (select Nome_BDP_Produto from @CampoProcesso_Temp Join BDP_Produto P with(nolock)  on P.ID_PD=campo_dados where num_proc=@Num_Proc and ID_Campo=143)    
    
Declare @BDP1System1Code varchar(10)    
set @BDP1System1Code = 'ATLBR'    


set @Report1DamagedY6AN =(select (case isnull(dbo.fBusca_CampoCliente(@Num_Proc,9),'N') when '1' then 'Y' when '2' then 'N' else isnull(dbo.fBusca_CampoCliente(@Num_Proc,9),'N')  end))    --100-232189
set @Cargo1Damaged1Description = (select left(Campo_Dados,40) from @CampoProcesso_Temp where id_campo=114) --100-232189

    
--Incluido por Rafael Lindenberg - 11/08/2017     
    
Declare @DUE1Access1Key1Number varchar(50)    
set @DUE1Access1Key1Number = dbo.fBusca_TipoDocCliente('N',@Num_Proc,209)    
    
Declare @CHB1Collaborator varchar(30)    
set @CHB1Collaborator = (select U.Nome_Usuario from @CampoProcesso_Temp C    
      join usuario U with (nolock)  on C.Campo_Dados = U.Cd_Usuario    
      where id_campo=167 and num_proc=@Num_Proc)    
    
Declare @Receipt1Sent_Transportation_Date DateTime    
 Set @Receipt1Sent_Transportation_Date=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=210 and dt_conclusao is not null)    
    
Declare @DGR1Request1Docs_Date DateTime    
 Set @DGR1Request1Docs_Date=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=212 and dt_conclusao is not null)    
    
Declare @DTA1Request1Docs_Date DateTime    
 Set @DTA1Request1Docs_Date=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=213 and dt_conclusao is not null)    
     
Declare @PDF_Shipping1Instructions Varchar(3)    
if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=47)    
 Begin    
  Set @PDF_Shipping1Instructions='YES'    
 End    
Else    
 Begin    
  Set @PDF_Shipping1Instructions='NO'    
 End    
     
Declare @PDF_Commercial1Proposal Varchar(3)    
if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=188)    
 Begin    
  Set @PDF_Commercial1Proposal='YES'    
 End    
Else    
 Begin    
  Set @PDF_Commercial1Proposal='NO'    
 End    
    
Declare @PC1Draft1Send_Date DateTime    
 Set @PC1Draft1Send_Date=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=191 and dt_conclusao is not null)    
    
Declare @Protocol1MAPA1IN26_Date DateTime    
 Set @Protocol1MAPA1IN26_Date=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=216 and dt_conclusao is not null)    
    
Declare @BOL1Post1Audit1Back_Date DateTime    
 Set @BOL1Post1Audit1Back_Date=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=217 and dt_conclusao is not null)    
    
Declare @Entry1Terminal varchar(50)    
set @Entry1Terminal = (select T.Nome_Terminal from @CampoProcesso_Temp C join Terminal T with(nolock) on C.Campo_Dados = T.Cd_Terminal where id_campo=2 and num_proc=@Num_Proc)    
    
--206 Billing Authorization CHB - Date    
Declare @Billing1Authorization1CHB_Date DateTime    
 Set @Billing1Authorization1CHB_Date=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=206 and dt_conclusao is not null)    
    
--207 Billing Authorization CSR - Date    
Declare @Billing1Authorization1CSR_Date DateTime    
 Set @Billing1Authorization1CSR_Date=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=207 and dt_conclusao is not null)    
     
--208 Billing Authorization Transpor - Date    
Declare @Billing1Authorization1Transpor_Date DateTime    
 Set @Billing1Authorization1Transpor_Date=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=208 and dt_conclusao is not null)    
     
--168 10017 S VLR_Laudo_Eng_Arqueação -     
--[Engineer Report Value] varchar(200) NULL    
Declare @Engineer1Report1Value varchar(200)    
 Set @Engineer1Report1Value = (select campo_Dados from @CampoProcesso_Temp where id_campo=168 and num_proc=@Num_Proc)    
    
--169 10017 S Engenheiro Nomeado    
--[Engineer Name] varchar(200) NULL    
Declare @Engineer1Name varchar(200)    
 Set @Engineer1Name = (select campo_Dados from @CampoProcesso_Temp where id_campo=169 and num_proc=@Num_Proc)    
    
    
--174 10017 S Freight Currency - DI    
--[Freight Currency - DI] varchar(200) NULL    
 Declare @Freight1Currency_DI varchar(200)    
 Set @Freight1Currency_DI = (select campo_Dados from @CampoProcesso_Temp where id_campo=174 and num_proc=@Num_Proc)    
     
--175 10017 S FOB Currency - DI    
--[Freight Currency - DI] varchar(200) NULL    
 Declare @CFR1Currency_DI varchar(200)    
 Set @CFR1Currency_DI = (select campo_Dados from @CampoProcesso_Temp where id_campo=175 and num_proc=@Num_Proc)    
    
--176 10017 F Paridade Dolar D.I.    
Declare @ExchangeRatesUSDValue Varchar(15)  --Imports    
if LEFT(@Num_Proc,1) = 'I' and RIGHT(@Num_Proc,2) = 'BR'    
 BEGIN      
  Set @ExchangeRatesUSDValue=(select campo_dados Paridade from @CampoProcesso_Temp where  id_campo=176 and num_proc=@Num_Proc)    
 END    
     
--Ticket#100-114512    
Declare @Dangerous1Goods varchar(3)    
--set @Dangerous1Goods = (select (case Campo_Dados when '1' then 'YES' when '2' then 'NO' end) from @CampoProcesso_Temp  where id_campo = '185' and num_proc=@Num_Proc)    
    
set @Dangerous1Goods = (select top 1(case when PP.cd_prod is Not null or CP.Campo_Dados = 1  then  'YES' else 'NO' End)     
From vwCliente C    
    left join  Pedido_Ship PS With(nolock) on C.num_proc = PS.Num_Proc    
    left Join Pedido_Det PDD With(nolock) on PDD.cd_pedido=PS.cd_pedido and PDD.cd_produto=PS.cd_produto and PDD.item=ps.item and pdd.lote=ps.lote    
    left Join Produto_Cliente PC With(nolock) on PC.cd_prod=PS.cd_produto    
    left join Produto_Perigoso PP with(nolock) on PC.cd_prod = PP.cd_prod    
    left join Campo_Processo CP with(nolock) on CP.Num_Proc = @Num_Proc and Id_Campo = '185'    
 Where C.num_proc= @Num_Proc)    
     
 --100-124172    
 --Container Yard Sending - Date - Task:218 - Envio de Docs p/ Redestinação    
 Declare @ContainerYardSendingDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,42) Redistinacao    
 Set @ContainerYardSendingDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=218     
  and dt_conclusao is not null)    
     
 --Insurance Company Release - Date - Task:224 - Liberação Seguradora    
 Declare @InsuranceCompanyReleaseDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,42) Redistinacao    
 Set @InsuranceCompanyReleaseDate=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc     
  and id_task=224 and dt_conclusao is not null)    
     
 --100-124172     
 Declare @Customs1Clearance1Terminal varchar(200)--Adicional Fields:186 - Terminal de Desembaraço     
 Set @Customs1Clearance1Terminal = (select left(Campo_Dados,200) from @CampoProcesso_Temp      
        where id_campo = '186' and num_proc=@Num_Proc)    
            
 Declare @Redex1Reason varchar(200)--Adicional Fields:187 - Motivo REDEX    
 Set @Redex1Reason = (select left(Campo_Dados,200) from @CampoProcesso_Temp      
        where id_campo = '187' and num_proc=@Num_Proc)    
            
 Declare @Correction1Customs1Clearance1Export varchar(200)--Adicional Fields:188 - Motivo Correção Despacho EXP    
 Set @Correction1Customs1Clearance1Export = (select left(Campo_Dados,200) from @CampoProcesso_Temp      
        where id_campo = '188' and num_proc=@Num_Proc)    
     
 Declare @Export1Agent1Commission varchar(200)--Adicional Fields:189 - Comissão Agente Desp. Exp    
 Set @Export1Agent1Commission = (select left(Campo_Dados,200) from @CampoProcesso_Temp      
        where id_campo = '189' and num_proc=@Num_Proc)    
    
 Declare @Rectification1Dispatch_Exp_Date DateTime --Task: 226 - Retificação Despacho - Exp    
 Set @Rectification1Dispatch_Exp_Date=(select top 1 dt_conclusao from @Task_Temp     
     where num_proc=@Num_PRoc and id_task=226 and dt_conclusao is not null)    
    
 Declare @Doc1Delivery1to1Invoice1CHB_Date DateTime --Task: 162 ENTREGA DOCS P/ FAT.CHB    
 Set @Doc1Delivery1to1Invoice1CHB_Date=(select top 1 dt_conclusao from @Task_Temp     
     where num_proc=@Num_PRoc and id_task=162 and dt_conclusao is not null)    
    
    
 --BL - PO     
   Declare @PDF_PO Varchar(3) --Tipo de Documento: 1 - PO    
   if exists(select  Nome_Arquivo from doc_anexos with(nolock)     
     where num_proc=@num_proc and id_dc=1)    
    Begin    
     Set @PDF_PO='YES'    
    End    
   Else    
    Begin    
     Set @PDF_PO ='NO'    
    End       
    
 --BL - BOOKING    
   Declare @PDF_BOOKING Varchar(3)--Tipo de Documento: 130 - Booking    
   if exists(select  Nome_Arquivo from doc_anexos with(nolock)    
    where num_proc=@num_proc and id_dc=130)    
    Begin    
     Set @PDF_BOOKING='YES'    
    End    
   Else    
    Begin    
     Set @PDF_BOOKING='NO'    
    End     
        
 --Delivery Address - task: 146 - Delivery Address    
 Declare @Delivery1Address varchar(200)    
 Set @Delivery1Address = (select left(Campo_Dados,500) from @CampoProcesso_Temp      
        where id_campo = '146' and num_proc=@Num_Proc)     
     
 --Nome do Campo no Report Manager: "Shipping Confirmation Sent - Date"    
 --task: 184 - Envio do Shipment Confirmation - EM e EO - GRUPO RHODIA           
 Declare @Shipping1Confirmation1Sent_Date DateTime --Task: 184 - Envio do Shipment Confirmation    
 Set @Shipping1Confirmation1Sent_Date=(select top 1 dt_conclusao from @Task_Temp     
     where num_proc=@Num_PRoc and id_task=184 and dt_conclusao is not null)     
    
--100-152529     
    
Declare @Inter8Stacking1Input_Date DateTime    
 Set @Inter8Stacking1Input_Date=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=231 and dt_conclusao is not null)    
    
Declare @Get1Early_Date DateTime    
 Set @Get1Early_Date =(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_PRoc and id_task=232 and dt_conclusao is not null)    
     
--100-130673    
    
Declare @Insurance varchar(3)    
Set @Insurance = (select (case Campo_Dados when '1' then 'YES' when '2' then 'NO' end) from @CampoProcesso_Temp  where id_campo = '193' and num_proc=@Num_Proc)    
    
--100-138051    
Declare @Exchange1Rates1Due_Date DateTime    
set @Exchange1Rates1Due_Date  = (select     
(Case when TMC.Dt_Base = 'Invoice'  then   (Case when dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,2) is not null  then     
 dateadd(day,isnull(TMC.Dias,0),dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,2)) else null End)  else    
Case when TMC.Dt_Base = 'ATD'  then   (Case when HOU.ATD is not null then dateadd(day,isnull(TMC.Dias,0),HOU.ATD)     
 else null End) else null end end)    
from vwHouse_Imp HOU    
left join @CampoProcesso_Temp CP87 on HOU.num_proc = CP87.Num_Proc and CP87.id_campo=87    
Left Join Termo_Pagamento TMC with(nolock) on TMC.cd_termo=CP87.campo_Dados    
where    
 hou.Num_Proc = @Num_Proc)    
    
    
--100-158821    
 --Loading at the Terminal - Date @Loading1at1the1Terminal_Date    
Declare @Loading1at1the1Terminal_Date DateTime --223 Retirada da Carga no Terminal    
 Set @Loading1at1the1Terminal_Date=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_Proc     
  and id_task=223 and dt_conclusao is not null)    
      
 --GR Efetivo - Date - Date @GR1Efetivo_Date    
Declare @GR1Efetivo_Date DateTime --222 GR Actual    
 Set @GR1Efetivo_Date=(select top 1 dt_conclusao from @Task_Temp where num_proc=@Num_Proc     
  and id_task=222 and dt_conclusao is not null)    
      
--[GR Previsto - Date] @GR1Previsto_Date    
--177 1 D GR previsto    
Declare @GR1Previsto_Date datetime    
set @GR1Previsto_Date = (select convert(datetime,Campo_Dados,105)     
 from @CampoProcesso_Temp where id_campo=177 and num_proc=@Num_Proc)     
     
-- Alessandra 10/07/2019 - 100-159526    
Declare @Receb_Ordem_confirmation DateTime     
 Set @Receb_Ordem_confirmation=( select top 1 dt_conclusao     
         from @Task_Temp     
         where num_proc=@Num_Proc     
         and id_task=233     
         and dt_conclusao is not null)    
     
-- Alessandra 10/07/2019 - 100-159526    
Declare @Proforma_aprovada DateTime     
 Set @Proforma_aprovada =( select top 1 dt_conclusao     
        from @Task_Temp     
        where num_proc=@Num_Proc     
        and id_task=234     
        and dt_conclusao is not null)     
    
-- Alessandra 10/07/2019 - 100-159526    
Declare @Vencimento_de_Armagenagem datetime    
 Set @Vencimento_de_Armagenagem = (select  convert(Datetime,campo_dados,103)     
         from @CampoProcesso_Temp      
         where id_campo = '150'     
         and num_proc=@Num_Proc    
         and Campo_Dados is not null)    
             
      
-- Alessandra 09/08/2019 -     
Declare @Envio_de_Impurezas datetime    
 Set @Envio_de_Impurezas = ( select top 1 dt_conclusao     
        from @Task_Temp     
        where num_proc=@Num_Proc     
        and id_task=228     
        and dt_conclusao is not null)     
    
--print left(@num_proc,2)    
--print @Free1Time    
--0print @ATA1Date    
    
-- Alessandra 10/07/2019 - 100-159526    
Declare @Vencimento_da_demurrage datetime    
if left(@num_proc,2)='EM'    
 begin    
  Set @Vencimento_da_demurrage = (    
          select   
   Case   
    when LLP.Cd_Tp_Carga = '1' -- FCL   
     then Dateadd(day,convert(int,@Free1Time),@ATA1Date)    
   else    
    null    
           end   
    as Vencimento_da_demurrage    
          from   
    LLP_exp_mar LLP  with(nolock)  
          Where   
    Num_Proc_Lem=@Num_Proc    
      
          )    
    
 end    
else if left(@num_proc,2)='IM'    
 begin    
  Set @Vencimento_da_demurrage = (    
          select     
           Case when LLP.Cd_Tp_Carga = '1' -- FCL    
           then    
            dateadd(day,convert(int,@Free1Time),@ATA1Date)    
           else    
            null    
           end as Vencimento_da_demurrage    
          from LLP_Imp_Mar LLP  with(nolock)  
          Where Num_Proc_Lim=@Num_Proc    
      
          )    
 end    
  
 --Marcela 04/05/2020   
 Declare @CaixaIronMountain varchar(500)     
 Set @CaixaIronMountain =(select  campo_dados    
         from @CampoProcesso_Temp      
         where id_campo = '162'     
         and num_proc=@Num_Proc    
         and Campo_Dados is not null)    
  
   
--Marcela 04/05/2020   
 Declare @ETDOriginal DateTime     
 Set @ETDOriginal =(select  convert(Datetime,campo_dados,103)     
         from @CampoProcesso_Temp      
         where id_campo = '127'     
         and num_proc=@Num_Proc    
         and Campo_Dados is not null)    
  
--Marcela 04/05/2020   
  Declare @QtdeItensDUE varchar(5)     --Quantidades de itens as Qtde Itens  192- Quantidade de itens na DUE ADDITIONAL FIELDS
 Set @QtdeItensDUE =(select  campo_dados    
         from @CampoProcesso_Temp      
         where id_campo = '192'     
         and num_proc=@Num_Proc    
         and Campo_Dados is not null)    

--Marcela 04/05/2020   
  Declare @QtdeAdicoes varchar(3)  --Quantidades de adições as Qtde adições    
 Set @QtdeAdicoes =(select  campo_dados   
         from @CampoProcesso_Temp      
         where id_campo = '194'     
         and num_proc=@Num_Proc    
         and Campo_Dados is not null)    
  
 --TASK TEMP  
 --Marcela 04/05/2020   
 Declare @ProdutoDisponivel DateTime     
 Set @ProdutoDisponivel =( select top 1 dt_conclusao     
        from @Task_Temp     
        where num_proc=@Num_Proc     
        and id_task='237'  
        and dt_conclusao is not null)      
  
--Marcela 04/05/2020   
Declare @ProtocoloMinExercito DateTime     
 Set @ProtocoloMinExercito=( select top 1 dt_conclusao     
         from @Task_Temp     
         where num_proc=@Num_Proc     
         and id_task='219'    
         and dt_conclusao is not null)   
  
--Marcela 04/05/2020 up above  
 Declare @RecebOrderConfirmation DateTime     
 Set @RecebOrderConfirmation=( select top 1 dt_conclusao     
         from @Task_Temp     
         where num_proc=@Num_Proc     
         and id_task='233'     
         and dt_conclusao is not null)    
  
--Marcela 04/05/2020   
 Declare @EmissaoBLOriginalDestino DateTime     
 Set @EmissaoBLOriginalDestino=( select top 1 dt_conclusao     
         from @Task_Temp     
         where num_proc=@Num_Proc     
         and id_task='249'  
         and dt_conclusao is not null)    
  
--Marcela 04/05/2020   
  Declare @EmissaoBLoriginalorigem DateTime     
 Set @EmissaoBLoriginalorigem=( select top 1 dt_conclusao     
         from @Task_Temp     
         where num_proc=@Num_Proc     
         and id_task='250'  
         and dt_conclusao is not null)    
--FIM TASK TEMP  
  
--Marcela 04/05/2020 Account1Balance  
  Declare @SaldoDoProcesso decimal     
 Set @SaldoDoProcesso=( select  sum(dbo.valor(vlr_pgto_rcto_hia,dc_hia)) Saldo   
from vwcxas with(nolock)   
where num_proc_hia=@Num_Proc)  
  
--Marcela 04/05/2020 Frete1internacional1pago   
   Declare @FRETECHB decimal ----- todo     
 Set @FRETECHB=( select top 1 Vlr_Org_HIM     
         from Cta_Cte_Hou_Imp_Mar   with(nolock)  
         where Num_Proc_HIM=@Num_Proc     
         and cd_tp_tx='XFR'  
         and Vlr_Org_HIM is not null)    
  
--DOCUMENTOS  
--Marcela 04/05/2020  
    Declare @038Proforma varchar(30)     
 Set @038Proforma=( select top 1 Nome_Arquivo     
         from Doc_Anexos with(nolock)    
         where num_proc=@Num_Proc     
         and id_dc='038'   
         and Nome_Arquivo is not null)    
  
--Marcela 04/05/2020   
     Declare @PDFCEMERCANTE varchar(30)     
 Set @PDFCEMERCANTE=( select top 1 Nome_Arquivo     
         from Doc_Anexos  with(nolock)  
         where num_proc=@Num_Proc     
         and id_dc='029'   
         and Nome_Arquivo is not null)    
  
--Marcela 04/05/2020   
     Declare @017CartaCorrecao varchar(30)      
 Set @017CartaCorrecao=( select top 1 Nome_Arquivo     
         from Doc_Anexos   with(nolock)  
         where num_proc=@Num_Proc     
         and id_dc='017'     
         and Nome_Arquivo is not null)    
  
--Marcela 04/05/2020   
     Declare @057FichaEmergencia varchar(30)      
 Set @057FichaEmergencia=( select top 1 Nome_Arquivo     
         from Doc_Anexos   with(nolock)  
         where num_proc=@Num_Proc     
         and id_dc='057'    
         and Nome_Arquivo is not null)    
  
--Marcela 04/05/2020   
     Declare @215FichaEmergencia varchar(30)      
 Set @215FichaEmergencia=( select top 1 Nome_Arquivo     
         from Doc_Anexos   with(nolock)  
         where num_proc=@Num_Proc     
         and id_dc='215'  
         and Nome_Arquivo is not null)    
 --FIM DOCUMENTOS  
  
--Marcela 04/05/2020   
    Declare @CFOP varchar(80)     
 Set @CFOP=( select top 1 Numero_PO     
         from vwPO_ALL     
         where num_proc=@Num_Proc     
         and id_dc='46'     
         and Numero_PO is not null)    
  
--Marcela 04/05/2020   204-DUE REFERENCIAS 
    Declare   @QtdeItensDUE204 varchar(80)     
 Set   @QtdeItensDUE204=( select top 1 Numero_PO     
         from vwPO_ALL     
         where num_proc=@Num_Proc     
         and id_dc='204'   
         and Numero_PO is not null)    
  
--Marcela 04/05/2020   
    Declare @DUIMP varchar(80)     
 Set @DUIMP=( select top 1 Numero_PO     
         from vwPO_ALL     
         where num_proc=@Num_Proc     
         and id_dc='237'   
         and Numero_PO is not null)    
  
--Marcela 04/05/2020   
    Declare @DATADUIMP DateTime     
 Set @DATADUIMP=( select top 1 Data_PO     
         from vwPO_ALL     
         where num_proc=@Num_Proc     
         and id_dc='237'    
         and Data_PO is not null)    
  
--Marcela 04/05/2020   
    Declare @DataCEMercante DateTime     
 Set @DataCEMercante=( select top 1 convert(Datetime,Data_PO,103)      
         from vwPO_ALL     
         where num_proc=@Num_Proc     
         and id_dc='029'   
         and Data_PO is not null)    
  
     
 --case when xxx = '' then     
 --        xpto - @Free1Time    
 --        else     
 --        ''    
 --        end    
 --         )     
     
     
     
---OUTPUT    
select     
 @Num_Proc Num_Proc, @DataSyncro Synchro_Date, [dbo].[fBusca_Tarefa](@Num_Proc,115)  DANFE1Approval1Date,    
 @DemurrageHistoric Demurrage1Historic,@DemurragePeriod Demurrage1Period,@WarehousePeriod Warehouse1Period,    
 @LiExpiredDate LI1Expired_Date,@LIType LI_Type,@Usuario Account1Manager,@ICMSExonerationPDF ICMS1Exoneration_PDF,    
 @ICMSexonerationDate ICMS1exoneration1Date,AdvancementReceivedDate Advancement1Received1Date,AdvancementValue Advancement_Value,    
 @WarehousePaymentDate Warehouse1Payment_Date,@ExchangeRatesValue Exchange1Rates1Value, @DemurrageInvoiceNumber Demurrage1Invoice1Number,    
 @DemurrageInvoiceDate Demurrage1Invoice1Date,replace(cast(@AntiDumpingValuebyShipment as Varchar(40)),',','.') AntiDumping1Value1by1Shipment,replace(cast(@AFRMMValuebyShipment as varchar(40)),',','.') AFRMM1Value1by1Shipment,    
 @ICMSPaymentDate ICMS1Payment1Date, @PDFRequerimento PDF_Requerimento,[dbo].[fBusca_TipoDocCliente]('N',@num_proc,25) Requerimento_Number,    
 [dbo].[fBusca_Tarefa](@Num_Proc,70) Draft1Complementary1DANFE1Sent_Date, [dbo].[fBusca_TipoDocCliente]('N',@num_proc,54) NF1Complementary_Number,    
 [dbo].[fBusca_TipoDocCliente]('D',@num_proc,54) NF1Complementary_Date, @Forwarder Forwarder, @FreightType Freight1Type, @ShipperMaster [Shipper-Master],    
 @WarehouseHistoric Warehouse1Historic, @InvoiceapprovalbycustomerDate Invoice1approval1by1customer_Date, @ExportRegisterReceiptDate Export1Register1Receipt_Date,    
 @TerminalmoverequestbyCustomerDate Terminal1move1request1by1Customer_Date,@PDFSolRedestinaçãoCliente PDF_Sol1Redestinação1Cliente,    
 @BookingConfirmationDate Booking1Confirmation1Date,@CustomsClearanceDate Customs1Clearance1Date,@GoodReceiptDateEstimated Good1Receipt1Date_Estimated,@GoodReceiptDateActual Good1Receipt1Date_Actual,    
 @PlantExitDateActual Plant1Exit1Date_Actual,@PlantExitDateEstimated Plant1Exit1Date_Estimated,    
 @DocSentDate Doc1Sent_Date,@NFEDraftDate NFE1Draft_Date,@BillofLadingBackDate BillofLadingBack_Date,@EnvioCHBFaturamentoDate Envio1CHB1Faturamento_Date,    
 @OrderReceivedDate Order1Received_Date, @BDPInvoiceCreationDate BDP1Invoice1Creation_Date, @PositioningContainerRequireDate Positioning1Container1Require_Date,    
 @TerminalEntryDate Terminal1Entry_Date,@AverbacaoEXPDate Averbacao1EXP_Date, @WoodInspectionDate Wood1Inspection1Date, @DocSentBLBRDate Doc1Sent1BLBR_Date,    
 @DocsToCambioDate Docs1To1Cambio_Date, @DocsToBDPBillingDate Docs1To1BDP1Billing1Date, @AFRMMPaymentDate AFRMM1Payment1Date,    
 @EntryrequirementDate Entry1requirement_Date,@DueDateSupplier Due1Date_Supplier,@SurveyRequestDate Survey1Request_Date,    
 @IMOApprovalDate IMO1Approval_Date, @PDF_NF_omplementar PDF_NF_Complementar,    
 @ArrivalattheborderDate Arrival1at1the1border_Date, @AuthorizationCrossDate Authorization1Cross_Date, [dbo].[fBusca_TipoDocCliente]('N',@num_proc,15) Remittance1Number,    
 [dbo].[fBusca_TipoDocCliente]('D',@num_proc,15) Remittance1Date,@PDFRemittance PDF_Remittance, [dbo].[fBusca_TipoDocCliente]('N',@num_proc,133) Treatment1Cargo_Number,    
 [dbo].[fBusca_TipoDocCliente]('D',@num_proc,133) Treatment1Cargo_Date, @ETD1Original_Date Original1ETD_Date,    
 @Withdrawalof1Samples_Date Withdrawal1of1Samples_Date, @PDF_DA PDF_DA, [dbo].[fBusca_TipoDocCliente]('D',@num_proc,59) DA_Date,[dbo].[fBusca_TipoDocCliente]('N',@num_proc,59) DA1Number,    
 @NFIssueValue NF1Issue_Value,     
 Upper(@FinalDEstination) Final1Destination, [dbo].[fBusca_TipoDocCliente]('D',@num_proc,8) Shipment1Creation1Date,    
 @Notify Notify, @Incoterm Incoterm,@Shipper  Shipper, @Consignee Consignee, @CNPJ CNPJ, @ConsigneeAddress Consignee1Address,    
 @CityofConsignee City1of1Consignee, @Terminal Terminal,     
 --@Manufacturer Manufacturer, desabilitado    
 @Shipper1Address Shipper1Address,    
  replace(cast(@Volume1M3 as varchar(50)),',','.') Volume1M3, Left([dbo].[fNCM](@Num_Proc),200) NCM1by1Shipment,    
  @ClosingSpreadsheettocustomer_Date Closing1Spreadsheet1to1customer_Date,@Sending1Of1Invoice1Amount1Date Sending1Of1Invoice1Amount1Date,    
  @Sending1Of1Banking1Collection1Date Sending1Of1Banking1Collection1Date,@Return1Terminal Return1Terminal,@Warehouse1Expiration1Date Warehouse1Expiration1Date,    
  @DeadLine1Loading1Date DeadLine1Loading1Date,@Docs1ok1to1Delivery1Inland1Trucker1Date Docs1ok1to1Delivery1Inland1Trucker1Date,    
  --@CIFValue CIF1Value,    
  @CRT1Received1Date CRT1Received1Date, @BL1Payment1Date BL1Payment1Date, @RE1Value RE1Value,@Siscomex1Destination1Code Siscomex1Destination1Code,    
  @BPS1COD1SISCOMEX BPS1COD1SISCOMEX, @DDE1or1DSE1Value DDE1or1DSE1Value,@NFSerie NF1Serie, @SDA1Payment1Date SDA1Payment1Date, @Seller1Code Seller1Code,    
  @BDP1Invoice1Date BDP1Invoice1Date, @BL1Released_Date BL1Released_Date,     
  @Process1Status Process1Status , @PDF_Protocolo1Transporte PDF_Protocolo1Transporte, @Reason1Code1Events Reason1Code1Events, @Drawback1Number Drawback1Number,    
 @Certified1Of1Origin1Number Certified1Of1Origin1Number ,    
 replace(cast(@Products1by1Shipment as varchar(40)),',','.') Products1by1Shipment,    
 @Product1IDs1by1Shipment Product1IDs1by1Shipment,     
    replace(cast(@IPI1Value1by1Shipment as varchar(40)),',','.') IPI1Value1by1Shipment ,    
    
    replace(cast(@Cofins1Value1by1Shipment as varchar(40)),',','.') Cofins1Value1by1Shipment ,    
    replace(cast(@PIS1Value1by1Shipment  as varchar(40)), ',','.') PIS1Value1by1Shipment,    
    replace(cast(@Import1Duties1Value1by1Shipment  as varchar(40)), ',','.') Import1Duties1Value1by1Shipment,    
    replace(cast(@Siscomex1Debit1Value1by1Shipment  as varchar(40)), ',','.') Siscomex1Debit1Value1by1Shipment,    
    @Terminal1Pier1Name Terminal1Pier1Name,    
    [dbo].[fBusca_TipoDocCliente]('D',@num_proc,36) Direct1Colletion_Date,    
    [dbo].[fBusca_TipoDocCliente]('N',@num_proc,36) Direct1Collection,    
    @Controlled1Goods Controlled1Goods,    
    @PlaceofReceipt Place1of1Receipt,    
    @Free1Time Free1Time,    
    @DJAI1Approval DJAI1Approval_Date,    
 @Certified1Of1Origin1Date Certified1Of1Origin1Date,    
 @Delivery1of1Documents Delivery1of1Documents,    
 @Invoice Invoice,    
 @DocsSentToForeignBank Docs1Sent1To1Foreign1Bank,    
 @DocsDeliveredToForeignBank Docs1Delivered1To1Foreign1Bank,    
 replace(cast(@BL1Pieces  as varchar(40)), ',','.') BL1Pieces,    
     
 @DraftApprovalImportDate Draft1Approval1IMP_Date, --[Draft Approval IMP - Date]    
      
 @LIRequest LI1Request_Date, --[LI Request - Date]    
 @DTAClearanceDate DTA1Clearance_Date, --[DTA Clearance - Date]    
 @PortEntryDate Port1Entry1Date, --[Port Entry Date]    
 @TransportDocDeliveryDate [Transport.1Doc1Delivery1Date],      
 @UnloadedDate Unloaded1Date, --[Unloaded Date]    
 @PREDIDate PRE1DI1Date, --[PRE DI Date]     
 @RemocaoDate Remocao1Date, --[Remocao Date]    
 @FileOpen File1Open1Date, --[File Open Date]    
 @ContainerYardRequestDate Container1Yard1Request1Date, --[Container Yard Request Date]     
 @DocsReceivedDate Docs1Received1Date, --[Docs Received Date]     
 @NFBDPDate NF1BDP1Date, --[NF BDP Date]    
 @AdvancedRequestDate Advanced1Request1Date,--[Advanced Request Date]    
 @Dt_SI Shipping1Instruction1Sent_Date,--[Shipping Instruction Sent - Date]    
 @DtGreenLight Green1light_Date, --[Green light - Date]    
 @DefLI [Def.1LI_Date], --[Def. LI - Date]    
 @InvoiceSentDate Invoice1Sent1Date,--[Invoice Sent Date]    
 @BRIssuedDate BRBL1Issued_Date, --[BRBL Issued - Date]    
 @DraftSentCustomerDate  Draft1Sent1to1Customer_Date, --[Draft Sent to Customer - Date]    
 @DraftReceivedDate Draft1Received_Date,--[Draft Received - Date]    
 @DraftBackDate Draft1Back_1Date,--[Draft Back -  Date]      
 @BDPPreInvoice [PRE-BDPInvoice_Date],--[PRE-BDPInvoice - Date]     
 @EnvioShipping Envio1de1Shipping_Date,--[Envio de Shipping - Date]     
 @TruckLoading Truck1Loading1Confirmed_Date,--[Truck Loading Confirmed - Date]    
 @DraftExport Draft1EXP_Date,--[Draft EXP - Date]    
 @AverbacaoImpDate Averbacao1Imp_Date,--[Averbacao Imp - Date]    
 @PosicionamentoEfetivo Effective1Position1Container_Date, --[Effective Position Container - Date]    
 @InspMAPA Inspection1MAPA_Date, --[Inspection MAPA - Date]    
 @ProftRegister Proft1Register_Date, --[Proft Register - Date]    
 @TransmissionValue Transmission1Value_Date, --[Transmission Value - Date]    
 @ProcessOKpaymentHBL Process1OK1to1payment1of1HBL_Date, --[Process OK to payment of HBL - Date]    
 @ManifestDate Manifest1Date, --[Manifest Date]    
 @SiscargaRegister Siscarga1Register_Date, --[Siscarga Register - Date]    
 @DocsOKregister Docs1OK1to1register_Date, --[Docs OK to register - Date]     
 @PreAlertSending [Pre-Alert1Sending_Date], --[Pre-Alert Sending - Date]     
 @ChegadaFronteira Cross1Boarder_Date, --[Cross Boarder - Date]=    
 @Cumplido Conclusion1Cumplido_Date, --[Conclusion Cumplido - Date]=    
 @Cumplido_Est Estimated1Cumplido_Date,--[Estimated Cumplido - Date]=    
 @AnticipoDOC Anticipo1DOC1Original_Date, --[Anticipo DOC Original - Date]=    
 @InvoiceController Invoice1Sent1to1Controller_Date, --[Invoice Sent to Controller - Date]     
 @EntrCobranca [Entr.1Cobranca_Date], --[Entr. Cobranca - Date]     
 @BDPCambio BDP1Cambio_Date, --[BDP Cambio - Date]    
 @DIDraftOKDateBRonly DI1Draft1OK_Date_BR1only, --[DI Draft OK - Date - BR only]    
 @DanfeReceiptDateBRonly Danfe1Receipt_Date_BR1only, --[Danfe Receipt - Date - BR only]    
 @BDPInvoiceReceiptDateBRonly BDP1Invoice1Receipt_Date_BR1only, --[BDP Invoice Receipt - Date - BR only]    
 @ReceivedMBLDate Received1MBL_Date, --[Received MBL - Date]      
 @ReceivedHBLDate Received1HBL_Date, --[Received HBL - Date]      
 @SurveyDate Survey_Date, --[Survey - Date]     
     
 @Export1Voucher1Sending_Date Export1Voucher1Sending_Date, --[Export Voucher Sending - Date]    
 @Freight1Receipt1A61Delivery1Fee_Date Freight1Receipt1A61Delivery1Fee_Date, --[Freight Receipt / Delivery Fee - Date]    
 @BL1Sent_Express1Mail1SP_Date BL1Sent_Express1Mail1SP_Date, --[BL Sent - Express Mail SP - Date]    
 @Freight1Payment1and1Fees_Date Freight1Payment1and1Fees_Date, --[Freight Payment and Fees - Date]    
 @Draft1Review_Date Draft1Review_Date, --[Draft Review - Date]    
 @Terminal1Container1Delivery_Date Terminal1Container1Delivery_Date, --[Terminal Container Delivery - Date]    
 @Opening1Gate_Date Opening1Gate_Date, --[Opening Gate - Date]    
 @MDGF1Protocol_Date MDGF1Protocol_Date, --[MDGF Protocol - Date]    
 @VGM1Transmission_Date VGM1Transmission_Date, --[VGM Transmission - Date]    
 @VGM1Retransmission_Date VGM1Retransmission_Date, --[VGM Retransmission - Date]    
 @VGM1Carrier1Receipt_Date VGM1Carrier1Receipt_Date, --[VGM Carrier Receipt - Date]    
 @JOB1Reopenning_Additional1Billing_Date JOB1Reopenning_Additional1Billing_Date, --[JOB Reopenning - Additional Billing - Date]    
 @Additional1Billing1Sending_Date Additional1Billing1Sending_Date, --[Additional Billing Sending - Date]    
 @Shipment1Departure1Confirmation_Date Shipment1Departure1Confirmation_Date, --[Shipment Departure Confirmation - Date]    
 @BL1Fee1Payment_Date BL1Fee1Payment_Date, --[BL Fee Payment - Date]    
 @DDE1Terminal1Protocol_Date DDE1Terminal1Protocol_Date, --[DDE Terminal Protocol - Date]    
 @Pre1Import1License1Release_Date Pre1Import1License1Release_Date, --[Pre Import License Release - Date]    
 @Post1Import1License1Release_Date Post1Import1License1Release_Date, --[Post Import License Release - Date]    
 @Docs1Delivery1for1Customs1Clearance_Date Docs1Delivery1for1Customs1Clearance_Date, --[Docs Delivery for Customs Clearance - Date]    
 @Wood1Released_Date Wood1Released_Date, --[Wood Released - Date]    
 @Terminal1Nomination_Date Terminal1Nomination_Date, --[Terminal Nomination - Date]    
 @Original1Docs1Received_CHB_Date Original1Docs1Received_CHB_Date, --[Original Docs Received - CHB - Date]    
 @Original1Docs1Received_CSR_Date Original1Docs1Received_CSR_Date, --[Original Docs Received - CSR - Date]    
 @Copy1of1Docs1Received_Date Copy1of1Docs1Received_Date, --[Copy of Docs Received - Date]    
 @Wood1Inspection1Selected_Date Wood1Inspection1Selected_Date, --[Wood Inspection Selected - Date]    
 @Discharge1Conclusion_Date Discharge1Conclusion_Date, --[Discharge Conclusion - Date]    
 @Operation1Audit_Date Operation1Audit_Date, --[Operation Audit - Date]    
 @Quota1Reestablishment_Date Quota1Reestablishment_Date, --[Quota Reestablishment - Date]    
 @COA1Sent1for1Transp_Date COA1Sent1for1Transp_Date, --[COA Sent for Transp - Date]    
 @Cargo1Manifest1for1Import1Declaration_Date Cargo1Manifest1for1Import1Declaration_Date, --[Cargo Manifest for Import Declaration - Date]    
 @Billing1Receipt_Date Billing1Receipt_Date, --[Billing Receipt - Date]    
 @DRAFTBDPInvoice_Date [DRAFT-BDPInvoice_Date], --[DRAFT-BDPInvoice - Date]    
 @Service1BDP1Invoice1Sent_Date Service1BDP1Invoice1Sent_Date, --[Service BDP Invoice Sent]    
 @Delivery1for1Pre1Import1Declaration_Date Delivery1for1Pre1Import1Declaration_Date, --[Delivery for Pre Import Declaration - Date]    
 @Protocol1at1the1Tax1Office_Date Protocol1at1the1Tax1Office_Date, --[Protocol at the Tax Office - Date]    
 @Shipment1with1Loss_Date Shipment1with1Loss_Date, --[Shipment with Loss - Date]     
 @Shipment1without1Profit_Date Shipment1without1Profit_Date, --[Shipment without Profit - Date]    
 @PreAlert1Sent1Agent_Date [PRE-Alert1Sent1Agent_Date], --[Pre-Alert Sent Agent - Date]    
 @Receipt1and1NF1Sent_Date Receipt1and1NF1Sent_Date, --[Receipt and NF Sent - Date]    
 @Siscoserv1Sent_Date Siscoserv1Sent_Date, --[Siscoserv Sent - Date]    
 @ISF1Sent_Date ISF1Sent_Date, --[ISF Sent - Date]    
 @ISF1Sent1to1Destination_Date ISF1Sent1to1Destination_Date, --[ISF Sent to Destination - Date]    
 @AMSENS1Sent1to1Destination_Date AMSA6ENS1Sent1to1Destination_Date, --[AMS/ENS Sent to Destination - Date]    
 @AMS1Registration_Date AMS1Registration_Date, --[AMS Registration - Date]    
     
 @TransshipmentArrivalDate [Transshipment181Arrival_Date], --[Transshipment – Arrival - Date]    
 @TransshipmentDepartureDate [Transshipment181Departure_Date], --[Transshipment – Departure - Date]     
 @BookingRequestDate Booking1Request1Date, --[Booking Request Date]    
     
 --*********************************************    
 @EnvioDoc1 [A0Envio1Docs1Brasilia_Date], --[1 Envio Docs Brasilia - Date]    
 @RecDoc1 [A0Receb.1em1Brasilia_Date],  --[1 Receb. em Brasilia - Date]    
 @Def1 [A0Deferimento_Date], --[1 Deferimento - Date]    
 @EnvioDoc2 [A2Envio1Docs1Brasilia_Date], --[2 Envio Docs Brasilia - Date]    
 @Def2 [A2Deferimento_Date], --[2 Deferimento - Date]    
 --*********************************************     
     
 left(dbo.fBusca_Docs_PO_Modal(@num_proc,1),500)PO1Number, --[PO Number]    
     
 @ParteLote Parte1Lote, --[Parte Lote]    
 replace(cast(@QttyofUnits as varchar(40)),',','.') Qtty1of1Units, -- [Qtty of Units]    
     
 @DanfeRequest Danfe1Request_Date,--[Danfe Request - Date]    
 @DanfeReceipt Danfe1Receipt_Date, --[Danfe Receipt - Date]    
     
 --@Country1Manufacturer Country1Manufacturer, - desabilitado    
 @PDF_CE1Mercante PDF_CE1Mercante, --[PDF - CE Mercante]    
 @PDF_Termo1correção1siscarga PDF_Termo1Correção1Siscarga, --[PDF - Termo Correção Siscarga],    
 @PDF_DSE PDF_DSE, --[PDF - DSE]    
 @PDF_MDGF PDF_MDGF,--[PDF - MDGF]    
 @PDF_CO1Receipt PDF_CO1Receipt,--[PDF - CO Receipt]    
 @PDF_Freight1and1Fees1Receipt PDF_Freight1and1Fees1Receipt,--[PDF - Freight and Fees Receipt]    
 @PDF_CEXP PDF_CEXP,--[PDF - CEXP]    
 @PDF_DUE PDF_DUE,--[PDF - DUE]    
 @PDF_DAT PDF_DAT,--[PDF - DAT]    
 @PDF_BDP1NF PDF_BDP1NF,--[PDF - BDP NF]    
 @PDF_PCC PDF_PCC, --[PDF - PCC]    
 @PDF_Tank1Inspection PDF_Tank1Inspection, --[PDF - Tank Inspection]    
     
 @PDF_BL PDF_BL,    
 @PDF_Invoice PDF_Invoice,    
 @PDF_RE PDF_RE,    
 @PDF_DDE PDF_DDE,     
 @PDF_PC PDF_PC,    
 @PDF_DI PDF_DI,    
 @PDF_CI PDF_CI,    
 @PDF_NF PDF_NF,    
 @PDF_PL PDF_PL,    
 @PDF_COA PDF_COA,    
 @PDF_COO PDF_COO,    
 @PDF_CAPA PDF_CAPA,    
 @PDF_BL1Original PDF_BL1Original,    
 @PDF_AFRMM PDF_AFRMM,    
 @PDF_ICMS PDF_ICMS,    
 @PDF_LI PDF_LI, --Incluido por Rafael 08-10-2015    
 @PDF_Form1A PDF_Form1A,    
 @PDF_Insurance PDF_Insurance,    
 @PDF_Fumigacao PDF_Fumigacao,    
 @PDF_Arqueacao PDF_Arqueacao,    
 @PDF_Saque PDF_Saque,    
 @PDF_Courier PDF_Courier,    
 @PDF_Courier12 PDF_Courier12,    
 @Courier Courier, --Incluido por Rafael Lindenberg 2016-05-19    
 @Courier1Number Courier1Number, --Incluido por Rafael Lindenberg 2016-05-19    
 replace(cast(@Total11Taxes1Value1by1Shipment as varchar(40)),',','.') Total11Taxes1Value1by1Shipment ,    
 replace(cast(@Total1Siscomex1Value1by1Shipment as varchar(40)),',','.') Total1Siscomex1Value1by1Shipment,    
 --replace(cast(@Insurance1Value as varchar(40)),',','.') Insurance1Value, --Incluido por Erbson 2017-03-29    
 @BankerA3s1Draft BankerA3s1Draft, --Incluido por Erbson 2017-03-30    
 @Government1Agency Government1Agency, --Incluido por Erbson 2017-04-04    
 @BB1Protocol BB1Protocol, --Incluido por Erbson 2017-04-04    
 @Payment1Term Payment1Term, --Incluido por Erbson 2017-04-05    
 @BL1Description BL1Description, --Incluido por Erbson 2017-04-07    
 replace(@Last1Historic,'''','') Last1Historic, --Incluido por Erbson 2017-04-11    
     
     
 @Real1Deposit_Date Real1Deposit_Date, --Incluido por Erbson 2017-04-11    
 @Volume1Description Volume1Description, --Incluido por Erbson 2017-04-11    
 replace(@Cd9BDP1Last1Historic,'''','') Cd9BDP1Last1Historic, --Incluido por Erbson 2017-04-11    
 @DTA1Clearance_Number DTA1Clearance_Number, --Incluido por Erbson 2017-04-11    
 @USD1Exch1Date_BR1Exp1only USD1Exch1Date_BR1Exp1only, --Incluido por Erbson 2017-04-12    
 @USD1Exch1Rate_BR1Exp1only USD1Exch1Rate_BR1Exp1only, --Incluido por Erbson 2017-04-12    
 @Doc1Delivery1to1Customs1House_Date Doc1Delivery1to1Customs1House_Date, --Incluido por Erbson 2017-04-13    
 @Dead1Line1Transf_Date Dead1Line1Transf_Date, --Incluido por Erbson 2017-04-13    
 @Damage_Details Damage_Details, --Incluido por Erbson 2017-04-13    
 @Courier1Number_2nd Courier1Number_2nd, --Incluido por Erbson 2017-04-13    
 @Courier1Number12nd_Date Courier1Number12nd_Date, --Incluido por Erbson 2017-04-13    
 @cd9Courier13rd1Number cd9Courier13rd1Number,--Incluido por Erbson 2017-04-13    
 @cd9Courier13rd1Date cd9Courier13rd1Date, --Incluido por Erbson 2017-04-13    
 GETDATE() Last1Update, --Incluido por Erbson 2017-04-13    
 @DSE_Number DSE_Number, --Incluido por Erbson 2017-04-17    
 @DSE181Date DSE181Date,  --Incluido por Erbson 2017-04-17    
 @Form1A Form1A, --Incluido por Erbson 2017-04-17    
 @Batch1Number Batch1Number, --Incluido por Erbson 2017-04-18    
 @RE1Number RE1Number, --Incluido por Erbson 2017-04-18    
 @Qty_Truck Qty_Truck, --Incluido por Erbson 2017-04-19    
 @Time1to1Delivery Time1to1Delivery, --Incluido por Erbson 2017-04-19    
 @Department1WM Department1WM, --Incluido por Erbson 2017-04-19    
 @Area Area, --Incluido por Erbson 2017-04-19    
 @Division Division, --Incluido por Erbson 2017-04-20    
 @Invoice1Date Invoice1Date,  --Incluido por Erbson 2017-04-20    
 @ArkTec1Number ArkTec1Number, --Incluido por Erbson 2017-04-24    
 @RC1Number RC1Number, --Incluido por Erbson 2017-04-26    
 @ETA1Transhipment1Port_Date ETA1Transhipment1Port_Date,  --Incluido por Erbson 2017-04-27    
 @A4st1Vessel1Voyage A4st1Vessel1Voyage,--Incluido por Erbson 2017-04-27    
 @CE1Mercante1Master CE1Mercante1Master, --Incluido por Erbson 2017-04-28    
 @CE1Mercante CE1Mercante, --Incluido por Erbson 2017-04-28    
 @Agent1Invoice1Number Agent1Invoice1Number,  --Incluido por Erbson 2017-05-02    
 @Entry1Number Entry1Number,  --Incluido por Erbson 2017-05-02    
 @Liberação1Laudo Liberação1Laudo, --Incluido por Erbson 2017-05-02    
 replace(cast(@Volume1descarregado1em1Santos as varchar(40)),',','.') Volume1descarregado1em1Santos, --Incluido por Erbson 2017-05-04    
 @Customer1PO Customer1PO, --Incluido por Erbson 2017-05-04    
 @LI1Date LI1Date, --Incluido por Erbson 2017-05-05    
 @Customs1Transmission1Date Customs1Transmission1Date, --Incluido por Erbson 2017-05-08    
 @Import1License Import1License, --Incluido por Erbson 2017-05-08    
 @Necessidade1de1LIA5 [Necessidade1de1LIA5], --Incluido por Erbson 2017-05-09    
 @DDE1Number DDE1Number, --Incluido por Erbson 2017-05-18    
 @DDE_Date DDE_Date, --Incluido por Erbson 2017-05-18    
 @Sales1Order Sales1Order, --Incluido por Erbson 2017-05-18    
 @Order1Date Order1Date,  --Incluido por Erbson 2017-05-19    
 @NF1Date NF1Date, --Incluido por Erbson 2017-05-19    
 @NF1Number NF1Number, --Incluido por Erbson 2017-05-19    
 @Transit1Register1DTA_Date Transit1Register1DTA_Date, --Incluido por Erbson 2017-05-24    
 @Shipment1Number Shipment1Number,  --Incluido por Erbson 2017-05-24    
 @COA1Number COA1Number, --Incluido por Erbson 2017-05-24    
 @DUE1Number DUE1Number, --Incluido por Rafael 2017-08-11    
 @DUE1Date DUE1Date, --Incluido por Rafael 2017-08-11    
 @RUC1Number RUC1Number, --Incluido por Rafael 2017-08-11    
 @MRUC1Number MRUC1Number, --Incluido por Rafael 2017-08-11    
 @DAT1Number DAT1Number, --Incluido por Rafael 2017-08-11    
 @DAT1Date DAT1Date, --Incluido por Rafael 2017-08-11    
 @Permiso1de1Embarque_Number Permiso1de1Embarque_Number, --Incluido por Rafael 2017-08-24    
 @MICA6DTA_Number MICA6DTA_Number, --Incluido por Rafael 2017-08-24    
 @Urgent1YA6N Urgent1YA6N, --Incluido por Erbson 2017-05-24    
 @CHB1YA6N CHB1YA6N,--Incluido por Erbson 2017-05-24    
 @BDP1Product BDP1Product, --Incluido por Rafael 2017-08-11    
 @Container1Type Container1Type, --Incluido por Erbson 2017-05-25    
 @Packing Packing, --Incluido por Erbson 2017-05-26    
 @Freight1Currency Freight1Currency, --Incluido por Erbson 2017-05-26    
 replace(@Notes,'''','') Notes, --Incluido por Erbson 2017-05-26    
 @Region1of1Origin Region1of1Origin , --Incluido por Erbson 2017-05-26    
 @Region1of1Destination Region1of1Destination, --Incluido por Erbson 2017-05-26    
 @Dispatch1Type Dispatch1Type, --Incluido por Erbson 2017-05-31    
 @CSR1Name CSR1Name, --Incluido por Erbson 2017-05-31    
 @Agent Agent,  --Incluido por Erbson 2017-06-01    
 @Freight1BL Freight1BL, --Incluido por Erbson 2017-06-02    
 isnull(@Container1Qty,0) Container1Qty, --Incluido por Erbson 2017-06-02    
 @Consol1RefA7 Consol1RefA7,  --Incluido por Erbson 2017-06-02    
 replace(cast(cast(@ChargA71Weight_Shipment_Value   AS DECIMAL(18,3)) as Varchar(40)),',','.') ChargA71Weight_Shipment_Value, --Incluido por Erbson 2017-06-02    
 replace(cast(cast(@Gross1Weight_Shipment_Value AS DECIMAL(18,3)) as Varchar(40)),',','.') Gross1Weight_Shipment_Value,  --Incluido por Erbson 2017-06-02    
 replace(cast(cast(@Netweight1KG81Shipment  AS DECIMAL(18,3)) as Varchar(40)),',','.') Netweight1KG81Shipment,    --Incluido por Erbson 2017-06-06    
 @Voyage Voyage,  --Incluido por Erbson 2017-06-06    
 @LLP1UNIT LLP1UNIT,  --Incluido por Erbson 2017-06-06    
 @Carrier Carrier,--Incluido por Erbson 2017-06-07    
 @Containers Containers,--Incluido por Erbson 2017-06-07    
 @Cd_Grupo Cd9Grupo,--Incluido por Erbson 2017-06-07    
 @Register1Date Register1Date, --Incluido por Erbson 2017-06-08    
 @Vessel Vessel, --Incluido por Erbson 2017-06-08    
 @Origin Origin, --Incluido por Erbson 2017-06-08    
 @Country1of1Origin Country1of1Origin , --Incluido por Erbson 2017-06-08    
 @Master Master, --Incluido por Erbson 2017-06-08    
 @House House, --Incluido por Erbson 2017-06-08    
 @Destination Destination, --Incluido por Erbson 2017-06-08    
 @Country1of1Destination Country1of1Destination, --Incluido por Erbson 2017-06-08    
 isnull(@TEUS1Qtys,0) TEUS1Qtys, --Incluido por Erbson 2017-06-08    
 @Booking1Number Booking1Number, --Incluido por Erbson 2017-06-08    
 @Group1Name Group1Name,  --Incluido por Erbson 2017-06-08    
 @Sales1Person Sales1Person, --Incluido por Erbson 2017-06-08    
 @Modal Modal, --Incluido por Erbson 2017-06-08    
 @Bank Bank, --Incluido por Erbson 2017-06-09    
 @Dead1at1Terminal_Date Dead1at1Terminal_Date,  --Incluido por Erbson 2017-06-09    
 @Country1of1Final1Destination Country1of1Final1Destination,  --Incluido por Erbson 2017-06-09    
 @Inland1Trucker Inland1Trucker,  --Incluido por Erbson 2017-06-12    
 @Dead1Line1Draft_DT Dead1Line1Draft_DT, --Incluido por Erbson 2017-06-12    
 @Cut1off_DT Cut1off_DT, --Incluido por Erbson 2017-06-12    
 @VGM1DeadLine_DT VGM1DeadLine_DT, --Incluido por Erbson 2017.07.12    
 @Original1ETA_Date Original1ETA_Date, --Incluido por Erbson 2017-06-13    
 @PO1Request1Del1Date PO1Request1Del1Date, --Incluido por Erbson 2017-06-13    
 @ETA1Date  ETA1Date, --Incluido por Erbson 2017-06-13    
 @ETD1Date  ETD1Date, --Incluido por Erbson 2017-06-13    
 @ATA1Date  ATA1Date, --Incluido por Erbson 2017-06-13    
 @ATD1Date  ATD1Date, --Incluido por Erbson 2017-06-13    
 @Month1of1Arrival Month1of1Arrival, --Incluido por Erbson 2017-06-13    
 @Intl1Reference Intl1Reference, --Incluido por Erbson 2017-06-13    
 @Type1Of1Cargo Type1Of1Cargo, --Incluido por Erbson 2017-06-13    
 @Channel Channel,  --Incluido por Erbson 2017-06-13    
 @BDP1System1Code BDP1System1Code,  --Incluido por Erbson 2017-06-13    
 @Import1A61Export Import1A61Export, --Incluido por Erbson 2017-06-19    
 @Partner Partner, --Incluido por Cadu 2017-10-26    
 @DUE1Access1Key1Number DUE1Access1Key1Number,  --Incluido por Erbson 2017-11-03    
 @CHB1Collaborator CHB1Collaborator,  --Incluido por Erbson 2017-11-03    
 @Receipt1Sent_Transportation_Date Receipt1Sent_Transportation_Date, --Incluido por Erbson 2017-11-22    
 @DGR1Request1Docs_Date DGR1Request1Docs_Date, --Incluido por Erbson 2017-11-22    
 @DTA1Request1Docs_Date DTA1Request1Docs_Date, --Incluido por Erbson 2017-11-22    
 @PDF_Shipping1Instructions PDF_Shipping1Instructions, --Incluido por Erbson 2017-11-22    
 @PDF_Commercial1Proposal PDF_Commercial1Proposal, --Incluido por Erbson 2017-11-22    
 @PC1Draft1Send_Date PC1Draft1Send_Date, --Incluido por Erbson 2017-11-30    
 @Protocol1MAPA1IN26_Date Protocol1MAPA1IN26_Date, --Incluido por Erbson 2017-12-04    
 @BOL1Post1Audit1Back_Date BOL1Post1Audit1Back_Date,  --Incluido por Erbson 2017-12-06    
 @Entry1Terminal Entry1Terminal,   --Incluido por Erbson 2017-12-12    
 @Billing1Authorization1CHB_Date Billing1Authorization1CHB_Date,   --Incluido por Cadu 2017-12-26    
 @Billing1Authorization1CSR_Date Billing1Authorization1CSR_Date,  --Incluido por Cadu 2017-12-26    
 @Billing1Authorization1Transpor_Date Billing1Authorization1Transpor_Date,--Incluido por Cadu 2017-12-26    
 @Engineer1Report1Value Engineer1Report1Value,--Incluido por Cadu 2017-12-28    
 @Engineer1Name Engineer1Name--Incluido por Cadu 2017-12-28    
      
    
      
  ,REPLACE(@Invoice1Currency,'REL','BRL') Invoice1Currency --Incluido por Cadu 2018-04-30    
  --@Invoice1Currency Invoice1Currency,     
  ,replace(cast(@Invoice1Value as varchar(40)),',','.') Invoice1Value --Incluido por Cadu 2018-04-30    
   --replace(cast(@Invoice1Value as varchar(40)),',','.') Invoice1Value,    
  ,REPLACE(@Invoice1Currency1Val,'REL','BRL') Invoice1Currency1and1Val --Incluido por Cadu 2018-04-30    
  --@Invoice1Currency1Val Invoice1Currency1and1Val,    
      
  ,@ExchangeRatesUSDValue Exchange1Rate1Value_USD --[Exchange Rate Value - USD] --Incluido por Cadu 2018-04-30    
      
  --,@Freight1Currency_DI Freight1Currency_DI   --[Freight Currency - DI] --Incluido por Cadu 2018-04-30    
  ,REPLACE(@Freight1Currency_DI,'REL','BRL') Freight1Currency_DI    
  --,@CFR1Currency_DI FOB1Currency_DI     --[FOB Currency - DI] --Incluido por Cadu 2018-04-30    
  ,REPLACE(@CFR1Currency_DI,'REL','BRL') FOB1Currency_DI,    
      
 @Dangerous1Goods Dangerous1Goods,    
     
 --100-124172    
 --NF BDP Issued - Number    
 [dbo].[fBusca_TipoDocCliente]('N',@num_proc,147) NF1BDP1Issued_Number,    
 --NF BDP Issued - Date    
 [dbo].[fBusca_TipoDocCliente]('D',@num_proc,147) NF1BDP1Issued_Date,    
 --Container Yard Sending - Date    
 @ContainerYardSendingDate Container1Yard1Sending_Date, --[Container Yard Sending - Date]     
 --Insurance Company Release - Date     
 @InsuranceCompanyReleaseDate Insurance1Company1Release_Date, --[Container Yard Request Date]     
     
 left([dbo].[fBusca_TipoDocCliente]('N',@Num_Proc,233),200) LPCO_NUMBER, --[LPCO - Number]    
 [dbo].[fBusca_TipoDocCliente]('D',@Num_Proc,233)  LPCO_DATE, --[LPCO - Date]    
 @Customs1Clearance1Terminal  Customs1Clearance1Terminal,--[Customs Clearance Terminal]    
 @Redex1Reason Redex1Reason, --Redex Reason    
 @Correction1Customs1Clearance1Export Correction1Customs1Clearance1Export, --[Correction Customs Clearance Export]           
 @Export1Agent1Commission Export1Agent1Commission, --[Export Agent Commission]     
     
 @Rectification1Dispatch_Exp_Date Rectification1Dispatch_Exp_Date, --[Rectification Dispatch - Exp - Date]    
 @Doc1Delivery1to1Invoice1CHB_Date Doc1Delivery1to1Invoice1CHB_Date, --[Doc Delivery to Invoice CHB - Date]    
 @PDF_BOOKING PDF_BOOKING, --[PDF - BOOKING]    
 @PDF_PO PDF_PO,  --[PDF - PO]    
 left([dbo].[fBusca_TipoDocCliente]('N',@Num_Proc,20),100) BL_Number, --[BL - Number] --Tipo de Documento: 20 - Doc. Embarque    
     
 @Delivery1Address Delivery1Address, --[Delivery Address] task: 146 - Delivery Address    
 @Agricultural1Batch Agricultural1Batch,    
     
 @Shipping1Confirmation1Sent_Date Shipping1Confirmation1Sent_Date, --[Shipping Confirmation Sent - Date] 184 - Envio do Shipment Confirmation    
 @Inter8Stacking1Input_Date Inter8Stacking1Input_Date,    
 @Get1Early_Date Get1Early_Date,    
 @Insurance Insurance,    
 @Exchange1Rates1Due_Date Exchange1Rates1Due_Date,    
 @Danfe1Value Danfe1Value,    
     
 @Loading1at1the1Terminal_Date Loading1at1the1Terminal_Date, -- [Loading at the Terminal - Date] 223 Retirada da Carga no Terminal    
 @GR1Efetivo_Date GR1Efetivo_Date, --[GR Efetivo - Date] - 222 GR Actual    
 @GR1Previsto_Date GR1Previsto_Date, -- [GR Previsto - Date] 177 P000031345 D GR previsto    
 @GoodReceiptDateActual Entrega1na1Planta_Date, --[Entrega na Planta - Date] id_task=13    
 @PO1Request1Del1Date GR1Atual_Date --[GR Atual - Date]    
 ,@Envio_de_Impurezas Envio1de1Impurezas_Date -- Alessandra 09/08/2019    
 ,@Receb_Ordem_confirmation Receb1Ordem1confirmation -- Alessandra 10/07/2019 - 100-159526    
 ,@Proforma_aprovada Proforma1aprovada  -- Alessandra 10/07/2019 - 100-159526    
 ,@Vencimento_de_Armagenagem Vencimento1de1Armagenagem -- Alessandra 10/07/2019 - 100-159526    
 ,@Vencimento_da_demurrage  Vencimento1da1demurrage -- Alessandra 10/07/2019 - 100-159526    
     
 ,replace(@Last1Historic1Client,'''','') Last1Historic1Client --incluido cadu 2019-10-16    
   
  , @CaixaIronMountain 'Caixa1Iron1Mountain_Arquivo' --Marcela 04/05/2020   
, @ETDOriginal ETD1Original --Marcela 04/05/2020   
 , @QtdeItensDUE Qtde1Itens --Quantidades de itens as Qtde Itens --Marcela 04/05/2020   192- Quantidade de itens na DUE ADDITIONAL FIELDS
 , @QtdeAdicoes Qtde1Adicoes -- Quantidades de adições as Qtde adições --Marcela 04/05/2020   
  
 , @ProdutoDisponivel Product1available --Marcela 04/05/2020   
 , @ProtocoloMinExercito Protocol1MinA71Exercito1Date --Marcela 04/05/2020   
 , @RecebOrderConfirmation Received1Order1Confirmation --Marcela 04/05/2020   
 , @EmissaoBLOriginalDestino Emissão1de1BL1Original1Destino --Marcela 04/05/2020   
 , @EmissaoBLoriginalorigem Emissão1de1BL1original1origem --Marcela 04/05/2020   
  
 , @SaldoDoProcesso Account1Balance --Marcela 04/05/2020   
 , @FRETECHB Frete1internacional1pago --Marcela 04/05/2020   
  
 , @038Proforma PDF_Proforma --Marcela 04/05/2020   
-- , @PDFCEMERCANTE PDF_CE1MERCANTE --Marcela 04/05/2020   
 , @017CartaCorrecao PDF_Correction1letter --Marcela 04/05/2020   
 , @057FichaEmergencia PDF_FERMEG --Marcela 04/05/2020   
 , @215FichaEmergencia PDF_Anexo1VII --Marcela 04/05/2020   
  
-- , @CFOP CFOP --Marcela 04/05/2020   
 , @QtdeItensDUE204 Qtde1Itens1DUE --Marcela 04/05/2020   204-DUE REFERENCIAS  192- Quantidade de itens na DUE ADDITIONAL FIELDS
 , @DUIMP DUIMP --Marcela 04/05/2020   
 , @DATADUIMP DUIMP1DATE --Marcela 04/05/2020   
 , @DataCEMercante CE1DATE --Marcela 04/05/2020   
  ,@Report1DamagedY6AN Report1DamagedY6AN --Anderson - 2020-06-04 Ticket 100-232189
  ,@Cargo1Damaged1Description Cargo1Damaged1Description --Anderson - 2020-06-04 Ticket 100-232189
  ,@Insurance1Letter_Sent1Date Insurance1Letter_Sent1Date  --Anderson - 2020-06-04 Ticket 100-232189
  
 From    
 @Adiantamento    
     
OPTION(HASH JOIN)    
    
--select * from Tarefas_Processos where id_task = 218 and dt_conclusao is not null and Dt_Conclusao > GETDATE() -10    
    
GO
