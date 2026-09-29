SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[sp_Saving_COO_Report_Sel] 
	@Grupo			VARCHAR(50) , 
	@DataInicial	DATETIME,
	@DataFinal		DATETIME
AS
/* -------------------------------------------------------------------------------------------------------------------------
HISTORY CHANGE
. Date: 24/06/2021
. Applicant: 
. Developer: Alessandra Suzuki Mariano / Beatriz Barbosa
. Request:100-275343	
-------------------------------------------------------------------------------------------------------------------------
EXECUTION EXECUTION
EXEC sp_Saving_COO_Report_Sel 'GRUPO NUTRITION&BIOS','2021-03-01','2021-03-31'

-------------------------------------------------------------------------------------------------------------------------
*/


/*
--Filtros Variáveis
--Data inicial
--Data final

--Filtros Fixos
--Processo de Exportação
--Que possui certificado de origem 
--Exportações efetuadas no trimestre = Processo desembaraçados enre data inicial e final
*/

DECLARE @Output TABLE
	(

	[BDP Ref.]						VARCHAR(16),
	[Shipper]						VARCHAR(60),
	[PO Number]						VARCHAR(400),
	[Sales Order]					VARCHAR(400),
	[Country of Final Destination]	VARCHAR(50),
	[Product ID]					VARCHAR(30),
	[Product Description]			VARCHAR(500),
	[Business Group]				VARCHAR(40),
	[Business Name]					VARCHAR(40),
	[NCM PO]						VARCHAR(8),
	[FOB - Invoice]					FLOAT,
	[Freight BL]					DECIMAL(10,2),
	[Freight Currency]				VARCHAR(3),
	[Invoice Value]					FLOAT,
	[Invoice Currency]				VARCHAR(3),
	[Incoterm]						VARCHAR(3),
	[Consignee]						VARCHAR(20),
	[Net Weight KG]					FLOAT,
	[Gross Weight KG]				FLOAT,
	[Agreement]						varchar(8000),
	[ATD Date]						DATETIME,
	[CFR Value (USD)]				FLOAT,
	[Import Duty %]					INT,
	[Preference (%)]				INT,
	[Saving (USD)]					FLOAT
	)

	INSERT INTO @Output
	SELECT 
	HOU.NUM_PROC													AS	[BDP Ref.]
	,PES.Nome_Raz_Soc												AS	[Shipper]
	,DBO.fBusca_Docs_PO_Modal(HOU.NUM_PROC,'001')					AS	[PO Number]
	,DBO.fBusca_Docs_PO_Modal(HOU.NUM_PROC,'003')					AS	[Sales Order]
	,LOCDEST.Pais_Local												AS	[Country of Final Destination]
	,PC.cd_Proc_Cliente												AS	[Product ID]
	,PC.Produto_Descr												AS	[Product Description]
	,DP.Business_Group_Descr										AS	[Business Group]
	,DP.Business_Descr												AS	[Business Name]
	,PC.NCM_Cliente													AS	[NCM PO]
	,NULL															AS	[FOB - Invoice]
	,HOU.Frete_BL													AS	[Freight BL]
	,HOU.Moeda_invoice												AS	[Freight Currency]
	,HOU.Vlr_Invoice												AS	[Invoice Value]
	,HOU.Moeda_Invoice												AS	[Invoice Currency]
	,P.Incoterm														AS	[Incoterm]
	,CONSIG.Apelido													AS	[Consignee]
	,PD.Peso_Liquido_TOT											AS	[Net Weight KG]
	,PD.Peso_Bruto_TOT												AS	[Gross Weight KG]
	,A.NOME_TP_AC													AS	[Agreement]
	,HOU.ATD														AS	[ATD Date]
	,HOU.Frete_BL+ HOU.Vlr_Invoice									AS	[CFR Value (USD)]
	,NULL															AS	[Import Duty %]
	,NULL															AS	[Preference (%)]
	,NULL															AS	[Saving (USD)]
	FROM vwHouse_exp HOU (NOLOCK)	-- Processos de Exportação
	INNER JOIN localidade LOCDEST (NOLOCK)		
		ON HOU.Cd_DstFinal = LOCDEST.Cd_Local 
	INNER JOIN PESSOA PES (NOLOCK)
		ON HOU.CD_EXPORT = PES.CD_PES 
	Left Join Pedido_Ship PS			(nolock) 
		on HOU.Num_Proc = PS.Num_Proc
	left Join Pedido_Det PD				(nolock) 
		on PS.cd_pedido = PD.Cd_pedido 
		and PS.cd_produto = PD.Cd_Produto
	left Join Pedido P					(nolock) 
		on PD.cd_pedido = P.Cd_pedido
	left Join Produto_Cliente PC		(nolock) 
		on PD.Cd_Produto = PC.cd_prod 
	Left Outer Join DE_Para_Produto DP	(nolock) 
		on DP.gmid=cd_proc_cliente	
	left Join Pessoa CONSIG				(nolock) 
		on HOU.Cd_Consig = CONSIG.Cd_Pes
	left join Pedido_Det_Complementar PDC (nolock) 
		on PDC.cd_pedido = PD.Cd_Pedido 
		and PDC.cd_produto = PD.Cd_Produto 
		and PDC.ITEM = PD.Item 
		and PDC.Lote = PD.Lote
	LEFT JOIN Tipo_Acordo_Comercial A (nolock) 
		on A.ID_TP_AC = PDC.ID_TP_AC
		
	LEFT JOIN Tarefas_processos TP4 (NOLOCK)
		ON HOU.Num_Proc = TP4.NUM_PROC
		AND TP4.ID_TASK = 4 
	
	-- JOINS PARA PUXAR QUAL GRUPO PERTENCE O PROCESSO
	INNER JOIN Pessoa_LLP LLP (NOLOCK)  
		ON LLP.Cd_Pes = HOU.Cd_Export  
	INNER JOIN Pessoa GRUPO (NOLOCK)  
		ON GRUPO.CD_PES = LLP.Cd_Pes_Grupo  

	WHERE 
	--HOU.Num_Proc = 'EMCSR201901001BR' 


	GRUPO.APELIDO =  @Grupo
		AND TP4.dt_conclusao between @DataInicial and @DataFinal 

	
	Declare @Temp Table  
	(  
	Cd_Proc_Cliente		varchar(40) 
	,Preco_Unt			float  
	,Peso_Liquido		float  
	,Uom				Varchar(5)  
	,Num_Proc			Varchar(16)  
	,Quantidade			Float  
	)  
	
	insert @Temp  
	select 
	cd_proc_cliente
	,Preco_Unit
	,sum(Peso_Liquido) Peso_Liquido
	,upper(Tipo_Unid) Uom
	,Num_Proc
	,sum(quantidade)*capacidade quantidade 
	from invoice_det ID (nolock)  
	INNER JOIN  Invoice_Cliente IC (nolock) 
		ON IC.id_inv=ID.id_inv  
	INNER JOIN  Produto_Cliente PC (nolock) 
		ON PC.cd_prod=ID.cd_produto
	INNER JOIN @Output
		ON IC.Num_Proc = [BDP Ref.]
		AND PC.cd_proc_cliente = [Product ID]
	group by  
	cd_proc_cliente
	,Preco_Unit
	,Peso_Liquido
	,Tipo_Unid
	,Num_Proc 
	,capacidade  
  
	union all  
  
	Select 
	cd_proc_cliente
	,vlr_item preco_unit
	,peso_liquido_tot peso_liquido
	,uom
	,ps.num_proc
	,ps.qty quantidade 
	From Pedido_Ship PS (nolock)  
	Join Pedido_Det PDD (nolock) 
		on PDD.cd_pedido=PS.cd_pedido 
		and PDD.cd_produto=PS.cd_produto 
		and PDD.lote=PS.lote and PDD.item=PS.item  
	Left Join Invoice_Cliente IC (nolock) 
		on PS.num_proc=IC.num_proc  
	INNER Join Produto_Cliente PC (nolock) 
		on PS.cd_produto=PC.cd_prod 
	INNER JOIN @Output
		ON PS.Num_Proc = [BDP Ref.]
		AND PC.cd_proc_cliente = [Product ID]
	where IC.num_proc is null  

	Declare @Temp2 Table  
	(   
	Num_Proc			Varchar(16)  
	,FOB			Float   
	)  

	insert into @Temp2
	SELECT 
	[BDP Ref.]
	,SUM(Quantidade*Preco_Unt) 
	from @Output
	INNER JOIN @temp
		ON [BDP Ref.] = num_proc
	GROUP BY [BDP Ref.]	

	update @Output
	set [FOB - Invoice] = FOB
	FROM @Output T1
	INNER JOIN @Temp2 T2
		ON T2.num_proc = T1.[BDP Ref.]


	
	SELECT * FROM @Output
GO
