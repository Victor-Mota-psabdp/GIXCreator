SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spATL_PoPc_DOW_Rel]
(
	@Grupo			VARCHAR(50),  
	@DATA_INICIAL	DATETIME,
	@DATA_FINAL		DATETIME
)

AS


--/* -------------------------------------------------------------------------------------------------------------------------
--HISTORY CHANGE
--. Date:			18/11/2020
--. Business:		Tiago Tadeu (Tiago.Alves@bdpint.com) e Sibério Bezerra (Siberio.Bezerra@bdpint.com)
--. Dept:			Financeiro/Faturamento
--. Developer:	Alessandra Suzuki Mariano
--. Ticket:		100-296675	
--. Request:		File Upload to Dow invoicing
--				The idea is to generate and export an excel file for each type of document generated in the billing, containing BDP and client information.
---------------------------------------------------------------------------------------------------------------------------
--EXECUTION 
--exec spATL_PoPc_DOW_Rel 'GRUPO DOW','2022-08-20','2022-11-18'
---------------------------------------------------------------------------------------------------------------------------
--*/

--Somente Importação e BO

--Declare @Grupo			VARCHAR(50)
--Declare @DATA_INICIAL	DATETIME
--Declare @DATA_FINAL		DATETIME

--Set @Grupo = 'GRUPO DOW'
--Set @DATA_INICIAL ='2022-08-20'
--Set @DATA_FINAL = '2022-11-18'


IF @Grupo is NULL  
BEGIN  
	SET @Grupo = ''  
END  

	DECLARE @output TABLE  
	(
		[BusinessTransaction]			VARCHAR(3)
		,[CompanyCode]					VARCHAR(4)
		,[VendorNumber]					VARCHAR(7)
		,[VendorInvoiceNumber]			VARCHAR(17)
		,[InvoiceDate]					VARCHAR(10)
		,[IncomingDate]					VARCHAR(10)
		,[InvoiceAmount]				DECIMAL(18,2)
		,[Currency]						VARCHAR(3)
		,[TaxCode]						CHAR(2)
		,[PaymentMethod]				CHAR(1)

		,[LineItemAmount]				FLOAT
		,[Quantity]						FLOAT
		,[UnitofMeasure]				VARCHAR(5)
		,[PONumber]						VARCHAR(30)

		,[POLineItemNumber]				CHAR(1)
		,[AdditionalCostCondition1]		CHAR(4)
		,[AdditionalCostAmount1]		FLOAT
		,[TaxTariff]					VARCHAR(50)
		,[GLaccount]					VARCHAR(6)
		,[TextforExpenseLineItem]		VARCHAR(255)


		,ID_Referencia					INT
		,ID_PO							INT
		,job_number						VARCHAR(16)
		,Fatura							VARCHAR(25)
	)

	--LINHA DOS DADOS DA REFERENCIA
	DECLARE @Dados_Referencia TABLE  
	(
		ID_Referencia			INT IDENTITY(1,1)
		,Nota_Fiscal			VARCHAR(8)
		,Ref_Acesso				CHAR(1)
		,[BusinessTransaction]	VARCHAR(3)
		,[CompanyCode]			VARCHAR(4)
		,[VendorNumber]			VARCHAR(7)
		,[VendorInvoiceNumber]	VARCHAR(9)
		,[InvoiceDate]			VARCHAR(10)
		,[InvoiceAmount]		DECIMAL(18,2)
		,[Currency]				VARCHAR(3)
		,[TaxCode]				CHAR(2)
		,[PaymentMethod]		CHAR(1)
		,[TaxTariff]			VARCHAR(50)
	)

	--Dados do job e CTA_CTE
	DECLARE @Dados_JOB_e_CTA TABLE
	(
		ID_Referencia			INT
		,Nota_Fiscal			VARCHAR(8)
		,Ref_Acesso				CHAR(1)
		,Num_proc				VARCHAR(16)
		,Vlr_Pgto				DECIMAL(18,2)
		,Qtde_Shipment			INT
	)

	--Dados da Prestacao
	DECLARE @Dados_Prestacao TABLE
	(
		ID_Referencia			INT
		,Nota_Fiscal			VARCHAR(8)
		,Ref_Acesso				CHAR(1)
		,Num_proc				VARCHAR(16)
		,Fatura					VARCHAR(25)
		,Vlr_Pgto				DECIMAL(18,2)
		,Nome_Taxa				VARCHAR(250)
	)

	--Dados do pedido e item do pedido
	DECLARE @Dados_JOB_of_PO TABLE
	(
		ID_Referencia			INT
		,Nota_Fiscal			VARCHAR(8)
		,Ref_Acesso				CHAR(1)
		,Num_proc				VARCHAR(16)
		,[IncomingDate]			VARCHAR(10)
		,[TextforExpenseLineItem]		VARCHAR(255)
	)

	--Dados do pedido e item do pedido
	DECLARE @Dados_PO TABLE
	(
		ID_Referencia					INT
		,ID_PO							INT IDENTITY(1,1)
		,Num_proc						VARCHAR(16)
		,Nota_Fiscal					VARCHAR(8)
		,Ref_Acesso						CHAR(1)
		,Valor_Total					DECIMAL(18,2)
		,[LineItemAmount]				FLOAT
		,[Quantity]						FLOAT
		,[UnitofMeasure]				VARCHAR(5)
		,[PONumber]						VARCHAR(30)

		,[IncomingDate]					VARCHAR(10)
		,[POLineItemNumber]				CHAR(1)
		,[AdditionalCostCondition1]		CHAR(4)
		,[AdditionalCostAmount1]		FLOAT
		,[GLaccount]					VARCHAR(6)
		,[TextforExpenseLineItem]		VARCHAR(255)
		,Fatura							VARCHAR(25)
		,fBuscaPorcentagem_CdPedido_UOM	FLOAT
	)

	DECLARE @controle TABLE 
	(
		ID_Referencia			INT
		,minID_PO				INT 
		,maxID_PO				INT 
		,valorTotalNF			DECIMAL(18,2)
		,sumLineItemAmount		DECIMAL(18,2)
	)


	/*
	Coluna						Detalhes do preenchimento									OBS								
	BusinessTransaction			SDB															Campo Não Editável
	CompanyCode					31 - Dow Brasil Ind e Com Ltda
								833 - Dow Brasil Sudeste Ltda
								4308 - Palmyra Silicio do Brasil
								4083 - Rohm & Haas Quimica
								4621 - Performance Material Brasil
	VendorNumber				1058637														Campo Não Editável
	InvoiceDate					Data de emissão	
	IncomingDate				Data do envio	
	VendorInvoiceNumber			Número da referência	
	InvoiceAmount				Valor total 	
	Currency					BRL															Campo Não Editável
	TaxCode						I3															Campo Não Editável
	PaymentMethod				M															Campo Não Editável
	LineItemAmount				Preencher valor total do adiantamento semanal 
								e somente na linha da conta 148173	
	Quantity					Quantidade da ordem de compra	
	UnitofMeasure				Unidade de medida da ordem de compra	
	PONumber					Número da ordem de compra	
	POLineItemNumber			1															Campo Não Editável
	AdditionalCostCondition1	ZCC															Campo Não Editável
	AdditionalCostAmount1		Valor total da ordem de compra	
	TaxTariff					99,99														Campo Não Editável
	GLaccount					148173														Campo Não Editável
	TextforExpenseLineItem		Número adiantamento semanal ( Ex: ADTO BDP 1) 	
	*/


	INSERT INTO @Dados_Referencia
	(		
		Nota_Fiscal,Ref_Acesso,[BusinessTransaction],[CompanyCode],[VendorNumber],[VendorInvoiceNumber],[InvoiceDate],[InvoiceAmount],[Currency]
		,[TaxCode],[PaymentMethod],[TaxTariff]
	)
	SELECT																				
		BNF.Nota_Fiscal												AS	Nota_Fiscal
		,BNF.Ref_Acesso												AS	Ref_Acesso
		,'SDB'														AS	[BusinessTransaction]
		,REPLICATE ('0',4 - LEN(CP.Campo_Dados)) + CP.Campo_Dados	AS	[CompanyCode]			
		--,CASE BNF.Ref_Acesso 
		--WHEN 'K' THEN  '1058637' 
		--WHEN 'I' THEN  '1398350' 
		--ELSE '' END											AS	[VendorNumber]	
		, '1058637'											AS	[VendorNumber]	
		,BNF.RPS_NFE + 'PD'									AS	[VendorInvoiceNumber]	
		,CONVERT(VARCHAR(10),BNF.Emissao,101)				AS	[InvoiceDate]			
		,BNF.Valor_Total									AS	[InvoiceAmount]			
		,'BRL'												AS	[Currency]				
		--,'YY'												AS	[TaxCode]	
		,'I3'												AS	[TaxCode]	
		,'M'												AS	[PaymentMethod]		
		,BNF.Item_lei
		FROM Base_Nota_Fiscal	BNF	(NOLOCK)
			LEFT JOIN Campo_Pessoa	CP	(NOLOCK) ON BNF.Cd_Pes = CP.Cd_Pes  AND CP.Id_Campo = '25'
			INNER JOIN Pessoa CLI (nolock)	ON BNF.Cd_Pes=CLI.cd_pes  
			LEFT JOIN Pessoa_LLP PLLP (nolock)  ON CLI.cd_pes  =PLLP.cd_pes  
			LEFT JOIN Pessoa PP (nolock)  ON PP.cd_pes=cd_pes_grupo 
		WHERE 
			Ref_Acesso IN ('I','K')
			and (PP.Apelido = @Grupo or @Grupo = '')  
			AND BNF.Emissao BETWEEN @DATA_INICIAL AND @DATA_FINAL
			--AND  (RPS_NFE in ('12557'))

	--select * from @Dados_Referencia

	INSERT INTO @Dados_JOB_e_CTA
	(
		Nota_Fiscal,Ref_Acesso,Num_proc,Vlr_Pgto
	)
	SELECT 
		Nota_Fiscal
		,Ref_Acesso
		,CTA.Num_Proc_HIA
		,sum(Vlr_Pgto_NF_HIA)
		FROM @Dados_Referencia DN 
			INNER JOIN vwcta_Cte CTA (NOLOCK) ON DN.Nota_Fiscal = Num_NF_HIA AND DN.Ref_Acesso = Ref_Acesso_NF_HIA
			--join PEDIDO_SHIP PS (NOLOCK) ON CTA.Num_Proc_HIA = PS.NUM_PROC
			--JOIN PEDIDO P (NOLOCK) ON PS.CD_PEDIDO = P.CD_PEDIDO
		Where
			left(CTA.Num_Proc_HIA,1) <> 'E'
		--	AND P.cd_tipo <> 4 
		--WHERE EXISTS 
		--(
		--	SELECT DISTINCT 
		--	PS.Num_Proc
		--	FROM PEDIDO_SHIP PS (NOLOCK) 
		--	INNER JOIN PEDIDO P (NOLOCK) ON PS.CD_PEDIDO = P.CD_PEDIDO
		--	WHERE 
		--		CTA.Num_Proc_HIA = PS.NUM_PROC
		--		AND left(CTA.Num_Proc_HIA,1) <> 'E'
		--		AND P.cd_tipo <> 4 
		--)
		GROUP BY
			Nota_Fiscal,Ref_Acesso,Num_Proc_HIA

	--select * from @Dados_JOB_e_CTA

	--Dados da Prestacao
	INSERT INTO @Dados_Prestacao
	(
		Nota_Fiscal,Ref_Acesso,Num_proc,Fatura, Vlr_Pgto--,Nome_Taxa
	)
	select distinct 
		DN.Nota_Fiscal,
		DN.Ref_Acesso,
		DN.Num_Proc,
		FC.Fatura_PC,
		sum(F.Vlr_PC)
		--,T.nome_tp_tx
	FROM @Dados_JOB_e_CTA DN 
		--INNER JOIN vwcta_Cte CTA (NOLOCK) ON DN.Nota_Fiscal = Num_NF_HIA AND DN.Ref_Acesso = CTA.Ref_Acesso_NF_HIA and DN.Num_Proc = CTA.Num_Proc_Hia
		join fatura_chb FC on FC.Processo_PC = DN.Num_Proc and fc.cd_tipo = 'P'
		--join Pessoa P on P.cd_pes = FC.cd_pes_pc
		join Fatura_CHB_Item F on FC.fatura_pc = F.fatura_cc
		join Tipo_taxa T on T.cd_tp_tx = F.cd_tp_tx and T.Nome_Tp_Tx not like 'Adianta%'
		--join vwCliente_Alerta A on A.num_proc = I.Num_Proc_HIA
		--left join Base_Nota_Fiscal BA on BA.nota_fiscal = I.num_nf_hia and BA.ref_acesso = I.ref_acesso_NF_hia
	where 
		F.Tp_Pgto = 'B'
		and FC.status_pc = 'E'
	GRoup by 
		FC.Fatura_PC,
		DN.Nota_Fiscal,
		DN.Ref_Acesso,
		DN.Num_Proc--,T.nome_tp_tx

	--select * from @Dados_Prestacao

	UPDATE dj
	SET [InvoiceAmount] = 
					(SELECT sum(vlr_pgto)
					FROM @Dados_Prestacao ds
					WHERE ds.Nota_Fiscal = dj.Nota_Fiscal
					AND ds.Ref_Acesso = dj.Ref_Acesso
					)
	FROM @Dados_Referencia dj

	--select * from @Dados_Referencia

	INSERT INTO @Dados_JOB_of_PO
	(		
		Nota_Fiscal			
		,Ref_Acesso		
		,Num_proc
		,[IncomingDate]	
		,[TextforExpenseLineItem]
	)
		SELECT DISTINCT
		DN.Nota_Fiscal								AS	Nota_Fiscal
		,DN.Ref_Acesso								AS	Ref_Acesso
		,FV.Num_proc								AS	Num_proc
																		
		--,CONVERT(VARCHAR(10),TP.Dt_Conclusao,101)	AS	[IncomingDate]
		,CONVERT(VARCHAR(10),Getdate(),101)	AS	[IncomingDate]
		,dbo.fBusca_Docs_PO_Modal(FV.Num_proc,25)	AS	[TextforExpenseLineItem]
		FROM @Dados_Referencia DN 
		INNER JOIN fatura_arg FA (NOLOCK) ON RIGHT('000000000'+DN.nota_fiscal,10)=RIGHT('00000000'+FA.numero,10) AND ref_acesso=codigo 
		INNER JOIN dbo.vwFaturasValidasArg FVA (NOLOCK) ON FA.id_fat=FVA.id_fat  
		INNER JOIN  dbo.vwFaturasValidas FV (NOLOCK) ON FV.num_proc=FVA.num_proc AND FV.cd_tp_tx=FVA.cd_tp_tx AND FV.dc=FVA.dc 
		--LEFT JOIN Tarefas_Processos TP (NOLOCK)	ON FV.num_proc=TP.num_proc 	AND TP.ID_Task = 40

	--select * from @Dados_JOB_of_PO

	INSERT INTO @Dados_PO
	(		
		Nota_Fiscal			
		,Ref_Acesso		
		,Num_proc
		,[IncomingDate]	
		,[Quantity]				
		,[UnitofMeasure]			
		,[PONumber]	
		,[POLineItemNumber]				
		,[AdditionalCostCondition1]		
		--,[AdditionalCostAmount1]				
		,[GLaccount]					
		,[TextforExpenseLineItem]	
		,Fatura	
		 ,fBuscaPorcentagem_CdPedido_UOM
	)
	SELECT 
	DJP.Nota_Fiscal								AS	Nota_Fiscal
	,DJP.Ref_Acesso								AS	Ref_Acesso
	,DJP.Num_proc								AS	Num_proc
	,DJP.[IncomingDate]							AS	[IncomingDate]

	--,sum(PD.qty)								AS  [Quantity]			--Quantity					Quantidade da ordem de compra
	,1								AS  [Quantity]			--Quantity					Quantidade da ordem de compra
	,UoM										AS  [UnitofMeasure]		--UnitofMeasure				Unidade de medida da ordem de compra
	,left(P.Num_PO,10)									AS  [PONumber]			

	,'1'										AS	[POLineItemNumber]				
	,'ZCC2'										AS	[AdditionalCostCondition1]	--,'ZSR'										AS	[AdditionalCostCondition1]	
	--,sum(dn.Vlr_pgto)							AS	[AdditionalCostAmount1]		
	--,P.vlr_pedido								AS	[AdditionalCostAmount1]						
	,NULL										AS	[GLaccount]					
	,NULL										AS	[TextforExpenseLineItem]	
	,dn.Fatura									AS	Fatura
	, [dbo].fBuscaPorcentagem_CdPedido_UOM (PS.NUM_PROC,PD.UoM,PS.CD_PEDIDO)	
	FROM @Dados_JOB_of_PO DJP 
	INNER JOIN PEDIDO_SHIP PS (NOLOCK)	ON DJP.NUM_PROC = PS.NUM_PROC
	INNER JOIN PEDIDO P (NOLOCK)ON PS.CD_PEDIDO = P.CD_PEDIDO
	INNER JOIN PEDIDO_DET PD (NOLOCK)	ON P.CD_PEDIDO = PD.CD_PEDIDO	and PS.ITEM = PD.ITEM
	INNER JOIN @Dados_Prestacao dn ON DJP.Nota_Fiscal = dn.Nota_Fiscal	AND DJP.Ref_Acesso = dn.Ref_Acesso AND DJP.Num_proc = dn.Num_proc
	where
		P.cd_tipo <> 4 --cadu 18/11/2022 -retirado os casos 4 - Samples(Solicitado pela Rosangela)
	GROUP BY		
		PD.UoM,DJP.Nota_Fiscal,DJP.Ref_Acesso,DJP.[IncomingDate],P.Num_PO		
		,DJP.Num_proc,dn.[Fatura],PS.NUM_PROC,PS.CD_PEDIDO

	--select * from @Dados_PO

	UPDATE ds
	SET ds.AdditionalCostAmount1 = convert(decimal(18,2),(dn.Vlr_pgto * DS.fBuscaPorcentagem_CdPedido_UOM))	
	FROM @Dados_PO ds
	INNER JOIN @Dados_Prestacao dn	ON ds.Nota_Fiscal = dn.Nota_Fiscal	AND ds.Ref_Acesso = dn.Ref_Acesso AND ds.Num_proc = dn.Num_proc

	--select * from @Dados_PO

	-- PARA CRIAR A LINHA EM BRANCO POR PO
	INSERT INTO @Dados_PO
	(		
		Nota_Fiscal			
		,Ref_Acesso		
		,Num_proc

		,[IncomingDate]	
		,[Quantity]				
		,[UnitofMeasure]			
		,[PONumber]			

		,[POLineItemNumber]				
		,[AdditionalCostCondition1]		
		,[AdditionalCostAmount1]							
		,[GLaccount]					
		,[TextforExpenseLineItem]		
	)

	SELECT DISTINCT
		DJP.Nota_Fiscal					AS	Nota_Fiscal
		,DJP.Ref_Acesso					AS	Ref_Acesso
		,NULL							AS	Num_proc
		,NULL							AS	[IncomingDate]

		,NULL							AS  [Quantity]			
		,NULL							AS  [UnitofMeasure]		
		,NULL							AS  [PONumber]			

		,NULL							AS	[POLineItemNumber]				
		,NULL							AS	[AdditionalCostCondition1]		
		,NULL							AS	[AdditionalCostAmount1]						
		,'148173'						AS	[GLaccount]					
		,(SELECT TOP 1 [TextforExpenseLineItem]
		FROM @Dados_JOB_of_PO DJP2
		WHERE DJP.Nota_Fiscal = DJP2.Nota_Fiscal
		AND DJP.Ref_Acesso =  DJP2.Ref_Acesso 
		ORDER BY [TextforExpenseLineItem] DESC
		)								AS	[TextforExpenseLineItem]	
		from @Dados_JOB_of_PO DJP


	UPDATE ds
	SET ds.ID_Referencia = dn.ID_Referencia
	,ds.valor_total = [InvoiceAmount]
	FROM @Dados_PO ds
	INNER JOIN @Dados_Referencia dn	ON ds.Nota_Fiscal = dn.Nota_Fiscal	AND ds.Ref_Acesso = dn.Ref_Acesso

	UPDATE dj
	SET dj.ID_Referencia = dn.ID_Referencia
	FROM @Dados_JOB_e_CTA dj
	INNER JOIN @Dados_Referencia dn	ON dj.Nota_Fiscal = dn.Nota_Fiscal AND dj.Ref_Acesso = dn.Ref_Acesso

	UPDATE dj
	SET Qtde_Shipment = 
					(SELECT COUNT(distinct [PONumber])
					FROM @Dados_PO ds
					WHERE ds.ID_Referencia = dj.ID_Referencia
					AND ds.Num_proc = dj.Num_proc
					)
	FROM @Dados_JOB_e_CTA dj
	   

	INSERT INTO @Controle
		SELECT 
		ds.ID_Referencia					
		,MIN(ds.ID_PO)							as minID_PO
		,MAX(ds.ID_PO)							as maxID_PO

		,MIN(valor_total)						as valorTotalNF	
		,SUM(LineItemAmount)					as sumLineItemAmount
		FROM @Dados_PO ds
		GROUP BY ds.ID_Referencia	

	UPDATE @Dados_PO
	SET LineItemAmount = Valor_Total
	FROM @Dados_PO ds
	INNER JOIN @Controle C ON DS.ID_Referencia = c.ID_Referencia AND ds.ID_PO = c.maxID_PO

	--SELECT * FROM @Dados_PO

	--SELECT * from @Dados_Referencia dn
	--	inner join @Dados_PO ds
	--	on dn.ID_Referencia = ds.ID_Referencia

	INSERT INTO @output  
	(
		[BusinessTransaction]
		,[CompanyCode]		
		,[VendorNumber]				
		,[VendorInvoiceNumber]		
		,[InvoiceDate]				
		,[IncomingDate]				
		,[InvoiceAmount]				
		,[Currency]					
		,[TaxCode]	
		,[PaymentMethod]						

		,[LineItemAmount]		
		,[Quantity]					
		,[UnitofMeasure]				
		,[PONumber]	
	
		,[POLineItemNumber]				
		,[AdditionalCostCondition1]		
		,[AdditionalCostAmount1]		
		,[TaxTariff]					
		,[GLaccount]					
		,[TextforExpenseLineItem]

		,ID_Referencia					
		,ID_PO	
		,JOB_NUMBER
		,Fatura
	)
	select 
		dn.[BusinessTransaction]
		,dn.[CompanyCode]		
		,dn.[VendorNumber]				
		,dn.[VendorInvoiceNumber]		
		,dn.[InvoiceDate]				
		,ds.[IncomingDate]				
		,dn.[InvoiceAmount]				
		,dn.[Currency]					
		,dn.[TaxCode]	
		,dn.[PaymentMethod]				

		,ds.[LineItemAmount]		
		,ds.[Quantity]					
		,ds.[UnitofMeasure]				
		,ds.[PONumber]

		,ds.[POLineItemNumber]				
		,ds.[AdditionalCostCondition1]		
		,ds.[AdditionalCostAmount1]		
		,dn.[TaxTariff]					
		,ds.[GLaccount]					
		,ds.[TextforExpenseLineItem]

		,ds.ID_Referencia					
		,ds.ID_PO		
		,DS.Num_proc
		,DS.Fatura
		from @Dados_Referencia dn
		inner join @Dados_PO ds
		on dn.ID_Referencia = ds.ID_Referencia
		where 
		dn.[InvoiceAmount] is not null --incluido 01/07/2022 10:55
		and dn.[TaxTariff] not in ('10.06')
			

	-- tirar as linhas dos dados da nota
	update o
	SET 
		[BusinessTransaction]		= null
		,[CompanyCode]				= null	
		,[VendorNumber]				= null			
		,[VendorInvoiceNumber]		= null	
		,[InvoiceDate]				= null		
		,[IncomingDate]				= null			
		,[InvoiceAmount]			= null				
		,[Currency]					= null			
		,[TaxCode]					= null	
		,[PaymentMethod]			= null			
	FROM @output o
	LEFT JOIN @controle c	ON o.ID_Referencia = c.ID_Referencia	AND o.ID_PO = c.minID_PO 
	WHERE C.ID_Referencia IS NULL

	-- EXIBIÇÃO
	SELECT
		[BusinessTransaction]
		,[CompanyCode]		
		,[VendorNumber]	
		,[InvoiceDate]		

		,[VendorInvoiceNumber]		
			
		,[IncomingDate]		
		,[InvoiceAmount]				
		,[Currency]					
		,[TaxCode]		
		,[PaymentMethod]				
			

		,[LineItemAmount]		
		,[Quantity]					
		,[UnitofMeasure]				
		,[PONumber]

		,[POLineItemNumber]				
		,[AdditionalCostCondition1]		
		,[AdditionalCostAmount1]		
		,[TaxTariff]					
		,[GLaccount]					
		,[TextforExpenseLineItem]	
		,JOB_NUMBER
		--,Fatura [PC]
	FROM 
		@output
	--Where 
	--	Fatura is not null and
	ORDER BY 		
		ID_Referencia					
		,ID_PO 







/*
ALTER PROCEDURE [dbo].[spATL_PoPc_DOW_Rel]
(
@Grupo			VARCHAR(50),  
@DATA_INICIAL	DATETIME,
@DATA_FINAL		DATETIME
)

AS
/* -------------------------------------------------------------------------------------------------------------------------
HISTORY CHANGE
. Date:			18/11/2020
. Business:		Tiago Tadeu (Tiago.Alves@bdpint.com) e Sibério Bezerra (Siberio.Bezerra@bdpint.com)
. Dept:			Financeiro/Faturamento
. Developer:	Alessandra Suzuki Mariano
. Ticket:		100-296675	
. Request:		File Upload to Dow invoicing
				The idea is to generate and export an excel file for each type of document generated in the billing, containing BDP and client information.
-------------------------------------------------------------------------------------------------------------------------
EXECUTION 
exec spATL_PoPc_DOW_Rel 'GRUPO DOW','2022-04-10','2022-04-11'
-------------------------------------------------------------------------------------------------------------------------
*/

  
IF @Grupo is NULL  
BEGIN  
	SET @Grupo = ''  
END  

	DECLARE @output TABLE  
	(
	[BusinessTransaction]			VARCHAR(3)
	,[CompanyCode]					VARCHAR(4)
	,[VendorNumber]					VARCHAR(7)
	,[VendorInvoiceNumber]			VARCHAR(17)
	,[InvoiceDate]					VARCHAR(10)
	,[IncomingDate]					VARCHAR(10)
	,[InvoiceAmount]				DECIMAL(18,2)
	,[Currency]						VARCHAR(3)
	,[TaxCode]						CHAR(2)
	,[PaymentMethod]				CHAR(1)

	,[LineItemAmount]				FLOAT
	,[Quantity]						FLOAT
	,[UnitofMeasure]				VARCHAR(5)
	,[PONumber]						VARCHAR(30)

	,[POLineItemNumber]				CHAR(1)
	,[AdditionalCostCondition1]		CHAR(3)
	,[AdditionalCostAmount1]		FLOAT
	,[TaxTariff]					VARCHAR(50)
	,[GLaccount]					VARCHAR(6)
	,[TextforExpenseLineItem]		VARCHAR(255)


	,ID_Referencia					INT
	,ID_PO							INT
	,job_number						VARCHAR(16)
	)

	--LINHA DOS DADOS DA REFERENCIA
	DECLARE @Dados_Referencia TABLE  
	(
	ID_Referencia			INT IDENTITY(1,1)
	,Nota_Fiscal			VARCHAR(8)
	,Ref_Acesso				CHAR(1)
	,[BusinessTransaction]	VARCHAR(3)
	,[CompanyCode]			VARCHAR(4)
	,[VendorNumber]			VARCHAR(7)
	,[VendorInvoiceNumber]	VARCHAR(9)
	,[InvoiceDate]			VARCHAR(10)
	,[InvoiceAmount]		DECIMAL(18,2)
	,[Currency]				VARCHAR(3)
	,[TaxCode]				CHAR(2)
	,[PaymentMethod]		CHAR(1)
	,[TaxTariff]			VARCHAR(50)
	)


	--Dados do job e CTA_CTE
	DECLARE @Dados_JOB_e_CTA TABLE
	(
	ID_Referencia			INT
	,Nota_Fiscal			VARCHAR(8)
	,Ref_Acesso				CHAR(1)
	,Num_proc				VARCHAR(16)
	,Vlr_Pgto				DECIMAL(18,2)
	,Qtde_Shipment			INT
	)


	--Dados do pedido e item do pedido
	DECLARE @Dados_JOB_of_PO TABLE
	(
	ID_Referencia			INT
	,Nota_Fiscal			VARCHAR(8)
	,Ref_Acesso				CHAR(1)
	,Num_proc				VARCHAR(16)
	,[IncomingDate]			VARCHAR(10)
	,[TextforExpenseLineItem]		VARCHAR(255)
	)

	--Dados do pedido e item do pedido
	DECLARE @Dados_PO TABLE
	(
	ID_Referencia					INT
	,ID_PO							INT IDENTITY(1,1)
	,Num_proc						VARCHAR(16)
	,Nota_Fiscal					VARCHAR(8)
	,Ref_Acesso						CHAR(1)
	,Valor_Total					DECIMAL(18,2)
	,[LineItemAmount]				FLOAT
	,[Quantity]						FLOAT
	,[UnitofMeasure]				VARCHAR(5)
	,[PONumber]						VARCHAR(30)

	,[IncomingDate]					VARCHAR(10)
	,[POLineItemNumber]				CHAR(1)
	,[AdditionalCostCondition1]		CHAR(3)
	,[AdditionalCostAmount1]		FLOAT
	,[GLaccount]					VARCHAR(6)
	,[TextforExpenseLineItem]		VARCHAR(255)
	)

	DECLARE @controle TABLE 
	(
	ID_Referencia			INT
	,minID_PO				INT 
	,maxID_PO				INT 
	,valorTotalNF			DECIMAL(18,2)
	,sumLineItemAmount		DECIMAL(18,2)

	)


	/*
	Coluna						Detalhes do preenchimento									OBS								
	BusinessTransaction			SDB															Campo Não Editável
	CompanyCode					31 - Dow Brasil Ind e Com Ltda
								833 - Dow Brasil Sudeste Ltda
								4308 - Palmyra Silicio do Brasil
								4083 - Rohm & Haas Quimica
								4621 - Performance Material Brasil
	VendorNumber				1058637														Campo Não Editável
	InvoiceDate					Data de emissão	
	IncomingDate				Data do envio	
	VendorInvoiceNumber			Número da referência	
	InvoiceAmount				Valor total 	
	Currency					BRL															Campo Não Editável
	TaxCode						I3															Campo Não Editável
	PaymentMethod				M															Campo Não Editável
	LineItemAmount				Preencher valor total do adiantamento semanal 
								e somente na linha da conta 148173	
	Quantity					Quantidade da ordem de compra	
	UnitofMeasure				Unidade de medida da ordem de compra	
	PONumber					Número da ordem de compra	
	POLineItemNumber			1															Campo Não Editável
	AdditionalCostCondition1	ZCC															Campo Não Editável
	AdditionalCostAmount1		Valor total da ordem de compra	
	TaxTariff					99,99														Campo Não Editável
	GLaccount					148173														Campo Não Editável
	TextforExpenseLineItem		Número adiantamento semanal ( Ex: ADTO BDP 1) 	
	*/


	INSERT INTO @Dados_Referencia
	(		
	Nota_Fiscal			
	,Ref_Acesso				
	,[BusinessTransaction]
	,[CompanyCode]
	,[VendorNumber]
	,[VendorInvoiceNumber]
	,[InvoiceDate]
	,[InvoiceAmount]
	,[Currency]
	,[TaxCode]
	,[PaymentMethod]	
	,[TaxTariff]
	)
	SELECT																				
	BNF.Nota_Fiscal												AS	Nota_Fiscal
	,BNF.Ref_Acesso												AS	Ref_Acesso
	,'SDB'														AS	[BusinessTransaction]
	,REPLICATE ('0',4 - LEN(CP.Campo_Dados)) + CP.Campo_Dados	AS	[CompanyCode]			
	,CASE BNF.Ref_Acesso 
	WHEN 'K' THEN  '1058637' 
	WHEN 'I' THEN  '1398350' 
	ELSE '' END											AS	[VendorNumber]			
	,BNF.RPS_NFE + 'PD'									AS	[VendorInvoiceNumber]	
	,CONVERT(VARCHAR(10),BNF.Emissao,101)				AS	[InvoiceDate]			
	,BNF.Valor_Total									AS	[InvoiceAmount]			
	,'BRL'												AS	[Currency]				
	,'I3'												AS	[TaxCode]	
	,'M'												AS	[PaymentMethod]		
	,BNF.Item_lei
	FROM Base_Nota_Fiscal	BNF	(NOLOCK)
	LEFT JOIN Campo_Pessoa	CP	(NOLOCK) 
		ON BNF.Cd_Pes = CP.Cd_Pes  
		AND CP.Id_Campo = '25'

	INNER JOIN Pessoa CLI (nolock)
		ON BNF.Cd_Pes=CLI.cd_pes  
	LEFT JOIN Pessoa_LLP PLLP (nolock)  
		ON CLI.cd_pes  =PLLP.cd_pes  
	LEFT JOIN Pessoa PP (nolock)  
		ON PP.cd_pes=cd_pes_grupo  

	WHERE 
	Ref_Acesso IN ('I','K')
	and (PP.Apelido = @Grupo or @Grupo = '')  
	AND BNF.Emissao BETWEEN @DATA_INICIAL AND @DATA_FINAL
	--AND  (RPS_NFE in ( '115446'))

	INSERT INTO @Dados_JOB_e_CTA
	(
	Nota_Fiscal
	,Ref_Acesso
	,Num_proc
	,Vlr_Pgto
	)
	SELECT 
	Nota_Fiscal
	,Ref_Acesso
	,Num_Proc_HIA
	,sum(Vlr_Pgto_NF_HIA)
	FROM @Dados_Referencia DN 
	INNER JOIN vwcta_Cte CTA (NOLOCK)
		ON 	DN.Nota_Fiscal = Num_NF_HIA			
		AND DN.Ref_Acesso = Ref_Acesso_NF_HIA
	GROUP BY
	Nota_Fiscal
	,Ref_Acesso
	,Num_Proc_HIA


	INSERT INTO @Dados_JOB_of_PO
	(		
	Nota_Fiscal			
	,Ref_Acesso		
	,Num_proc
	,[IncomingDate]	
	,[TextforExpenseLineItem]
	)
	SELECT DISTINCT
	DN.Nota_Fiscal								AS	Nota_Fiscal
	,DN.Ref_Acesso								AS	Ref_Acesso
	,FV.Num_proc								AS	Num_proc
																		
	,CONVERT(VARCHAR(10),TP.Dt_Conclusao,101)	AS	[IncomingDate]
	,dbo.fBusca_Docs_PO_Modal(FV.Num_proc,25)	AS	[TextforExpenseLineItem]
	FROM @Dados_Referencia DN 
	INNER JOIN fatura_arg FA (NOLOCK) 
		ON RIGHT('000000000'+DN.nota_fiscal,10)=RIGHT('00000000'+FA.numero,10) 
		AND ref_acesso=codigo 
	INNER JOIN dbo.vwFaturasValidasArg FVA (NOLOCK) 
		ON FA.id_fat=FVA.id_fat  
	INNER JOIN  dbo.vwFaturasValidas FV (NOLOCK) 
		ON FV.num_proc=FVA.num_proc 
		AND FV.cd_tp_tx=FVA.cd_tp_tx 
		AND FV.dc=FVA.dc 
	LEFT JOIN Tarefas_Processos TP (NOLOCK)
		ON FV.num_proc=TP.num_proc 
		AND TP.ID_Task = 40

	--select * from @Dados_JOB_of_PO

	INSERT INTO @Dados_PO
	(		
	Nota_Fiscal			
	,Ref_Acesso		
	,Num_proc

	,[IncomingDate]	
	,[Quantity]				
	,[UnitofMeasure]			
	,[PONumber]			

	,[POLineItemNumber]				
	,[AdditionalCostCondition1]		
	,[AdditionalCostAmount1]		
				
	,[GLaccount]					
	,[TextforExpenseLineItem]		
	)
	SELECT 
	DJP.Nota_Fiscal								AS	Nota_Fiscal
	,DJP.Ref_Acesso								AS	Ref_Acesso
	,DJP.Num_proc								AS	Num_proc
	,DJP.[IncomingDate]							AS	[IncomingDate]

	,sum(PD.qty)								AS  [Quantity]			--Quantity					Quantidade da ordem de compra
	,UoM										AS  [UnitofMeasure]		--UnitofMeasure				Unidade de medida da ordem de compra
	,P.Num_PO									AS  [PONumber]			

	,'1'										AS	[POLineItemNumber]				
	,'ZSR'										AS	[AdditionalCostCondition1]		
	,P.vlr_pedido								AS	[AdditionalCostAmount1]						
	,NULL										AS	[GLaccount]					
	,NULL										AS	[TextforExpenseLineItem]	
	FROM @Dados_JOB_of_PO DJP 
	INNER JOIN PEDIDO_SHIP PS (NOLOCK)
		ON DJP.NUM_PROC = PS.NUM_PROC
	INNER JOIN PEDIDO P (NOLOCK)
		ON PS.CD_PEDIDO = P.CD_PEDIDO
	INNER JOIN PEDIDO_DET PD (NOLOCK)
		ON P.CD_PEDIDO = PD.CD_PEDIDO
		and PS.ITEM = PD.ITEM

	GROUP BY
	
	DJP.Nota_Fiscal
	,DJP.Ref_Acesso
	,DJP.[IncomingDate]	

	,UoM
	,P.Num_PO
	,P.vlr_pedido
	,DJP.Num_proc


	-- PARA CRIAR A LINHA EM BRANCO POR PO
	INSERT INTO @Dados_PO
	(		
	Nota_Fiscal			
	,Ref_Acesso		
	,Num_proc

	,[IncomingDate]	
	,[Quantity]				
	,[UnitofMeasure]			
	,[PONumber]			

	,[POLineItemNumber]				
	,[AdditionalCostCondition1]		
	,[AdditionalCostAmount1]							
	,[GLaccount]					
	,[TextforExpenseLineItem]		
	)

	SELECT DISTINCT

	DJP.Nota_Fiscal					AS	Nota_Fiscal
	,DJP.Ref_Acesso					AS	Ref_Acesso
	,NULL							AS	Num_proc
	,NULL							AS	[IncomingDate]

	,NULL							AS  [Quantity]			
	,NULL							AS  [UnitofMeasure]		
	,NULL							AS  [PONumber]			

	,NULL							AS	[POLineItemNumber]				
	,NULL							AS	[AdditionalCostCondition1]		
	,NULL							AS	[AdditionalCostAmount1]						
	,'148173'						AS	[GLaccount]					
	,(SELECT TOP 1 [TextforExpenseLineItem]
	FROM @Dados_JOB_of_PO DJP2
	WHERE DJP.Nota_Fiscal = DJP2.Nota_Fiscal
	AND DJP.Ref_Acesso =  DJP2.Ref_Acesso 
	ORDER BY [TextforExpenseLineItem] DESC
	)								AS	[TextforExpenseLineItem]	
	from @Dados_JOB_of_PO DJP



	UPDATE ds
	SET ds.ID_Referencia = dn.ID_Referencia
	,ds.valor_total = [InvoiceAmount]
	FROM @Dados_PO ds
	INNER JOIN @Dados_Referencia dn
		ON ds.Nota_Fiscal = dn.Nota_Fiscal
		AND ds.Ref_Acesso = dn.Ref_Acesso

	UPDATE dj
	SET dj.ID_Referencia = dn.ID_Referencia
	FROM @Dados_JOB_e_CTA dj
	INNER JOIN @Dados_Referencia dn
		ON dj.Nota_Fiscal = dn.Nota_Fiscal
		AND dj.Ref_Acesso = dn.Ref_Acesso

	UPDATE dj
	SET Qtde_Shipment = 
							(SELECT COUNT(distinct [PONumber])
							FROM @Dados_PO ds
							WHERE ds.ID_Referencia = dj.ID_Referencia
							AND ds.Num_proc = dj.Num_proc
							)
	FROM @Dados_JOB_e_CTA dj




	INSERT INTO @Controle
	SELECT 
	ds.ID_Referencia					
	,MIN(ds.ID_PO)							as minID_PO
	,MAX(ds.ID_PO)							as maxID_PO

	,MIN(valor_total)						as valorTotalNF	
	,SUM(LineItemAmount)					as sumLineItemAmount
	FROM @Dados_PO ds
	GROUP BY ds.ID_Referencia	

	UPDATE @Dados_PO
	SET LineItemAmount = Valor_Total
	FROM @Dados_PO ds
	INNER JOIN @Controle C
		ON DS.ID_Referencia = c.ID_Referencia 
		AND ds.ID_PO = c.maxID_PO


	--SELECT * FROM @Dados_PO

	INSERT INTO @output  
	(
	[BusinessTransaction]
	,[CompanyCode]		
	,[VendorNumber]				
	,[VendorInvoiceNumber]		
	,[InvoiceDate]				
	,[IncomingDate]				
	,[InvoiceAmount]				
	,[Currency]					
	,[TaxCode]	
	,[PaymentMethod]						

	,[LineItemAmount]		
	,[Quantity]					
	,[UnitofMeasure]				
	,[PONumber]	
	
	,[POLineItemNumber]				
	,[AdditionalCostCondition1]		
	,[AdditionalCostAmount1]		
	,[TaxTariff]					
	,[GLaccount]					
	,[TextforExpenseLineItem]

	,ID_Referencia					
	,ID_PO	
	,JOB_NUMBER
	)
	select 
	dn.[BusinessTransaction]
	,dn.[CompanyCode]		
	,dn.[VendorNumber]				
	,dn.[VendorInvoiceNumber]		
	,dn.[InvoiceDate]				
	,ds.[IncomingDate]				
	,dn.[InvoiceAmount]				
	,dn.[Currency]					
	,dn.[TaxCode]	
	,dn.[PaymentMethod]				

	,ds.[LineItemAmount]		
	,ds.[Quantity]					
	,ds.[UnitofMeasure]				
	,ds.[PONumber]

	,ds.[POLineItemNumber]				
	,ds.[AdditionalCostCondition1]		
	,ds.[AdditionalCostAmount1]		
	,dn.[TaxTariff]					
	,ds.[GLaccount]					
	,ds.[TextforExpenseLineItem]

	,ds.ID_Referencia					
	,ds.ID_PO		
	,DS.Num_proc
	from @Dados_Referencia dn
	inner join @Dados_PO ds
	on dn.ID_Referencia = ds.ID_Referencia

	-- tirar as linhas dos dados da nota
	update o
	SET 
	[BusinessTransaction]		= null
	,[CompanyCode]				= null	
	,[VendorNumber]				= null			
	,[VendorInvoiceNumber]		= null	
	,[InvoiceDate]				= null		
	,[IncomingDate]				= null			
	,[InvoiceAmount]			= null				
	,[Currency]					= null			
	,[TaxCode]					= null	
	,[PaymentMethod]			= null			
	FROM @output o
	LEFT JOIN @controle c
		ON o.ID_Referencia = c.ID_Referencia
		AND o.ID_PO = c.minID_PO 
	WHERE C.ID_Referencia IS NULL

	-- EXIBIÇÃO
	SELECT
	[BusinessTransaction]
	,[CompanyCode]		
	,[VendorNumber]	
	,[InvoiceDate]		

	,[VendorInvoiceNumber]		
			
	,[IncomingDate]				
	,[InvoiceAmount]				
	,[Currency]					
	,[TaxCode]		
	,[PaymentMethod]				
			

	,[LineItemAmount]		
	,[Quantity]					
	,[UnitofMeasure]				
	,[PONumber]

	,[POLineItemNumber]				
	,[AdditionalCostCondition1]		
	,[AdditionalCostAmount1]		
	,[TaxTariff]					
	,[GLaccount]					
	,[TextforExpenseLineItem]	
	--,JOB_NUMBER
	FROM @output
	ORDER BY 	
	ID_Referencia					
	,ID_PO 
*/


















GO
