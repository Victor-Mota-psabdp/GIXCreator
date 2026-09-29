SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spATL_Reembolso_DOW_Rel]
(
	@Grupo			VARCHAR(50),  
	@DTINICIAL	    DATETIME,
	@DTFINAL		DATETIME,
	@Tipo           varchar(1)
)

AS
 
IF @Grupo is NULL  
BEGIN  
	SET @Grupo = ''  
END  

/* -------------------------------------------------------------------------------------------------------------------------
HISTORY CHANGE
. Date:			14/04/2023
. Business:		Antonio e Sibério Bezerra (Siberio.Bezerra@bdpint.com)
. Dept:			Financeiro/Faturamento
. Developer:	Antonio Jose 
. Ticket:		100-384167	
. Request:		File upload to Dow refund
				Criar relatório com o resumo do reembolso para integrar com o sistema da DOW.
				Informação extraida do relatório XLS Report Prestação de Contas.
-------------------------------------------------------------------------------------------------------------------------
EXECUTION 
exec spATL_Reembolso_DOW_Rel 'GRUPO DOW','2022-12-27','2022-12-31', 'R', 'C'
-- Reembolso 
-- Conferencia 
-------------------------------------------------------------------------------------------------------------------------
*/

SET NOCOUNT ON
declare @total_adiantamento float
declare @total_Despesas float
declare @saldo float
declare @AdtoSemana varchar(100)

DECLARE @PrestCC_Detalhe TABLE 
(
	[Data encerramento] [datetime],
	[JOB] [varchar](16) ,
	[PO] [varchar](400) ,
	[CNPJ] [varchar](14) ,
	[Favorecido] [varchar](60)  ,
	[CD_TP_TX] [varchar](3) ,
	[NOME_TP_TX] [varchar](200) ,
	TP_PGTO [char] (1),
	[Valor] DECIMAL(20,2),
	[VENCIMENTO] [datetime],
	TP CHAR(1),
	[BusinessTransaction]		VARCHAR(3),
	[CompanyCode]				VARCHAR(4),
	[SiteContact]				VARCHAR(50),
	[InvoiceDate]				[datetime],
	[IncomingDate]				[datetime],
	[VendorNumber]				VARCHAR(7),
	[VendorInvoiceNumber]		VARCHAR(50),
	[InvoiceAmount]		    	DECIMAL(18,2),
	[Currency]					VARCHAR(3),
	[TaxCode]					VARCHAR(2),
	[PartnerBank]				VARCHAR(4),
	[LineItemAmount]			DECIMAL(18,2),
	[Quantity]			        VARCHAR(1),
	[UnitofMeasure]		        VARCHAR(2),
	[TextforExpenseLineItem]	VARCHAR(50),
	[Assignment]	            VARCHAR(50),
	[VendorItemText]	        VARCHAR(50),
	[GLaccount]				    VARCHAR(6),
	[ProfitCenter]			    VARCHAR(8),
	[MaterialGroup]			    VARCHAR(8),
	[Plant]					    VARCHAR(10),
	[TaxTariff]				    VARCHAR(5)
	) 

DECLARE @PrestCC_Consolidado TABLE 
(
	[ORDEM]	INT IDENTITY(1,1), 
	[Data encerramento] [datetime],
	[JOB] [varchar](16) ,
	[PO] [varchar](400) ,
	[CNPJ] [varchar](14) ,
	[Favorecido] [varchar](60)  ,
	[Adiantamento] DECIMAL(20,2) ,
	[Despesas + comissão BDP] DECIMAL(20,2) ,
	[Saldo final da Prestação de contas] DECIMAL(20,2),
	[A RECEBER / A DEVOLVER] [varchar](20) ,
	[VENCIMENTO] [datetime],
	[BusinessTransaction]		VARCHAR(3),
	[CompanyCode]				VARCHAR(4),
	[SiteContact]				VARCHAR(50),
	[InvoiceDate]				[datetime],
	[IncomingDate]				[datetime],
	[VendorNumber]				VARCHAR(7),
	[VendorInvoiceNumber]		VARCHAR(50),
	[InvoiceAmount]		    	DECIMAL(18,2),
	[Currency]					VARCHAR(3),
	[TaxCode]					VARCHAR(2),
	[PartnerBank]				VARCHAR(4),
	[LineItemAmount]			DECIMAL(18,2),
	[Quantity]			        VARCHAR(1),
	[UnitofMeasure]		        VARCHAR(2),
	[TextforExpenseLineItem]	VARCHAR(50),
	[Assignment]	            VARCHAR(50),
	[VendorItemText]	        VARCHAR(50),
	[GLaccount]				    VARCHAR(6),
	[ProfitCenter]			    VARCHAR(8),
	[MaterialGroup]			    VARCHAR(8),
	[Plant]					    VARCHAR(10),
	[TaxTariff]				    VARCHAR(5)
	) 

	INSERT INTO @PrestCC_Detalhe
	(
	[Data encerramento] 
	,[JOB]
	,[PO]
	,[CNPJ]
	,[Favorecido]
	,[CD_TP_TX]
	,[NOME_TP_TX]
	,[TP_PGTO]
	,[Valor] 
	,[VENCIMENTO]
	,[BusinessTransaction]
	,[CompanyCode]
	,[SiteContact]
	,[InvoiceDate]
	,[IncomingDate]
	,[VendorNumber]
	,[VendorInvoiceNumber]
	,[InvoiceAmount]
	,[Currency]
	,[TaxCode]
	,[PartnerBank]
	,[LineItemAmount]
	,[Quantity]
	,[UnitofMeasure]
	,[TextforExpenseLineItem]
	,[Assignment]
	,[VendorItemText]
	,[GLaccount]
	,[ProfitCenter]
	,[MaterialGroup]
	,[Plant]
	,[TaxTariff] 	)
	SELECT 
	DISTINCT 
	FAT.Data_PC												as [Data encerramento]
	,LEFT(FAT.FATURA_PC,16)									as [JOB]
	,case when left(fat.fatura_pc,2) = 'BO' THEN
		dbo.fbusca_docs_po_modal(LEFT(FAT.FATURA_PC,16),'1')
	ELSE
		--dbo.fbusca_docs_po_modal(LEFT(FAT.FATURA_PC,16),'1')
		dbo.fBusca_PO_NumPedido(LEFT(FAT.FATURA_PC,16),'')     
	END														as [PO]
	,right(PP.Num_CPF_CNPJ,14) 								as [CNPJ]
	,PP.Nome_Raz_Soc										as [Favorecido]
	,ITM.CD_TP_TX
	,TT.NOME_TP_TX
	,TP_PGTO
	,ISNULL(ITM.VLR_PC,0)
	,fatDtVenc
	,'INV'														AS	[BusinessTransaction]	--BusinessTransaction		SBD															Campo Não Editável
	,REPLICATE ('0',4 - LEN(CP.Campo_Dados)) + CP.Campo_Dados	AS	[CompanyCode]			--CompanyCode				31 - Dow Brasil Ind e Com Ltda
																								--							833 - Dow Brasil Sudeste Ltda
																								--							4308 - Palmyra Silicio do Brasil
																								--							4083 - Rohm & Haas Quimica
																								--							4621 - Performance Material Brasil

		,'LFuzettiNeves@dow.com'									AS	[SiteContact]			--SiteContact				SiteContact	E-mail
		,convert(datetime, getdate(), 105)                          AS  [InvoiceDate]
		,convert(datetime, getdate(), 105)                          AS  [IncomingDate]
		,'1058637'                                                  AS  [VendorNumber]
		,[dbo].[FRemoveCaracteresEspeciais](vPO.Numero_PO)          AS  [VendorInvoiceNumber]
		,0                                                          AS  [InvoiceAmount]
		,'BRL'														AS	[Currency]				--Currency					BRL															Campo Não Editável
		,'YY'														AS	[TaxCode]				--TaxCode					YY															Campo Não Editável
		,'BRP1'														AS	[PartnerBank]			--PartnerBank				1058637 - BRP1												Campo Não Editável
		,'0'														AS	[LineItemAmount]																						--							1398350 - BRP1
		,'1'														AS	[Quantity]																						--							1398350 - BRP1
		,'EA'														AS	[UnitofMeasure]																						--							1398350 - BRP1
		,vPO.Numero_PO      										AS	[TextforExpenseLineItem]																				--							1398350 - 2027372
		,vPO.Numero_PO												AS	[Assignment]		
		,vPO.Numero_PO												AS	[VendorItemText]		
		,'148173'													AS	[GLaccount]
		,'8526'							     						AS	[ProfitCenter]
		,'93160000'													AS	[MaterialGroup]
		,CP27.Campo_Dados											AS	[Plant]
		,'99.99'													AS	[TaxTariff]
	FROM 
	FATURA_CHB FAT (nolock) 
	INNER JOIN FATURA_CHB_ITEM ITM (nolock)  
		ON ITM.FATURA_CC=FAT.FATURA_PC
	INNER JOIN PESSOA PP (nolock) 
		ON PP.CD_PES=CD_PES_PC
	INNER JOIN Pessoa_LLP PLL (nolock) 
		ON PP.CD_PES = PLL.CD_PES
	INNER JOIN Grupo G (nolock) 
		on PLL.cd_pes_grupo = G.Cd_Pes_Grupo
	INNER JOIN pessoa PG  (nolock) 
		on G.cd_pes_grupo=PG.CD_PES  

	LEFT JOIN Campo_Pessoa	CP		(NOLOCK) ON FAT.cd_pes_PC	=	CP.Cd_Pes    AND CP.Id_Campo = '25'
	LEFT JOIN Campo_Pessoa	CP27	(NOLOCK) ON FAT.cd_pes_PC	=	CP27.Cd_Pes  AND CP27.Id_Campo = '27'
	LEFT JOIN vwPO_ALL vPO          (NOLOCK) ON FAT.Processo_PC =   vPO.Num_Proc AND vPO.ID_DC = 25
																	and vPO.Data_PO   between @DtInicial and @DtFinal
	   	                        
	LEFT JOIN VWCTA_CTE CCH (nolock)  
		on CCH.Num_Proc_HIA = LEFT(FATURA_PC,16) 
		and CCH.Num_NF_HIA is not null 
		AND CCH.Ref_Acesso_NF_HIA <> 'P' 
		AND CCH.Ref_Acesso_NF_HIA is not null 
		and cch.cd_tp_tx = ITM.cd_tp_tx
	INNER join Tipo_Taxa TT (nolock)  on TT.cd_tp_Tx=itm.cd_tp_Tx
	INNER Join Fatura (nolock)  on fatcod=fatura_pc
	WHERE  TP_PGTO in ('B','A')
	and status_pc <> 'C'
	AND (PG.Apelido like @Grupo or @Grupo ='Grupo ALL')
	and FAT.Data_PC   between @DtInicial and @DtFinal
	
	--	and LEFT(FATURA_PC,16) = 'IMCSR202109234BR' -- TO TEST

	--dados da consolidada
	INSERT INTO @PrestCC_Detalhe
	(
	[Data encerramento] 
	,[JOB]
	,[PO]
	,[CNPJ]
	,[Favorecido]
	,[CD_TP_TX]
	,[NOME_TP_TX]
	,[TP_PGTO]
	,[Valor] 
	,[VENCIMENTO]
	,[BusinessTransaction]
	,[CompanyCode]
	,[SiteContact]
	,[InvoiceDate]
	,[IncomingDate]
	,[VendorNumber]
	,[VendorInvoiceNumber]
	,[InvoiceAmount]
	,[Currency]
	,[TaxCode]
	,[PartnerBank]
	,[LineItemAmount]
	,[Quantity]
	,[UnitofMeasure]
	,[TextforExpenseLineItem]
	,[Assignment]
	,[VendorItemText]
	,[GLaccount]
	,[ProfitCenter]
	,[MaterialGroup]
	,[Plant]
	,[TaxTariff]
	)
	SELECT 
	DISTINCT 
	FAT.Data_PC												as [Data encerramento]
	,LEFT(FAT.FATURA_PC,16)									as [JOB]
	,dbo.fBusca_PO_NumPedido(LEFT(FAT.FATURA_PC,16),'')     as [PO]
	,right(PP.Num_CPF_CNPJ,14) 								as [CNPJ]
	,PP.Nome_Raz_Soc										as [Favorecido]
	,IFT.CD_TP_TX
	,NOME_TP_TX + ' ('+ FAT.BDP_Invoice + ')' NOME_TP_TX
	,TP_PGTO
	,ISNULL(IFT.Vlr_RS,0)
	,f.fatDtVenc
	,'INV'														AS	[BusinessTransaction]	--BusinessTransaction		SBD															Campo Não Editável
	,REPLICATE ('0',4 - LEN(CP.Campo_Dados)) + CP.Campo_Dados	AS	[CompanyCode]			--CompanyCode				31 - Dow Brasil Ind e Com Ltda
																								--							833 - Dow Brasil Sudeste Ltda
																								--							4308 - Palmyra Silicio do Brasil
																								--							4083 - Rohm & Haas Quimica
																								--							4621 - Performance Material Brasil

		,'LFuzettiNeves@dow.com'									AS	[SiteContact]			--SiteContact				SiteContact	E-mail
		,convert(datetime, getdate(), 105)                           AS  [InvoiceDate]
		,convert(datetime, getdate(), 105)                           AS  [IncomingDate]
		,'1058637'                                                  AS  [VendorNumber]
		,[dbo].[FRemoveCaracteresEspeciais](vPO.Numero_PO)          AS  [VendorInvoiceNumber]
		,0                                                          AS  [InvoiceAmount]
		,'BRL'														AS	[Currency]				--Currency					BRL															Campo Não Editável
		,'YY'														AS	[TaxCode]				--TaxCode					YY															Campo Não Editável
		,'BRP1'														AS	[PartnerBank]			--PartnerBank				1058637 - BRP1												Campo Não Editável
		,'0'														AS	[LineItemAmount]																						--							1398350 - BRP1
		,'1'														AS	[Quantity]																						--							1398350 - BRP1
		,'EA'														AS	[UnitofMeasure]																						--							1398350 - BRP1
		,vPO.Numero_PO												AS	[TextforExpenseLineItem]																				--							1398350 - 2027372
		,vPO.Numero_PO												AS	[Assignment]		
		,vPO.Numero_PO												AS	[VendorItemText]		
		,'148173'													AS	[GLaccount]
		,'8526'							     						AS	[ProfitCenter]
		,'93160000'													AS	[MaterialGroup]
		,CP27.Campo_Dados											AS	[Plant]
		,'99.99'													AS	[TaxTariff]
	FROM 
	FATURA_CHB FAT (nolock) 
	INNER JOIN FATURA_CHB_ITEM ITM (nolock)  
		ON ITM.FATURA_CC=FAT.FATURA_PC

	INNER JOIN Fatura FT with(nolock)
		on FT.fatcod=FAT.BDP_Invoice
	INNER JOIN Item_Fat IFT with(nolock)
		on FT.fatcod = IFT.FatCod

	INNER JOIN PESSOA PP (nolock) 
		ON PP.CD_PES=CD_PES_PC

	INNER JOIN Pessoa_LLP PLL (nolock) 
		ON PP.CD_PES = PLL.CD_PES
	INNER JOIN Grupo G (nolock) 
		on PLL.cd_pes_grupo = G.Cd_Pes_Grupo
	INNER JOIN pessoa PG  (nolock) 
		on G.cd_pes_grupo=PG.CD_PES  
	
	LEFT JOIN Campo_Pessoa	CP		(NOLOCK) ON FAT.cd_pes_PC	=	CP.Cd_Pes    AND CP.Id_Campo = '25'
	LEFT JOIN Campo_Pessoa	CP27	(NOLOCK) ON FAT.cd_pes_PC	=	CP27.Cd_Pes  AND CP27.Id_Campo = '27'
	LEFT JOIN vwPO_ALL vPO          (NOLOCK) ON FAT.Processo_PC =   vPO.Num_Proc AND vPO.ID_DC = 25 
																	and vPO.Data_PO between @DtInicial and @DtFinal 

	LEFT JOIN VWCTA_CTE CCH (nolock)  
		on CCH.Num_Proc_HIA = LEFT(FATURA_PC,16) 
		and CCH.Num_NF_HIA is not null 
		AND CCH.Ref_Acesso_NF_HIA <> 'P' 
		AND CCH.Ref_Acesso_NF_HIA is not null 
		and cch.cd_tp_tx = ITM.cd_tp_tx
	INNER join Tipo_Taxa TT (nolock) on TT.cd_tp_Tx=IFT.cd_tp_Tx
	INNER Join Fatura f (nolock)  on f.fatcod=fatura_pc
	WHERE  TP_PGTO in ('B','A')
	and status_pc <> 'C'
	AND (PG.Apelido like @Grupo or @Grupo ='Grupo ALL')
	and FAT.Data_PC between @DtInicial and @DtFinal
	
	--and LEFT(FATURA_PC,16) = 'IMCSR202109234BR'  -- Test 

	--SELECT 
	--DBO.fTipo_Taxa_pc([CD_TP_TX],[NOME_TP_TX])
	--,TP_PGTO
	--,
	--* FROM @PrestCC_Detalhe

	update @PrestCC_Detalhe
	set TP = 'A' -- adiantamento
	where DBO.fTipo_Taxa_pc([CD_TP_TX],[NOME_TP_TX]) = 'Adiantamentos'  or TP_PGTO = 'A'

	update @PrestCC_Detalhe
	set TP = 'D' -- DESPESAS
	where DBO.fTipo_Taxa_pc([CD_TP_TX],[NOME_TP_TX]) = 'Despesas' AND NOT TP_PGTO = 'A'


	INSERT INTO @PrestCC_Consolidado
	(
	[Data encerramento] 
	,[JOB] 
	,[PO] 
	,[CNPJ] 
	,[Favorecido] 
	,[Adiantamento] 
	,[Despesas + comissão BDP]
	,[VENCIMENTO]
	,[BusinessTransaction]
	,[CompanyCode]
	,[SiteContact]
	,[InvoiceDate]
	,[IncomingDate]
	,[VendorNumber]
	,[VendorInvoiceNumber]
	,[InvoiceAmount]
	,[Currency]
	,[TaxCode]
	,[PartnerBank]
	,[LineItemAmount]
	,[Quantity]
	,[UnitofMeasure]
	,[TextforExpenseLineItem]
	,[Assignment]
	,[VendorItemText]
	,[GLaccount]
	,[ProfitCenter]
	,[MaterialGroup]
	,[Plant]
	,[TaxTariff]
	)
	SELECT  
	[Data encerramento]		
	,[JOB]					
	,[PO]					
	,[CNPJ]
	,[Favorecido]
	,ISNULL(SUM(CASE WHEN TP = 'A'  THEN
		[Valor]
	END),0)											as [Adiantamento]
	,ISNULL(SUM(CASE WHEN TP = 'D'  THEN
		[Valor] 
	END),0)											as [Despesas + comissão BDP]
	,[VENCIMENTO] 
	,[BusinessTransaction]
	,[CompanyCode]
	,[SiteContact]
	,[InvoiceDate]
	,[IncomingDate]
	,[VendorNumber]
	,[VendorInvoiceNumber]
	,[InvoiceAmount]
	,[Currency]
	,[TaxCode]
	,[PartnerBank]
	,[LineItemAmount]
	,[Quantity]
	,[UnitofMeasure]
	,[TextforExpenseLineItem]
	,[Assignment]
	,[VendorItemText]
	,[GLaccount]
	,[ProfitCenter]
	,[MaterialGroup]
	,[Plant]
	,[TaxTariff]
	FROM @PrestCC_Detalhe
	GROUP BY
	[Data encerramento]		
	,[JOB]					
	,[PO]					
	,[CNPJ]
	,[Favorecido]
	,[VENCIMENTO]
	,[BusinessTransaction]
	,[CompanyCode]
	,[SiteContact]
	,[InvoiceDate]
	,[IncomingDate]
	,[VendorNumber]
	,[VendorInvoiceNumber]
	,[InvoiceAmount]
	,[Currency]
	,[TaxCode]
	,[PartnerBank]
	,[LineItemAmount]
	,[Quantity]
	,[UnitofMeasure]
	,[TextforExpenseLineItem]
	,[Assignment]
	,[VendorItemText]
	,[GLaccount]
	,[ProfitCenter]
	,[MaterialGroup]
	,[Plant]
	,[TaxTariff]
	order by job
	
	UPDATE @PrestCC_Consolidado 
	SET [Saldo final da Prestação de contas] = ([Adiantamento] - [Despesas + comissão BDP])*-1 
		
	UPDATE @PrestCC_Consolidado 
	SET [A RECEBER / A DEVOLVER] = 
	CASE WHEN [Saldo final da Prestação de contas] > 0
	THEN
	'SALDO A RECEBER'
	ELSE 
	'SALDO A DEVOLVER'
	END

	SELECT 
	@total_adiantamento = SUM(ISNULL([Adiantamento],0))
	,@total_Despesas = SUM(ISNULL([Despesas + comissão BDP],0))
	,@saldo = SUM(ISNULL([Saldo final da Prestação de contas],0))
	FROM @PrestCC_Consolidado
	
	set @AdtoSemana = (select top 1 [VendorItemText] from @PrestCC_Consolidado where [VendorItemText] is not null)
	UPDATE @PrestCC_Consolidado 
	SET [VendorInvoiceNumber]    = [dbo].[FRemoveCaracteresEspeciais](@AdtoSemana),
	    [TextforExpenseLineItem] = @AdtoSemana,
	    [Assignment]             = @AdtoSemana,
	    [VendorItemText]         = @AdtoSemana
	where left([JOB],2) = 'BO'  
	   	 
/*
	if exists(select * from @PrestCC_Consolidado)
	begin
		INSERT INTO @PrestCC_Consolidado
		(
		[JOB] 
		,[Adiantamento] 
		,[Despesas + comissão BDP]
		,[Saldo final da Prestação de contas] 
		)
		SELECT 
		'TOTAL'
		,@total_adiantamento
		,@total_Despesas
		,@saldo
	end
*/

if @Tipo ='C'
	begin 
		SELECT
		[Data encerramento] 
		,[JOB] 
		,[PO] 
		,[CNPJ] 
		,[Favorecido] 
		,[Adiantamento] 
		,[Despesas + comissão BDP]
		,[Saldo final da Prestação de contas] 
		,[A RECEBER / A DEVOLVER]
		,[VENCIMENTO]
		,[BusinessTransaction]
		,[CompanyCode]
		,[SiteContact]
		,[InvoiceDate]
		,[IncomingDate]
		,[VendorNumber]
		,[VendorInvoiceNumber]
		,[InvoiceAmount]
		,[Currency]
		,[TaxCode]
		,[PartnerBank]
		,[LineItemAmount]
		,[Quantity]
		,[UnitofMeasure]
		,[TextforExpenseLineItem]
		,[Assignment]
		,[VendorItemText]
		,[GLaccount]
		,[ProfitCenter]
		,[MaterialGroup]
		,[Plant]
		,[TaxTariff]
		FROM @PrestCC_Consolidado 
		order by [CompanyCode]
	end 
else
--Ajustar para separar com companyId unico e somar os valores na tabela de saida 
	begin 
	DECLARE @output TABLE  
		(
		[BusinessTransaction]		VARCHAR(3),
		[CompanyCode]				VARCHAR(4),
		[SiteContact]				VARCHAR(50),
		[InvoiceDate]				[datetime],
		[IncomingDate]				[datetime],
		[VendorNumber]				VARCHAR(7),
		[VendorInvoiceNumber]		VARCHAR(50),
		[InvoiceAmount]		    	DECIMAL(18,2),
		[Currency]					VARCHAR(3),
		[TaxCode]					VARCHAR(2),
		[PartnerBank]				VARCHAR(4),
		[LineItemAmount]			DECIMAL(18,2),
		[Quantity]			        VARCHAR(1),
		[UnitofMeasure]		        VARCHAR(2),
		[TextforExpenseLineItem]	VARCHAR(50),
		[Assignment]	            VARCHAR(50),
		[VendorItemText]	        VARCHAR(50),
		[GLaccount]				    VARCHAR(6),
		[ProfitCenter]			    VARCHAR(8),
		[MaterialGroup]			    VARCHAR(8),
		[Plant]					    VARCHAR(10),
		[TaxTariff]				    VARCHAR(5)
		)
	DECLARE 
		@BusinessTransaction		VARCHAR(3),
		@CompanyCode				VARCHAR(4),
		@SiteContact				VARCHAR(50),
		@InvoiceDate				[datetime],
		@IncomingDate				[datetime],
		@VendorNumber				VARCHAR(7),
		@VendorInvoiceNumber		VARCHAR(50),
		@InvoiceAmount		    	DECIMAL(18,2),
		@Currency					VARCHAR(3),
		@TaxCode					VARCHAR(2),
		@PartnerBank				VARCHAR(4),
		@LineItemAmount			DECIMAL(18,2),
		@Quantity			        VARCHAR(1),
		@UnitofMeasure		        VARCHAR(2),
		@TextforExpenseLineItem  VARCHAR(50),
		@Assignment	            VARCHAR(50),
		@VendorItemText	        VARCHAR(50),
		@GLaccount				    VARCHAR(6),
		@ProfitCenter			    VARCHAR(8),
		@MaterialGroup			    VARCHAR(8),
		@Plant					    VARCHAR(10),
		@TaxTariff				    VARCHAR(5),
		@IdFound               INT           

	DECLARE separa_PrestCC_Consolidado CURSOR
	FOR
		SELECT  
		 [BusinessTransaction]
		,[CompanyCode]
		,[SiteContact]
		,[InvoiceDate]
		,[IncomingDate]
		,[VendorNumber]
		,[VendorInvoiceNumber]
		,[Saldo final da Prestação de contas]
		,[Currency]
		,[TaxCode]
		,[PartnerBank]
		,[Saldo final da Prestação de contas]
		,[Quantity]
		,[UnitofMeasure]
		,[TextforExpenseLineItem]
		,[Assignment]
		,[VendorItemText]
		,[GLaccount]
		,[ProfitCenter]
		,[MaterialGroup]
		,[Plant]
		,[TaxTariff]
		FROM @PrestCC_Consolidado 
		WHERE [CompanyCode] IS NOT NULL
		and [A RECEBER / A DEVOLVER] = 'SALDO A RECEBER'
		and [Adiantamento] = 0 
		order by [CompanyCode]

	OPEN separa_PrestCC_Consolidado

	FETCH NEXT FROM separa_PrestCC_Consolidado
	INTO 	 
		 @BusinessTransaction
		,@CompanyCode
		,@SiteContact
		,@InvoiceDate
		,@IncomingDate
		,@VendorNumber
		,@VendorInvoiceNumber
		,@InvoiceAmount
		,@Currency
		,@TaxCode
		,@PartnerBank
		,@LineItemAmount
		,@Quantity
		,@UnitofMeasure
		,@TextforExpenseLineItem
		,@Assignment
		,@VendorItemText
		,@GLaccount
		,@ProfitCenter
		,@MaterialGroup
		,@Plant
		,@TaxTariff
	WHILE (@@fetch_status = 0)
	BEGIN
		set @IdFound=(SELECT count(*) FROM @output WHERE [CompanyCode] = @CompanyCode)
		IF (@IdFound>0)    
			 BEGIN
				UPDATE @output
				SET [InvoiceAmount]  = [InvoiceAmount]  + @InvoiceAmount,
					[LineItemAmount] = [LineItemAmount] + @InvoiceAmount
				WHERE [CompanyCode] = @CompanyCode
			 END
		ELSE
			BEGIN
				INSERT INTO @output Values 
				(
					 @BusinessTransaction
					,@CompanyCode
					,@SiteContact
					,@InvoiceDate
					,@IncomingDate
					,@VendorNumber
					,replace(@VendorInvoiceNumber,' ','')
					,@InvoiceAmount
					,@Currency
					,@TaxCode
					,@PartnerBank
					,@LineItemAmount
					,@Quantity
					,@UnitofMeasure
					,@TextforExpenseLineItem
					,@Assignment
					,@VendorItemText
					,@GLaccount
					,@ProfitCenter
					,@MaterialGroup
					,@Plant
					,@TaxTariff
							)
		END
		FETCH NEXT FROM separa_PrestCC_Consolidado
			INTO 
				@BusinessTransaction
				,@CompanyCode
				,@SiteContact
				,@InvoiceDate
				,@IncomingDate
				,@VendorNumber
				,@VendorInvoiceNumber
				,@InvoiceAmount
				,@Currency
				,@TaxCode
				,@PartnerBank
				,@LineItemAmount
				,@Quantity
				,@UnitofMeasure
				,@TextforExpenseLineItem
				,@Assignment
				,@VendorItemText
				,@GLaccount
				,@ProfitCenter
				,@MaterialGroup
				,@Plant
				,@TaxTariff
	END
	CLOSE separa_PrestCC_Consolidado
	DEALLOCATE separa_PrestCC_Consolidado
	SELECT * FROM @output order by [CompanyCode]
end 
SET NOCOUNT OFF

GO
