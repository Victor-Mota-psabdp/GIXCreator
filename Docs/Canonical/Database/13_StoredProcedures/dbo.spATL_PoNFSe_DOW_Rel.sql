SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spATL_PoNFSe_DOW_Rel]
(
@Grupo			VARCHAR(50),  
@DATA_INICIAL	DATETIME,
@DATA_FINAL		DATETIME
)

AS

  
IF @Grupo is NULL  
BEGIN  
	SET @Grupo = ''  
END  


/* -------------------------------------------------------------------------------------------------------------------------
HISTORY CHANGE
. Date:			15/09/2020
. Business:		Tiago Tadeu (Tiago.Alves@bdpint.com) e Sibério Bezerra (Siberio.Bezerra@bdpint.com)
. Dept:			Financeiro/Faturamento
. Developer:	Alessandra Suzuki Mariano
. Ticket:		100-296675	
. Request:		File Upload to Dow invoicing
				The idea is to generate and export an excel file for each type of document generated in the billing, containing BDP and client information.
-------------------------------------------------------------------------------------------------------------------------
EXECUTION 
exec spATL_PoNFSe_DOW_Rel 'GRUPO DOW','2021-09-01','2021-09-30'
-------------------------------------------------------------------------------------------------------------------------
*/

	DECLARE @output TABLE  
	(
	[BusinessTransaction]			VARCHAR(3)
	,[CompanyCode]					VARCHAR(500)
	,[VendorNumber]					VARCHAR(7)
	,[VendorInvoiceNumber]			VARCHAR(9)
	,[InvoiceDate]					VARCHAR(10)
	,[IncomingDate]					VARCHAR(10)
	,[InvoiceAmount]				DECIMAL(18,2)
	,[Currency]						VARCHAR(3)
	,[TaxCode]						VARCHAR(2)
	,[Payee]						VARCHAR(7)
	,[PartnerBank]					VARCHAR(4)

	,[LineItemAmount]				FLOAT
	,[Quantity]						FLOAT
	,[UnitofMeasure]				CHAR(2)
	,[PONumber]						VARCHAR(25)
	,[POLineItemNumber]				CHAR(1)
	,[AdditionalCostCondition1]		CHAR(3)
	,[AdditionalCostAmount1]		FLOAT
	,[TaxTariff]					VARCHAR(50)

	,ID_Nota				INT
	,ID_PO					INT
	,job_number				VARCHAR(16)
	)

	--LINHA DOS DADOS DA NOTA FISCAL
	DECLARE @Dados_nota TABLE  
	(
	ID_Nota					INT IDENTITY(1,1)
	,Nota_Fiscal			VARCHAR(8)
	,Ref_Acesso				CHAR(1)
	,[BusinessTransaction]	VARCHAR(3)
	,[CompanyCode]			VARCHAR(500)
	,[VendorNumber]			VARCHAR(7)
	,[VendorInvoiceNumber]	VARCHAR(9)
	,[InvoiceDate]			VARCHAR(10)
	,[IncomingDate]			VARCHAR(10)
	,[InvoiceAmount]		DECIMAL(18,2)
	,[Currency]				VARCHAR(3)
	,[TaxCode]				VARCHAR(2)
	,[Payee]				VARCHAR(7)
	,[PartnerBank]			VARCHAR(4)
	,[TaxTariff]			VARCHAR(50)
	)


	--Dados do job e CTA_CTE
	DECLARE @Dados_JOB_e_CTA TABLE
	(
	ID_Nota					INT
	,Nota_Fiscal			VARCHAR(8)
	,Ref_Acesso				CHAR(1)
	,Num_proc				VARCHAR(16)
	,Vlr_Pgto				DECIMAL(18,2)
	,Qtde_PO				INT
	)

	--Dados do JOB do PO
	DECLARE @Dados_JOB_of_PO TABLE
	(
	ID_Nota					INT
	,Nota_Fiscal			VARCHAR(8)
	,Ref_Acesso				CHAR(1)
	,Num_proc				VARCHAR(16)
	)


	--Dados do pedido e item do pedido
	DECLARE @Dados_PO TABLE
	(
	ID_Nota							INT
	,ID_PO							INT IDENTITY(1,1)
	,Num_proc						VARCHAR(16)
	,Nota_Fiscal					VARCHAR(8)
	,Ref_Acesso						CHAR(1)
	,Valor_Total					DECIMAL(18,2)
	,[LineItemAmount]				FLOAT
	,[Quantity]						FLOAT
	,[UnitofMeasure]				VARCHAR(2)
	,[PONumber]						VARCHAR(25)
	,[POLineItemNumber]				CHAR(1)
	,[AdditionalCostCondition1]		CHAR(3)
	,[AdditionalCostAmount1]		FLOAT
	)

	DECLARE @controle TABLE 
	(
	ID_Nota					INT
	,minID_PO			INT 
	,maxID_PO			INT 
	,valorTotalNF			DECIMAL(18,2)
	,sumLineItemAmount		DECIMAL(18,2)
	,dif					DECIMAL(18,2)	
	)


	/*
	Coluna					Detalhes do preenchimento									OBS
	BusinessTransaction		SBD															Campo Não Editável
	CompanyCode				31 - Dow Brasil Ind e Com Ltda
							833 - Dow Brasil Sudeste Ltda
							4308 - Palmyra Silicio do Brasil
							4083 - Rohm & HaAS Quimica
							4621 - Performance Material Brasil
	VendorNumber			São Caetano do Sul (CNPJ 03.706.460/0001-28) - 1058637
							Santos (CNPJ 03.706.460/0002-09) - 1398350
	InvoiceDate				Data de emissão da nota fiscal
	IncomingDate			Data do envio
	VendorInvoiceNumber		Número da nota fiscal
	InvoiceAmount			Valor total da nota fiscal
	Currency				BRL															Campo Não Editável
	TaxCode					YY															Campo Não Editável
	PartnerBank				1058637 - BRP1												Campo Não Editável
							1398350 - BRP1
	Payee					1058637 - Não preencher
							1398350 - 2027372
	LineItemAmount			Valor total do shipment										Campo Não Editável
	Quantity				Quantidade da ordem de compra
	UnitofMeasure			Unidade de medida da ordem de compra
	PONumber			Número da ordem de compra
	*/


	INSERT INTO @Dados_nota
	(		
	Nota_Fiscal			
	,Ref_Acesso				
	,[BusinessTransaction]
	,[CompanyCode]
	,[VendorNumber]
	,[VendorInvoiceNumber]
	,[InvoiceDate]
	,[IncomingDate]
	,[InvoiceAmount]
	,[Currency]
	,[TaxCode]
	,[Payee]
	,[PartnerBank]
	,[TaxTariff]
	)
	SELECT																			
	BNF.Nota_Fiscal										AS Nota_Fiscal
	,BNF.Ref_Acesso										AS Ref_Acesso
																					--Coluna					Detalhes do preenchimento									OBS
	,'SDB'												AS	[BusinessTransaction]	--BusinessTransaction		SBD															Campo Não Editável
	,CP.Campo_Dados										AS	[CompanyCode]			--CompanyCode				31 - Dow Brasil Ind e Com Ltda
																					--							833 - Dow Brasil Sudeste Ltda
																					--							4308 - Palmyra Silicio do Brasil
																					--							4083 - Rohm & HaAS Quimica
																					--							4621 - Performance Material Brasil
	,CASE BNF.Ref_Acesso 
	WHEN 'K' THEN  '1058637' 
	WHEN 'I' THEN  '1398350' 
	ELSE '' END											AS	[VendorNumber]			--VendorNumber				São Caetano do Sul (CNPJ 03.706.460/0001-28) - 1058637
																					--							Santos (CNPJ 03.706.460/0002-09) - 1398350		
	,BNF.RPS_NFE										AS	[VendorInvoiceNumber]	--VendorInvoiceNumber		Número da nota fiscal
	,CONVERT(VARCHAR(10),BNF.Emissao,101)				AS	[InvoiceDate]			--InvoiceDate				Data de emissão da nota fiscal
	--,CONVERT(VARCHAR(10),BNF.Emissao,101)				AS	[IncomingDate]	
	,CONVERT(VARCHAR(10),Getdate(),101)	AS	[IncomingDate]
	,BNF.Valor_Total									AS	[InvoiceAmount]			--InvoiceAmount				Valor total da nota fiscal
	,'BRL'												AS	[Currency]				--Currency					BRL															Campo Não Editável
	,'I3'												AS	[TaxCode]				--TaxCode					YY															Campo Não Editável
	,CASE BNF.Ref_Acesso 
	WHEN 'K' THEN  '' 
	WHEN 'I' THEN  '2027372' 
	ELSE '' END											AS	[Payee]					--Payee						1058637 - Não preencher
																					--							1398350 - 2027372
	,'BRP1'												AS	[PartnerBank]			--PartnerBank				1058637 - BRP1												Campo Não Editável
																					--							1398350 - BRP1
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
	--AND (RPS_NFE in ('7035','7185','7516') /*or rps_nfe = '109404'*/)

	--select * from @Dados_nota

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
	FROM @Dados_nota DN 
	INNER JOIN vwcta_Cte CTA (NOLOCK)
		ON 	DN.Nota_Fiscal = Num_NF_HIA			
		AND DN.Ref_Acesso = Ref_Acesso_NF_HIA
	-- WHERE SUBSTRING(Num_Proc_HIA,1,1) = 'I' -- Call com o sibério em 29/12/2021 disse que no report shipment será somente exportação
	WHERE EXISTS 
	(
	SELECT DISTINCT 
	PS.Num_Proc
	FROM PEDIDO_SHIP PS (NOLOCK) 
	INNER JOIN PEDIDO P (NOLOCK)
		ON PS.CD_PEDIDO = P.CD_PEDIDO
	WHERE 
	CTA.Num_Proc_HIA = PS.NUM_PROC
	AND SUBSTRING(NUM_PROC,1,1) = 'I'
	AND P.cd_tipo <> 4 
	)
	GROUP BY
	Nota_Fiscal
	,Ref_Acesso
	,Num_Proc_HIA


	UPDATE dj
	SET dj.ID_nota = dn.ID_nota
	FROM @Dados_JOB_e_CTA dj
	INNER JOIN @Dados_nota dn
		ON dj.Nota_Fiscal = dn.Nota_Fiscal
		AND dj.Ref_Acesso = dn.Ref_Acesso


	--select * from @Dados_JOB_e_CTA

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

	INSERT INTO @Dados_JOB_of_PO
	(		
	Nota_Fiscal			
	,Ref_Acesso		
	,Num_proc
	)
	SELECT DISTINCT
	DN.Nota_Fiscal								AS	Nota_Fiscal
	,DN.Ref_Acesso								AS	Ref_Acesso
	,FV.Num_proc								AS	Num_proc
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


	--select * from @Dados_JOB_of_PO


	INSERT INTO @Dados_PO
	(		
	Nota_Fiscal			
	,Ref_Acesso		
	,Num_proc
	,[Quantity]				
	,[UnitofMeasure]			
	,[PONumber]		
	
	,[POLineItemNumber]				
	,[AdditionalCostCondition1]							
	)
	SELECT DISTINCT
	DJP.Nota_Fiscal								AS	Nota_Fiscal
	,DJP.Ref_Acesso								AS	Ref_Acesso
	,DJP.Num_proc								AS	Num_proc

	--,sum(PD.qty)								
	,ISNULL((SELECT sum(PD.qty)
	FROM PEDIDO_DET PD (NOLOCK)
	WHERE P.CD_PEDIDO = PD.CD_PEDIDO
	GROUP BY PD.CD_PEDIDO),0)					AS  [Quantity]			--Quantity					Quantidade da ordem de compra
	
	,'KG'										AS  [UnitofMeasure]		--UnitofMeasure				Unidade de medida da ordem de compra
	
	
	
	,CASE WHEN SUBSTRING (DJP.NUM_PROC,1,2) = 'BO'
	THEN isnull(dbo.fBusca_Docs_PO_Modal(DJP.NUM_PROC,1),DJP.Num_proc)
	ELSE isnull(P.Num_PO,DJP.Num_proc)	END		AS  [PONumber]			
	
	,'1'										AS	[POLineItemNumber]
	,'ZSR'										AS	[AdditionalCostCondition1]
	FROM @Dados_JOB_of_PO DJP
	LEFT JOIN PEDIDO_SHIP PS (NOLOCK)
		ON DJP.NUM_PROC = PS.NUM_PROC
	LEFT JOIN PEDIDO P (NOLOCK)
		ON PS.CD_PEDIDO = P.CD_PEDIDO
	ORDER BY 
	[PONumber]

	--select * from @Dados_PO

	--select * from @Dados_PO 	where Num_proc = 'EMCSR202107021BR'


	UPDATE ds
	SET ds.ID_nota = dn.ID_nota
	,ds.valor_total = [InvoiceAmount]
	FROM @Dados_PO ds
	INNER JOIN @Dados_nota dn
		ON ds.Nota_Fiscal = dn.Nota_Fiscal
		AND ds.Ref_Acesso = dn.Ref_Acesso

	UPDATE dj
	SET dj.ID_nota = dn.ID_nota
	FROM @Dados_JOB_e_CTA dj
	INNER JOIN @Dados_nota dn
		ON dj.Nota_Fiscal = dn.Nota_Fiscal
		AND dj.Ref_Acesso = dn.Ref_Acesso

	UPDATE dj
	SET Qtde_PO = 
							(SELECT COUNT(distinct [PONumber])
							FROM @Dados_PO ds
							WHERE ds.ID_nota = dj.ID_nota
							AND ds.Num_proc = dj.Num_proc
							)
	FROM @Dados_JOB_e_CTA dj

	--SELECT * FROM @Dados_JOB_e_CTA WHERE Qtde_PO > 1


	UPDATE @Dados_PO
	SET LineItemAmount = 
							(SELECT Vlr_Pgto/Qtde_PO
							FROM @Dados_JOB_e_CTA dj
							WHERE dj.ID_nota = ds.ID_nota
							AND dj.Num_proc = ds.Num_proc
							and Qtde_PO > 0
							)
	FROM @Dados_PO ds


	INSERT INTO @Controle
	SELECT 
	ds.ID_Nota					
	,MIN(ds.ID_PO)							AS minID_PO
	,MAX(ds.ID_PO)							AS maxID_PO

	,MIN(valor_total)						AS valorTotalNF	
	,SUM(LineItemAmount)					AS sumLineItemAmount
	,MIN(valor_total)-SUM(LineItemAmount)	AS dif
	FROM @Dados_PO ds
	GROUP BY ds.ID_Nota	

	--SELECT * FROM @Controle

	UPDATE @Dados_PO
	SET LineItemAmount = LineItemAmount + dif
	FROM @Dados_PO DS
	INNER JOIN @Controle C
		ON DS.id_nota = c.id_nota 
		AND ds.ID_PO = c.maxID_PO

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
	,[Payee]						
	,[PartnerBank]				

	,[LineItemAmount]		
	,[Quantity]					
	,[UnitofMeasure]				
	,[PONumber]	
	
	,[POLineItemNumber]				
	,[AdditionalCostCondition1]		
	,[AdditionalCostAmount1]		
	,[TaxTariff]	

	,ID_Nota					
	,ID_PO	
	,JOB_NUMBER
	)
	select 
	dn.[BusinessTransaction]
	,dn.[CompanyCode]		
	,dn.[VendorNumber]				
	,dn.[VendorInvoiceNumber]		
	,dn.[InvoiceDate]				
	,dn.[IncomingDate]				
	,dn.[InvoiceAmount]				
	,dn.[Currency]					
	,dn.[TaxCode]				
	,dn.[Payee]						
	,dn.[PartnerBank]				

	,ds.[LineItemAmount]		
	,ds.[Quantity]					
	,ds.[UnitofMeasure]				
	,ds.[PONumber]
	,ds.[POLineItemNumber]				
	,ds.[AdditionalCostCondition1]		
	,ds.[AdditionalCostAmount1]		
	,dn.[TaxTariff]	

	,ds.ID_Nota					
	,ds.ID_PO		
	,DS.Num_proc
	from @Dados_nota dn
	inner join @Dados_PO ds
	on dn.ID_Nota = ds.ID_Nota

	UPDATE @OUTPUT
	SET AdditionalCostAmount1 = LineItemAmount

	UPDATE @OUTPUT
	SET LineItemAmount = NULL


	-- tirar AS linhAS dos dados da nota
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
	,[Payee]					= null				
	,[PartnerBank]				= null		
	FROM @output o
	LEFT JOIN @controle c
		ON o.id_nota = c.id_nota
		AND o.ID_PO = c.minID_PO 
	WHERE C.ID_NOTA IS NULL

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
	,[PartnerBank]	
	,[Payee]							

	,[LineItemAmount]		
	,[Quantity]					
	,[UnitofMeasure]				
	,[PONumber]

	,[POLineItemNumber]				
	,[AdditionalCostCondition1]		
	,[AdditionalCostAmount1]		
	,[TaxTariff]	
	--,JOB_NUMBER
	FROM @output
	ORDER BY 	
	ID_Nota					
	,ID_PO

	 

GO
