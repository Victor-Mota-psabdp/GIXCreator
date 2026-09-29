SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spATL_ShipmentNFSe_DOW_Rel_teste]
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
exec spATL_ShipmentNFSe_DOW_Rel_teste 'GRUPO DOW','2021-09-01','2021-09-30'
-------------------------------------------------------------------------------------------------------------------------
*/

	DECLARE @output TABLE  
	(
	[BusinessTransaction]	VARCHAR(3)
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
	,[LineItemAmount]		FLOAT
	,[Quantity]				FLOAT
	,[UnitofMeasure]		VARCHAR(5)
	,[ShipmentNumber]		VARCHAR(30)
	,ID_Nota				INT
	,ID_Shipment			INT
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
	,[InvoiceAmount]		DECIMAL(18,2)
	,[Currency]				VARCHAR(3)
	,[TaxCode]				VARCHAR(2)
	,[Payee]				VARCHAR(7)
	,[PartnerBank]			VARCHAR(4)
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


	/*
	Coluna					Detalhes do preenchimento									OBS
	BusinessTransaction		SBD															Campo Não Editável
	CompanyCode				31 - Dow Brasil Ind e Com Ltda
							833 - Dow Brasil Sudeste Ltda
							4308 - Palmyra Silicio do Brasil
							4083 - Rohm & Haas Quimica
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
	ShipmentNumber			Número da ordem de compra
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
	,[InvoiceAmount]
	,[Currency]
	,[TaxCode]
	,[Payee]
	,[PartnerBank]
	)
	SELECT																			
	BNF.Nota_Fiscal										AS Nota_Fiscal
	,BNF.Ref_Acesso										AS Ref_Acesso
																					--Coluna					Detalhes do preenchimento									OBS
	,'SDB'												AS	[BusinessTransaction]	--BusinessTransaction		SBD															Campo Não Editável
	,CP.Campo_Dados										AS	[CompanyCode]			--CompanyCode				31 - Dow Brasil Ind e Com Ltda
																					--							833 - Dow Brasil Sudeste Ltda
																					--							4308 - Palmyra Silicio do Brasil
																					--							4083 - Rohm & Haas Quimica
																					--							4621 - Performance Material Brasil
	,CASE BNF.Ref_Acesso 
	WHEN 'K' THEN  '1058637' 
	WHEN 'I' THEN  '1398350' 
	ELSE '' END											AS	[VendorNumber]			--VendorNumber				São Caetano do Sul (CNPJ 03.706.460/0001-28) - 1058637
																					--							Santos (CNPJ 03.706.460/0002-09) - 1398350		
	,BNF.RPS_NFE										AS	[VendorInvoiceNumber]	--VendorInvoiceNumber		Número da nota fiscal
	,CONVERT(VARCHAR(10),BNF.Emissao,103)				AS	[InvoiceDate]			--InvoiceDate				Data de emissão da nota fiscal
	,BNF.Valor_Total									AS	[InvoiceAmount]			--InvoiceAmount				Valor total da nota fiscal
	,'BRL'												AS	[Currency]				--Currency					BRL															Campo Não Editável
	,'YY'												AS	[TaxCode]				--TaxCode					YY															Campo Não Editável
	,CASE BNF.Ref_Acesso 
	WHEN 'K' THEN  '' 
	WHEN 'I' THEN  '2027372' 
	ELSE '' END											AS	[Payee]					--Payee						1058637 - Não preencher
																					--							1398350 - 2027372
	,'BRP1'												AS	[PartnerBank]			--PartnerBank				1058637 - BRP1												Campo Não Editável
																					--							1398350 - BRP1
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
	AND (RPS_NFE in ( '7608','115074') /*or rps_nfe = '109404'*/)

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
	GROUP BY
	Nota_Fiscal
	,Ref_Acesso
	,Num_Proc_HIA




	INSERT INTO @Dados_Shipment
	(		
	Nota_Fiscal			
	,Ref_Acesso		
	,Num_proc

	,[IncomingDate]		
	,[Quantity]				
	,[UnitofMeasure]			
	,[ShipmentNumber]			
	)
	SELECT 
	DN.Nota_Fiscal								AS	Nota_Fiscal
	,DN.Ref_Acesso								AS	Ref_Acesso
	,FV.Num_proc								AS	Num_proc
																		--Coluna					Detalhes do preenchimento									OBS
	,CONVERT(VARCHAR(10),TP.Dt_Conclusao,103)	AS	[IncomingDate]		--IncomingDate				Data do envio
	,sum(PD.qty)								AS  [Quantity]			--Quantity					Quantidade da ordem de compra
	,UoM										AS  [UnitofMeasure]		--UnitofMeasure				Unidade de medida da ordem de compra
	,P.NUM_PEDIDO								AS  [ShipmentNumber]	--ShipmentNumber			Número da ordem de compra
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

	INNER JOIN PEDIDO_SHIP PS (NOLOCK)
		ON FV.NUM_PROC = PS.NUM_PROC
	INNER JOIN PEDIDO P (NOLOCK)
		ON PS.CD_PEDIDO = P.CD_PEDIDO
	INNER JOIN PEDIDO_DET PD (NOLOCK)
		ON P.CD_PEDIDO = PD.CD_PEDIDO

	LEFT JOIN Tarefas_Processos TP (nolock)
		ON FV.num_proc=TP.num_proc 
		AND TP.ID_Task = 40
	--WHERE p.[status] <> 'E' - TEM CASOS QUE O JOB ESTA ATIVO E O PEDIDO CANCELADO, VAI DAR RUIM.
	--AND (RPS_NFE = '109404' or rps_nfe = '109404')

	GROUP BY
	
	DN.Nota_Fiscal
	,DN.Ref_Acesso

	,CONVERT(VARCHAR(10),TP.Dt_Conclusao,103)
	,UoM
	,P.NUM_PEDIDO
	,FV.Num_proc

	ORDER BY 
	P.NUM_PEDIDO 









	SELECT 
	DN.Nota_Fiscal								AS	Nota_Fiscal
	,DN.Ref_Acesso								AS	Ref_Acesso
		,FVA.Num_proc								AS	Num_proc
	,PD.qty										AS  [Quantity]			--Quantity					Quantidade da ordem de compra
	,UoM										AS  [UnitofMeasure]		--UnitofMeasure				Unidade de medida da ordem de compra
	,P.NUM_PEDIDO								AS  [ShipmentNumber]	--ShipmentNumber			Número da ordem de compra
	FROM @Dados_nota DN 

	INNER JOIN fatura_arg FA (NOLOCK) 
		ON RIGHT('000000000'+DN.nota_fiscal,10)=RIGHT('00000000'+FA.numero,10) 
		AND ref_acesso=codigo 
	INNER JOIN dbo.vwFaturasValidasArg FVA (NOLOCK) 
		ON FA.id_fat=FVA.id_fat  
	INNER JOIN PEDIDO_SHIP PS (NOLOCK)
		ON FVA.NUM_PROC = PS.NUM_PROC
	INNER JOIN PEDIDO P (NOLOCK)
		ON PS.CD_PEDIDO = P.CD_PEDIDO
	INNER JOIN PEDIDO_DET PD (NOLOCK)
		ON P.CD_PEDIDO = PD.CD_PEDIDO
	--WHERE p.[status] <> 'E' - TEM CASOS QUE O JOB ESTA ATIVO E O PEDIDO CANCELADO, VAI DAR RUIM.
	where (Nota_Fiscal = '7608')

	select distinct 'select final'
	,*
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

	INNER JOIN PEDIDO_SHIP PS (NOLOCK)
		ON FV.NUM_PROC = PS.NUM_PROC
	INNER JOIN PEDIDO P (NOLOCK)
		ON PS.CD_PEDIDO = P.CD_PEDIDO
	INNER JOIN PEDIDO_DET PD (NOLOCK)
		ON P.CD_PEDIDO = PD.CD_PEDIDO
	where (Nota_Fiscal = '7608')
	and P.NUM_PEDIDO = '1695BV'

















	--select * from @Dados_Shipment 	where Num_proc = 'EMCSR202106131BR'

	UPDATE ds
	SET ds.ID_nota = dn.ID_nota
	,ds.valor_total = [InvoiceAmount]
	FROM @Dados_Shipment ds
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
	SET Qtde_Shipment = 
							(SELECT COUNT(distinct [ShipmentNumber])
							FROM @Dados_Shipment ds
							WHERE ds.ID_nota = dj.ID_nota
							AND ds.Num_proc = dj.Num_proc
							)
	FROM @Dados_JOB_e_CTA dj

	--SELECT * FROM @Dados_JOB_e_CTA WHERE Qtde_Shipment > 1


	UPDATE @Dados_Shipment
	SET LineItemAmount = 
							(SELECT Vlr_Pgto/Qtde_Shipment
							FROM @Dados_JOB_e_CTA dj
							WHERE dj.ID_nota = ds.ID_nota
							AND dj.Num_proc = ds.Num_proc
							)
	FROM @Dados_Shipment ds


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

	UPDATE @Dados_Shipment
	SET LineItemAmount = LineItemAmount + dif
	FROM @Dados_Shipment DS
	INNER JOIN @Controle C
		ON DS.id_nota = c.id_nota 
		AND ds.ID_Shipment = c.maxid_shipment

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
	,[ShipmentNumber]	
	
	,ID_Nota					
	,ID_Shipment	
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
	,dn.[Payee]						
	,dn.[PartnerBank]				

	,ds.[LineItemAmount]		
	,ds.[Quantity]					
	,ds.[UnitofMeasure]				
	,ds.[ShipmentNumber]

	,ds.ID_Nota					
	,ds.ID_Shipment		
	,DS.Num_proc
	from @Dados_nota dn
	inner join @Dados_Shipment ds
	on dn.ID_Nota = ds.ID_Nota

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
	,[Payee]					= null				
	,[PartnerBank]				= null		
	FROM @output o
	LEFT JOIN @controle c
		ON o.id_nota = c.id_nota
		AND o.id_shipment = c.minid_shipment 
	WHERE C.ID_NOTA IS NULL

	-- EXIBIÇÃO
	SELECT 
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
	,[ShipmentNumber]
	,JOB_NUMBER
	FROM @output
	ORDER BY 	
	ID_Nota					
	,ID_Shipment

	 

GO
