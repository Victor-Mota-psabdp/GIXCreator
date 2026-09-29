SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spATL_ICMS_DOW_Rel]
(
@Grupo		VARCHAR(50),  
@DATA_INICIAL	DATETIME,
@DATA_FINAL		DATETIME
)

AS


  
IF @Grupo is NULL  
BEGIN  
	SET @Grupo = ''  
END  

DECLARE @cd_pes_grupo VARCHAR(10)  
SET @cd_pes_grupo = (SELECT TOP 1 Cd_Pes FROM pessoa (NOLOCK) WHERE apelido=@Grupo)  


/* -------------------------------------------------------------------------------------------------------------------------
HISTORY CHANGE
. Date:			15/09/2020
. Business:		Marcia Silva
. Dept:			Operação
. Developer:	Alessandra Suzuki Mariano
. Ticket:		100-296675	
. Request:		ICMS File Upload
				The ICMS amount must be paid in the clearance process. Example attached (ICMS - manual file).
-------------------------------------------------------------------------------------------------------------------------
EXECUTION 


-------------------------------------------------------------------------------------------------------------------------
*/

	DECLARE @output TABLE  
	(
	[BusinessTransaction]			VARCHAR(3)
	,[CompanyCode]					VARCHAR(500)
	,[SiteContact]					VARCHAR(30)
	,[InvoiceDate]					VARCHAR(10)
	,[VendorNumber]					VARCHAR(7)
	,[VendorInvoiceNumber]			VARCHAR(15)
	,[IncomingDate]					VARCHAR(10)
	,[InvoiceAmount]				DECIMAL(18,2)
	,[Currency]						VARCHAR(3)
	,[TaxCode]						VARCHAR(2)
	,[PaymentMethod]				VARCHAR(255)

	,[LineItemAmount]				FLOAT
	,[Quantity]						FLOAT
	,[UnitofMeasure]				VARCHAR(5)
	,[TextforExpenseLineItem]		VARCHAR(255)
	,[Assignment]					VARCHAR(255)
	,[GLaccount]					VARCHAR(255)
	,[MaterialGroup]				VARCHAR(255)
	,[Plant]						VARCHAR(255)
	,[VendorItemText]				VARCHAR(255)
	,[TaxTariff]					VARCHAR(255)
	,[CNPJ]							VARCHAR(15)
	)

	


	/*
	Company Codes and Plant ID to be considered in the File Upload:		
	Cia Code	Company Name					Plant ID
	31			Dow Brasil Ind e Com Ltda		A982
	833			Dow Brasil Sudeste Ltda			C158
	4083		Rohm & Haas Química				A026
	4308		Palmyra Silicio do Brasil		B521
	4621		Performance Materials Brasil	B843


	Column						Comments
	BusinessTransaction			INV
	CompanyCode					According to company codes informed above
	SiteContact					Do not fill
	VendorNumber				507510
	InvoiceDate					File sent Date
	IncomingDate				File Sent Date
	VendorInvoiceNumber			ICMS + Month + Day + Year + Sequence (Ex: ICMS08062101, ICMS08062102)
	InvoiceAmount				ICMS Amount
	Currency					BRL
	TaxCode						YY
	PaymentMethod				M
	LineItemAmount				ICMS Amount
	Quantity					1
	UnitofMeasure				EA
	TextforExpenseLineItem		PO/SH/SO + BDP + JOB + ICMS (Ex: 4006140561 BDP IMCSR202106586BR ICMS)
	Assignment					PO Number / Sales Order or Shipment Number
	GLaccount					148070
	MaterialGroup				93160000
	Plant						According to plant ID informed above
	VendorItemText				ICMS + Date (day/month/year) + PO/SH/SO (Ex: ICMS 05/08/2021 1875034)
	TaxTariff					99.99


	*/

	SELECT	DISTINCT																							--Column						Comments
	'INV'																					AS [BusinessTransaction]		--BusinessTransaction			INV		
	,CP25.Campo_Dados																		AS [CompanyCode]				--CompanyCode					According to company codes informed above
	,'LFuzettiNeves@dow.com'																AS [SiteContact]				--SiteContact					Do not fill
	,CONVERT(VARCHAR(10), PO.Data_PO,101)													AS [InvoiceDate]				--InvoiceDate					File sent Date													
	,'507510'																				AS [VendorNumber]				--VendorNumber					507510
	
	,'ICMS'
	+ REPLACE(CONVERT(VARCHAR(10), PO.Data_PO,1),'/','')
	+substring(HOI.Num_Proc,9,5)															AS [VendorInvoiceNumber]		--VendorInvoiceNumber			ICMS + Month + Day + Year + Sequence (Ex: ICMS08062101, ICMS08062102)
	
	,CONVERT(VARCHAR(10), PO.Data_PO,101)													AS [IncomingDate]				--IncomingDate					File Sent Date		
	,CASE WHEN 
		ISNUMERIC(REPLACE(Numero_PO,',','.')) = 0 
		THEN '' 
		ELSE 
			REPLACE(REPLACE(
				FORMAT(
					CAST(
						replace(
							Numero_PO
						,',','.') 
					AS DECIMAL(18, 2))
				,'c', 'en-us') 
			 ,'$',''),',','')
	END																					 	AS [InvoiceAmount]				--InvoiceAmount					ICMS Amount
	,'BRL'																					AS [Currency]					--Currency						BRL				
	,'YY'																					AS [TaxCode]					--TaxCode						YY
	,'M'																					AS [PaymentMethod]				--PaymentMethod					M
	,CASE WHEN 
		ISNUMERIC(REPLACE(Numero_PO,',','.')) = 0 
		THEN '' 
		ELSE 
			REPLACE(REPLACE(
				FORMAT(
					CAST(
						replace(
							Numero_PO
						,',','.') 
					AS DECIMAL(18, 2))
				,'c', 'en-us') 
			 ,'$',''),',','')
	END																						AS [LineItemAmount]				--LineItemAmount				ICMS Amount	
	,'1'																					AS [Quantity]					--Quantity						1
	,'EA'																					AS [UnitofMeasure]				--UnitofMeasure					EA
	
	,P.NUM_PEDIDO + ' BDP ' +  PS.Num_Proc +  ' ICMS' 										AS [TextforExpenseLineItem]		--TextforExpenseLineItem		PO/SH/SO + BDP + JOB + ICMS (Ex: 4006140561 BDP IMCSR202106586BR ICMS)			
	,P.NUM_PEDIDO																			AS [Assignment]					--Assignment					PO Number / Sales Order or Shipment Number
	,'148070'																				AS [GLaccount]					--GLaccount						148070				
	,'93160000'																				AS [MaterialGroup]				--MaterialGroup					93160000
	,CP27.Campo_Dados																		AS [Plant]						--Plant							According to plant ID informed above		
	,'ICMS ' + CONVERT(VARCHAR(10), PO.Data_PO,101) + ' ' + P.NUM_PEDIDO					AS [VendorItemText]				--VendorItemText				ICMS + Date (day/month/year) + PO/SH/SO (Ex: ICMS 05/08/2021 1875034)	
	,'99.99'																				AS [TaxTariff]					--TaxTariff						99.99
	,CLI.Num_CPF_CNPJ																		AS [CNPJ]
	FROM vwHouse_imp HOI (NOLOCK)

	INNER JOIN Pedido_Ship PS (NOLOCK) 
		on HOI.Num_Proc = PS.Num_Proc  
	INNER JOIN Pedido P (NOLOCK) 
		on PS.Cd_Pedido = P.Cd_Pedido

	INNER JOIN vwPO_ALL PO (NOLOCK)
		ON HOI.Num_Proc = PO.Num_Proc 
		AND PO.ID_DC = 266

	LEFT JOIN Campo_Pessoa	CP25	(NOLOCK) 
		ON HOI.Cd_Consig = CP25.Cd_Pes  
		AND CP25.Id_Campo = '25'

	LEFT JOIN Campo_Pessoa	CP27	(NOLOCK) 
		ON HOI.Cd_Consig = CP27.Cd_Pes  
		AND CP27.Id_Campo = '27'

	--JOIN DA TABELA PESSOA
	INNER JOIN Pessoa CLI (NOLOCK)
		ON HOI.Cd_Consig=CLI.cd_pes  
	LEFT JOIN Pessoa_LLP PLLP (NOLOCK)  
		ON CLI.cd_pes  =PLLP.cd_pes  
	LEFT JOIN Pessoa PP (NOLOCK)  
		ON PP.cd_pes=cd_pes_grupo  


	WHERE 
	 (PP.Apelido = @Grupo or @Grupo = '')  
	AND PO.Data_PO BETWEEN @DATA_INICIAL AND @DATA_FINAL





GO
