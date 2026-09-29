SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--parece q os valores nao estao bem separados
CREATE PROCEDURE [dbo].[spATL_NoPoCC_DOW_Teste_Rel]
(
@Grupo			VARCHAR(50),  
@DATA_INICIAL	DATETIME,
@DATA_FINAL		DATETIME
)

AS

--Declare @Grupo			VARCHAR(50)
--Declare @DATA_INICIAL	DATETIME
--Declare @DATA_FINAL		DATETIME

--Set @Grupo = 'GRUPO DOW'
--Set @DATA_INICIAL = '2022-04-10'
--Set @DATA_FINAL = '2022-04-11'

IF @Grupo is NULL  
BEGIN  
	SET @Grupo = ''  
END  


/* -------------------------------------------------------------------------------------------------------------------------
HISTORY CHANGE
. Date:			11/02/2022
. Business:		Tiago Tadeu (Tiago.Alves@bdpint.com) e Sibério Bezerra (Siberio.Bezerra@bdpint.com)
. Dept:			Financeiro/Faturamento
. Developer:	Alessandra Suzuki Mariano
. Ticket:		100-296675	
. Request:		File Upload to Dow invoicing
				The idea is to generate and export an excel file for each type of document generated in the billing, containing BDP and client information.
-------------------------------------------------------------------------------------------------------------------------
EXECUTION 
exec spATL_NoPoCC_DOW_Rel 'GRUPO DOW','2022-04-10','2022-04-11'
-------------------------------------------------------------------------------------------------------------------------
*/

	DECLARE @output TABLE  
	(
	[BusinessTransaction]			VARCHAR(3)
	,[CompanyCode]					VARCHAR(500)
	,[SiteContact]					VARCHAR(50)
	,[InvoiceDate]					VARCHAR(10)
	,[VendorNumber]					VARCHAR(7)
	,[VendorInvoiceNumber]			VARCHAR(15)
	,[IncomingDate]					VARCHAR(10)
	,[InvoiceAmount]				DECIMAL(18,2)
	,[Currency]						VARCHAR(3)
	,[TaxCode]						VARCHAR(2)
	,[PartnerBank]					VARCHAR(4)
	,[PaymentMethod]				CHAR(1)
	,[Payee]						VARCHAR(7)
	,[LineItemAmount]				FLOAT
	,[Quantity]						FLOAT
	,[UnitofMeasure]				VARCHAR(5)
	,[TextforExpenseLineItem]		VARCHAR(3)
	,[Assignment]					VARCHAR(80)
	,[GLaccount]					VARCHAR(6)
	,[CostCenter]					VARCHAR(80)
	,[MaterialGroup]				VARCHAR(8)
	,[Plant]						VARCHAR(10)
	,[VendorItemText]				VARCHAR(90)
	,[TaxTariff]					VARCHAR(5)

	,ID_Nota				INT
	,ID_Shipment			INT
	,job_number				VARCHAR(16)
	)

	/*
	Coluna					Detalhes do preenchimento								obs
	BusinessTransaction		INV	
	CompanyCode				"31 - Dow Brasil Ind e Com Ltda
							833 - Dow Brasil Sudeste Ltda
							4308 - Palmyra Silicio do Brasil
							4083 - Rohm & Haas Quimica"	
	SiteContact				E-mail	
	VendorNumber			"1398350
							1058637"	
	InvoiceDate				Data de emissão da fatura	
	IncomingDate			Data do envio	
	VendorInvoiceNumber		Número da fatura	
	InvoiceAmount			Valor total da nota	
	Currency				BRL	
	TaxCode					I3														YY para PD
	PaymentMethod																	M para PD
	Payee					2027372 - Preencher apenas para vendor 1398350	
	LineItemAmount			Preencher linhas de acordo com o valor de cada job.	
	GLaccount				640000	
	CostCenter				Número do centro de custo	
	TextforExpenseLineItem	BDP	
	VendorItemText			BDP + Centro de Custo	"Para PD:						ADTO BDP XX (preencher com o número do adiantamento)"

	*/


	--LINHA DOS DADOS DA NOTA FISCAL
	DECLARE @Dados_nota TABLE  
	(
	ID_Nota					INT IDENTITY(1,1)
	,Nota_Fiscal			VARCHAR(8)
	,Ref_Acesso				CHAR(1)
	,[BusinessTransaction]		VARCHAR(3)
	,[CompanyCode]				VARCHAR(4)
	,[SiteContact]				VARCHAR(50)
	,[InvoiceDate]				VARCHAR(10)
	,[VendorNumber]				VARCHAR(7)
	,[VendorInvoiceNumber]		VARCHAR(9)
	,[InvoiceAmount]			DECIMAL(18,2)
	,[Currency]					VARCHAR(3)
	,[TaxCode]					VARCHAR(2)
	,[PartnerBank]				VARCHAR(4)
	,[PaymentMethod]			CHAR(1)
	,[Payee]					VARCHAR(7)
	,[TextforExpenseLineItem]	VARCHAR(3)
	,[GLaccount]				VARCHAR(6)
	,[MaterialGroup]			VARCHAR(8)
	,[TaxTariff]				VARCHAR(5)
	,[Plant]					VARCHAR(10)
	
	)

	--Dados do job e CTA_CTE
	DECLARE @Dados_JOB_e_CTA TABLE
	(
	ID_Nota					INT
	,Nota_Fiscal			VARCHAR(8)
	,Ref_Acesso				CHAR(1)
	,Num_proc				VARCHAR(16)
	,Vlr_Pgto				DECIMAL(18,2)
	,Qtde_Shipment			INT
	)

	--Dados do pedido e item do pedido
	DECLARE @Dados_JOB_of_Shipment TABLE
	(
	ID_Nota					INT
	,Nota_Fiscal			VARCHAR(8)
	,Ref_Acesso				CHAR(1)
	,Num_proc				VARCHAR(16)
	,[IncomingDate]			VARCHAR(10)
	,[Assignment]			VARCHAR(80)
	,[CostCenter]			VARCHAR(80)
	,[VendorItemText]		VARCHAR(90)
	)

	--Dados da Prestacao
	DECLARE @Dados_Prestacao TABLE
	(
		ID_Referencia			INT
		,Nota_Fiscal			VARCHAR(8)
		,Ref_Acesso				CHAR(1)
		,Num_proc				VARCHAR(16)
		,Vlr_Pgto				DECIMAL(18,2)
		,Nome_Taxa				VARCHAR(250)
	)

	--Dados do pedido e item do pedido
	DECLARE @Dados_Shipment TABLE
	(
	ID_Nota					INT
	,ID_Shipment			INT IDENTITY(1,1)
	,Num_proc				VARCHAR(16)
	,Nota_Fiscal			VARCHAR(8)
	,Ref_Acesso				CHAR(1)
	,Valor_Total			DECIMAL(18,2)
	,[LineItemAmount]		FLOAT
	,[Quantity]				FLOAT
	,[UnitofMeasure]		VARCHAR(5)
	,[ShipmentNumber]		VARCHAR(30)
	,[IncomingDate]			VARCHAR(10)
	,[Assignment]			VARCHAR(80)
	,[CostCenter]			VARCHAR(80)
	,[VendorItemText]		VARCHAR(90)
	)

	DECLARE @controle TABLE 
	(
	ID_Nota					INT
	,minid_shipment			INT 
	,maxid_shipment			INT 
	,valorTotalNF			DECIMAL(18,2)
	,sumLineItemAmount		DECIMAL(18,2)
	,dif					DECIMAL(18,2)	
	)	

	INSERT INTO @Dados_nota
	(		
		Nota_Fiscal,Ref_Acesso,[BusinessTransaction],[CompanyCode],[SiteContact],[InvoiceDate],[VendorNumber],[VendorInvoiceNumber],[InvoiceAmount],[Currency]
		,[TaxCode],[PartnerBank],[PaymentMethod],[Payee],[TextforExpenseLineItem],[GLaccount],[MaterialGroup],[TaxTariff],[Plant]
	)
	SELECT																				
	BNF.Nota_Fiscal												AS Nota_Fiscal
	,BNF.Ref_Acesso												AS Ref_Acesso
																								--Coluna					Detalhes do preenchimento									OBS
		,'INV'														AS	[BusinessTransaction]	--BusinessTransaction		SBD															Campo Não Editável
		,REPLICATE ('0',4 - LEN(CP.Campo_Dados)) + CP.Campo_Dados	AS	[CompanyCode]			--CompanyCode				31 - Dow Brasil Ind e Com Ltda
																								--							833 - Dow Brasil Sudeste Ltda
																								--							4308 - Palmyra Silicio do Brasil
																								--							4083 - Rohm & Haas Quimica
																								--							4621 - Performance Material Brasil

		,'BdeJesusEduardo@dow.com'									AS	[SiteContact]			--SiteContact				SiteContact	E-mail
		,CONVERT(VARCHAR(10),BNF.Emissao,101)						AS	[InvoiceDate]			--InvoiceDate				Data de emissão da nota fiscal
		,CASE BNF.Ref_Acesso 
		WHEN 'K' THEN  '1058637' 
		WHEN 'I' THEN  '1398350' 
		ELSE '' END													AS	[VendorNumber]			--VendorNumber				São Caetano do Sul (CNPJ 03.706.460/0001-28) - 1058637
																						--							Santos (CNPJ 03.706.460/0002-09) - 1398350		
		,BNF.RPS_NFE + 'PD'												AS	[VendorInvoiceNumber]	--VendorInvoiceNumber		Número da nota fiscal
		,BNF.Valor_Total											AS	[InvoiceAmount]			--InvoiceAmount				Valor total da nota fiscal
		,'BRL'														AS	[Currency]				--Currency					BRL															Campo Não Editável
		,'I3'														AS	[TaxCode]				--TaxCode					YY															Campo Não Editável
		,'BRP1'														AS	[PartnerBank]			--PartnerBank				1058637 - BRP1												Campo Não Editável
		,'M'														AS	[PaymentMethod]																						--							1398350 - BRP1
		--,CASE BNF.Ref_Acesso 
		--WHEN 'K' THEN  '' 
		--WHEN 'I' THEN  '2027372' 
		--ELSE '' END													AS	[Payee]					--Payee						1058637 - Não preencher
		,''															AS	[Payee]		
		,'BDP'														AS	[TextforExpenseLineItem]																				--							1398350 - 2027372
		,'640000'													AS	[GLaccount]
		,'93160000'													AS	[MaterialGroup]
		,'33.01'													AS	[TaxTariff]
		,CP27.Campo_Dados											AS	[Plant]
	FROM Base_Nota_Fiscal	BNF		(NOLOCK)
		LEFT JOIN Campo_Pessoa	CP		(NOLOCK) ON BNF.Cd_Pes	=	CP.Cd_Pes  AND CP.Id_Campo = '25'
		LEFT JOIN Campo_Pessoa	CP27	(NOLOCK) ON BNF.Cd_Pes	=	CP27.Cd_Pes  AND CP27.Id_Campo = '27'
		INNER JOIN Pessoa		CLI		(NOLOCK) ON BNF.Cd_Pes	=	CLI.cd_pes  
		LEFT JOIN Pessoa_LLP	PLLP	(NOLOCK) ON CLI.cd_pes  =	PLLP.cd_pes  
		LEFT JOIN Pessoa		PP		(NOLOCK) ON PP.cd_pes	=	cd_pes_grupo
	WHERE 
		Ref_Acesso IN ('I','K')
		and (PP.Apelido = @Grupo or @Grupo = '')  
		AND BNF.Emissao BETWEEN @DATA_INICIAL AND @DATA_FINAL
	--	AND  (RPS_NFE in ( '9020'))

	INSERT INTO @Dados_JOB_e_CTA
	(
		DN.Nota_Fiscal,DN.Ref_Acesso,Num_proc,Vlr_Pgto
	)
	SELECT 
	Nota_Fiscal
	,Ref_Acesso
	,Num_Proc_HIA
	,sum(Vlr_Pgto_NF_HIA)
	FROM @Dados_nota DN 
	INNER JOIN vwcta_Cte CTA (NOLOCK) ON DN.Nota_Fiscal = CTA.Num_NF_HIA	AND DN.Ref_Acesso = CTA.Ref_Acesso_NF_HIA
	--WHERE SUBSTRING(Num_Proc_HIA,1,1) = 'E' -- Call com o sibério em 29/12/2021 disse que no report shipment será somente exportação
	WHERE EXISTS 
	(
		SELECT DISTINCT 
		PS.Num_Proc
		FROM PEDIDO_SHIP PS (NOLOCK) 
		INNER JOIN PEDIDO P (NOLOCK)ON PS.CD_PEDIDO = P.CD_PEDIDO
		WHERE 
		CTA.Num_Proc_HIA = PS.NUM_PROC
		--AND SUBSTRING(NUM_PROC,1,1) = 'E'
		AND P.cd_tipo = 4 
	)
	GROUP BY 
		Nota_Fiscal,Ref_Acesso,Num_Proc_HIA
	
--Dados da Prestacao
	INSERT INTO @Dados_Prestacao
	(
		Nota_Fiscal,Ref_Acesso,Num_proc,Vlr_Pgto,Nome_Taxa
	)
	select distinct 
		DN.Nota_Fiscal,
		DN.Ref_Acesso,
		DN.Num_Proc,		
		F.Vlr_PC,
		T.nome_tp_tx
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

	UPDATE dj
	SET [InvoiceAmount] = 
					(SELECT sum(vlr_pgto)
					FROM @Dados_Prestacao ds
					WHERE ds.Nota_Fiscal = dj.Nota_Fiscal
					AND ds.Ref_Acesso = dj.Ref_Acesso
					)
	FROM @Dados_nota dj

	UPDATE dj
	SET dj.ID_nota = dn.ID_nota
	FROM @Dados_JOB_e_CTA dj
	INNER JOIN @Dados_nota dn
		ON dj.Nota_Fiscal = dn.Nota_Fiscal
		AND dj.Ref_Acesso = dn.Ref_Acesso

	-- Call com o sibério em 29/12/2021 disse que no report shipment será somente exportação
	DELETE FROM @Dados_nota
	WHERE ID_Nota NOT IN
	(
		SELECT N.ID_NOTA 
		FROM @Dados_nota N
		INNER JOIN @Dados_JOB_e_CTA J
			on N.nota_fiscal = J.nota_fiscal
			and N.ref_acesso = J.ref_acesso
	)

	INSERT INTO @Dados_JOB_of_Shipment
	(		
		Nota_Fiscal,Ref_Acesso,Num_proc,[IncomingDate]	,[Assignment],[CostCenter],[VendorItemText]
	)
	SELECT DISTINCT
		DN.Nota_Fiscal								AS	Nota_Fiscal
		,DN.Ref_Acesso								AS	Ref_Acesso
		,FV.Num_proc								AS	Num_proc
																				--Coluna					Detalhes do preenchimento									OBS
		,CONVERT(VARCHAR(10),TP.Dt_Conclusao,101)	AS	[IncomingDate]		--IncomingDate				Data do envio
		,vPO.Numero_PO									AS [Assignment]
		,vPO.Numero_PO									AS [CostCenter]
		--,'BDP CC ' + vPO.Numero_PO						AS [VendorItemText]
		,PO25.Numero_PO								AS [VendorItemText]
	FROM @Dados_nota DN 
		INNER JOIN fatura_arg FA (NOLOCK) ON RIGHT('000000000'+DN.nota_fiscal,10)=RIGHT('00000000'+FA.numero,10) AND ref_acesso=codigo 
		INNER JOIN dbo.vwFaturasValidasArg FVA (NOLOCK) ON FA.id_fat=FVA.id_fat  
		INNER JOIN  dbo.vwFaturasValidas FV (NOLOCK) ON FV.num_proc=FVA.num_proc AND FV.cd_tp_tx=FVA.cd_tp_tx AND FV.dc=FVA.dc 
		LEFT JOIN Tarefas_Processos TP (nolock)	ON FV.num_proc=TP.num_proc AND TP.ID_Task = 40
		LEFT JOIN vwPO_ALL vPO (NOLOCK) ON FV.num_proc = vPO.Num_Proc AND vPO.ID_DC = 268
		LEFT JOIN vwPO_ALL PO25 (NOLOCK) ON FV.num_proc = PO25.Num_Proc AND PO25.ID_DC = 25


	INSERT INTO @Dados_Shipment
	(		
		Nota_Fiscal,Ref_Acesso,Num_proc,[IncomingDate]	,[Quantity]	,[UnitofMeasure],[ShipmentNumber],[Assignment],[CostCenter],[VendorItemText]
	)
	SELECT 
		DJS.Nota_Fiscal								AS	Nota_Fiscal
		,DJS.Ref_Acesso								AS	Ref_Acesso
		,DJS.Num_proc								AS	Num_proc
		,DJS.[IncomingDate]							AS	[IncomingDate]
																			--Coluna					Detalhes do preenchimento									OBS
		,1											AS  [Quantity]			--Quantity					Quantidade da ordem de compra
		,'AU'										AS  [UnitofMeasure]		--UnitofMeasure				Unidade de medida da ordem de compra
		,isnull(P.NUM_PEDIDO,DJS.Num_proc)			AS  [ShipmentNumber]	--ShipmentNumber			Número da ordem de compra	FROM @Dados_JOB_of_Shipment DJS 
		,[Assignment]
		,[CostCenter]
		,[VendorItemText]
	FROM @Dados_JOB_of_Shipment DJS 
		INNER JOIN PEDIDO_SHIP PS (NOLOCK)	ON DJS.NUM_PROC = PS.NUM_PROC
		INNER JOIN PEDIDO P (NOLOCK)ON PS.CD_PEDIDO = P.CD_PEDIDO
	WHERE 
		P.cd_tipo = 4
	GROUP BY	
		DJS.Nota_Fiscal,DJS.Ref_Acesso,DJS.[IncomingDate]	,P.NUM_PEDIDO,DJS.Num_proc,P.Planta,[Assignment],[CostCenter],[VendorItemText]
	ORDER BY 
		P.NUM_PEDIDO		

	UPDATE ds
	SET ds.ID_nota = dn.ID_nota
	,ds.valor_total = [InvoiceAmount]
	FROM @Dados_Shipment ds
	INNER JOIN @Dados_nota dn
		ON ds.Nota_Fiscal = dn.Nota_Fiscal
		AND ds.Ref_Acesso = dn.Ref_Acesso

	UPDATE dj
	SET Qtde_Shipment = 
							(SELECT COUNT(distinct [ShipmentNumber])
							FROM @Dados_Shipment ds
							WHERE ds.ID_nota = dj.ID_nota
							AND ds.Num_proc = dj.Num_proc
							)
	FROM @Dados_JOB_e_CTA dj

	UPDATE @Dados_Shipment
	SET LineItemAmount = 
							(SELECT Vlr_Pgto/Qtde_Shipment
							FROM @Dados_JOB_e_CTA dj
							WHERE dj.ID_nota = ds.ID_nota
							AND dj.Num_proc = ds.Num_proc
							)
	FROM @Dados_Shipment ds

	----verificar se esta ok cadu
	--UPDATE @Dados_Shipment
	--SET LineItemAmount = Valor_Total
	--FROM @Dados_nota ds	

	--select * from @Dados_Shipment  where num_proc in ( 'EACSR202105013BR','EACSR202105014BR','IMCSR202012474BR','IMCSR202012046BR','IMCSR202012120BR')
	--select * from @Dados_JOB_e_CTA where num_proc in ( 'EACSR202105013BR','EACSR202105014BR','IMCSR202012474BR','IMCSR202012046BR','IMCSR202012120BR')
	
	INSERT INTO @Controle
		SELECT 
			ds.ID_Nota					
			,MIN(ds.ID_Shipment)					as minid_shipment
			,MAX(ds.ID_Shipment)					as maxid_shipment

			,MIN(valor_total)						as valorTotalNF	
			,SUM(LineItemAmount)					as sumLineItemAmount
			,MIN(valor_total)-SUM(LineItemAmount)	as dif
		FROM @Dados_Shipment ds
		GROUP BY ds.ID_Nota	

	--SELECT * FROM @Controle

	--UPDATE @Dados_Shipment
	--SET LineItemAmount = LineItemAmount + dif
	--FROM @Dados_Shipment DS
	--INNER JOIN @Controle C
	--	ON DS.id_nota = c.id_nota 
	--	AND ds.ID_Shipment = c.maxid_shipment

	INSERT INTO @output  
	(
		[BusinessTransaction]
		,[CompanyCode]	
		,[SiteContact]
		,[InvoiceDate]
		,[VendorNumber]				
		,[VendorInvoiceNumber]			
		,[IncomingDate]				
		,[InvoiceAmount]				
		,[Currency]					
		,[TaxCode]	
		,[PartnerBank]
		,[PaymentMethod]
		,[Payee]						
		,[LineItemAmount]		
		,[Quantity]					
		,[UnitofMeasure]
		,[TextforExpenseLineItem]
		,[Assignment]
		,[GLaccount]
		,[CostCenter]
		,[MaterialGroup]
		,[Plant]
		,[VendorItemText]
		,[TaxTariff]
	----,[ShipmentNumber]	
	,ID_Nota					
	,ID_Shipment	
	--,JOB_NUMBER
	)
	select 
		dn.[BusinessTransaction]
		,dn.[CompanyCode]
		,dn.[SiteContact]
		,dn.[InvoiceDate]	
		,dn.[VendorNumber]				
		,dn.[VendorInvoiceNumber]		
		,ds.[IncomingDate]				
		,dn.[InvoiceAmount]				
		,dn.[Currency]					
		,dn.[TaxCode]
		,dn.[PartnerBank]
		,dn.[PaymentMethod]
		,dn.[Payee]						
		,ds.[LineItemAmount]		
		,ds.[Quantity]					
		,ds.[UnitofMeasure]	
		,dn.[TextforExpenseLineItem]
		,ds.[Assignment]
		,dn.[GLaccount]
		,ds.[CostCenter]
		,dn.[MaterialGroup]
		,dn.[Plant]
		,ds.[VendorItemText]
		,dn.[TaxTariff]
	----,ds.[ShipmentNumber]
	,ds.ID_Nota					
	,ds.ID_Shipment		
	--,DS.Num_proc
	from @Dados_nota dn
	inner join @Dados_Shipment ds
	on dn.ID_Nota = ds.ID_Nota

	-- tirar as linhas dos dados da nota
	update o
	SET 
	[BusinessTransaction] = NULL
	,[CompanyCode] = NULL
	,[SiteContact] = NULL
	,[InvoiceDate] = NULL
	,[VendorNumber] = NULL
	,[VendorInvoiceNumber] = NULL
	,[IncomingDate] = NULL
	,[InvoiceAmount] = NULL
	,[Currency] = NULL
	,[TaxCode] = NULL
	,[PartnerBank] = NULL
	,[PaymentMethod] = NULL
	,[Payee] = NULL
	FROM @output o
	LEFT JOIN @controle c
		ON o.id_nota = c.id_nota
		AND o.id_shipment = c.minid_shipment 
	WHERE C.ID_NOTA IS NULL
	


	-- EXIBIÇÃO
	SELECT
		[BusinessTransaction]
		,[CompanyCode]
		,[SiteContact]
		,[InvoiceDate]
		,[VendorNumber]
		,[VendorInvoiceNumber]
		,[IncomingDate]
		,[InvoiceAmount]
		,[Currency]
		,[TaxCode]
		,[PartnerBank]
		,[PaymentMethod]
		,[Payee]
		,[InvoiceAmount] [LineItemAmount]
		,[Quantity]
		,[UnitofMeasure]
		,[TextforExpenseLineItem]
		,[Assignment]
		,[GLaccount]
		,[CostCenter]
		,[MaterialGroup]
		,[Plant]
		,[VendorItemText]
		,[TaxTariff]				
	--,[ShipmentNumber]
	--,JOB_NUMBER
	FROM @output
	where
		[BusinessTransaction] IS not NULL
	ORDER BY 	
	ID_Nota					
	--,ID_Shipment

	 


/*
	DECLARE @output TABLE  
	(
	[BusinessTransaction]			VARCHAR(3)
	,[CompanyCode]					VARCHAR(500)
	,[SiteContact]					VARCHAR(50)
	,[InvoiceDate]					VARCHAR(10)
	,[VendorNumber]					VARCHAR(7)
	,[VendorInvoiceNumber]			VARCHAR(15)
	,[IncomingDate]					VARCHAR(10)
	,[InvoiceAmount]				DECIMAL(18,2)
	,[Currency]						VARCHAR(3)
	,[TaxCode]						VARCHAR(2)
	,[PartnerBank]					VARCHAR(4)
	,[PaymentMethod]				CHAR(1)
	,[Payee]						VARCHAR(7)
	,[LineItemAmount]				FLOAT
	,[Quantity]						FLOAT
	,[UnitofMeasure]				VARCHAR(5)
	,[TextforExpenseLineItem]		VARCHAR(3)
	,[Assignment]					VARCHAR(80)
	,[GLaccount]					VARCHAR(6)
	,[CostCenter]					VARCHAR(80)
	,[MaterialGroup]				VARCHAR(8)
	,[Plant]						VARCHAR(10)
	,[VendorItemText]				VARCHAR(90)
	,[TaxTariff]					VARCHAR(5)

	,ID_Nota				INT
	,ID_Shipment			INT
	,job_number				VARCHAR(16)
	)

	/*
	Coluna					Detalhes do preenchimento								obs
	BusinessTransaction		INV	
	CompanyCode				"31 - Dow Brasil Ind e Com Ltda
							833 - Dow Brasil Sudeste Ltda
							4308 - Palmyra Silicio do Brasil
							4083 - Rohm & Haas Quimica"	
	SiteContact				E-mail	
	VendorNumber			"1398350
							1058637"	
	InvoiceDate				Data de emissão da fatura	
	IncomingDate			Data do envio	
	VendorInvoiceNumber		Número da fatura	
	InvoiceAmount			Valor total da nota	
	Currency				BRL	
	TaxCode					I3														YY para PD
	PaymentMethod																	M para PD
	Payee					2027372 - Preencher apenas para vendor 1398350	
	LineItemAmount			Preencher linhas de acordo com o valor de cada job.	
	GLaccount				640000	
	CostCenter				Número do centro de custo	
	TextforExpenseLineItem	BDP	
	VendorItemText			BDP + Centro de Custo	"Para PD:						ADTO BDP XX (preencher com o número do adiantamento)"

	*/


	--LINHA DOS DADOS DA NOTA FISCAL
	DECLARE @Dados_nota TABLE  
	(
	ID_Nota					INT IDENTITY(1,1)
	,Nota_Fiscal			VARCHAR(8)
	,Ref_Acesso				CHAR(1)
	,[BusinessTransaction]		VARCHAR(3)
	,[CompanyCode]				VARCHAR(4)
	,[SiteContact]				VARCHAR(50)
	,[InvoiceDate]				VARCHAR(10)
	,[VendorNumber]				VARCHAR(7)
	,[VendorInvoiceNumber]		VARCHAR(9)
	,[InvoiceAmount]			DECIMAL(18,2)
	,[Currency]					VARCHAR(3)
	,[TaxCode]					VARCHAR(2)
	,[PartnerBank]				VARCHAR(4)
	,[PaymentMethod]			CHAR(1)
	,[Payee]					VARCHAR(7)
	,[TextforExpenseLineItem]	VARCHAR(3)
	,[GLaccount]				VARCHAR(6)
	,[MaterialGroup]			VARCHAR(8)
	,[TaxTariff]				VARCHAR(5)
	,[Plant]					VARCHAR(10)
	
	)

	--Dados do job e CTA_CTE
	DECLARE @Dados_JOB_e_CTA TABLE
	(
	ID_Nota					INT
	,Nota_Fiscal			VARCHAR(8)
	,Ref_Acesso				CHAR(1)
	,Num_proc				VARCHAR(16)
	,Vlr_Pgto				DECIMAL(18,2)
	,Qtde_Shipment			INT
	)

	--Dados do pedido e item do pedido
	DECLARE @Dados_JOB_of_Shipment TABLE
	(
	ID_Nota					INT
	,Nota_Fiscal			VARCHAR(8)
	,Ref_Acesso				CHAR(1)
	,Num_proc				VARCHAR(16)
	,[IncomingDate]			VARCHAR(10)
	,[Assignment]			VARCHAR(80)
	,[CostCenter]			VARCHAR(80)
	,[VendorItemText]		VARCHAR(90)
	)

	--Dados do pedido e item do pedido
	DECLARE @Dados_Shipment TABLE
	(
	ID_Nota					INT
	,ID_Shipment			INT IDENTITY(1,1)
	,Num_proc				VARCHAR(16)
	,Nota_Fiscal			VARCHAR(8)
	,Ref_Acesso				CHAR(1)
	,Valor_Total			DECIMAL(18,2)
	,[LineItemAmount]		FLOAT
	,[Quantity]				FLOAT
	,[UnitofMeasure]		VARCHAR(5)
	,[ShipmentNumber]		VARCHAR(30)
	,[IncomingDate]			VARCHAR(10)
	,[Assignment]			VARCHAR(80)
	,[CostCenter]			VARCHAR(80)
	,[VendorItemText]		VARCHAR(90)
	)

	DECLARE @controle TABLE 
	(
	ID_Nota					INT
	,minid_shipment			INT 
	,maxid_shipment			INT 
	,valorTotalNF			DECIMAL(18,2)
	,sumLineItemAmount		DECIMAL(18,2)
	,dif					DECIMAL(18,2)	
	)	

	INSERT INTO @Dados_nota
	(		
	Nota_Fiscal			
	,Ref_Acesso				
	,[BusinessTransaction]
	,[CompanyCode]
	,[SiteContact]
	,[InvoiceDate]
	,[VendorNumber]
	,[VendorInvoiceNumber]
	,[InvoiceAmount]
	,[Currency]
	,[TaxCode]
	,[PartnerBank]
	,[PaymentMethod]
	,[Payee]
	,[TextforExpenseLineItem]
	,[GLaccount]
	,[MaterialGroup]
	,[TaxTariff]
	,[Plant]
	)
	SELECT																				
	BNF.Nota_Fiscal												AS Nota_Fiscal
	,BNF.Ref_Acesso												AS Ref_Acesso
																								--Coluna					Detalhes do preenchimento									OBS
		,'INV'														AS	[BusinessTransaction]	--BusinessTransaction		SBD															Campo Não Editável
		,REPLICATE ('0',4 - LEN(CP.Campo_Dados)) + CP.Campo_Dados	AS	[CompanyCode]			--CompanyCode				31 - Dow Brasil Ind e Com Ltda
																								--							833 - Dow Brasil Sudeste Ltda
																								--							4308 - Palmyra Silicio do Brasil
																								--							4083 - Rohm & Haas Quimica
																								--							4621 - Performance Material Brasil

		,'BdeJesusEduardo@dow.com'									AS	[SiteContact]			--SiteContact				SiteContact	E-mail
		,CONVERT(VARCHAR(10),BNF.Emissao,101)						AS	[InvoiceDate]			--InvoiceDate				Data de emissão da nota fiscal
		,CASE BNF.Ref_Acesso 
		WHEN 'K' THEN  '1058637' 
		WHEN 'I' THEN  '1398350' 
		ELSE '' END													AS	[VendorNumber]			--VendorNumber				São Caetano do Sul (CNPJ 03.706.460/0001-28) - 1058637
																						--							Santos (CNPJ 03.706.460/0002-09) - 1398350		
		,BNF.RPS_NFE												AS	[VendorInvoiceNumber]	--VendorInvoiceNumber		Número da nota fiscal
		,BNF.Valor_Total											AS	[InvoiceAmount]			--InvoiceAmount				Valor total da nota fiscal
		,'BRL'														AS	[Currency]				--Currency					BRL															Campo Não Editável
		,'I3'														AS	[TaxCode]				--TaxCode					YY															Campo Não Editável
		,'BRP1'														AS	[PartnerBank]			--PartnerBank				1058637 - BRP1												Campo Não Editável
		,NULL														AS	[PaymentMethod]																						--							1398350 - BRP1
		,CASE BNF.Ref_Acesso 
		WHEN 'K' THEN  '' 
		WHEN 'I' THEN  '2027372' 
		ELSE '' END													AS	[Payee]					--Payee						1058637 - Não preencher
		,'BDP'														AS	[TextforExpenseLineItem]																				--							1398350 - 2027372
		,'640000'													AS	[GLaccount]
		,'93160000'													AS	[MaterialGroup]
		,'33.01'													AS	[TaxTariff]
		,CP27.Campo_Dados											AS	[Plant]
	FROM Base_Nota_Fiscal	BNF	(NOLOCK)
	LEFT JOIN Campo_Pessoa	CP	(NOLOCK) 
		ON BNF.Cd_Pes = CP.Cd_Pes  
		AND CP.Id_Campo = '25'

	LEFT JOIN Campo_Pessoa	CP27	(NOLOCK) 
		ON BNF.Cd_Pes = CP27.Cd_Pes  
		AND CP27.Id_Campo = '27'

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
--	AND  (RPS_NFE in ( '9020'))

	INSERT INTO @Dados_JOB_e_CTA
	(
	DN.Nota_Fiscal
	,DN.Ref_Acesso
	,Num_proc
	,Vlr_Pgto
	)
	SELECT 
	Nota_Fiscal
	,Ref_Acesso
	,Num_Proc_HIA
	,sum(Vlr_Pgto_NF_HIA)
	FROM @Dados_nota DN 
	INNER JOIN vwcta_Cte CTA (NOLOCK)
		ON 	DN.Nota_Fiscal = Num_NF_HIA			
		AND DN.Ref_Acesso = Ref_Acesso_NF_HIA
	--WHERE SUBSTRING(Num_Proc_HIA,1,1) = 'E' -- Call com o sibério em 29/12/2021 disse que no report shipment será somente exportação
	WHERE EXISTS 
	(
	SELECT DISTINCT 
	PS.Num_Proc
	FROM PEDIDO_SHIP PS (NOLOCK) 
	INNER JOIN PEDIDO P (NOLOCK)
		ON PS.CD_PEDIDO = P.CD_PEDIDO
	WHERE 
	CTA.Num_Proc_HIA = PS.NUM_PROC
	--AND SUBSTRING(NUM_PROC,1,1) = 'E'
	AND P.cd_tipo = 4 
	)
	GROUP BY
	Nota_Fiscal
	,Ref_Acesso
	,Num_Proc_HIA

--select '@Dados_nota_antes',*from @Dados_nota
--select '@Dados_JOB_e_CTA_antes',* from @Dados_JOB_e_CTA

	UPDATE dj
	SET dj.ID_nota = dn.ID_nota
	FROM @Dados_JOB_e_CTA dj
	INNER JOIN @Dados_nota dn
		ON dj.Nota_Fiscal = dn.Nota_Fiscal
		AND dj.Ref_Acesso = dn.Ref_Acesso

	-- Call com o sibério em 29/12/2021 disse que no report shipment será somente exportação
	DELETE FROM @Dados_nota
	WHERE ID_Nota NOT IN
	(
	SELECT N.ID_NOTA 
	FROM @Dados_nota N
	INNER JOIN @Dados_JOB_e_CTA J
		on N.nota_fiscal = J.nota_fiscal
		and N.ref_acesso = J.ref_acesso
	)

--select '@Dados_nota_depois',*from @Dados_nota
--select '@Dados_JOB_e_CTA_depois',* from @Dados_JOB_e_CTA



	--select '@Dados_JOB_e_CTA',* from @Dados_JOB_e_CTA

	--select '@Dados_nota',* from @Dados_nota

	INSERT INTO @Dados_JOB_of_Shipment
	(		
	Nota_Fiscal			
	,Ref_Acesso		
	,Num_proc
	,[IncomingDate]	
	,[Assignment]
	,[CostCenter]
	,[VendorItemText]
	)
	SELECT DISTINCT
	DN.Nota_Fiscal								AS	Nota_Fiscal
	,DN.Ref_Acesso								AS	Ref_Acesso
	,FV.Num_proc								AS	Num_proc
																			--Coluna					Detalhes do preenchimento									OBS
	,CONVERT(VARCHAR(10),TP.Dt_Conclusao,101)	AS	[IncomingDate]		--IncomingDate				Data do envio
	,vPO.Numero_PO									AS [Assignment]
	,vPO.Numero_PO									AS [CostCenter]
	,'BDP CC ' + vPO.Numero_PO						AS [VendorItemText]
	FROM @Dados_nota DN 
	INNER JOIN fatura_arg FA (NOLOCK) 
		ON RIGHT('000000000'+DN.nota_fiscal,10)=RIGHT('00000000'+FA.numero,10) 
		AND ref_acesso=codigo 
	INNER JOIN dbo.vwFaturasValidasArg FVA (NOLOCK) 
		ON FA.id_fat=FVA.id_fat  
	INNER JOIN  dbo.vwFaturasValidas FV (NOLOCK) 
		ON FV.num_proc=FVA.num_proc 
		AND FV.cd_tp_tx=FVA.cd_tp_tx 
		AND FV.dc=FVA.dc 
	LEFT JOIN Tarefas_Processos TP (nolock)
		ON FV.num_proc=TP.num_proc 
		AND TP.ID_Task = 40
	LEFT JOIN vwPO_ALL vPO (NOLOCK) --Alessandra 06/04/2022
		ON FV.num_proc = vPO.Num_Proc 
		AND vPO.ID_DC = 268

	INSERT INTO @Dados_Shipment
	(		
	Nota_Fiscal			
	,Ref_Acesso		
	,Num_proc
	,[IncomingDate]	
	,[Quantity]				
	,[UnitofMeasure]			
	,[ShipmentNumber]
	,[Assignment]
	,[CostCenter]
	,[VendorItemText]
	)
	SELECT 
	DJS.Nota_Fiscal								AS	Nota_Fiscal
	,DJS.Ref_Acesso								AS	Ref_Acesso
	,DJS.Num_proc								AS	Num_proc
	,DJS.[IncomingDate]							AS	[IncomingDate]
																		--Coluna					Detalhes do preenchimento									OBS
	,1											AS  [Quantity]			--Quantity					Quantidade da ordem de compra
	,'AU'										AS  [UnitofMeasure]		--UnitofMeasure				Unidade de medida da ordem de compra
	,isnull(P.NUM_PEDIDO,DJS.Num_proc)			AS  [ShipmentNumber]	--ShipmentNumber			Número da ordem de compra	FROM @Dados_JOB_of_Shipment DJS 
	,[Assignment]
	,[CostCenter]
	,[VendorItemText]
	FROM @Dados_JOB_of_Shipment DJS 
	INNER JOIN PEDIDO_SHIP PS (NOLOCK)
		ON DJS.NUM_PROC = PS.NUM_PROC
	INNER JOIN PEDIDO P (NOLOCK)
		ON PS.CD_PEDIDO = P.CD_PEDIDO
	WHERE P.cd_tipo = 4

	GROUP BY
	
	DJS.Nota_Fiscal
	,DJS.Ref_Acesso
	,DJS.[IncomingDate]	
	,P.NUM_PEDIDO
	,DJS.Num_proc
	,P.Planta
	,[Assignment]
	,[CostCenter]
	,[VendorItemText]

	ORDER BY 
	P.NUM_PEDIDO	

	--select * from @Dados_Shipment 	where Num_proc = 'EMCSR202106131BR'

	UPDATE ds
	SET ds.ID_nota = dn.ID_nota
	,ds.valor_total = [InvoiceAmount]
	FROM @Dados_Shipment ds
	INNER JOIN @Dados_nota dn
		ON ds.Nota_Fiscal = dn.Nota_Fiscal
		AND ds.Ref_Acesso = dn.Ref_Acesso

	UPDATE dj
	SET Qtde_Shipment = 
							(SELECT COUNT(distinct [ShipmentNumber])
							FROM @Dados_Shipment ds
							WHERE ds.ID_nota = dj.ID_nota
							AND ds.Num_proc = dj.Num_proc
							)
	FROM @Dados_JOB_e_CTA dj

	--SELECT * FROM @Dados_JOB_e_CTA WHERE Qtde_Shipment > 1

	--select * from @Dados_Shipment where num_proc in ( 'EACSR202105013BR','EACSR202105014BR','IMCSR202012474BR','IMCSR202012046BR','IMCSR202012120BR')
	--select * from @Dados_JOB_e_CTA where num_proc in ( 'EACSR202105013BR','EACSR202105014BR','IMCSR202012474BR','IMCSR202012046BR','IMCSR202012120BR')

	UPDATE @Dados_Shipment
	SET LineItemAmount = 
							(SELECT Vlr_Pgto/Qtde_Shipment
							FROM @Dados_JOB_e_CTA dj
							WHERE dj.ID_nota = ds.ID_nota
							AND dj.Num_proc = ds.Num_proc
							)
	FROM @Dados_Shipment ds

	--select * from @Dados_Shipment  where num_proc in ( 'EACSR202105013BR','EACSR202105014BR','IMCSR202012474BR','IMCSR202012046BR','IMCSR202012120BR')
	--select * from @Dados_JOB_e_CTA where num_proc in ( 'EACSR202105013BR','EACSR202105014BR','IMCSR202012474BR','IMCSR202012046BR','IMCSR202012120BR')
	
	INSERT INTO @Controle
	SELECT 
	ds.ID_Nota					
	,MIN(ds.ID_Shipment)					as minid_shipment
	,MAX(ds.ID_Shipment)					as maxid_shipment

	,MIN(valor_total)						as valorTotalNF	
	,SUM(LineItemAmount)					as sumLineItemAmount
	,MIN(valor_total)-SUM(LineItemAmount)	as dif
	FROM @Dados_Shipment ds
	GROUP BY ds.ID_Nota	

	--SELECT * FROM @Controle

	--UPDATE @Dados_Shipment
	--SET LineItemAmount = LineItemAmount + dif
	--FROM @Dados_Shipment DS
	--INNER JOIN @Controle C
	--	ON DS.id_nota = c.id_nota 
	--	AND ds.ID_Shipment = c.maxid_shipment

	INSERT INTO @output  
	(
		[BusinessTransaction]
		,[CompanyCode]	
		,[SiteContact]
		,[InvoiceDate]
		,[VendorNumber]				
		,[VendorInvoiceNumber]			
		,[IncomingDate]				
		,[InvoiceAmount]				
		,[Currency]					
		,[TaxCode]	
		,[PartnerBank]
		,[PaymentMethod]
		,[Payee]						
		,[LineItemAmount]		
		,[Quantity]					
		,[UnitofMeasure]
		,[TextforExpenseLineItem]
		,[Assignment]
		,[GLaccount]
		,[CostCenter]
		,[MaterialGroup]
		,[Plant]
		,[VendorItemText]
		,[TaxTariff]
	----,[ShipmentNumber]	
	,ID_Nota					
	,ID_Shipment	
	--,JOB_NUMBER
	)
	select 
		dn.[BusinessTransaction]
		,dn.[CompanyCode]
		,dn.[SiteContact]
		,dn.[InvoiceDate]	
		,dn.[VendorNumber]				
		,dn.[VendorInvoiceNumber]		
		,ds.[IncomingDate]				
		,dn.[InvoiceAmount]				
		,dn.[Currency]					
		,dn.[TaxCode]
		,dn.[PartnerBank]
		,dn.[PaymentMethod]
		,dn.[Payee]						
		,ds.[LineItemAmount]		
		,ds.[Quantity]					
		,ds.[UnitofMeasure]	
		,dn.[TextforExpenseLineItem]
		,ds.[Assignment]
		,dn.[GLaccount]
		,ds.[CostCenter]
		,dn.[MaterialGroup]
		,dn.[Plant]
		,ds.[VendorItemText]
		,dn.[TaxTariff]
	----,ds.[ShipmentNumber]
	,ds.ID_Nota					
	,ds.ID_Shipment		
	--,DS.Num_proc
	from @Dados_nota dn
	inner join @Dados_Shipment ds
	on dn.ID_Nota = ds.ID_Nota

	-- tirar as linhas dos dados da nota
	update o
	SET 
	[BusinessTransaction] = NULL
	,[CompanyCode] = NULL
	,[SiteContact] = NULL
	,[InvoiceDate] = NULL
	,[VendorNumber] = NULL
	,[VendorInvoiceNumber] = NULL
	,[IncomingDate] = NULL
	,[InvoiceAmount] = NULL
	,[Currency] = NULL
	,[TaxCode] = NULL
	,[PartnerBank] = NULL
	,[PaymentMethod] = NULL
	,[Payee] = NULL
	FROM @output o
	LEFT JOIN @controle c
		ON o.id_nota = c.id_nota
		AND o.id_shipment = c.minid_shipment 
	WHERE C.ID_NOTA IS NULL
	


	-- EXIBIÇÃO
	SELECT 


		[BusinessTransaction]
		,[CompanyCode]
		,[SiteContact]
		,[InvoiceDate]
		,[VendorNumber]
		,[VendorInvoiceNumber]
		,[IncomingDate]
		,[InvoiceAmount]
		,[Currency]
		,[TaxCode]
		,[PartnerBank]
		,[PaymentMethod]
		,[Payee]
		,[LineItemAmount]
		,[Quantity]
		,[UnitofMeasure]
		,[TextforExpenseLineItem]
		,[Assignment]
		,[GLaccount]
		,[CostCenter]
		,[MaterialGroup]
		,[Plant]
		,[VendorItemText]
		,[TaxTariff]				
	--,[ShipmentNumber]
	--,JOB_NUMBER
	FROM @output
	ORDER BY 	
	ID_Nota					
	--,ID_Shipment
*/
GO
