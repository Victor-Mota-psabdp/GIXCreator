SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
--[dbo].[spRManagerv2Header_Sel] 'EACSR201511008BR'
--spRManagerv2Header_TESTE_Sel
CREATE Procedure [dbo].[spRManagerv2Header_TESTE_Sel] 
	@Num_Proc	Varchar(16)
as

--declare @Num_Proc	Varchar(16)
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
	
*/

--Declare @Num_Proc	Varchar(16)
--set @Num_Proc = 'IMUPL201501017BR'

Declare @DataSyncro						Datetime		--Imports
Declare @DemurrageHistoric				Varchar(500)	--IM
Declare @DemurragePeriod				Varchar(20)		--IM
Declare @WarehousePeriod				Varchar(20)		--IM
Declare @LiExpiredDate					Datetime		--Imports
Declare @LIType							Varchar(30)		--Imports
Declare @Usuario						Varchar(30) 	--Account Manager informado no Grupo 
Declare @ICMSexonerationDate			Datetime		-- Task Manager Data de Exoneração de ICMS  
Declare @ICMSExonerationPDF				Varchar(3)		--Indicação se PDF foi anexado no sistema
Declare @WarehousePaymentDate			Datetime		--Data de Pagamento da Armazenagem 08-11-2011
Declare @ExchangeRatesValue				Varchar(15)		--Imports
DEclare @DemurrageInvoiceNumber			Varchar(50)		--IM
Declare @DemurrageInvoiceDate			Datetime		--IM
Declare @AntiDumpingValuebyShipment		float
Declare @AFRMMValuebyShipment			float			--IM
Declare @ICMSPaymentDate				Datetime
Declare @PDFRequerimento				VarChar(3)
Declare @Forwarder						Varchar(30)		--Imports: Incluso para todos os Modais: 02/04/2013
Declare @ShipperMaster					Varchar(30)
Declare @FreightType					Varchar(30)
Declare @WarehouseHistoric				Varchar(255)	--IM
Declare @InvoiceapprovalbycustomerDate	datetime
Declare @ExportRegisterReceiptDate		Datetime
DEclare @TerminalmoverequestbyCustomerDate Datetime	--IM
Declare @PDFSolRedestinaçãoCliente		Varchar(3)		--IM
Declare @BookingConfirmationDate		Datetime
Declare @CustomsClearanceDate			Datetime
Declare @GoodReceiptDateActual			Datetime
Declare	@GoodReceiptDateEstimated		Datetime
Declare @PlantExitDateActual			Datetime
Declare @PlantExitDateEstimated			Datetime
Declare @DocSentDate					Datetime
Declare @NFEDraftDate					Datetime
Declare @BillofLadingBackDate			Datetime
Declare @EnvioCHBFaturamentoDate		Datetime
Declare @OrderReceivedDate					Datetime
Declare @BDPInvoiceCreationDate				Datetime
Declare @PositioningContainerRequireDate	Datetime
Declare @TerminalEntryDate			Datetime
Declare @AverbacaoEXPDate			Datetime
DEclare @WoodInspectionDate			Datetime
Declare @DocSentBLBRDate			Datetime
Declare @DocsToCambioDate			Datetime
Declare @DocsToBDPBillingDate		Datetime
Declare @AFRMMPaymentDate			Datetime
Declare @EntryrequirementDate		Datetime
Declare @DueDateSupplier			Datetime
Declare @SurveyRequestDate			Datetime
Declare @IMOApprovalDate			Datetime
Declare @PDF_NF_omplementar			Varchar(3)
Declare @ArrivalattheborderDate		Datetime
Declare @AuthorizationCrossDate		Datetime
Declare @PDFRemittance				VArchar(3)
Declare @ETD1Original_Date			Datetime
Declare @Withdrawalof1Samples_Date	Datetime
Declare @DANumber					Varchar(40)
Declare @DA_Date					Datetime
Declare @PDF_DA						Varchar(3)
Declare @NFIssueValue				Varchar(40)
Declare @Invoice1Currency			Varchar(3)
Declare @Invoice1Currency1Val		Varchar(50)
Declare @Invoice1Value				Varchar(40)
DEclare @FinalDestination			Varchar(40)
Declare @Notify						Varchar(50)
Declare @Incoterm					Varchar(3)
Declare @Consignee					Varchar(50)
Declare @Shipper					Varchar(50)
Declare @CNPJ						Varchar(20)
Declare @ConsigneeAddress					Varchar(500)
Declare	@CityofConsignee					Varchar(25)
Declare @Terminal							Varchar(50)
--Declare @CIFValue							Varchar(40)
Declare @BL1Payment1Date					datetime
Declare @BDP1Invoice1Date					Datetime
Declare @Process1Status						Varchar(40)
Declare @PDF_Protocolo1Transporte			Varchar(3)
Declare @Reason1Code1Events					Varchar(300)
Declare @Drawback1Number					Varchar(30)
Declare @Certified1Of1Origin1Number			Varchar(30)
Declare @Products1by1Shipment				Varchar(500)
Declare @Product1IDs1by1Shipment			Varchar(200)
Declare @IPI1Value1by1Shipment				decimal(18,2)	
Declare @Cofins1Value1by1Shipment			decimal(18,2)
Declare @PIS1Value1by1Shipment				decimal(18,2)
Declare @Import1Duties1Value1by1Shipment	decimal(18,2)
Declare @Siscomex1Debit1Value1by1Shipment	decimal(18,2)
Declare @Terminal1Pier1Name					Varchar(50)


--Terminal Pier Name
	Set @Terminal1Pier1Name=(select Descricao_Op from campo_processo with(nolock) Join Tipo_operador_Portuario T with(nolock)  on T.id_op=campo_dados where num_proc=@num_proc and id_Campo=139)
	
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
		set @Product1IDs1by1Shipment=(select 	dbo.fBusca_PRODUTO(@Num_PRoc))
		
	--Numero do Drawback
		set @Drawback1Number= (select [dbo].[fBusca_TipoDocCliente]('N',@num_proc,24))

	
	--Numero do Cerfificado de Origem
		set @Certified1Of1Origin1Number= (select [dbo].[fBusca_TipoDocCliente]('N',@num_proc,13))
		Declare @Certified1Of1Origin1Date datetime
		set @Certified1Of1Origin1Date= (select [dbo].[fBusca_TipoDocCliente]('D',@num_proc,13))

--FIM 30/10/2013

--Informações do House
	Declare @Shipper1Address Varchar(150)
	Declare @Volume1M3	Decimal(10,2)
	Declare @Seller1Code Varchar(15)
	
	exec spRManagerv2House_Sel @Num_Proc,@Notify output,@Incoterm output,@Consignee output,@Shipper output, @CNPJ output,@ConsigneeAddress output, @CityofConsignee output, @Shipper1Address Output, @Volume1M3 output,@Seller1Code output
	SEt @Consignee=replace(@Consignee,char(39),' ')
	SEt @Shipper=replace(@Shipper,char(39),' ')
	Set @Notify=replace(@notify,char(39),' ')
	Set @ConsigneeAddress=replace(@ConsigneeAddress,char(39),' ')
	Set @CityofConsignee=replace(@CityofConsignee,char(39),' ')
	Set @Shipper1Address=replace(@Shipper1Address,char(39),' ')

-- Invoices
exec spReportManagerInvoiceValorMoeda_Sel @Num_Proc,@Invoice1Currency output,@Invoice1Value output,@Invoice1Currency1Val output


set @BDP1Invoice1Date=(select top 1 isnull(fatdtemissao,fatdtvenc) from fatura fat with(nolock) Join vwcliente C on C.num_proc=left(fat.fatcod,16) where fatstatus<>0 and left(fatcod,16)=@num_proc order by 1 desc )





--Informações LLP
exec SpReportManagerV2_LLP @Num_PRoc,@FinalDestination output,@Terminal output
	Set @Terminal=replace(@Terminal,char(39),' ')

--Campo_Processo
	--Declare @Manufacturer Varchar(50)
	Declare @Return1Terminal Varchar(50)
	Declare @Controlled1Goods varchar(3)
	Declare @Free1Time varchar(50)
	Declare @DJAI1Approval varchar(50)
	Declare @Delivery1of1Documents varchar(50)
	--Set @Manufacturer = (select top 1 nome_raz_Soc from pessoa with (nolock) join campo_processo CP with(nolock) on CP.campo_dados=cd_pes and id_Campo=1 where num_proc=@Num_Proc) 

	
	Set @Return1Terminal = (select top 1 nome_terminal from Terminal with (nolock) join campo_processo CP with(nolock) on CP.campo_dados=cd_terminal and id_Campo=3 where num_proc=@Num_Proc) 
	
	Set @Controlled1Goods = (select (case Campo_Dados when '1' then 'YES' when '2' then 'NO' end) from campo_processo with(nolock)  where id_campo = '123' and num_proc=@Num_Proc)
	
	Set @Free1Time = (select Campo_Dados from campo_processo with(nolock)  where id_campo = '138' and num_proc=@Num_Proc)
	
	Set @DJAI1Approval = (select Campo_Dados from campo_processo with(nolock)  where id_campo = '140' and num_proc=@Num_Proc)
	Set @Delivery1of1Documents = (select (case Campo_Dados when 'BNC' then 'Bank' when 'DPC' then 'Customer Brokerage' when 'DRT' then 'Direct' end) from campo_processo with(nolock) where id_campo ='141' and num_proc=@num_proc)

	--Cadu = 09/2/2015
	Declare @ParteLote varchar(3)
	Set @ParteLote = (select (case Campo_Dados when '1' then 'YES' when '2' then 'NO' end) from campo_processo with(nolock)  where id_campo = '144' and num_proc=@Num_Proc)
	
	--Cadu = 09/2/2015 - desabilitado 17-6 - cadu
	--Declare @Country1Manufacturer varchar(50)
	--Set @Country1Manufacturer = (select top 1 Nome_Pais from Pais with (nolock) join campo_processo CP with(nolock) on CP.campo_dados=Cd_Pais and id_Campo=145 where num_proc=@Num_Proc) 
--TASKS
	Declare @ClosingSpreadsheettocustomer_Date datetime

	set @ClosingSpreadsheettocustomer_Date=(select dt_conclusao from tarefas_processos with (nolock) where id_task=123 and num_proc=@num_proc)
	
	Declare @BL1Released_Date Datetime
	set @BL1Released_Date=(select dt_conclusao from tarefas_processos with (nolock) where id_task=21 and num_proc=@num_proc)
	
	
	Set @IMOApprovalDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=122 and dt_conclusao is not null)

	Set @ArrivalattheborderDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=107 and dt_conclusao is not null)
	Set @AuthorizationCrossDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=112 and dt_conclusao is not null)


	Set @BookingConfirmationDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=5 and dt_conclusao is not null)
	Set @CustomsClearanceDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=4 and dt_conclusao is not null)
	Select top 1  @GoodReceiptDateEstimated=Dt_Previsao,@GoodReceiptDateActual=dt_conclusao from Tarefas_processos with(nolock) where num_proc=@Num_Proc and id_task=13
	Select top 1  @PlantExitDateEstimated=Dt_Previsao,@PlantExitDateActual=dt_conclusao from Tarefas_processos with(nolock) where num_proc=@Num_Proc and id_task=10
	Set @DocSentDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=12 and dt_conclusao is not null)
	Set @DocsToCambioDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=23 and dt_conclusao is not null)
	Set @DocsToBDPBillingDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=26 and dt_conclusao is not null)
	
	Declare @DocsSentToForeignBank DateTime
	Set @DocsSentToForeignBank= (select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=139 and dt_conclusao is not null)
	Declare @DocsDeliveredToForeignBank DateTime
	Set @DocsDeliveredToForeignBank=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=140 and dt_conclusao is not null)

	--Cadu - 04/02/2015
	Declare @DraftApprovalImportDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,41) Draft_Imp,
	Set @DraftApprovalImportDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=41 and dt_conclusao is not null)
	
	Declare @LIRequest DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,46) SolLI,Cadu 04/02/2015
	Set @LIRequest=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=46 and dt_conclusao is not null)
		
	Declare @DTAClearanceDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,18) LibDTA
	Set @DTAClearanceDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=18 and dt_conclusao is not null)
		
	--Incluido para Exportação - Ticket #100-57752
	Declare @PortEntryDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,15) Presenca
	if LEFT(@Num_Proc,1) ='I'
		begin 
			Set @PortEntryDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=15 and dt_conclusao is not null)
		End
	if LEFT(@num_proc,1)='E'
		begin 
			Set @PortEntryDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=189 and dt_conclusao is not null)
		End
		
	Declare @TransportDocDeliveryDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,7) Doc_Deliv
	Set @TransportDocDeliveryDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=7 and dt_conclusao is not null)
	
	Declare @UnloadedDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,29) Desova
	Set @UnloadedDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=29 and dt_conclusao is not null)
		
	Declare @PREDIDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,27) Digitacao_DI
	Set @PREDIDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=27 and dt_conclusao is not null)
	
	Declare @RemocaoDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,19) Remocao
	Set @RemocaoDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=19 and dt_conclusao is not null)
		
	Declare @FileOpen DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,60) FileOpen
	Set @FileOpen=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=60 and dt_conclusao is not null)
		
	Declare @ContainerYardRequestDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,42) Redistinacao
	Set @ContainerYardRequestDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=42 and dt_conclusao is not null)
	
	Declare @DocsReceivedDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,16) DocsReceived
	Set @DocsReceivedDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=16 and dt_conclusao is not null)
	
	Declare @NFBDPDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,78) EnvioCobranca,
	Set @NFBDPDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=78 and dt_conclusao is not null)
	
	Declare @AdvancedRequestDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,59) SolAdto
	Set @AdvancedRequestDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=59 and dt_conclusao is not null)
	
	Declare @Dt_SI DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,45) Dt_SI
	Set @Dt_SI=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=45 and dt_conclusao is not null)
	
	Declare @DtGreenLight DateTime --[[dbo].[fBusca_Tarefa](@Num_Proc,39) Dt_Aut
	Set @DtGreenLight=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=39 and dt_conclusao is not null)
		
	Declare @DefLI DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,20) Def_LI,
	Set @DefLI=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=20 and dt_conclusao is not null)
		
	Declare @InvoiceSentDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,40) Envio_Prestacao
	Set @InvoiceSentDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=40 and dt_conclusao is not null)
	
	Declare @BRIssuedDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,80) Emissao_BLBR
	Set @BRIssuedDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=80 and dt_conclusao is not null)
	
	Declare @DraftSentCustomerDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,84) Envio_Draft_Cliente
	Set @DraftSentCustomerDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=84 and dt_conclusao is not null)
	
	Declare @DraftReceivedDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,83) Recebimento_Draft
	Set @DraftReceivedDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=83 and dt_conclusao is not null)
	
	Declare @DraftBackDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,85) Retorno_Draft_Cliente
	Set @DraftBackDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=85 and dt_conclusao is not null)
	
	Declare @BDPPreInvoice DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,79) PREFaturamento
	Set @BDPPreInvoice=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=79 and dt_conclusao is not null)
	
	Declare @EnvioShipping DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,45) EnvioShipping
	Set @EnvioShipping=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=45 and dt_conclusao is not null)
	
	Declare @TruckLoading DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,100) Confirmacao_Carregamento
	Set @TruckLoading=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=100 and dt_conclusao is not null)
	
	Declare @DraftExport DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,66) Draft_Exp
	Set @DraftExport=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=66 and dt_conclusao is not null)
	
	Declare @AverbacaoImpDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,68) Averbacao_imp
	Set @AverbacaoImpDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=68 and dt_conclusao is not null)
	
	Declare @PosicionamentoEfetivo DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,104) Posicionamento_Efetivo,
	Set @PosicionamentoEfetivo=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=104 and dt_conclusao is not null)
	
	Declare @InspMAPA DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,105)InspMAPA
	Set @InspMAPA=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=105 and dt_conclusao is not null)
	
	Declare @ProftRegister DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,905) RegProft
	Set @ProftRegister=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=905 and dt_conclusao is not null)
	
	Declare @TransmissionValue DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,87) EnvioVlores
	Set @TransmissionValue=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=87 and dt_conclusao is not null)
	
	Declare @ProcessOKpaymentHBL DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,88) ProcessoOKPPG,
	Set @ProcessOKpaymentHBL=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=88 and dt_conclusao is not null)
	
	Declare @ManifestDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,8) Manifesto
	Set @ManifestDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=8 and dt_conclusao is not null)
	
	Declare @SiscargaRegister DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,903) RegSiscarga
	Set @SiscargaRegister=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=903 and dt_conclusao is not null)
	
	Declare @DocsOKregister DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,63) DocsPRestrito,
	Set @DocsOKregister=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=63 and dt_conclusao is not null)
	
	Declare @PreAlertSending DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,1) EnvioPreAlerta
	Set @PreAlertSending=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=1 and dt_conclusao is not null)
	
	--**************
	Declare @ChegadaFronteira DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,31) ChegadaFronteira
	Set @ChegadaFronteira=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=31 and dt_conclusao is not null)
	
	Declare @Cumplido DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,6) Cumplido
	Set @Cumplido=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=6 and dt_conclusao is not null)
	
	Declare @Cumplido_Est DateTime --[dbo].[fBusca_Tarefa_Prev](@Num_Proc,6) Cumplido_Est
	Set @Cumplido_Est=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=6 and dt_conclusao is not null)
	
	Declare @AnticipoDOC DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,202) AnticipoDOC
	Set @AnticipoDOC=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=202 and dt_conclusao is not null)
	
	Declare @InvoiceController DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,203) Invoice_SentC,
	Set @InvoiceController=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=203 and dt_conclusao is not null)
	
	Declare @EntrCobranca DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,201) Entrega_Cobr
	Set @EntrCobranca=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=201 and dt_conclusao is not null)
	
	Declare @BDPCambio DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,86)  Cambio_BDP
	Set @BDPCambio=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=86 and dt_conclusao is not null)
	
	Declare @DIDraftOKDateBRonly DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,65)  Conf_DI
	Set @DIDraftOKDateBRonly=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=65 and dt_conclusao is not null)
	
	Declare @DanfeReceiptDateBRonly DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,108)  DANFE_Recebe
	Set @DanfeReceiptDateBRonly=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=108 and dt_conclusao is not null)
	
	Declare @BDPInvoiceReceiptDateBRonly DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,77)  PrestacaoRecibo
	Set @BDPInvoiceReceiptDateBRonly=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=77 and dt_conclusao is not null)
	
	Declare @ReceivedMBLDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,110) Receb_MBL
	Set @ReceivedMBLDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=110 and dt_conclusao is not null)
	
	Declare @ReceivedHBLDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,111) Receb_HBL
	Set @ReceivedHBLDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=111 and dt_conclusao is not null)
	
	Declare @SurveyDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,114) Receb_LaudoArqueacao
	Set @SurveyDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=114 and dt_conclusao is not null)
	
	Declare @TransshipmentArrivalDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,38) TransshipmentArrival
	Set @TransshipmentArrivalDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=38 and dt_conclusao is not null)
	
	Declare @TransshipmentDepartureDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,37) TransshipmentDeparture
	Set @TransshipmentDepartureDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=37 and dt_conclusao is not null)
	
	Declare @BookingRequestDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,58) Solic_Booking
	Set @BookingRequestDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=58 and dt_conclusao is not null)
		
	
	--Cadu - 11/02/2015		
	--*********************************	
	Declare @EnvioDoc1 DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,89) Doc_1,
	Set @EnvioDoc1=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=89 and dt_conclusao is not null)
	
	Declare @RecDoc1 DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,90) Rec_Doc_1,
	Set @RecDoc1=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=90 and dt_conclusao is not null)
		
	Declare @Def1 DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,91) Def_1,
	Set @Def1=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=91 and dt_conclusao is not null)
		
	Declare @EnvioDoc2 DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,92) Doc_2,
	Set @EnvioDoc2=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=92 and dt_conclusao is not null)
		
	Declare @Def2 DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,93) Def_2,
	Set @Def2=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=93 and dt_conclusao is not null)
	--*********************************
			
	Declare @DanfeRequest DateTime -- solicitação por ticket - 300-5854
	Set @DanfeRequest=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=142 and dt_conclusao is not null)
	
	Declare @DanfeReceipt DateTime
	Set @DanfeReceipt=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=143 and dt_conclusao is not null)
	
	--Tasks Especifico do BR
	
		Declare @Sending1Of1Invoice1Amount1Date Datetime ---ID Task=87
		Declare @Sending1Of1Banking1Collection1Date Datetime --ID Task=124
		Declare @Warehouse1Expiration1Date	Datetime -- ID campo=131		
		Declare @DeadLine1Loading1Date		Datetime -- ID Campo=130
		Declare @Docs1ok1to1Delivery1Inland1Trucker1Date	Datetime -- ID task=125
		Declare @CRT1Received1Date		Datetime -- ID=127
		
		Set @Sending1Of1Invoice1Amount1Date=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=87 and dt_conclusao is not null)
		Set @Sending1Of1Banking1Collection1Date=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=124 and dt_conclusao is not null)
		SEt @Warehouse1Expiration1Date=(select convert(Datetime,campo_dados,103) from campo_processo with(nolock) where id_campo=131 and campo_dados is not null and num_proc=@Num_Proc)
		SEt @DeadLine1Loading1Date=(select convert(Datetime,campo_dados,103) from campo_processo with(nolock) where id_campo=130 and campo_dados is not null and num_proc=@Num_Proc)

		Set @CRT1Received1Date=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=127 and dt_conclusao is not null)

		Set @Docs1ok1to1Delivery1Inland1Trucker1Date=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=125 and dt_conclusao is not null)
	
		Set @NFEDraftDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=67 and dt_conclusao is not null)
		Set @BillofLadingBackDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=82 and dt_conclusao is not null)
		Set @EnvioCHBFaturamentoDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=62 and dt_conclusao is not null)
		Set @OrderReceivedDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=50 and dt_conclusao is not null)
		Set @BDPInvoiceCreationDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=76 and dt_conclusao is not null)
		Set @InvoiceapprovalbycustomerDate=(select top 1 dt_conclusao from tarefas_processos with(nolock) where num_proc=@Num_Proc and id_Task=117)
		Set @PositioningContainerRequireDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=103 and dt_conclusao is not null)
		Set @TerminalEntryDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=28 and dt_conclusao is not null)
		Set @AverbacaoEXPDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=15 and dt_conclusao is not null)
		Set @WoodInspectionDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=30 and dt_conclusao is not null)
		Set @DocSentBLBRDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=81 and dt_conclusao is not null)
		Set @AFRMMPaymentDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=25 and dt_conclusao is not null)
		Set @EntryrequirementDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=51 and dt_conclusao is not null)
		SEt @ETD1Original_Date=(select convert(Datetime,campo_dados,103) from campo_processo where id_campo=127 and campo_dados is not null and num_proc=@Num_Proc)
		Set @Withdrawalof1Samples_Date=(select top 1 dt_conclusao from Tarefas_processos with(nolock) where num_proc=@num_proc and id_task=113 and dt_conclusao is not null)
		SEt @NFIssueValue= (select campo_Dados from campo_processo with(nolock) where id_Campo=117 and num_proc=@num_proc and campo_dados is not null)
		--SEt @CIFValue= (select campo_Dados from campo_processo where id_Campo=110 and num_proc=@num_proc and campo_dados is not null)


	--Doc Especifico BR
			if exists(select Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=15)
				Begin
					Set @PDFRemittance='YES'
				End
			Else
				Begin
					Set @PDFRemittance	='NO'
				End

	--Doc Especifico BR - DOCS PARA TRANSPORTE
			if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=90)
				Begin
					Set @PDF_Protocolo1Transporte='YES'
				End
			Else
				Begin
					Set @PDF_Protocolo1Transporte	='NO'
				End
	--BL PDF 
			Declare @PDF_BL Varchar(3)
			if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=20)
				Begin
					Set @PDF_BL='YES'
				End
			Else
				Begin
					Set @PDF_BL	='NO'
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
						Set @PDF_RE	='NO'
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
						Set @PDF_DDE	='NO'
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
						Set @PDF_Form1A	='NO'
					End		
				End
				
			Declare @PDF_Insurance Varchar(4)
			if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=21)
				Begin
					Set @PDF_Insurance='YES'
				End
			Else
				Begin
					Set @PDF_Insurance	='NO'
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
					Set @PDF_Arqueacao	='NO'
				End		


			Declare @PDF_Saque Varchar(4)
			if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=65)
				Begin
					Set @PDF_Saque='YES'
				End
			Else
				Begin
					Set @PDF_Saque	='NO'
				End		

			Declare @PDF_Courier Varchar(4)
			if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=103)
				Begin
					Set @PDF_Courier='YES'
				End
			Else
				Begin
					Set @PDF_Courier	='NO'
				End		


			Declare @PDF_Courier12 Varchar(4)
			if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=94)
				Begin
					Set @PDF_Courier12='YES'
				End
			Else
				Begin
					Set @PDF_Courier12	='NO'
				End		




				
			Declare @PDF_COA Varchar(3)
			if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=16)
				Begin
					Set @PDF_COA='YES'
				End
			Else
				Begin
					Set @PDF_COA	='NO'
				End								

			Declare @PDF_COO Varchar(3)
			
			if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=13)
				Begin
					Set @PDF_COO='YES'
				End
			Else
				Begin
					Set @PDF_COO	='NO'
				End								

				
			Declare @PDF_PL Varchar(3)
			if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=11)
				Begin
					Set @PDF_PL='YES'
				End
			Else
				Begin
					Set @PDF_PL	='NO'
				End								

				
			Declare @PDF_NF Varchar(3)
			if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=10)
				Begin
					Set @PDF_NF='YES'
				End
			Else
				Begin
					Set @PDF_NF	='NO'
				End								
				
				
			Declare @PDF_PC Varchar(3)
			if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=60)
				Begin
					Set @PDF_PC='YES'
				End
			Else
				Begin
					Set @PDF_PC	='NO'
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
						Set @PDF_DI	='NO'
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
						Set @PDF_CAPA	='NO'
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
						Set @PDF_BL1Original	='NO'
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
						Set @PDF_AFRMM	='NO'
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
						Set @PDF_ICMS	='NO'
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
						Set @PDF_LI	='NO'
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
						Set @PDF_CI	='NO'
					End		
				End


	--Ticket do Andre Souza - 100-14750
		--029-Ce Mercante		
			Declare @PDF_CE1Mercante	Varchar(3)
			if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=29)
				Begin
					Set @PDF_CE1Mercante='YES'
				End
			Else
				Begin
					Set @PDF_CE1Mercante	='NO'
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


---- Pagamento de Liberação de BL
--	if substring(@Num_proc,2,1)='M'
--		Begin
--			Set @BL1Payment1Date=(select top 1  convert(datetime,dt_pgto_rcto_hia,105) from vwcxas cxa with (nolock) join tipo_taxa tt with (nolock) on tt.cd_tp_tx=cxa.cd_tp_tx where num_proc_hia=@Num_proc and nome_tp_tx like 'Liberação de BL%' and dc_hia='D') 
--		End
	
--alterei pra ver antes no task, se não tiver pega no vwcxas - cadu 11/2/2015
	BEGIN
		--Este codigo era feito no vb6	
		Declare @BLPaymentDate DateTime --[dbo].[fBusca_Tarefa](@Num_Proc,21) LibBL
		Set @BL1Payment1Date=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) where num_proc=@Num_PRoc and id_task=21 and dt_conclusao is not null)
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
	if left(@Num_proc,1)='E'
		Begin		
			Set @DDE1or1DSE1Value=(select top 1 campo_Dados from campo_processo with (nolock) where id_campo=137 and num_proc=@Num_Proc)
			Set @NFSerie=(select top 1 left(campo_Dados,10) from campo_processo with (nolock) where id_campo=112 and num_proc=@Num_Proc)

			Set @ExportRegisterReceiptDate=(select top 1 dt_conclusao from tarefas_processos with (nolock) where num_proc=@Num_Proc and id_Task=119)
			Set @RE1Value=(select top 1 campo_Dados from campo_processo with (nolock) where id_campo=71 and num_proc=@Num_Proc)
			Set @Siscomex1Destination1Code=(select top 1 left(campo_Dados,10) from campo_processo with (nolock) where id_campo=136 and num_proc=@Num_Proc)
			Set @BPS1COD1SISCOMEX=(select top 1 left(campo_Dados,10) from campo_processo with (nolock) where id_campo=135 and num_proc=@Num_Proc)
			
		End

	if left(@num_proc,1)='I'
		Begin

			if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=59)
				Begin
					Set @PDF_DA='YES'
				End
			Else
				Begin
					Set @PDF_DA	='NO'
				End


			if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=54)
				Begin
					Set @PDF_NF_omplementar='YES'
				End
			Else
				Begin
					Set @PDF_NF_omplementar	='NO'
				End


			Set @ICMSPaymentDate = (select top 1 dt_conclusao from tarefas_processos with(nolock) where num_proc=@num_proc and id_task=24 and dt_conclusao is not null)
			Set @AntiDumpingValuebyShipment=(select sum(valor) from custo_processo with(nolock) where cd_tp_tx in (select cd_tp_Tx from tipo_taxa with(nolock) where nome_tp_tx like '%Dumping%') and num_proc=@Num_PRoc)
			Set @ExchangeRatesValue=(select campo_dados Paridade from campo_processo with(nolock) where  id_campo=31 and num_proc=@Num_Proc)
			Set @DataSyncro = (select top 1 data_envio from nota_cliente with(nolock) where num_proc=@Num_Proc)
			Set @LiExpiredDate=(select max(dt_vencimento) from solicitacao_li with(nolock) where num_proc=@Num_Proc)
			Set @LIType=(select top 1 cast(id_tipo as varchar(2)) + '-' + Nome_Tp_LI from solicitacao_li SL with(nolock) Join Tipo_LI TL on TL.id_Tipo=SL.id_tipo_li where num_proc=@num_proc order by dt_solicitacao desc)
			Set @ICMSexonerationDate=(select top 1 dt_conclusao from tarefas_processos with(nolock) where num_proc=@Num_Proc and id_Task=61 and dt_conclusao is not null)
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
		
		
--Separação por Modal
	if left(@Num_Proc,2)='IM'
		Begin
			Set @DemurrageHistoric = (select top 1 campo_dados from campo_processo with(nolock) where num_proc=@Num_Proc and id_Campo=105)
			Set @DemurragePeriod=(select top 1 campo_dados from campo_processo with(nolock) where num_proc=@Num_Proc and id_Campo=102)
			Set @WarehousePeriod=(select top 1 campo_dados from campo_processo with(nolock) where num_proc=@Num_Proc and id_Campo=108)
			Set @WarehouseHistoric=(select left(campo_dados,255) from campo_processo where id_Campo=120 and num_proc=@Num_Proc)
			Set @DemurrageInvoiceNumber=(select top 1 numero_po_him from po_him  with(nolock) where id_dc=106 and num_proc_him=@Num_Proc)
			set @DemurrageInvoiceDate=(select top 1 data_po_him from po_him with(nolock) where id_dc=106 and num_proc_him=@Num_Proc)
			Set @AFRMMValuebyShipment=(select sum(valor) from custo_processo with(nolock) where cd_tp_tx in (select cd_tp_Tx from tipo_taxa with(nolock) where nome_tp_tx like '%AFRMM%') and num_proc=@Num_PRoc)
			SEt @TerminalmoverequestbyCustomerDate=(select top 1 dt_conclusao from tarefas_processos with(nolock) where num_proc=@Num_Proc and id_task=118)
			Set @FreightType=(Select case tp_frete_him when 'P' then 'Prepaid' when 'C' then 'Collect' End from house_imp_mar with(nolock) where num_proc_him=@Num_Proc)
			set @SurveyRequestDate=(select top 1 convert(Datetime,campo_dados,103) from campo_processo with(nolock) where num_proc=@Num_Proc and id_campo=124 and campo_dados is not null)


			if exists(select  Nome_Arquivo from doc_anexos with(nolock) where num_proc=@num_proc and id_dc=126)
				Begin
					set @PDFSolRedestinaçãoCliente='YES'
				End
			Else
				Begin
					set @PDFSolRedestinaçãoCliente='NO'
				End

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
	if left(@num_proc,2)='IA'
			Begin
				Select 	@Forwarder=Apelido,
					@process1Status=
					(
						case
							when Status_Descricao is not null then cast(TSP.id_status as varchar(2)) + ' - ' + Status_Descricao
							else Null
						End 
					),
					@PlaceofReceipt = LC.Nome_Local				
				from LLP_Imp_aer  LLP with(nolock)
				Left Join Pessoa PP with(nolock) on pp.cd_pes=cd_forwarder	
				Left Join Tipo_Status_Processo TSP with(nolock) on LLP.id_status=TSP.id_Status
				Left Join Localidade LC with(nolock) on LLP.Cd_Planta_LIA = LC.Cd_Local
				
				Where Num_proc_lia=@Num_Proc
			End
			
	if left(@num_proc,2)='IM'
			Begin
				Select 	@Forwarder=Apelido,
					@process1Status=
					(
						case
							when Status_Descricao is not null then cast(TSP.id_status as varchar(2)) + ' - ' + Status_Descricao
							else Null
						End 
					),
					@PlaceofReceipt = LC.Nome_Local	
				from LLP_Imp_Mar  LLP with(nolock)
				Left Join Pessoa PP with(nolock) on pp.cd_pes=cd_forwarder	
				Left Join Tipo_Status_Processo TSP with(nolock) on LLP.id_status=TSP.id_Status
				Left Join Localidade LC with(nolock) on LLP.Cd_Planta_LIM = LC.Cd_Local
				Where Num_proc_lim=@Num_Proc
			End

	if left(@num_proc,2)='IO'
			Begin
				Select 	@Forwarder=Apelido,
					@process1Status=
					(
						case
							when Status_Descricao is not null then cast(TSP.id_status as varchar(2)) + ' - ' + Status_Descricao
							else Null
						End 
					),
					@PlaceofReceipt = LC.Nome_Local	
				from LLP_Imp_out  LLP with(nolock)
				Left Join Pessoa PP with(nolock) on pp.cd_pes=cd_forwarder	
				Left Join Tipo_Status_Processo TSP with(nolock) on LLP.id_status=TSP.id_Status
				Left Join Localidade LC with(nolock) on LLP.Cd_Planta_LIO = LC.Cd_Local
				Where Num_proc_lio=@Num_Proc
			End
	if left(@num_proc,2)='EO'
			Begin
				Select 	@Forwarder=Apelido,
					@process1Status=
					(
						case
							when Status_Descricao is not null then cast(TSP.id_status as varchar(2)) + ' - ' + Status_Descricao
							else Null
						End 
					),
					@PlaceofReceipt = LC.Nome_Local	
				from LLP_exp_out  LLP with(nolock)
				Left Join Pessoa PP with(nolock) on pp.cd_pes=cd_forwarder	
				Left Join Tipo_Status_Processo TSP with(nolock) on LLP.id_status=TSP.id_Status
				Left Join Localidade LC with(nolock) on LLP.Cd_Planta_LEO = LC.Cd_Local
				Where Num_proc_leo=@Num_Proc
			End
	if left(@num_proc,2)='EM'
			Begin
				Select 	@Forwarder=Apelido,
					@process1Status=
					(
						case
							when Status_Descricao is not null then cast(TSP.id_status as varchar(2)) + ' - ' + Status_Descricao
							else Null
						End 
					),
					@PlaceofReceipt = LC.Nome_Local	
				from LLP_exp_mar  LLP with(nolock)
				Left Join Pessoa PP with(nolock) on pp.cd_pes=cd_forwarder	
				Left Join Tipo_Status_Processo TSP with(nolock) on LLP.id_status=TSP.id_Status
				Left Join Localidade LC with(nolock) on LLP.Cd_Planta_LEM = LC.Cd_Local
				Where Num_proc_lem=@Num_Proc
			End

	if left(@num_proc,2)='EA'
			Begin
				Select 	@Forwarder=Apelido,
					@process1Status=
					(
						case
							when Status_Descricao is not null then cast(TSP.id_status as varchar(2)) + ' - ' + Status_Descricao
							else Null
						End 
					),
					@PlaceofReceipt = LC.Nome_Local	
				from LLP_exp_aer  LLP with(nolock)
				Left Join Pessoa PP with(nolock) on pp.cd_pes=cd_forwarder	
				Left Join Tipo_Status_Processo TSP with(nolock) on LLP.id_status=TSP.id_Status
				Left Join Localidade LC with(nolock) on LLP.Cd_Planta_LEA = LC.Cd_Local
				Where Num_proc_lea=@Num_Proc
			End


--@AdvancementValue,@AdvancementValue
	Declare @Adiantamento Table
		(
			AdvancementReceivedDate Datetime,
			AdvancementValue		Varchar(15)
			
		)
	Insert @Adiantamento
	select max(convert(datetime,dt_pgto_rcto_hia,105)) data,cast(sum(vlr_pgto_Rcto_hia) as varchar(15)) Valor from vwcxas with (nolock) where num_proc_hia=@Num_Proc and dc_hia='C' and cd_tp_Tx in (select cd_tp_Tx from tipo_taxa with(nolock) where nome_tp_tx like 'Adiantamento%') 
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
		Set @SurveyRequestDate=(select top 1 convert(Datetime,campo_dados,103) from campo_processo with(nolock) where num_proc=@Num_Proc and id_campo=124 and campo_dados is not null)
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

Set @DueDateSupplier=(select top 1 convert(datetime,campo_dados,105) from campo_processo with(nolock) where num_proc=@num_proc and id_campo=29)


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

--[Total Siscomex Value by Shipment]=isnull([Fines by Shipment],0)+isnull([Cofins Value by Shipment],0)+isnull([PIS Value by Shipment],0)+isnull([IPI Value by Shipment],0)+isnull([Import Duties Value by Shipment],0)+isnull([Siscomex Debit Value by Shipment],0),
Declare @Total1Siscomex1Value1by1Shipment decimal(18,2)
set @Total1Siscomex1Value1by1Shipment = isnull(@Cofins1Value1by1Shipment,0)+isnull(@PIS1Value1by1Shipment,0)+isnull(@IPI1Value1by1Shipment,0)+
isnull(@Import1Duties1Value1by1Shipment,0)+isnull(@Siscomex1Debit1Value1by1Shipment,0)
--obs: nao encontrei este campo isnull([Fines by Shipment],0)+

--[Total  Taxes Value by Shipment]=Isnull([State Tax by Shipment],0)+Isnull([Total Siscomex Value by Shipment],0)
Declare @Total11Taxes1Value1by1Shipment decimal(18,2)
set @Total11Taxes1Value1by1Shipment = Isnull(@Total1Siscomex1Value1by1Shipment,0)	

	
	
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
	@ArrivalattheborderDate Arrival1at1the1border_Date, @AuthorizationCrossDate	Authorization1Cross_Date, [dbo].[fBusca_TipoDocCliente]('N',@num_proc,15) Remittance1Number,
	[dbo].[fBusca_TipoDocCliente]('D',@num_proc,15) Remittance1Date,@PDFRemittance PDF_Remittance, [dbo].[fBusca_TipoDocCliente]('N',@num_proc,133) Treatment1Cargo_Number,
	[dbo].[fBusca_TipoDocCliente]('D',@num_proc,133) Treatment1Cargo_Date, @ETD1Original_Date Original1ETD_Date,
	@Withdrawalof1Samples_Date Withdrawal1of1Samples_Date, @PDF_DA PDF_DA, [dbo].[fBusca_TipoDocCliente]('D',@num_proc,59) DA_Date,[dbo].[fBusca_TipoDocCliente]('N',@num_proc,59) DA1Number,
	@NFIssueValue NF1Issue_Value, @Invoice1Currency Invoice1Currency, replace(cast(@Invoice1Value as varchar(40)),',','.') Invoice1Value, @Invoice1Currency1Val Invoice1Currency1and1Val,
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
    replace(cast(@IPI1Value1by1Shipment	as varchar(40)),',','.') IPI1Value1by1Shipment ,

    replace(cast(@Cofins1Value1by1Shipment	as varchar(40)),',','.') Cofins1Value1by1Shipment ,
    replace(cast(@PIS1Value1by1Shipment	 as varchar(40)), ',','.')	PIS1Value1by1Shipment,
    replace(cast(@Import1Duties1Value1by1Shipment	 as varchar(40)), ',','.')	Import1Duties1Value1by1Shipment,
    replace(cast(@Siscomex1Debit1Value1by1Shipment	 as varchar(40)), ',','.')	Siscomex1Debit1Value1by1Shipment,
    @Terminal1Pier1Name Terminal1Pier1Name,[dbo].[fBusca_TipoDocCliente]('D',@num_proc,36) Direct1Colletion_Date,
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
	replace(cast(@BL1Pieces	 as varchar(40)), ',','.') BL1Pieces,
	
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
	
	@TransshipmentArrivalDate [Transshipment181Arrival_Date], --[Transshipment – Arrival - Date] 
	@TransshipmentDepartureDate [Transshipment181Departure_Date], --[Transshipment – Departure - Date]	
	@BookingRequestDate Booking1Request1Date, --[Booking Request Date]	
	
	--*********************************************
	@EnvioDoc1 [A0Envio1Docs1Brasilia_Date], --[1 Envio Docs Brasilia - Date]
	@RecDoc1 [A0Receb.1em1Brasilia_Date],	 --[1 Receb. em Brasilia - Date]
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
	@Courier1Number Courier1Number --Incluido por Rafael Lindenberg 2016-05-19
	
	
	,replace(cast(@Total11Taxes1Value1by1Shipment	as varchar(40)),',','.') Total11Taxes1Value1by1Shipment ,
	replace(cast(@Total1Siscomex1Value1by1Shipment	as varchar(40)),',','.') Total1Siscomex1Value1by1Shipment
	
From
	@Adiantamento
	
	
OPTION(HASH JOIN)


GO
