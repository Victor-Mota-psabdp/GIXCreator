SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_CEDAR_Levis_Rel]--'2024-08-28','2024-08-29'
(
	@DtInicial datetime,
	@DtFinal datetime
)
AS

Declare @Cd_Grupo varchar(10)    
Declare @Grupo varchar(50)    
set @Cd_Grupo = (select Cd_Pes_Grupo from Pessoa P with(nolock) join Grupo G with(nolock) on P.Cd_Pes = G.Cd_Pes_Grupo where P.Apelido = 'GRUPO LEVIS')        

	declare @TAB table
	(
	
	[Cd_Produto] varchar(100),
	[Cd_Pedido] varchar(100),
	[Importing Country] varchar(100),
	[Entry Number] varchar(100),
	[Entry Number 2] varchar(100),
	[File Number] varchar(100),
	[Commercial Invoice Number] varchar(2500),
	[Entry Line Number] varchar(100), 
	[PO Number] varchar(100),
	[PO Line] varchar(100),
	[ISD Number] varchar(2500),
	[Manufacturer Name] varchar(100),
	[Vendor Name] varchar(100),
	[Vendor Code] varchar(100),
	[Export Date] varchar(100),
	[Import Date] Datetime,
	[Entry Date] Datetime,
	[Release Date] Datetime,
	[Entry Type] varchar(100),
	[SCAC Code]	varchar(100),
	[Master B/L] varchar(100),
	[House B/L] varchar(100),
	[Port of Lading] varchar(250),
	[Port of Unlading] varchar(250), --Não Obrigatório
	[Entry Port] varchar(250),
	[Country of Origin] varchar(250),
	[Country of Export] varchar(250),
	[Cartons] bigint,
	[Unit Price] float,
	--[Invoice Value] decimal(18,2),
	[Invoice Value] float,
	[Invoice Currency] varchar(250),	
	[Additions] float,
	--[Deductions] varchar(100),
	[Deductions] float,
	--[Invoice Non Dutiables] varchar(100),
	[Invoice Non Dutiables] float,
	--[Entered Value] decimal(18,2),
	[Entered Value] float,
	[Currency Code] varchar(100),
	--[Total Duty] decimal(18,2),
	[Total Duty] float,
	[Duty Currency]  varchar(100),
	[Duty Rate] float,
	--[Additional Value for VAT] varchar(100),
	[Additional Value for VAT] float,
	--[Total Value for VAT] decimal(18,2),
	[Total Value for VAT] float,
	[VAT Rate] float,
	--[VAT Total] decimal(18,2),
	[VAT Total] float,
	[VAT Currency] varchar(100),
	[Customs Processing Fees] float,
	[Additional Taxes and Fees] float,
	--[Total Fee] decimal(18,2),
	[Total Fee] float,
	[Total Fee Currency Code] varchar(100),
	--[Entry Exchange Rate] decimal(18,2),
	[Entry Exchange Rate] float,
	[Incoterm] varchar(100),
	--[Quantity] varchar(100),
	[Quantity] float,
	[Quantity UOM] varchar(100),
	[Product Code] varchar(100),
	[SPI] varchar(100),
	[HTS Line 1] varchar(100),
	[HTS Line 2] varchar(100),
	[Mode of Transport] varchar(100),
	[Broker ID] varchar(100),	
	[Broker Name] varchar(100),
	[Entry Status] varchar(100),
	[Related Parties] varchar(100),
	[Chapter 98/99] varchar(100),
	[IOR] varchar(100),
	[MID] varchar(100),
	[HTS Desc] varchar(2500),
	[Freight] float,
	[Freight Currency] varchar(100),
	[Insurance] float,
	[Insurance Currency] varchar(100),
	[Gross Weight] float,
	[Net Weight] float,
	[Nota Fiscal] varchar(100),
	[D&D] varchar(100),
	[D&D Currency] varchar(100),
	[Royalties] varchar(100),
	[Royalty Currency] varchar(100),
	[Brand] varchar(100),
	[Adjustment Indicator] varchar(100),
	[Valuation Method] varchar(100),
	[Entry Number 3] varchar(100),
	[Licensee] varchar(100),
	[Courier] varchar(250),
	[Returns] varchar(100),
	[Indirect PO] varchar(100)
	)

	Begin
		insert into
			@TAB (
			
			[Cd_Produto],
			[Cd_Pedido],
			[Importing Country],
			[Entry Number],
			[Entry Number 2],
			[File Number],
			[Commercial Invoice Number],
			[Entry Line Number],
			[PO Number],
			[PO Line],
			[ISD Number],
			[Manufacturer Name],
			[Vendor Name],
			[Vendor Code],
			[Export Date],
			[Import Date],
			[Entry Date],
			[Release Date],
			[Entry Type],
			[SCAC Code],
			[Master B/L],
			[House B/L],
			[Port of Lading],
			[Port of Unlading],
			[Entry Port],
			[Country of Origin],
			[Country of Export],
			[Cartons],
			[Unit Price] ,
			[Invoice Value] ,
			[Invoice Currency],			
			[Deductions],
			[Invoice Non Dutiables],
			[Currency Code],
			[Duty Currency],
			[Additional Value for VAT],
			[VAT Currency],			 
			[Total Fee Currency Code],
			[Incoterm],
			[Quantity],
			[Quantity UOM],
			[Product Code],
			[SPI],
			[HTS Line 1],
			[HTS Line 2],
			[Mode of Transport],
			[Broker ID],	
			[Broker Name],
			[Entry Status],
			[Related Parties],
			[Chapter 98/99],
			[IOR],
			[MID],			
			[HTS Desc],
			[Freight Currency],
			[Insurance Currency],
			[D&D],
			[D&D Currency],
			[Royalties],
			[Royalty Currency],
			[Brand],
			[Adjustment Indicator],
			[Valuation Method],
			[Entry Number 3],
			[Licensee],
			[Courier],
			[Returns],
			[Indirect PO]
			)
			

					select					
					PS.cd_produto,
					PS.Cd_pedido,
					'BR', 
					--dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,5),
					REPLACE(REPLACE(REPLACE(COALESCE(dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,237),dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,5)),'.',''),'/',''),'-',''), --Alterado 30-08-2024 Leandro								
					'',																						
					HOU.Num_Proc,
					dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,2),
					--'', --Não tenho essa informação
					--dbo.fBusca_nAdicao_DDNFE(HOU.Num_Proc, PC.cd_proc_cliente), comentado em 06/03/2026 -- Leandro
					    COALESCE(dbo.fBusca_nAdicao_DDNFE(HOU.Num_Proc, PC.cd_proc_cliente),
						dbo.fBusca_nSeqAdic_DDNFE(HOU.Num_Proc, PC.cd_proc_cliente)),
					P.Num_Pedido,
					'',
					(case when (select dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,11)) = 'SEM NUMERO' 
					then '' 
					else (select dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,11)) end), --Decidir um Padrão S/N ou SEM NUMERO?
					'',
					--Export.Nome_Raz_Soc,
					'',--DC.xNome,
					'',
					'',
					HOU.ATA,
					COALESCE(dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc, 237),dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc, 5)),
					TP4.Dt_Conclusao,
					'',
					crm.SCAC,																				
					HOU.MAWB,																				
					HOU.HAWB,																				
					'',--Não Obrigatório
					'', --Não Obrigatório
					HOU.Cd_DstFinal,
					pf.cd_pais,
					PDC.cd_pais_fabricante,
					(CAse When PD.Qtde_Embal = NULL then '' else
					PD.Qtde_Embal end),
					PD.Vlr_Item,
					PD.Vlr_Total_Item,
					P.cd_tp_moeda,
					'',
					'',
					'BRL',
					'BRL',
					'',
					'BRL',
					'BRL',
					HOU.Cd_Tp_Oper,
					PD.Qty, --alterar para package type qty
					--PD.UoM,
					'PCS',
					PC.cd_Proc_Cliente,
					'',
					PD.NCM,
					'',
					(Case when P.cd_modal = 'O' then 'OCEAN' else
					(Case when P.cd_modal = 'A' then 'AIR' else
					(Case when P.cd_modal = 'T' then 'TRUCK' End) End) End),
					'BDP',
					'',
					HOU.canal,
					--(Case when PG.Apelido like '%LEVI%' then 'Y' else 'N' end),
					'',--(Case when DC.xNome like '%LEVI%' then 'Y' else 'N' end),
					'',
					substring(CNS.num_cpf_cnpj,1,2) + '.' + substring(CNS.num_cpf_cnpj,3,3) + '.' + substring(CNS.num_cpf_cnpj,6,3) + '/' + substring(CNS.num_cpf_cnpj,9,4) + '-' + substring(CNS.num_cpf_cnpj,13,2),
					'',
					PC.Produto_Descr,
					'BRL',
					'BRL',
					'',
					'',
					'',
					'',
					'LEVIS',
					'',
					'1',
					'',
					'',
					(CASE WHEN cp.num_proc IS NULL THEN 'N' ELSE 'Y'  end),
					'',
					''
					
					


					from vwHouse_Imp HOU with(nolock)

					left join Courier_Processo CP with(nolock) on CP.num_proc = hou.num_proc

					join pessoa	Export with(nolock) on Export.cd_pes = HOU.Cd_Export
					join pessoa	CNS with(nolock) on CNS.cd_pes = HOU.Cd_Consig
					Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig 
					join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo    
					join pessoa PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo  

					left Join Armador CRM with(nolock) on CRM.cd_armador=HOU.cd_armador 

					join Pedido_Ship PS with(nolock) on HOU.Num_Proc = PS.Num_Proc    
					join Pedido P with(nolock) on PS.cd_pedido = P.Cd_pedido 
					join Pedido_Det			PD with(nolock) on PD.Cd_Pedido = PS.Cd_Pedido and PD.Cd_Produto = PS.Cd_Produto and PD.item = PS.item and PD.Lote = PS.Lote
					join pedido_det_complementar PDC with(nolock)  on PDC.cd_pedido=PD.cd_pedido and PDC.cd_produto=PD.cd_produto and PDC.lote=PD.lote and PDC.item=PD.item   
					join Produto_Cliente	PC with(nolock) on PS.Cd_Produto = PC.Cd_Prod

					join Pais PF with(nolock) on PF.Cd_Pais = PDC.cd_pais_fabricante 

					join Tarefas_Processos TP4 with(nolock) on HOU.Num_Proc = TP4.Num_Proc and TP4.ID_Task =4  
					join Tarefas_Processos TP172 with(nolock) on HOU.Num_Proc = TP172.Num_Proc and TP172.ID_Task =172 

					where 
					PG.Apelido = 'GRUPO LEVIS' 
					and convert(datetime,TP4.Dt_Conclusao,103) between @DtInicial and @DtFinal					
					--and HOU.Num_Proc = 'IMLVS202511123BR'

	End

		Begin
	--Update com base na NOTA_CLIENTE
		Update T
		set 
			[Additions] = Acrescimos,
			[Entered Value] = VL_BASE_PIS,
			[Total Duty] = VL_II,
			[Duty Rate] = ALIQ_II / 100,
			[Total Value for VAT] = VL_BASE_ICMS,
			[VAT Rate] = ALIQ_ICMS / 100,
			[VAT Total] = VL_ICMS,
			[Entry Exchange Rate] = Paridade,
			[Freight] = Vlr_Frete,
			[Insurance] = Vlr_Seguro,
			[Gross Weight] = Peso_Bruto,
			[Net Weight] = Peso_Liquido,			
			[Nota Fiscal] = Nota_Fiscal
			
			
		from 
			@TAB T
			join
			(	
			Select 
				Acrescimos,
				VL_BASE_PIS,
				VL_II,
				ALIQ_II,
				VL_BASE_ICMS,
				ALIQ_ICMS,
				VL_ICMS,
				Paridade,
				Vlr_Frete, 
				Vlr_Seguro,  
				Peso_Bruto, 
				Peso_Liquido,
				Nota_Fiscal,
				Cd_Produto,				
				num_proc,
				Quantidade	
				

			from nota_fiscal_cliente_det NFCD
			join nota_cliente NC on NC.Id_NF = NFCD.Id_NF and NC.cd_cliente = NFCD.cd_cliente
			--where Num_Proc = 'IMLVS202401014BR'
			) A on A.num_proc = T.[File Number] and A.cd_produto = T.cd_produto 
			--and A.Quantidade = T.Quantity --RETIRADO em 14/04/2025 - leandro caso cristiane

			    UPDATE T
    SET
        [Vendor Name]     = DC.xNome,
        [Related Parties] = CASE WHEN DC.xNome LIKE '%LEVI%' THEN 'Y' ELSE 'N' END
    FROM
        @TAB T
        JOIN ATL_BR.dbo.Danfe_Base D WITH(NOLOCK) 
            ON D.Num_Proc = T.[File Number] AND D.nNF  = T.[Nota Fiscal] --Incluido amarracao por NF 26/02/2026
       LEFT JOIN ATL_BR.dbo.Danfe_Cia DC WITH(NOLOCK) 
            ON DC.Id_Danfe = D.Id_Danfe 
           AND DC.Tipo = 'D'
			End
			
			
			Begin
		--Update com base na CUSTO_CLIENTE
		Update @TAB
		set	
			[Customs Processing Fees] = dbo.fBusca_Custo([File Number], CD_Pedido, Cd_Produto, '%AFRMM - CHB%') + dbo.fBusca_Custo([File Number], CD_Pedido, Cd_Produto, '%Taxas Siscomex - CHB%'),
			[Additional Taxes and Fees] = dbo.fBusca_Custo([File Number], CD_Pedido, Cd_Produto, '%PIS - CHB%') + dbo.fBusca_Custo([File Number], CD_Pedido, Cd_Produto, '%COFINS - CHB%'),
			[Total Fee] =	dbo.fBusca_Custo([File Number], CD_Pedido, Cd_Produto, '%PIS - CHB%') +
							dbo.fBusca_Custo([File Number], CD_Pedido, Cd_Produto, '%COFINS - CHB%') + 
							dbo.fBusca_Custo([File Number], CD_Pedido, Cd_Produto, '%Taxas Siscomex - CHB%') +
							dbo.fBusca_Custo([File Number], CD_Pedido, Cd_Produto, '%AFRMM - CHB%')
							
			
		End


		Begin
			select 
					[Importing Country],
					[Entry Number],
					[Entry Number 2],
					[File Number],
					[Commercial Invoice Number],
					[Entry Line Number],
					[PO Number],
					[PO Line],
					[ISD Number],
					[Manufacturer Name],
					[Vendor Name],
					[Vendor Code],
					[Export Date],
					CONVERT(varchar, [Import Date], 101) AS [Import Date],
					CONVERT(varchar, [Entry Date], 101) AS [Entry Date],
					CONVERT(varchar,[Release Date],101) AS [Release Date],
					[Entry Type],
					[SCAC Code],
					[Master B/L],
					[House B/L],
					[Port of Lading],
					[Port of Unlading],
					[Entry Port],
					[Country of Origin],
					[Country of Export],
					[Cartons],
					--REPLACE([Unit Price],'.',',') AS [Unit Price],
					[Unit Price],
					--REPLACE([Invoice Value],'.',',') AS [Invoice Value],
					[Invoice Value],
					[Invoice Currency],
					--REPLACE([Additions],'.',',') AS [Additions],
					[Additions],
					[Deductions],
					[Invoice Non Dutiables],
					--REPLACE([Entered Value],'.',',') AS [Entered Value],	
					[Entered Value],
					[Currency Code],
					--REPLACE([Total Duty],'.',',') AS [Total Duty],
					[Total Duty],
					[Duty Currency],
					[Duty Rate],
					[Additional Value for VAT],
					--REPLACE([Total Value for VAT],'.',',') AS [Total Value for VAT],
					[Total Value for VAT],
					[VAT Rate],
					--REPLACE([VAT Total],'.',',') AS [VAT Total],
					[VAT Total],
					[VAT Currency],
					--REPLACE([Customs Processing Fees],'.',',') AS [Customs Processing Fees],
					[Customs Processing Fees],
					--REPLACE([Additional Taxes and Fees],'.',',') AS [Additional Taxes and Fees],
					[Additional Taxes and Fees],
					--REPLACE([Total Fee],'.',',') AS [Total Fee],
					[Total Fee],
					[Total Fee Currency Code],
					--REPLACE([Entry Exchange Rate],'.',',') AS [Entry Exchange Rate],
					[Entry Exchange Rate],
					[Incoterm],
					[Quantity],
					[Quantity UOM],
					[Product Code],
					[SPI],
					[HTS Line 1],
					[HTS Line 2],
					[Mode of Transport],
					[Broker ID],
					[Broker Name],
					[Entry Status],
					[Related Parties],
					[Chapter 98/99],
					[IOR],
					[MID],
					[HTS Desc],
					[Freight],
					[Freight Currency],
					[Insurance],
					[Insurance Currency],
					[Gross Weight],
					[Net Weight],
					[D&D],
					[D&D Currency],
					[Royalties],
					[Royalty Currency],
					[Brand],
					[Adjustment Indicator],
					[Valuation Method],
					[Entry Number 3],
					[Licensee],
					[Courier],
					[Returns],
					[Indirect PO]
					from 
					@TAB

		end
GO
