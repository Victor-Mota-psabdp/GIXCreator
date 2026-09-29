SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[spReport_SWB_Custos_Taboao_REL]'2019-09-18','2019-09-18'
--SELECT * FROM Pedido_Ship WHERE Num_Proc = 'IMSWB201907077BR'
--SELECT * FROM Tarefas_Processos WHERE Num_Proc = 'IMSWB201906069BR' and ID_Task = 108
CREATE PROCEDURE  [dbo].[spReport_SWB_Custos_Taboao_REL]
	
	@DtInicial datetime,
	@DtFinal datetime

AS	


declare @TAB table
	(
		[BDP Ref.]			varchar(16),
		[MÊS]				varchar(200),--MÊS DESEMBARAÇO
		[ETIQUETA]			varchar(200),--Aba Referências CUSTOMER P.O.		
		
		[FORNECEDOR]		varchar(200),--Aba BL - Exportador
		[INVOICE NO]		varchar(200),--Aba Referências - Invoice	
		[INVOICE DATE]		Datetime,	--Aba Referências - Invoice date
		[MOEDA]				varchar(200),--Aba Referências adicionais -Invoice Currency 	 
		[FOB]				float,	-- Aba Referências adicionais - Invoice Value
		[INCOTERM]			varchar(200), --Aba Referências adicionais - Invoice Value		
		[NÚMERODI]			varchar(200),--Aba Referências - DI Number
		[DATAREGISTRO]		Datetime,--Aba Referências - DI Number - Data
		--[IMPORTADOR/ADQUIRENTE] varchar(200),--Aba BL consignatário
		[ORG]				varchar(200),--Informação do campo plant ID
		[PO]				varchar(200),--Aba Referências CUSTOMER P.O.	
		[BRL/USD]			float,--Campos adicionais : Paridade dolar D.I. 	
		[BRL/EUR]			float,--Campos adicionais : Paridade  D.I. 			
		[MOEDAFOB]			varchar(200),	--Aba Referências adicionais -Invoice Currency 
		[TOTALFOB]			float,	--Aba Referências adicionais - Invoice Value
		[MOEDAFRETE]		varchar(200),	--Aba BL moeda
		--[MOEDASEGURO]		varchar(200),	--Aba Referências adicionais -Invoice Currency 	
		--[MOEDAOUTRASDESPESAS]	varchar(200),--Campo ADICIONAIS Freight currency - D.I. 
		[TOTALCIFBRL]		float,	--Campo ADICIONAIS valor CIF
		[ORIGEM/LOCALDEEMBARQUE]	varchar(200),--Considerar o porto de embarque da capa.
		[DATAEMBARQUE]		Datetime,	--Aba BL ATD
		[DATACHEGADA]		Datetime,	--ABA BL ATA		

--Custos
		[TAXASISCOMEX]	float,	--Aba custo - Taxa Siscomex CHB
		[AFRMM/DESPESASADUANEIRAS]	float,	--Aba conta corrente AFRMM - CHB
		[AFRMM]						float,	--Aba Conta corrente - AFRMM-1 - CHB
		[FRETEINTERNACIONAL]		float,	--Aba Conta corrente - Transporte mercadoria - CHB	
		[FRETECONSTADI]				float,	--Aba custo- Frete (consta na DI)
		[TXADM+COMISSÃO]			float,	--Campo conta corrente - Serviços Prestados 1 - DESPACHO
		
		[NFE]			varchar(200),--Aba Referência do cliente - Numero nota fiscal
		[DATAEMISSÃO]	Datetime,--Aba Referência do cliente - Data nota fiscal
		[ITEM]			varchar(200),--O.M. Product I.D.
		[DESCRIÇÃO]		varchar(5000),--O.M. Product description
		[QUANTIDADE]	float,--O.M. QTY	
		[UNID]			varchar(200),--O.M. UOM
		[MEIODETRANSPORTE]	varchar(200),--O.M. Modal	
		--[MOEDASEGURO]	varchar(200),
		[***BRL/USD]	float,--Campos adicionais : Paridade dolar D.I. --Taxa sempre do dia anterior da DI
		[***DIFERENÇASEGURO]	varchar(200),--Seguro da D.I. - Coluna BG	
		[NOMEDODESPACHANTE]	varchar(200),--BDP INTERNATIONAL	
		[OUTRASDESPESAS]	float,--Considerar valor do acréscimo da D.I. da ABA custos, convertendo para USD (coluna O)


--Conta Corrente
		[LIBERAÇÃODEBL]				float,	--Aba Conta corrente - Liberação de BL 1,2,3.......- CHB
		[ARMAZENAGEM]				float,	--Aba Conta corrente - Armazenagem 1,2,3.......- CHB
		[TOTALADIANTADO]			float,--Aba conta corrente - Adantamento cliente - CHB (1.........)  Soma de todos os adiantamentos	

		[***DIFERENÇAFRETEINTERNACIONAL]	float,	
		[***THC(CAPATAZIA)/LIBERAÇÃO]		float,	
		[***DIFERENÇALIBERAÇÃO]				float,	

		[DESCONSOLIDAÇÃO]			float,	
		[FRETEINTERNO]				float,
		
		[OUTRAS]					float,	--Todas as demais despesas do conta corrente com excessão da armazenagem, frete internacional. 
		--AFRMM,transporte da mercadoria,liberação que tem campo próprio
		[OBSOUTRAS]	varchar(200),	
		[TOTALDESPACHANTE]			float,--Fórmula (BQ+BR+BS-BT+BU+BV+BW+BX+BY+BZ+CA+CB+CC+CD)
		[SDPAGAR(+)/SDDEVOLVER(-)]	float,--Fórmula (CE-CF)	
		[TOTALCUSTODESPACHANTE]		float,--Fórmula (BR+BS+BU+BV+BW+BX+BY+BZ+CA+CB+CC+CD)
		
		[SEGURO_CUSTOS]	float, --SEGURO DO CUSTO
		
		[NFSSERVIÇOSADD]			varchar(200),	
		[OBSSERVIÇOS]				varchar(1000),
		[Nota_Fiscal]				varchar(200),	
		[Ref_Acesso]				varchar(200),	
		
		--CD_Pedido int, 
		--Cd_Produto int,
		
		--XXXXXXXXXX Nota Fiscal XXXXXXXXXXXXXx
		[INTL FREIGHT+OTHER]float,	 --Se frete collet vazio, se frete prepaid utilizar o valor do frete da capa do JOB. 
		--(Se a fatura estiver com moeda diferente do frete de acordo com a moeda da fatura. 
		--Converter dividindo o valor do frete em reais no custo pela taxa do dolar da D.I., se o frete estiver em Euro, por exemplo
		[Frete_BL]					varchar(200),
		[Tipo_Frete]				varchar(200),
		[NCM]						varchar(200),
		[INVOICE AMOUNT]	float, --Campo Ref./adicionais - Value invoice.		
		[TOTALFRETE]		float,	--Considerar frete da aba BL.
		[TOTALSEGURO]		float,--Campo Nota fiscal - Seguro/Paridade D.I.  (PARA SEGURO NA MOEDA DA FATURA)
		

		
		[II]				float,	--Campo Nota fiscal - II
		[%II]				float,	--Campo Nota fiscal Aliq. II
		[IPI] 				float,	--Campo Nota fiscal IPI
		[%IPI] 				float,	--Campo Nota fiscal Aliq. IPI
		[PIS]				float,	--Campo Nota fiscal PIS
		[%PIS] 				float,	--Campo Nota fiscal Aliq. PIS
		[COFINS]			float,--Campo Nota fiscal COFINS	
		[%COFINS]			float,--Campo Nota fiscal Aliq. Cofins
		[BASEICMS]			float,--Campo nota fiscal - Base ICMS
		[ICMS]				float,--Campo nota fiscal - ICMS	
		[%ICMS]				float,--Campo nota fiscal - Aliq. ICMS
		[VALORTOTALDANFBRL]	float,--Campo nota fiscal - Valor total NF	
		
		---XXXXX OUTRAS CONTAS
		[TOTALCIFMOEDAORIGEM]	float	--Campo ADICIONAIS valor CIF/Paridade D.I. 
)	


insert into
	@TAB (
			[BDP Ref.],
			[MÊS],[ETIQUETA],[FORNECEDOR],[INVOICE NO],
			[INVOICE DATE],[MOEDA],[FOB],[INVOICE AMOUNT],[INCOTERM],			
			[NÚMERODI],[DATAREGISTRO],[ORG],[PO],[BRL/USD],[BRL/EUR],
			[MOEDAFOB],[TOTALFOB],[MOEDAFRETE],--[MOEDASEGURO],--[MOEDAOUTRASDESPESAS],
			[TOTALCIFBRL],[ORIGEM/LOCALDEEMBARQUE],[DATAEMBARQUE],[DATACHEGADA],
			[TAXASISCOMEX],[LIBERAÇÃODEBL],[ARMAZENAGEM],[AFRMM],[FRETEINTERNACIONAL],
			[FRETECONSTADI],[***THC(CAPATAZIA)/LIBERAÇÃO],[TOTALADIANTADO],
			--[SDPAGAR(+)/SDDEVOLVER(-)],
			[OUTRASDESPESAS],[SEGURO_CUSTOS],
			[NFE],[DATAEMISSÃO],[ITEM],[DESCRIÇÃO],[QUANTIDADE],[UNID],[MEIODETRANSPORTE],
			[***BRL/USD],[NOMEDODESPACHANTE],
			--[AFRMM/DESPESASADUANEIRAS],[AFRMM],[FRETEINTERNACIONAL],[TXADM+COMISSÃO],
			--CD_Pedido, 
			--Cd_Produto,
			Frete_BL,Tipo_Frete,NCM
		)
		select
			HOU.Num_Proc,
			right('00' + cast(month(T108.Dt_Conclusao)as varchar(2)),2) + '/' + cast(year(T108.Dt_Conclusao)as varchar(4)) [Mes],
			--dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'9')		[Ref],
			P09.Numero_PO									[Ref],
			Fornecedor.Nome_Raz_Soc							[FORNECEDOR],
			--dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'2')		[INVOICE NO],
			P02.Numero_PO									[INVOICE NO],
			--dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,'2')		[INVOICE DATE],
			P02.Data_PO										[INVOICE DATE],
			HOU.Moeda_invoice								[MOEDA],
			HOU.Vlr_invoice									[FOB],
			HOU.Vlr_invoice									[INVOICE AMOUNT],
			Incoterm.Nome_Tp_Oper							[INCOTERM],

			--dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'5')		[NÚMERODI],
			P05.Numero_PO									[NÚMERODI],
			--dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,'5')		[DATAREGISTRO],
			P05.Data_PO										[DATAREGISTRO],
			PLLIMPORTADOR.Cd_Planta							[ORG],
			--P.Planta										[ORG],
			--dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'9')	[PO],
			P09.Numero_PO									[PO],
			CP176.Campo_Dados [BRL/USD],--Campos adicionais : 176	10017	F	Paridade Dolar D.I.
			CP31.Campo_Dados [BRL/EUR],--Campos adicionais : 31	10017	F	Paridade D.I.	
	
			HOU.Moeda_invoice								[MOEDAFOB],--Aba Referências adicionais -Invoice Currency 
			HOU.Vlr_invoice									[TOTALFOB],--Aba Referências adicionais - Invoice Value
			HOU.Moeda_Frete									[MOEDAFRETE],--Aba BL moeda			
			--HOU.Moeda_invoice								[MOEDASEGURO],--Aba Referências adicionais -Invoice Currency 
			--CP174.Campo_Dados								[MOEDAOUTRASDESPESAS],--Campo ADICIONAIS Freight currency - D.I. - 174	10017	S	Freight Currency - DI	Tipo_Moeda
			CP110.Campo_Dados								[TOTALCIFBRL],	--Campo ADICIONAIS valor CIF 110	1	F	Valor CIF
			Origin.Nome_Local								[ORIGEM/LOCALDEEMBARQUE],--O.M.  Origin Country	
			HOU.ATD											[DATAEMBARQUE],	--Aba BL ATD
			HOU.ATA											[DATACHEGADA],	--ABA BL ATA
			--CCXAD.Vlr_Item_Custo * [dbo].[fBuscaPorcentagem_CdPedido](HOU.Num_Proc,PS.Item,PS.cd_pedido) [TAXASISCOMEX],
			sum(CCXAD.Vlr_Item_Custo)						[TAXASISCOMEX],	
			sum(CCXAG.Vlr_Item_Custo)						[LIBERAÇÃODEBL],
			sum(CCXAH.Vlr_Item_Custo)						[ARMAZENAGEM],
			sum(CCXAM.Vlr_Item_Custo)						[AFRMM],
			sum(CCXFR.Vlr_Item_Custo)						[FRETEINTERNACIONAL],
			sum(CCYDI.Vlr_Item_Custo)						[FRETECONSTADI],
			sum(CCXTH.Vlr_Item_Custo)						[***THC(CAPATAZIA)/LIBERAÇÃO] ,
			CCXBA.Vlr_Org_HIA								 [TOTALADIANTADO],
			sum(CCXDU.Vlr_Item_Custo)						[OUTRASDESPESAS],
			sum(CCINC.Vlr_Item_Custo)						[SEGURO_CUSTOS],	
			
			dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'10')		[NFE],--Aba Referência do cliente - Numero nota fiscal			
			--P10.Numero_PO									[NFE],
			dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,'10')		[DATA EMISSÃO],--Aba Referência do cliente - Data nota fiscal
			--P10.Data_PO										[DATA EMISSÃO],
			
			--PC.cd_Proc_Cliente				
			dbo.fBusca_PRODUTOID(HOU.Num_Proc) [ITEM],--O.M. Product I.D.
			--PC.Produto_Descr				
			[dbo].[fBusca_PRODUTO_Produto_Descr] (HOU.Num_Proc) [DESCRIÇÃO],--O.M. Product description
			--PD.Qty							
			[dbo].[fBusca_Qty_PRODUTO](HOU.Num_Proc) [QUANTIDADE],--O.M. QTY	
			--PD.UOM							
			[dbo].[fBusca_UoM_ALL](HOU.Num_Proc,'UOM') [UNID],--O.M. UOM
			SUBSTRING(HOU.Num_Proc,2,1)			[MEIODETRANSPORTE],		
			--P.cd_modal						[MEIODETRANSPORTE],--O.M. Modal	

			CP176.Campo_Dados				[***BRL/USD],--Campos adicionais : Paridade dolar D.I. --Taxa sempre do dia anterior da DI			
			'BDP INTERNATIONAL'				[NOMEDODESPACHANTE],	

			--CCXAM.Vlr_Org_HIA * [dbo].[fBuscaPorcentagem_CdPedido](HOU.Num_Proc,PS.Item,PS.cd_pedido)[AFRMM/DESPESASADUANEIRAS],
			--CCXAM.Vlr_Org_HIA * [dbo].[fBuscaPorcentagem_CdPedido](HOU.Num_Proc,PS.Item,PS.cd_pedido)[AFRMM],
			--CCXTM.Vlr_Org_HIA * [dbo].[fBuscaPorcentagem_CdPedido](HOU.Num_Proc,PS.Item,PS.cd_pedido)[FRETEINTERNACIONAL],
			--CCSRV.Vlr_Org_HIA * [dbo].[fBuscaPorcentagem_CdPedido](HOU.Num_Proc,PS.Item,PS.cd_pedido)[TXADM+COMISSÃO],			

			--'' [PS.cd_pedido],
			--'' [PS.cd_produto],
			HOU.Frete_BL,
			HOU.Tipo_Frete,
			--PD.NCM
			NCM.Alterado [NCM]			
		from Tarefas_Processos T108 with(nolock)
			LEFT OUTER JOIN vwHouse_Imp HOU with(nolock) on HOU.Num_Proc = T108.Num_Proc
			join Localidade Origin with(nolock) on Origin.Cd_Local = HOU.Cd_Org
			Join Pessoa CON	with(nolock) on CON.Cd_Pes = HOU.Cd_Consig
			Join Pessoa Fornecedor	with(nolock) on Fornecedor.Cd_Pes = HOU.Cd_Export
			LEFT OUTER JOIN Tipo_Oper Incoterm with(nolock) on Incoterm.Cd_Tp_Oper = HOU.Cd_Tp_Oper
			Join Pessoa IMPORTADOR	with(nolock) on IMPORTADOR.Cd_Pes = HOU.Cd_Consig
			LEFT OUTER JOIN Pessoa_LLP PLLIMPORTADOR	with(nolock) on PLLIMPORTADOR.Cd_Pes = HOU.Cd_Consig
			LEFT OUTER JOIN Campo_Processo CP31	with(nolock) on HOU.Num_Proc = CP31.Num_Proc AND CP31.Id_Campo = '31' 
			LEFT OUTER JOIN Campo_Processo CP176	with(nolock) on HOU.Num_Proc = CP176.Num_Proc AND CP176.Id_Campo = '176' 
			LEFT OUTER JOIN Campo_Processo CP174	with(nolock) on HOU.Num_Proc = CP174.Num_Proc AND CP174.Id_Campo = '174' 
			LEFT OUTER JOIN Campo_Processo CP110	with(nolock) on HOU.Num_Proc = CP110.Num_Proc AND CP110.Id_Campo = '110'
			
			LEFT OUTER JOIN vwPO_ALL P09	with(nolock) on HOU.Num_Proc = P09.Num_Proc AND P09.ID_DC = '9'	
			LEFT OUTER JOIN vwPO_ALL P02	with(nolock) on HOU.Num_Proc = P02.Num_Proc AND P02.ID_DC = '2'	
			LEFT OUTER JOIN vwPO_ALL P05	with(nolock) on HOU.Num_Proc = P05.Num_Proc AND P05.ID_DC = '5'	
			--LEFT OUTER JOIN vwPO_ALL P10	with(nolock) on HOU.Num_Proc = P10.Num_Proc AND P10.ID_DC = '10'
			LEFT OUTER JOIN PROC_NCM PNCM with(nolock) on HOU.Num_Proc = PNCM.Num_Proc
			LEFT OUTER JOIN NCM NCM with(nolock) on PNCM.ID_NCM = NCM.ID_NCM
			LEFT OUTER JOIN Pedido_Ship PS with(nolock) on HOU.Num_Proc = PS.Num_Proc
			-- LEFT OUTER JOIN Pedido_Det PD	 with(nolock) on PS.cd_pedido = PD.Cd_pedido and PS.cd_produto = PD.Cd_Produto and PS.Lote = PD.Lote and PS.Item = PD.Item
			-- LEFT OUTER JOIN Pedido P	with(nolock) on PD.cd_pedido = P.Cd_pedido
			---- LEFT OUTER JOIN Pais Origin with(nolock) on Origin.Cd_Pais = P.Cd_Pais_Org
			 --LEFT OUTER JOIN Tipo_Modal Modal with(nolock) on Modal.Id = P.cd_modal	
			 
			-- LEFT OUTER JOIN Produto_Cliente PC with(nolock) on PD.Cd_Produto = PC.cd_prod and PD.Cd_Produto = PC.cd_prod		
			 LEFT JOIN Custo_Cliente CCXAD with(nolock)on T108.Num_Proc = CCXAD.Num_Proc and CCXAD.Cd_tp_tx = 'XAD' 
				and CCXAD.Cd_Pedido = PS.Cd_pedido and CCXAD.Cd_Produto = PS.cd_produto
			LEFT JOIN Custo_Cliente CCXAG with(nolock)on T108.Num_Proc = CCXAG.Num_Proc and CCXAG.Cd_tp_tx = 'XAG' 
				and CCXAG.Cd_Pedido = PS.Cd_pedido and CCXAG.Cd_Produto = PS.cd_produto
			LEFT OUTER JOIN Custo_Cliente CCXAH with(nolock)on HOU.Num_Proc = CCXAH.Num_Proc and CCXAH.Cd_tp_tx = 'XAH' 
				and CCXAH.Cd_Pedido = PS.Cd_pedido and CCXAH.Cd_Produto = PS.cd_produto
			LEFT OUTER JOIN Custo_Cliente CCXAM with(nolock)on HOU.Num_Proc = CCXAM.Num_Proc and CCXAM.Cd_tp_tx = 'XAM' 
				and CCXAM.Cd_Pedido = PS.Cd_pedido and CCXAM.Cd_Produto = PS.cd_produto
			LEFT OUTER JOIN Custo_Cliente CCXFR with(nolock)on HOU.Num_Proc = CCXFR.Num_Proc and CCXFR.Cd_tp_tx = 'XFR' 
				and CCXFR.Cd_Pedido = PS.Cd_pedido and CCXFR.Cd_Produto = PS.cd_produto			
			LEFT OUTER JOIN Custo_Cliente CCYDI with(nolock)on HOU.Num_Proc = CCYDI.Num_Proc and CCYDI.Cd_tp_tx = 'YDI' 
				and CCYDI.Cd_Pedido = PS.Cd_pedido and CCYDI.Cd_Produto = PS.cd_produto
			LEFT OUTER JOIN Custo_Cliente CCXTH with(nolock)on HOU.Num_Proc = CCXTH.Num_Proc and CCXTH.Cd_tp_tx = 'XTH'
				and CCXTH.Cd_Pedido = PS.Cd_pedido and CCXTH.Cd_Produto = PS.cd_produto 			
			LEFT OUTER JOIN Custo_Cliente CCXDU with(nolock)on HOU.Num_Proc = CCXDU.Num_Proc and CCXDU.Cd_tp_tx = 'XDU'
				and CCXDU.Cd_Pedido = PS.Cd_pedido and CCXDU.Cd_Produto = PS.cd_produto 
			LEFT OUTER JOIN Custo_Cliente CCINC with(nolock)on HOU.Num_Proc = CCINC.Num_Proc and CCINC.Cd_tp_tx = 'INC'
				and CCINC.Cd_Pedido = PS.Cd_pedido and CCINC.Cd_Produto = PS.cd_produto 
				
				
			LEFT OUTER JOIN vwcta_cte CCXBA		with(nolock)on CCXBA.num_proc_hia=HOU.num_proc and CCXBA.dc_hia='C' and CCXBA.cd_tp_tx='XBA'
			--LEFT OUTER JOIN vwcta_cte CCXCA		with(nolock)on CCXCA.num_proc_hia=HOU.num_proc and CCXCA.dc_hia='D' and CCXCA.cd_tp_tx='XCA'		
		where 
			T108.ID_Task = 108
			AND convert(date,T108.Dt_Conclusao) BETWEEN convert(date,@DtInicial) and convert(date,@DtFinal)
			and PLLIMPORTADOR.Cd_Pes_Grupo = 'P000031844'
			--AND T4.Num_Proc in ('IMSWB201907077BR','IMSWB201904055BR')
			--AND T4.Num_Proc in ('IASWB201909012BR')
			--AND T4.Num_Proc  in ('IMSWB201907134BR')
			--AND T108.Num_Proc  in ('IMSWB201908027BR')
			
			and CON.Num_CPF_CNPJ IN ('60872306004661' ,'60872306000160')
		group by
			HOU.Num_Proc,			T108.Dt_Conclusao,			P09.Numero_PO,			Fornecedor.Nome_Raz_Soc,			P02.Numero_PO,
			P02.Data_PO,			HOU.Moeda_invoice,			HOU.Vlr_invoice,			Incoterm.Nome_Tp_Oper,			P05.Numero_PO,
			P05.Data_PO,			PLLIMPORTADOR.Cd_Planta,			P09.Numero_PO,			CP176.Campo_Dados,			CP31.Campo_Dados,
			HOU.Moeda_invoice,			HOU.Vlr_invoice,			HOU.Moeda_Frete,					HOU.Moeda_invoice,
			CP174.Campo_Dados,			CP110.Campo_Dados,			Origin.Nome_Local,			HOU.ATD,
			HOU.ATA,					--P10.Numero_PO,						--P10.Data_PO,						CP176.Campo_Dados,
			HOU.Frete_BL,			HOU.Tipo_Frete	,CCXBA.Vlr_Org_HIA,ncm.Alterado


--OUTRAS CONTAS
	Begin
	--Update com base na NOTA_CLIENTE
		Update T
		set 
			--[INTL FREIGHT+OTHER] = vlrINTL_FREIGHT_OTHER,--[INTL FREIGHT+OTHER], Campo nota fiscal - Frete + Acréscimos - Capatazias
			[TOTALFRETE] = vlr_frete,--Campo Nota fiscal - Valor frete
			[VALORTOTALDANFBRL] = Vlr_NF,
			[II] = vl_II,	--Campo Nota fiscal - II
			[%II]=ALIQ_II,	--Campo Nota fiscal Aliq. II
			[IPI] = VL_IPI,	--Campo Nota fiscal IPI
			[%IPI] = ALIQ_IPI,	--Campo Nota fiscal Aliq. IPI
			[PIS]=VL_IMPOSTO_PIS,	--Campo Nota fiscal PIS
			[%PIS]=VL_ALIQ_PIS,	--Campo Nota fiscal Aliq. PIS
			[COFINS]=VL_IMPOSTO_COFINS,--Campo Nota fiscal COFINS	
			[%COFINS]=VL_ALIQ_COFINS,--Campo Nota fiscal Aliq. Cofins
			[BASEICMS]= VL_BASE_ICMS ,--Campo nota fiscal - Base ICMS
			[ICMS]=VL_ICMS,--Campo nota fiscal - ICMS	
			[%ICMS]	= ALIQ_ICMS--Campo nota fiscal - Aliq. ICMS	
			--[TOTALSEGURO] = Vlr_Seguro
			
		from 
			@TAB T
			join
				(Select 
					--NFCD.vlr_frete + NFCD.ACRESCIMOS vlrINTL_FREIGHT_OTHER,
					sum(NFCD.vlr_frete)		vlr_frete,
					sum(NFCD.vl_II	)			vl_II,
					AVG(NFCD.ALIQ_II)			ALIQ_II,
					sum(NFCD.VL_IPI)				VL_IPI,
					AVG(NFCD.ALIQ_IPI)			ALIQ_IPI,
					sum(NFCD.VL_IMPOSTO_PIS)		VL_IMPOSTO_PIS,
					AVG(NFCD.VL_ALIQ_PIS)		VL_ALIQ_PIS,
					sum(NFCD.VL_IMPOSTO_COFINS)	 VL_IMPOSTO_COFINS,
					AVG(NFCD.VL_ALIQ_COFINS)	 VL_ALIQ_COFINS,
					sum(NFCD.VL_ICMS)			VL_ICMS,
					sum(NFCD.VL_BASE_ICMS)		VL_BASE_ICMS,
					AVG(NFCD.ALIQ_ICMS)			ALIQ_ICMS,
					--sum(NFCD.Vlr_Seguro)			Vlr_Seguro,
					NC.Vlr_NF Vlr_NF,
					Num_Proc --,Cd_Produto				
				from nota_fiscal_cliente_det NFCD with(nolock)
				join nota_cliente NC with(nolock) on NC.Id_NF = NFCD.Id_NF and NC.cd_cliente = NFCD.cd_cliente
				group by
					--NFCD.vlr_frete,NFCD.ACRESCIMOS,
					--NFCD.vl_II,
					--NFCD.ALIQ_II,
					--NFCD.VL_IPI,
					--NFCD.ALIQ_IPI,
					--NFCD.VL_IMPOSTO_PIS,
					--NFCD.VL_ALIQ_PIS,
					--NFCD.VL_IMPOSTO_COFINS,
					--NFCD.VL_ALIQ_COFINS,
					--NFCD.VL_ICMS,
					--NFCD.VL_BASE_ICMS,
					--NFCD.ALIQ_ICMS,
					--NFCD.Vlr_Seguro,
					NC.Vlr_NF,		

					--Cd_Produto,num_proc
					num_proc
			) A on A.num_proc = T.[BDP Ref.] 
			--and A.cd_produto = T.cd_produto --and A.cd_pedido=T.CD_Pedido
	End
	
	--update @TAB  set [TOTALSEGURO] = [TOTALSEGURO]/ [BRL/USD]
	--[TOTALSEGURO],--Campo Nota fiscal - Seguro/Paridade D.I.  (PARA SEGURO NA MOEDA DA FATURA)
	update @TAB  set [TOTALCIFMOEDAORIGEM] = [TOTALCIFBRL]/ [BRL/EUR]	
	--[TOTALCIFMOEDAORIGEM]	varchar(200),	--Campo ADICIONAIS valor CIF/Paridade D.I.
	
	
	Begin
		--Update com base na CUSTO_CLIENTE
		Update @TAB
		set
			--[LIBERAÇÃODEBL] = dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'Liberação%'),
			--[ARMAZENAGEM]= dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%Armazenagem%'),			
			--[AFRMM] = dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%AFRMM%'),
			--[FRETEINTERNACIONAL] = dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'Frete%CHB%'),
			--[FRETECONSTADI] = dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'Frete (consta na DI)%'),
			--[***THC(CAPATAZIA)/LIBERAÇÃO] = dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%THC%CHB%'),		
			[SDPAGAR(+)/SDDEVOLVER(-)]  = [dbo].[fBusca_CtaCteTaxaVlr]([BDP Ref.],'Prestacao de Contas%','D'),
			
			[BRL/EUR] = (CASE WHEN  [MOEDA] = 'EUR' THEN [BRL/EUR] ELSE NULL END),
			[OUTRASDESPESAS] = (CASE WHEN  [MOEDA] = 'EUR' THEN [OUTRASDESPESAS]/[BRL/EUR] ELSE [OUTRASDESPESAS] / [BRL/USD] END) ,
			--[OUTRASDESPESAS],--Considerar valor do acréscimo da D.I. da ABA custos, convertendo para USD (coluna O)
			
			--[SEGURO_CUSTOS]
			[TOTALSEGURO] = (CASE WHEN  [MOEDA] = 'EUR' THEN [SEGURO_CUSTOS]/[BRL/EUR] ELSE [SEGURO_CUSTOS] / [BRL/USD] END)
			--o valor do seguro do campo custo, sempre convertido em na moeda da 

			
	End
	
	Begin
		Update @TAB
		set
			[Nota_Fiscal] = (select distinct Numero from [dbo].[vwFaturasValidasArg] where Num_Proc = [BDP Ref.]and Cd_Tp_Tx in ('BRO','srv')),
			[Ref_Acesso] = (select distinct Ref_Accesso_Arg from [dbo].[vwFaturasValidasArg] where Num_Proc = [BDP Ref.]and Cd_Tp_Tx in ('BRO','srv')),
			FOB = 
				(CASE WHEN  [INCOTERM] = 'CIP - Carriage Insurance Paid'  THEN [FOB] - [Frete_BL] - [SEGURO_CUSTOS] ELSE
				(CASE WHEN  [INCOTERM] = 'CFR - Cost of Goods Freight' THEN [FOB] - [Frete_BL]  ELSE
				[FOB] END)END)
			--Neste campo quando o incoterm for CIF, considerar valor da invoice do campo Ref. Adic. (menos) 
			--o valor do frete da Capa do JOB (menos) o valor do seguro do campo custo, sempre convertido em na moeda da 
			--fatura que consta no campo Ref. Adic.)
			--CFR - Cost of Goods Freight
			--Neste campo quando o incoterm for CFR, considerar valor da invoice do campo Ref. Adic. 
			--(menos o valor do frete da CAPa do JOB, sempre convertido em na moeda 
			--da fatura que consta no campo Ref. Adic.)
			--DAP - Delivered at Place
			--Neste campo quando o incoterm for DAP, considerar valor da invoice do campo Ref. Adic. 
			--(menos o valor do frete da CAPa do JOB, sempre convertido em na moeda 
			--da fatura que consta no campo Ref. Adic.)
	End
	
	Begin
		Update @TAB
		set
			[NFSSERVIÇOSADD] = (select SUM(Valor_Org) from [dbo].[vwFaturasValidasArg] where Num_Proc = [BDP Ref.] and Numero =[Nota_Fiscal] and Ref_Accesso_Arg =[Ref_Acesso]),
			[TOTALFOB] = [TOTALFOB] - ([TOTALFRETE] /[BRL/USD])
				--(CASE WHEN   [INCOTERM] = 'CIP - Carriage Insurance Paid' OR [INCOTERM] = 'CFR - Cost of Goods Freight'
				-- THEN [FOB]  ELSE [TOTALFOB] END)				
	End
	
	Begin
		Update @TAB
		set
			[OBSSERVIÇOS] = (select [dbo].[FRemoveAcentuacao]([dbo].[fBusca_spRPSSTS]([Nota_Fiscal],[Ref_Acesso])))
	End
		
	Begin
		--Update com base na CUSTO_CLIENTE
		Update @TAB
		set
			--[INTL FREIGHT+OTHER] = (CASE WHEN Tipo_Frete = 'PREPAID' AND [MOEDAFRETE] <> [MOEDA] THEN 
			--												[FRETEINTERNACIONAL] / [BRL/USD] ELSE 
			--									(CASE WHEN Tipo_Frete = 'PREPAID' AND [MOEDAFRETE] = [MOEDA] THEN 
			--								[Frete_BL] 	ELSE NULL END)END)
			[INTL FREIGHT+OTHER] = ([TOTALFRETE] /[BRL/USD])
	End
	
	--%II - 12 - Verificar a possibilidade de utilizar o alerta da NCM para utilizar a alíquota correta quando tem redução.?
	-- Somente o item com NCM 3206.11.00, tem redução de alíquota, porém esta informação não e trazida para o ATL e nenhum campo,
	--neste caso seria possível condicionar se NCM 3206.11.00, informar na planilha confirmar alíquota utilizado. 
	--É um beneficio e pode ou não ser utilizado
	
	SELECT	
	--Tipo_Frete,[MOEDAFRETE],[MOEDA],[FRETEINTERNACIONAL],[BRL/USD] ,[Frete_BL],[Nota_Fiscal],
	
	[BDP Ref.],[MÊS],[ETIQUETA],[FORNECEDOR],[INVOICE NO],[INVOICE DATE],[MOEDA], [FOB],[INCOTERM],	
	
[INTL FREIGHT+OTHER],
[INVOICE AMOUNT],
[NÚMERODI],
[DATAREGISTRO],
[ORG],
[PO],
--convert(varchar(25),convert(decimal(10,4),[BRL/USD]))[BRL/USD],
convert(money,[***BRL/USD])[***BRL/USD],
[BRL/EUR],
[MOEDAFOB],
[TOTALFOB],
(CASE WHEN [MOEDAFRETE] = 'EUR' THEN [MOEDAFRETE] ELSE 'USD' END)[MOEDAFRETE],
--[Frete_BL] AS [TOTALFRETE],
convert(money,[Frete_BL])[TOTALFRETE],
'USD' [MOEDASEGURO],
(CASE WHEN [INCOTERM] = 'DAP - Delivered at Place' THEN NULL  ELSE [TOTALSEGURO] END)[TOTALSEGURO],
--[TOTALSEGURO] [TOTALSEGURO],
'USD'[MOEDAOUTRASDESPESAS],
[OUTRASDESPESAS] [OUTRASDESPESAS (Acréscimos)],
[TOTALCIFMOEDAORIGEM],
[TOTALCIFBRL],
[ORIGEM/LOCALDEEMBARQUE],
[DATAEMBARQUE],
[DATACHEGADA],
[II] [II],
(CASE WHEN NCM = 'S' THEN 'Confirmar Aliquota' else convert(varchar(25),[%II]) end)[%II], 
--[%II],
[IPI]			[IPI],
[%IPI]			[%IPI],
[PIS]			[PIS],
[%PIS]			[%PIS],
[COFINS]		[COFINS],
[%COFINS]		[%COFINS],
[TAXASISCOMEX] [TAXASISCOMEX],
[AFRMM] as		[AFRMM/DESPESASADUANEIRAS],
[BASEICMS]		[BASEICMS],
[ICMS]			[ICMS],
[%ICMS]		[%ICMS],
[NFE],
[DATAEMISSÃO],
[ITEM],
REPLACE([DESCRIÇÃO],'|',';') [DESCRIÇÃO],
[QUANTIDADE],
[UNID],
--'CLIENTE' [ITEM_TYPE],
[VALORTOTALDANFBRL],
--'CLIENTE' [CHECKTOTALNF],
(CASE WHEN [MEIODETRANSPORTE] ='M' THEN 'MARÍTIMO' ELSE 
		(CASE WHEN [MEIODETRANSPORTE] ='A' THEN 'AÉREO' ELSE 		
			'OUTROS' END)END) [MEIODETRANSPORTE],

'USD' [MOEDASEGURO],
--'CLIENTE'[VALORSEGURO],
--convert(varchar(25),convert(decimal(10,4),[***BRL/USD]))[***BRL/USD],
--convert(varchar(25),[***BRL/USD])[***BRL/USD],
--convert(varchar(25),convert(money,[***BRL/USD]))[***BRL/USD],
convert(money,[***BRL/USD])[***BRL/USD],
--'CLIENTE' [VALORSEGUROBRL],
--'CLIENTE' [***DIFERENÇASEGURO],
[NOMEDODESPACHANTE],
[II],
[ICMS],
[IPI],
[TAXASISCOMEX],
[PIS],
[COFINS],
[LIBERAÇÃODEBL],
[ARMAZENAGEM],
[AFRMM],
[FRETEINTERNACIONAL],
([FRETEINTERNACIONAL] - [FRETECONSTADI]) as [***DIFERENÇAFRETEINTERNACIONAL],
--[***DIFERENÇAFRETEINTERNACIONAL],
[***THC(CAPATAZIA)/LIBERAÇÃO],
--'CLIENTE' [***DIFERENÇALIBERAÇÃO],
''[SDA],
[DESCONSOLIDAÇÃO],
[FRETEINTERNO],
[TXADM+COMISSÃO],
[OUTRAS],
[OBSOUTRAS],
isnull([ICMS],0) + isnull([LIBERAÇÃODEBL],0) + isnull([ARMAZENAGEM],0) + isnull([AFRMM],0) + isnull([FRETEINTERNACIONAL],0) + isnull([***THC(CAPATAZIA)/LIBERAÇÃO],0)  [TOTALDESPACHANTE],
[TOTALADIANTADO],
--abs(([ICMS] + [LIBERAÇÃODEBL] + [ARMAZENAGEM] + [AFRMM] +[FRETEINTERNACIONAL] +[***THC(CAPATAZIA)/LIBERAÇÃO])- [TOTALADIANTADO]) 
[SDPAGAR(+)/SDDEVOLVER(-)],
isnull([LIBERAÇÃODEBL],0) + isnull([ARMAZENAGEM],0) + isnull([AFRMM],0) + isnull([FRETEINTERNACIONAL],0) + isnull([***THC(CAPATAZIA)/LIBERAÇÃO],0) [TOTALCUSTODESPACHANTE],
[NFSSERVIÇOSADD],
[OBSSERVIÇOS]
--'CLIENTE'[NÚMERORI],
--'CLIENTE'[ORG],
--'CLIENTE'[DATA],
--'CLIENTE'[TOTALKARDEX],
--'CLIENTE'[***CUSTOTOTAL],
--'CLIENTE'[VALORDOCOMPLEMENTO],
--'CLIENTE'[CHECK],
--'CLIENTE'[NÚMERORI],
--'CLIENTE'[DATA],
--'CLIENTE'[VALOR],
--'CLIENTE'[RESP.INPUTDADOS],
--'CLIENTE'[COMEX],
--'CLIENTE'[CONTASAPAGAR],
--'CLIENTE'[CONTABILIDADE],
--'CLIENTE'[SOL.COMPLEMENTO],
--'CLIENTE'[FISCALRI],
--'CLIENTE'[COMENTÁRIOS]
 FROM @TAB
 order by 2
--GROUP BY

--	[BDP Ref.],[MÊS],[ETIQUETA],[FORNECEDOR],[INVOICE NO],[INVOICE DATE],[MOEDA], [FOB],[INCOTERM],	
--	[Frete_BL],	
--[INTL FREIGHT+OTHER],
--[TOTALFOB],
--[NÚMERODI],
--[DATAREGISTRO],
--[ORG],
--[PO],
--[BRL/EUR],
--[MOEDAFOB],
--[TOTALFOB],
--[MOEDAFRETE],
--[MOEDASEGURO],
----[MOEDAOUTRASDESPESAS],
--[TOTALCIFMOEDAORIGEM],
--[TOTALCIFBRL],
--[ORIGEM/LOCALDEEMBARQUE],
--[DATAEMBARQUE],
--[DATACHEGADA],
-- NCM,
--[NFE],
--[DATAEMISSÃO],
--[ITEM],
--[DESCRIÇÃO],
--[QUANTIDADE],
--[UNID],
--[VALORTOTALDANFBRL],
--[MEIODETRANSPORTE],
--[MOEDASEGURO],
--[***BRL/USD],
--[***DIFERENÇASEGURO],
--[NOMEDODESPACHANTE],
--[II],
--[ICMS],
--[IPI],
--[TAXASISCOMEX],
--[PIS],
--[COFINS],
--[LIBERAÇÃODEBL],
--[ARMAZENAGEM],
--[AFRMM],
--[FRETEINTERNACIONAL],
--[FRETECONSTADI],
--[***THC(CAPATAZIA)/LIBERAÇÃO],
--[DESCONSOLIDAÇÃO],
--[FRETEINTERNO],
--[TXADM+COMISSÃO],
--[OUTRAS],
--[OBSOUTRAS],
--[ICMS], [LIBERAÇÃODEBL],[ARMAZENAGEM] ,[AFRMM],[FRETEINTERNACIONAL],[***THC(CAPATAZIA)/LIBERAÇÃO],
--[TOTALADIANTADO],
--[LIBERAÇÃODEBL],[ARMAZENAGEM], [AFRMM],[FRETEINTERNACIONAL],[***THC(CAPATAZIA)/LIBERAÇÃO],[TOTALADIANTADO], [SDPAGAR(+)/SDDEVOLVER(-)],
--[LIBERAÇÃODEBL] ,[ARMAZENAGEM] , [AFRMM],[FRETEINTERNACIONAL],[***THC(CAPATAZIA)/LIBERAÇÃO],
--[NFSSERVIÇOSADD],
--[OBSSERVIÇOS],
--[OUTRASDESPESAS]


	
	
--[ITEM_TYPE]		varchar(200),--Em branco para uso cliente incluir o titulo na coluna
--[CHECKTOTALNF]	varchar(200),--Em branco para uso cliente incluir o titulo na coluna
--[VALORSEGURO]	varchar(200),--Em branco - Valor da seguradora	
--[SDA]	varchar(200),--Em branco não tem cobrança de SDA
--[NÚMERORI]	varchar(200),--Em branco para uso cliente incluir o titulo na coluna	
--[DATA]	varchar(200),--Em branco para uso cliente incluir o titulo na coluna	
--[TOTALKARDEX]	varchar(200),--Em branco para uso cliente incluir o titulo na coluna
--[***CUSTOTOTAL]	varchar(200),--Em branco para uso cliente incluir o titulo na coluna
--[VALORDOCOMPLEMENTO]	varchar(200),--Em branco para uso cliente incluir o titulo na coluna	
--[CHECK]	varchar(200),--Em branco para uso cliente incluir o titulo na coluna	
--[VALOR]	varchar(200),--Em branco para uso cliente incluir o titulo na coluna	
--[RESP.INPUTDADOS]	varchar(200),--Em branco para uso cliente incluir o titulo na coluna	
--[COMEX]	varchar(200),	--Em branco para uso cliente incluir o titulo na coluna
--[CONTASAPAGAR]	varchar(200),--Em branco para uso cliente incluir o titulo na coluna	
--[CONTABILIDADE]	varchar(200),	--Em branco para uso cliente incluir o titulo na coluna
--[SOL.COMPLEMENTO]	varchar(200),	
--[FISCALRI]	varchar(200),	--Em branco para uso cliente incluir o titulo na coluna
--[COMENTÁRIOS]	varchar(200),		
		




/*
--select * from vwHouse_Imp where Num_Proc = 'IMSWB201907088BR'
--select * from Tarefas_Processos where Num_Proc = 'IMSWB201907077BR' and ID_Task = '4'
--select * from Tipo_Tarefas where Nome_Task like '%desem%'
--convert(Datetime,HOU.dt_emis,105) 
--select * from report where Stored like '%Dados_Mensais%'
--select * from Pessoa where Cd_Pes = 'P000031841'
--select * from Pessoa_LLP where Cd_Pes = 'P000031841'
--select * from Pessoa where Cd_Pes = 'P000031844'
--[spReport_SWB_Custos_REL] 'IMSWB201907088BR'
--select * from Tipo_Campo_Cliente where Descr_Campo like	'%serie%'
--select * from Pessoa where Cd_Pes in ('P000000450','P000003779','P000004208','P000006403','P000031844','P21128')
--select * from Campo_Processo where Id_Campo = '112'
--Se frete inter. Collect = (frete da DI R$ + Capatazias R$); Se frete inter. prepaid = capatazias R$
--Este relatório são para os CNPJ   60.872.306/0046-61 e 60.872.306/0001-60.
--[spReport_SWB_Custos_Taboao_REL]'2019-09-20','2019-09-20'
--select * from PO_HIM where Num_Proc_HIM = 'IMSWB201907001BR'
-- task Recebimento da Danfe?select * from tipo_tarefas where nome_task like '%Danfe%'
--108	Recebimento de Danfe
--select  convert(date,Dt_Conclusao) from Tarefas_Processos where Num_Proc = 'IMSWB201907001BR' and ID_Task = 108
ALTER PROCEDURE  [dbo].[spReport_SWB_Custos_Taboao_REL]
	
	@DtInicial datetime,
	@DtFinal datetime

AS	


declare @TAB table
	(
		[BDP Ref.]			varchar(16),
		[MÊS]				varchar(200),--MÊS DESEMBARAÇO
		[ETIQUETA]			varchar(200),--Aba Referências CUSTOMER P.O.		
		
		[FORNECEDOR]		varchar(200),--Aba BL - Exportador
		[INVOICE NO]		varchar(200),--Aba Referências - Invoice	
		[INVOICE DATE]		Datetime,	--Aba Referências - Invoice date
		[MOEDA]				varchar(200),--Aba Referências adicionais -Invoice Currency 	 
		[FOB]				float,	-- Aba Referências adicionais - Invoice Value
		[INCOTERM]			varchar(200), --Aba Referências adicionais - Invoice Value		
		[NÚMERODI]			varchar(200),--Aba Referências - DI Number
		[DATAREGISTRO]		Datetime,--Aba Referências - DI Number - Data
		--[IMPORTADOR/ADQUIRENTE] varchar(200),--Aba BL consignatário
		[ORG]				varchar(200),--Informação do campo plant ID
		[PO]				varchar(200),--Aba Referências CUSTOMER P.O.	
		[BRL/USD]			float,--Campos adicionais : Paridade dolar D.I. 	
		[BRL/EUR]			float,--Campos adicionais : Paridade  D.I. 			
		[MOEDAFOB]			varchar(200),	--Aba Referências adicionais -Invoice Currency 
		[TOTALFOB]			float,	--Aba Referências adicionais - Invoice Value
		[MOEDAFRETE]		varchar(200),	--Aba BL moeda
		[MOEDASEGURO]		varchar(200),	--Aba Referências adicionais -Invoice Currency 	
		[MOEDAOUTRASDESPESAS]	varchar(200),--Campo ADICIONAIS Freight currency - D.I. 
		[TOTALCIFBRL]		float,	--Campo ADICIONAIS valor CIF
		[ORIGEM/LOCALDEEMBARQUE]	varchar(200),--Considerar o porto de embarque da capa.
		[DATAEMBARQUE]		Datetime,	--Aba BL ATD
		[DATACHEGADA]		Datetime,	--ABA BL ATA		

--Custos
		[TAXASISCOMEX]	float,	--Aba custo - Taxa Siscomex CHB
		[AFRMM/DESPESASADUANEIRAS]	float,	--Aba conta corrente AFRMM - CHB
		[AFRMM]						float,	--Aba Conta corrente - AFRMM-1 - CHB
		[FRETEINTERNACIONAL]		float,	--Aba Conta corrente - Transporte mercadoria - CHB	
		[FRETECONSTADI]				float,	--Aba custo- Frete (consta na DI)
		[TXADM+COMISSÃO]			float,	--Campo conta corrente - Serviços Prestados 1 - DESPACHO
		
		[NFE]			varchar(200),--Aba Referência do cliente - Numero nota fiscal
		[DATAEMISSÃO]	Datetime,--Aba Referência do cliente - Data nota fiscal
		[ITEM]			varchar(200),--O.M. Product I.D.
		[DESCRIÇÃO]		varchar(200),--O.M. Product description
		[QUANTIDADE]	float,--O.M. QTY	
		[UNID]			varchar(200),--O.M. UOM
		[MEIODETRANSPORTE]	varchar(200),--O.M. Modal	
		--[MOEDASEGURO]	varchar(200),
		[***BRL/USD]	float,--Campos adicionais : Paridade dolar D.I. --Taxa sempre do dia anterior da DI
		[VALORSEGUROBRL]	float,	--Campo nota fiscal - Seguro
		[***DIFERENÇASEGURO]	varchar(200),--Seguro da D.I. - Coluna BG	
		[NOMEDODESPACHANTE]	varchar(200),--BDP INTERNATIONAL	
		[OUTRASDESPESAS]	float,--Considerar valor do acréscimo da D.I. da ABA custos, convertendo para USD (coluna O)


--Conta Corrente
		[LIBERAÇÃODEBL]				float,	--Aba Conta corrente - Liberação de BL 1,2,3.......- CHB
		[ARMAZENAGEM]				float,	--Aba Conta corrente - Armazenagem 1,2,3.......- CHB
		[TOTALADIANTADO]			float,--Aba conta corrente - Adantamento cliente - CHB (1.........)  Soma de todos os adiantamentos	

		[***DIFERENÇAFRETEINTERNACIONAL]	float,	
		[***THC(CAPATAZIA)/LIBERAÇÃO]		float,	
		[***DIFERENÇALIBERAÇÃO]				float,	

		[DESCONSOLIDAÇÃO]			float,	
		[FRETEINTERNO]				float,
		
		[OUTRAS]					float,	--Todas as demais despesas do conta corrente com excessão da armazenagem, frete internacional. 
		--AFRMM,transporte da mercadoria,liberação que tem campo próprio
		[OBSOUTRAS]	varchar(200),	
		[TOTALDESPACHANTE]			float,--Fórmula (BQ+BR+BS-BT+BU+BV+BW+BX+BY+BZ+CA+CB+CC+CD)
		[SDPAGAR(+)/SDDEVOLVER(-)]	float,--Fórmula (CE-CF)	
		[TOTALCUSTODESPACHANTE]		float,--Fórmula (BR+BS+BU+BV+BW+BX+BY+BZ+CA+CB+CC+CD)
		
		[NFSSERVIÇOSADD]			varchar(200),	
		[OBSSERVIÇOS]				varchar(1000),
		[Nota_Fiscal]				varchar(200),	
		[Ref_Acesso]				varchar(200),	
		
		CD_Pedido int, 
		Cd_Produto int,
		
		--XXXXXXXXXX Nota Fiscal XXXXXXXXXXXXXx
		[INTL FREIGHT+OTHER]float,	 --Se frete collet vazio, se frete prepaid utilizar o valor do frete da capa do JOB. 
		--(Se a fatura estiver com moeda diferente do frete de acordo com a moeda da fatura. 
		--Converter dividindo o valor do frete em reais no custo pela taxa do dolar da D.I., se o frete estiver em Euro, por exemplo
		[Frete_BL]					varchar(200),
		[Tipo_Frete]				varchar(200),
		[NCM]						varchar(200),
		[INVOICE AMOUNT]	float, --Campo Ref./adicionais - Value invoice.		
		[TOTALFRETE]		float,	--Considerar frete da aba BL.
		[TOTALSEGURO]		float,--Campo Nota fiscal - Seguro/Paridade D.I.  (PARA SEGURO NA MOEDA DA FATURA)
		
		[II]				float,	--Campo Nota fiscal - II
		[%II]				float,	--Campo Nota fiscal Aliq. II
		[IPI] 				float,	--Campo Nota fiscal IPI
		[%IPI] 				float,	--Campo Nota fiscal Aliq. IPI
		[PIS]				float,	--Campo Nota fiscal PIS
		[%PIS] 				float,	--Campo Nota fiscal Aliq. PIS
		[COFINS]			float,--Campo Nota fiscal COFINS	
		[%COFINS]			float,--Campo Nota fiscal Aliq. Cofins
		[BASEICMS]			float,--Campo nota fiscal - Base ICMS
		[ICMS]				float,--Campo nota fiscal - ICMS	
		[%ICMS]				float,--Campo nota fiscal - Aliq. ICMS
		[VALORTOTALDANFBRL]	float,--Campo nota fiscal - Valor total NF	
		
		---XXXXX OUTRAS CONTAS
		[TOTALCIFMOEDAORIGEM]	float	--Campo ADICIONAIS valor CIF/Paridade D.I. 
)	


insert into
	@TAB (
			[BDP Ref.],
			[MÊS],[ETIQUETA],[FORNECEDOR],[INVOICE NO],
			[INVOICE DATE],[MOEDA],[FOB],[INCOTERM],			
			[NÚMERODI],[DATAREGISTRO],[ORG],[PO],[BRL/USD],[BRL/EUR],
			[MOEDAFOB],[TOTALFOB],[MOEDAFRETE],[MOEDASEGURO],[MOEDAOUTRASDESPESAS],
			[TOTALCIFBRL],[ORIGEM/LOCALDEEMBARQUE],[DATAEMBARQUE],[DATACHEGADA],[TAXASISCOMEX],
			[NFE],[DATAEMISSÃO],[ITEM],[DESCRIÇÃO],[QUANTIDADE],[UNID],[MEIODETRANSPORTE],
			[***BRL/USD],[NOMEDODESPACHANTE],
			--[AFRMM/DESPESASADUANEIRAS],[AFRMM],[FRETEINTERNACIONAL],[TXADM+COMISSÃO],
			CD_Pedido, 
			Cd_Produto,
			Frete_BL,Tipo_Frete,NCM
		)
		select
			HOU.Num_Proc,
			right('00' + cast(month(T108.Dt_Conclusao)as varchar(2)),2) + '/' + cast(year(T108.Dt_Conclusao)as varchar(4)) [Mes],
			--dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'9')		[Ref],
			P09.Numero_PO									[Ref],
			Fornecedor.Nome_Raz_Soc							[FORNECEDOR],
			--dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'2')		[INVOICE NO],
			P02.Numero_PO									[INVOICE NO],
			--dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,'2')		[INVOICE DATE],
			P02.Data_PO										[INVOICE DATE],
			HOU.Moeda_invoice								[MOEDA],
			HOU.Vlr_invoice									[FOB],
			Incoterm.Nome_Tp_Oper							[INCOTERM],

			--dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'5')		[NÚMERODI],
			P05.Numero_PO									[NÚMERODI],
			--dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,'5')		[DATAREGISTRO],
			P05.Data_PO										[DATAREGISTRO],
			PLLIMPORTADOR.Cd_Planta							[ORG],
			--P.Planta										[ORG],
			--dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'9')	[PO],
			P09.Numero_PO									[PO],
			CP176.Campo_Dados [BRL/USD],--Campos adicionais : 176	10017	F	Paridade Dolar D.I.
			CP31.Campo_Dados [BRL/EUR],--Campos adicionais : 31	10017	F	Paridade D.I.	
	
			HOU.Moeda_invoice								[MOEDAFOB],--Aba Referências adicionais -Invoice Currency 
			HOU.Vlr_invoice									[TOTALFOB],--Aba Referências adicionais - Invoice Value
			HOU.Moeda_Frete									[MOEDAFRETE],--Aba BL moeda			
			HOU.Moeda_invoice								[MOEDASEGURO],--Aba Referências adicionais -Invoice Currency 
			CP174.Campo_Dados								[MOEDAOUTRASDESPESAS],--Campo ADICIONAIS Freight currency - D.I. - 174	10017	S	Freight Currency - DI	Tipo_Moeda
			CP110.Campo_Dados								[TOTALCIFBRL],	--Campo ADICIONAIS valor CIF 110	1	F	Valor CIF
			Origin.Nome_Local								[ORIGEM/LOCALDEEMBARQUE],--O.M.  Origin Country	
			HOU.ATD											[DATAEMBARQUE],	--Aba BL ATD
			HOU.ATA											[DATACHEGADA],	--ABA BL ATA
			CCXAD.Vlr_Item_Custo * [dbo].[fBuscaPorcentagem_CdPedido](HOU.Num_Proc,PS.Item,PS.cd_pedido) [TAXASISCOMEX],
			--dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'10')		[NFE],--Aba Referência do cliente - Numero nota fiscal			
			P10.Numero_PO									[NÚMERODI],
			--dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,'10')		[DATA EMISSÃO],--Aba Referência do cliente - Data nota fiscal
			P10.Data_PO										[DATAREGISTRO],
			
			PC.cd_Proc_Cliente				[ITEM],--O.M. Product I.D.
			PC.Produto_Descr				[DESCRIÇÃO],--O.M. Product description
			PD.Qty							[QUANTIDADE],--O.M. QTY	
			PD.UOM							[UNID],--O.M. UOM
			(CASE WHEN P.cd_modal = 'M' OR P.cd_modal = 'O' THEN 'Sea' 
				ELSE 
				Modal.Modal END)			[MEIODETRANSPORTE],		
			--P.cd_modal						[MEIODETRANSPORTE],--O.M. Modal	

			CP176.Campo_Dados				[***BRL/USD],--Campos adicionais : Paridade dolar D.I. --Taxa sempre do dia anterior da DI			
			'BDP INTERNATIONAL'				[NOMEDODESPACHANTE],	

			--CCXAM.Vlr_Org_HIA * [dbo].[fBuscaPorcentagem_CdPedido](HOU.Num_Proc,PS.Item,PS.cd_pedido)[AFRMM/DESPESASADUANEIRAS],
			--CCXAM.Vlr_Org_HIA * [dbo].[fBuscaPorcentagem_CdPedido](HOU.Num_Proc,PS.Item,PS.cd_pedido)[AFRMM],
			--CCXTM.Vlr_Org_HIA * [dbo].[fBuscaPorcentagem_CdPedido](HOU.Num_Proc,PS.Item,PS.cd_pedido)[FRETEINTERNACIONAL],
			--CCSRV.Vlr_Org_HIA * [dbo].[fBuscaPorcentagem_CdPedido](HOU.Num_Proc,PS.Item,PS.cd_pedido)[TXADM+COMISSÃO],			

			PS.cd_pedido,
			PS.cd_produto,
			HOU.Frete_BL,
			HOU.Tipo_Frete,
			PD.NCM			
		from Tarefas_Processos T108 with(nolock)
			LEFT OUTER JOIN vwHouse_Imp HOU with(nolock) on HOU.Num_Proc = T108.Num_Proc
			join Localidade Origin with(nolock) on Origin.Cd_Local = HOU.Cd_Org
			Join Pessoa CON	with(nolock) on CON.Cd_Pes = HOU.Cd_Consig
			Join Pessoa Fornecedor	with(nolock) on Fornecedor.Cd_Pes = HOU.Cd_Export
			LEFT OUTER JOIN Tipo_Oper Incoterm with(nolock) on Incoterm.Cd_Tp_Oper = HOU.Cd_Tp_Oper
			Join Pessoa IMPORTADOR	with(nolock) on IMPORTADOR.Cd_Pes = HOU.Cd_Consig
			LEFT OUTER JOIN Pessoa_LLP PLLIMPORTADOR	with(nolock) on PLLIMPORTADOR.Cd_Pes = HOU.Cd_Consig
			LEFT OUTER JOIN Campo_Processo CP31	with(nolock) on HOU.Num_Proc = CP31.Num_Proc AND CP31.Id_Campo = '31' 
			LEFT OUTER JOIN Campo_Processo CP176	with(nolock) on HOU.Num_Proc = CP176.Num_Proc AND CP176.Id_Campo = '176' 
			LEFT OUTER JOIN Campo_Processo CP174	with(nolock) on HOU.Num_Proc = CP174.Num_Proc AND CP174.Id_Campo = '174' 
			LEFT OUTER JOIN Campo_Processo CP110	with(nolock) on HOU.Num_Proc = CP110.Num_Proc AND CP110.Id_Campo = '110'
			
			LEFT OUTER JOIN vwPO_ALL P09	with(nolock) on HOU.Num_Proc = P09.Num_Proc AND P09.ID_DC = '9'	
			LEFT OUTER JOIN vwPO_ALL P02	with(nolock) on HOU.Num_Proc = P02.Num_Proc AND P02.ID_DC = '2'	
			LEFT OUTER JOIN vwPO_ALL P05	with(nolock) on HOU.Num_Proc = P05.Num_Proc AND P05.ID_DC = '5'	
			LEFT OUTER JOIN vwPO_ALL P10	with(nolock) on HOU.Num_Proc = P10.Num_Proc AND P10.ID_DC = '10'
			
			 
			 LEFT OUTER JOIN Pedido_Ship PS with(nolock) on HOU.Num_Proc = PS.Num_Proc
			 LEFT OUTER JOIN Pedido_Det PD	 with(nolock) on PS.cd_pedido = PD.Cd_pedido and PS.cd_produto = PD.Cd_Produto and PS.Lote = PD.Lote and PS.Item = PD.Item
			 LEFT OUTER JOIN Pedido P	with(nolock) on PD.cd_pedido = P.Cd_pedido
			-- LEFT OUTER JOIN Pais Origin with(nolock) on Origin.Cd_Pais = P.Cd_Pais_Org
			 LEFT OUTER JOIN Tipo_Modal Modal with(nolock) on Modal.Id = P.cd_modal		
			 LEFT OUTER JOIN Produto_Cliente PC with(nolock) on PD.Cd_Produto = PC.cd_prod and PD.Cd_Produto = PC.cd_prod		
			 LEFT OUTER JOIN Custo_Cliente CCXAD with(nolock)on HOU.Num_Proc = CCXAD.Num_Proc and CCXAD.Cd_tp_tx = 'XAD' 
				and CCXAD.Cd_Pedido = PS.Cd_pedido and CCXAD.Cd_Produto = PS.cd_produto			
			-- LEFT OUTER JOIN vwcta_cte CCSRV on CCSRV.num_proc_hia=HOU.num_proc and CCSRV.dc_hia='C' and CCSRV.cd_tp_tx='SRV'
			-- LEFT OUTER JOIN vwcta_cte CCXAM on CCXAM.num_proc_hia=HOU.num_proc and CCXAM.dc_hia='C' and CCXAM.cd_tp_tx='XAM'
			-- LEFT OUTER JOIN vwcta_cte CCXTM on CCXTM.num_proc_hia=HOU.num_proc and CCXTM.dc_hia='C' and CCXTM.cd_tp_tx='XTM'			
		where 
			T108.ID_Task = 108
			--AND convert(date,T108.Dt_Conclusao) BETWEEN convert(date,@DtInicial) and convert(date,@DtFinal)
			and PLLIMPORTADOR.Cd_Pes_Grupo = 'P000031844'
			--AND T4.Num_Proc in ('IMSWB201907077BR','IMSWB201904055BR')
			--AND T4.Num_Proc in ('IASWB201909012BR')
			--AND T4.Num_Proc  in ('IMSWB201907134BR')
			AND T108.Num_Proc  in ('IMSWB201907001BR')
			
			and CON.Num_CPF_CNPJ IN ('60872306004661' ,'60872306000160')



--OUTRAS CONTAS
	Begin
	--Update com base na NOTA_CLIENTE
		Update T
		set 
			--[INTL FREIGHT+OTHER] = vlrINTL_FREIGHT_OTHER,--[INTL FREIGHT+OTHER], Campo nota fiscal - Frete + Acréscimos - Capatazias
			--[TOTALFRETE] = vlr_frete,--Campo Nota fiscal - Valor frete
			[VALORTOTALDANFBRL] = Vlr_NF,
			[II] = vl_II,	--Campo Nota fiscal - II
			[%II]=ALIQ_II,	--Campo Nota fiscal Aliq. II
			[IPI] = VL_IPI,	--Campo Nota fiscal IPI
			[%IPI] = ALIQ_IPI,	--Campo Nota fiscal Aliq. IPI
			[PIS]=VL_IMPOSTO_PIS,	--Campo Nota fiscal PIS
			[%PIS]=VL_ALIQ_PIS,	--Campo Nota fiscal Aliq. PIS
			[COFINS]=VL_IMPOSTO_COFINS,--Campo Nota fiscal COFINS	
			[%COFINS]=VL_ALIQ_COFINS,--Campo Nota fiscal Aliq. Cofins
			[BASEICMS]= VL_BASE_ICMS ,--Campo nota fiscal - Base ICMS
			[ICMS]=VL_ICMS,--Campo nota fiscal - ICMS	
			[%ICMS]	= ALIQ_ICMS,--Campo nota fiscal - Aliq. ICMS	
			[TOTALSEGURO] = Vlr_Seguro,[VALORSEGUROBRL] = Vlr_Seguro
			
		from 
			@TAB T
			join
				(Select 
					--NFCD.vlr_frete + NFCD.ACRESCIMOS vlrINTL_FREIGHT_OTHER,
					NFCD.vlr_frete		vlr_frete,
					NFCD.vl_II			vl_II,
					NFCD.ALIQ_II		ALIQ_II,
					NFCD.VL_IPI			VL_IPI,
					NFCD.ALIQ_IPI		ALIQ_IPI,
					NFCD.VL_IMPOSTO_PIS	VL_IMPOSTO_PIS,
					NFCD.VL_ALIQ_PIS	VL_ALIQ_PIS,
					NFCD.VL_IMPOSTO_COFINS VL_IMPOSTO_COFINS,
					NFCD.VL_ALIQ_COFINS VL_ALIQ_COFINS,
					NFCD.VL_ICMS		VL_ICMS,
					NFCD.VL_BASE_ICMS	VL_BASE_ICMS,
					NFCD.ALIQ_ICMS		ALIQ_ICMS,
					NFCD.Vlr_Seguro		Vlr_Seguro,
					NC.Vlr_NF Vlr_NF,
					Num_Proc --,Cd_Produto				
				from nota_fiscal_cliente_det NFCD with(nolock)
				join nota_cliente NC with(nolock) on NC.Id_NF = NFCD.Id_NF and NC.cd_cliente = NFCD.cd_cliente
				group by
					NFCD.vlr_frete,NFCD.ACRESCIMOS,
					NFCD.vl_II,
					NFCD.ALIQ_II,
					NFCD.VL_IPI,
					NFCD.ALIQ_IPI,
					NFCD.VL_IMPOSTO_PIS,
					NFCD.VL_ALIQ_PIS,
					NFCD.VL_IMPOSTO_COFINS,
					NFCD.VL_ALIQ_COFINS,
					NFCD.VL_ICMS,
					NFCD.VL_BASE_ICMS,
					NFCD.ALIQ_ICMS,
					NFCD.Vlr_Seguro,
					NC.Vlr_NF,		

					--Cd_Produto,num_proc
					num_proc
			) A on A.num_proc = T.[BDP Ref.] 
			--and A.cd_produto = T.cd_produto --and A.cd_pedido=T.CD_Pedido
	End
	
	update @TAB  set [TOTALSEGURO] = [TOTALSEGURO]/ [BRL/EUR]
	--[TOTALSEGURO],--Campo Nota fiscal - Seguro/Paridade D.I.  (PARA SEGURO NA MOEDA DA FATURA)
	update @TAB  set [TOTALCIFMOEDAORIGEM] = [TOTALCIFBRL]/ [BRL/EUR]	
	--[TOTALCIFMOEDAORIGEM]	varchar(200),	--Campo ADICIONAIS valor CIF/Paridade D.I.
	
	
	Begin
		--Update com base na CUSTO_CLIENTE
		Update @TAB
		set
			[LIBERAÇÃODEBL] = dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'Liberação%'),
			[ARMAZENAGEM]= dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%Armazenagem%'),			
			[AFRMM] = dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%AFRMM%'),
			[FRETEINTERNACIONAL] = dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'Frete%CHB%'),
			[FRETECONSTADI] = dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'Frete (consta na DI)%'),
			[***THC(CAPATAZIA)/LIBERAÇÃO] = dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%THC%CHB%'),		
			[TOTALADIANTADO]  = [dbo].[fBusca_CtaCteTaxaVlr]([BDP Ref.],'Adiantamento%','C'),
			
			[BRL/EUR] = (CASE WHEN  [MOEDA] = 'EURO' THEN [BRL/EUR] ELSE NULL END),
			[OUTRASDESPESAS] = dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%VALOR DOS ACRÉSCIMOS (DI)%') / [BRL/USD]
			--[OUTRASDESPESAS],--Considerar valor do acréscimo da D.I. da ABA custos, convertendo para USD (coluna O)
			
	End
	
	Begin
		Update @TAB
		set

			[Nota_Fiscal] = (select distinct Numero from [dbo].[vwFaturasValidasArg] where Num_Proc = [BDP Ref.]and Cd_Tp_Tx in ('BRO','srv')),
			[Ref_Acesso] = (select distinct Ref_Accesso_Arg from [dbo].[vwFaturasValidasArg] where Num_Proc = [BDP Ref.]and Cd_Tp_Tx in ('BRO','srv'))
	End
	
	Begin
		Update @TAB
		set
			[NFSSERVIÇOSADD] = (select SUM(Valor_Org) from [dbo].[vwFaturasValidasArg] where Num_Proc = [BDP Ref.] and Numero =[Nota_Fiscal] and Ref_Accesso_Arg =[Ref_Acesso])
	End
	
	Begin
		Update @TAB
		set
			[OBSSERVIÇOS] = (select [dbo].[FRemoveAcentuacao]([dbo].[fBusca_spRPSSTS]([Nota_Fiscal],[Ref_Acesso])))
	End
		
	Begin
		--Update com base na CUSTO_CLIENTE
		Update @TAB
		set
			[INTL FREIGHT+OTHER] = (CASE WHEN Tipo_Frete = 'PREPAID' AND [MOEDAFRETE] <> [MOEDA] THEN 
															[FRETEINTERNACIONAL] / [BRL/USD] ELSE 
												(CASE WHEN Tipo_Frete = 'PREPAID' AND [MOEDAFRETE] = [MOEDA] THEN 
											[Frete_BL] 	ELSE NULL END)END)
	End
	
	--%II - 12 - Verificar a possibilidade de utilizar o alerta da NCM para utilizar a alíquota correta quando tem redução.?
	-- Somente o item com NCM 3206.11.00, tem redução de alíquota, porém esta informação não e trazida para o ATL e nenhum campo,
	--neste caso seria possível condicionar se NCM 3206.11.00, informar na planilha confirmar alíquota utilizado. 
	--É um beneficio e pode ou não ser utilizado
	
	SELECT	
	--Tipo_Frete,[MOEDAFRETE],[MOEDA],[FRETEINTERNACIONAL],[BRL/USD] ,[Frete_BL],[Nota_Fiscal],
	
	[BDP Ref.],[MÊS],[ETIQUETA],[FORNECEDOR],[INVOICE NO],[INVOICE DATE],[MOEDA], [FOB],[INCOTERM],	
	
[INTL FREIGHT+OTHER],
[TOTALFOB] as [INVOICE AMOUNT],
[NÚMERODI],
[DATAREGISTRO],
[ORG],
[PO],
--convert(varchar(25),convert(decimal(10,4),[BRL/USD]))[BRL/USD],
convert(money,[***BRL/USD])[***BRL/USD],
[BRL/EUR],
[MOEDAFOB],
[TOTALFOB],
[MOEDAFRETE],
--[Frete_BL] AS [TOTALFRETE],
convert(money,[Frete_BL])[TOTALFRETE],
[MOEDASEGURO],
sum([TOTALSEGURO]) [TOTALSEGURO],
[MOEDAOUTRASDESPESAS],
sum([OUTRASDESPESAS]) [OUTRASDESPESAS (Acréscimos)],
[TOTALCIFMOEDAORIGEM],
[TOTALCIFBRL],
[ORIGEM/LOCALDEEMBARQUE],
[DATAEMBARQUE],
[DATACHEGADA],
SUM([II]) [II],
(CASE WHEN NCM = '32061100' THEN 'Confirmar Aliquota' else convert(varchar(25),AVG([%II])) end)[%II], 
--[%II],
SUM([IPI])			[IPI],
AVG([%IPI])			[%IPI],
SUM([PIS])			[PIS],
AVG([%PIS])			[%PIS],
SUM([COFINS])		[COFINS],
AVG([%COFINS])		[%COFINS],
SUM([TAXASISCOMEX]) [TAXASISCOMEX],
SUM([AFRMM]) as		[AFRMM/DESPESASADUANEIRAS],
SUM([BASEICMS])		[BASEICMS],
SUM([ICMS])			[ICMS],
AVG([%ICMS])		[%ICMS],
[NFE],
[DATAEMISSÃO],
[ITEM],
[DESCRIÇÃO],
[QUANTIDADE],
[UNID],
'CLIENTE' [ITEM_TYPE],
[VALORTOTALDANFBRL],
'CLIENTE' [CHECKTOTALNF],
[MEIODETRANSPORTE],
[MOEDASEGURO],
''[VALORSEGURO],
--convert(varchar(25),convert(decimal(10,4),[***BRL/USD]))[***BRL/USD],
--convert(varchar(25),[***BRL/USD])[***BRL/USD],
--convert(varchar(25),convert(money,[***BRL/USD]))[***BRL/USD],
convert(money,[***BRL/USD])[***BRL/USD],
'CLIENTE' [VALORSEGUROBRL],
'CLIENTE' [***DIFERENÇASEGURO],
[NOMEDODESPACHANTE],
[II],
[ICMS],
[IPI],
[TAXASISCOMEX],
[PIS],
[COFINS],
[LIBERAÇÃODEBL],
[ARMAZENAGEM],
[AFRMM],
[FRETEINTERNACIONAL],
([FRETEINTERNACIONAL] - [FRETECONSTADI]) as [***DIFERENÇAFRETEINTERNACIONAL],
--[***DIFERENÇAFRETEINTERNACIONAL],
[***THC(CAPATAZIA)/LIBERAÇÃO],
'CLIENTE' [***DIFERENÇALIBERAÇÃO],
''[SDA],
[DESCONSOLIDAÇÃO],
[FRETEINTERNO],
[TXADM+COMISSÃO],
[OUTRAS],
[OBSOUTRAS],
[ICMS] + [LIBERAÇÃODEBL] + [ARMAZENAGEM] + [AFRMM] +[FRETEINTERNACIONAL] +[***THC(CAPATAZIA)/LIBERAÇÃO]  [TOTALDESPACHANTE],
[TOTALADIANTADO],
abs(([ICMS] + [LIBERAÇÃODEBL] + [ARMAZENAGEM] + [AFRMM] +[FRETEINTERNACIONAL] +[***THC(CAPATAZIA)/LIBERAÇÃO])- [TOTALADIANTADO]) [SDPAGAR(+)/SDDEVOLVER(-)],
[LIBERAÇÃODEBL] + [ARMAZENAGEM] + [AFRMM] +[FRETEINTERNACIONAL] +[***THC(CAPATAZIA)/LIBERAÇÃO] [TOTALCUSTODESPACHANTE],
[NFSSERVIÇOSADD],
[OBSSERVIÇOS],
'CLIENTE'[NÚMERORI],
'CLIENTE'[ORG],
'CLIENTE'[DATA],
'CLIENTE'[TOTALKARDEX],
'CLIENTE'[***CUSTOTOTAL],
'CLIENTE'[VALORDOCOMPLEMENTO],
'CLIENTE'[CHECK],
'CLIENTE'[NÚMERORI],
'CLIENTE'[DATA],
'CLIENTE'[VALOR],
'CLIENTE'[RESP.INPUTDADOS],
'CLIENTE'[COMEX],
'CLIENTE'[CONTASAPAGAR],
'CLIENTE'[CONTABILIDADE],
'CLIENTE'[SOL.COMPLEMENTO],
'CLIENTE'[FISCALRI],
'CLIENTE'[COMENTÁRIOS]
 FROM @TAB
 
GROUP BY

	[BDP Ref.],[MÊS],[ETIQUETA],[FORNECEDOR],[INVOICE NO],[INVOICE DATE],[MOEDA], [FOB],[INCOTERM],	
	[Frete_BL],	
[INTL FREIGHT+OTHER],
[TOTALFOB],
[NÚMERODI],
[DATAREGISTRO],
[ORG],
[PO],
[BRL/EUR],
[MOEDAFOB],
[TOTALFOB],
[MOEDAFRETE],
[MOEDASEGURO],
[MOEDAOUTRASDESPESAS],
[TOTALCIFMOEDAORIGEM],
[TOTALCIFBRL],
[ORIGEM/LOCALDEEMBARQUE],
[DATAEMBARQUE],
[DATACHEGADA],
 NCM,
[NFE],
[DATAEMISSÃO],
[ITEM],
[DESCRIÇÃO],
[QUANTIDADE],
[UNID],
[VALORTOTALDANFBRL],
[MEIODETRANSPORTE],
[MOEDASEGURO],
[***BRL/USD],
[VALORSEGUROBRL],
[***DIFERENÇASEGURO],
[NOMEDODESPACHANTE],
[II],
[ICMS],
[IPI],
[TAXASISCOMEX],
[PIS],
[COFINS],
[LIBERAÇÃODEBL],
[ARMAZENAGEM],
[AFRMM],
[FRETEINTERNACIONAL],
[FRETECONSTADI],
[***THC(CAPATAZIA)/LIBERAÇÃO],
[DESCONSOLIDAÇÃO],
[FRETEINTERNO],
[TXADM+COMISSÃO],
[OUTRAS],
[OBSOUTRAS],
[ICMS], [LIBERAÇÃODEBL],[ARMAZENAGEM] ,[AFRMM],[FRETEINTERNACIONAL],[***THC(CAPATAZIA)/LIBERAÇÃO],
[TOTALADIANTADO],
[LIBERAÇÃODEBL],[ARMAZENAGEM], [AFRMM],[FRETEINTERNACIONAL],[***THC(CAPATAZIA)/LIBERAÇÃO],[TOTALADIANTADO], [SDPAGAR(+)/SDDEVOLVER(-)],
[LIBERAÇÃODEBL] ,[ARMAZENAGEM] , [AFRMM],[FRETEINTERNACIONAL],[***THC(CAPATAZIA)/LIBERAÇÃO],
[NFSSERVIÇOSADD],
[OBSSERVIÇOS]


	
	
--[ITEM_TYPE]		varchar(200),--Em branco para uso cliente incluir o titulo na coluna
--[CHECKTOTALNF]	varchar(200),--Em branco para uso cliente incluir o titulo na coluna
--[VALORSEGURO]	varchar(200),--Em branco - Valor da seguradora	
--[SDA]	varchar(200),--Em branco não tem cobrança de SDA
--[NÚMERORI]	varchar(200),--Em branco para uso cliente incluir o titulo na coluna	
--[DATA]	varchar(200),--Em branco para uso cliente incluir o titulo na coluna	
--[TOTALKARDEX]	varchar(200),--Em branco para uso cliente incluir o titulo na coluna
--[***CUSTOTOTAL]	varchar(200),--Em branco para uso cliente incluir o titulo na coluna
--[VALORDOCOMPLEMENTO]	varchar(200),--Em branco para uso cliente incluir o titulo na coluna	
--[CHECK]	varchar(200),--Em branco para uso cliente incluir o titulo na coluna	
--[VALOR]	varchar(200),--Em branco para uso cliente incluir o titulo na coluna	
--[RESP.INPUTDADOS]	varchar(200),--Em branco para uso cliente incluir o titulo na coluna	
--[COMEX]	varchar(200),	--Em branco para uso cliente incluir o titulo na coluna
--[CONTASAPAGAR]	varchar(200),--Em branco para uso cliente incluir o titulo na coluna	
--[CONTABILIDADE]	varchar(200),	--Em branco para uso cliente incluir o titulo na coluna
--[SOL.COMPLEMENTO]	varchar(200),	
--[FISCALRI]	varchar(200),	--Em branco para uso cliente incluir o titulo na coluna
--[COMENTÁRIOS]	varchar(200),		
		
*/
GO
