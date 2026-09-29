SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--SELECT * from [dbo].[DW_CMRCL_INVC]  where n-m_proc = 'IMATL202406058BR'
--Antonio 25-07-2024,26-07-2024 e 29-07-2024, 08-08-2024

CREATE VIEW [dbo].[DW_CMRCL_INVC_PRDCT]
AS
--spProcesso_Sel - pegar todos os processos que encontrar 
--EM  
	SELECT 
		'01BDPBRSAO'																		[BDP_SS_ID]
		,PS.NUM_PROC																		[FRWDR_REF_NBR]
		,ROW_NUMBER() OVER(PARTITION BY PS.NUM_PROC ORDER BY PS.NUM_PROC ASC)		[CMRCL_INVC_PRDCT_SEQ_NBR]
		,ISNULL(DBO.FBUSCA_TIPODOCCLIENTE('N',PS.NUM_PROC,2),'0000000000')				[CMRCL_INVC_REF_NBR]
		,PC.PRODUTO_DESCR																	[FULL_PRDCT_DESC]
		,PC.PRODUTO_DESCR																	[PRDCT_DESC]
		,(CASE 
			WHEN VLR_ITEM > 10000 THEN ((VLR_ITEM/100000) * PS.QTY)
			ELSE VLR_ITEM * PS.QTY
		END)			        															[PRDCT_LN_ITM_AMT]
		,PED.CD_TP_MOEDA																	[PRDCT_LN_ITM_AMT_CURR_CD]
		,PS.QTY																				[PRDCT_LN_ITM_QTY]
		,PD.UOM																			[PRDCT_LN_ITM_QTY_UOM_CD]
		,(CASE 
			WHEN VLR_ITEM > 10000 THEN VLR_ITEM/100000
			ELSE VLR_ITEM
		END)									                                            [PRDCT_UNT_PRC_AMT]
		,PED.CD_TP_MOEDA																	[PRDCT_UNT_PRC_AMT_CURR_CD]		
	FROM PEDIDO_SHIP PS WITH(NOLOCK)
		JOIN PRODUTO_CLIENTE PC WITH(NOLOCK) ON PC.CD_PROD=CD_PRODUTO
		JOIN PEDIDO_DET PD WITH(NOLOCK) ON PS.CD_PEDIDO=PD.CD_PEDIDO AND PS.CD_PRODUTO=PD.CD_PRODUTO AND PS.LOTE = PD.LOTE AND PS.ITEM = PD.ITEM
		JOIN PEDIDO  PED WITH(NOLOCK) ON PED.CD_PEDIDO=PS.CD_PEDIDO
		--LEFT JOIN DE_PARA TIPO WITH(NOLOCK) ON TIPO.CD_ORG=UOM AND TIPO.CD_TIPO=3
	WHERE
		PS.NUM_PROC = 'EMCSR202407008BR'
		--AND CONVERT(DATE,PS.Dt_ins,103) >=GETDATE() - 365


UNION ALL
	SELECT 
		'01BDPBRSAO'																		[BDP_SS_ID]
		,PS.NUM_PROC																		[FRWDR_REF_NBR]
		,ROW_NUMBER() OVER(PARTITION BY PS.NUM_PROC ORDER BY PS.NUM_PROC ASC)		[CMRCL_INVC_PRDCT_SEQ_NBR]
		,ISNULL(DBO.FBUSCA_TIPODOCCLIENTE('N',PS.NUM_PROC,2),'0000000000')				[CMRCL_INVC_REF_NBR]
		,PC.PRODUTO_DESCR																	[FULL_PRDCT_DESC]
		,PC.PRODUTO_DESCR																	[PRDCT_DESC]
		,(CASE 
			WHEN VLR_ITEM > 10000 THEN ((VLR_ITEM/100000) * PS.QTY)
			ELSE VLR_ITEM * PS.QTY
		END)			        															[PRDCT_LN_ITM_AMT]
		,PED.CD_TP_MOEDA																	[PRDCT_LN_ITM_AMT_CURR_CD]
		,PS.QTY																				[PRDCT_LN_ITM_QTY]
		,PD.UOM																			[PRDCT_LN_ITM_QTY_UOM_CD]
		,(CASE 
			WHEN VLR_ITEM > 10000 THEN VLR_ITEM/100000
			ELSE VLR_ITEM
		END)									                                            [PRDCT_UNT_PRC_AMT]
		,PED.CD_TP_MOEDA																	[PRDCT_UNT_PRC_AMT_CURR_CD]		
	FROM PEDIDO_SHIP PS WITH(NOLOCK)
		JOIN PRODUTO_CLIENTE PC WITH(NOLOCK) ON PC.CD_PROD=CD_PRODUTO
		JOIN PEDIDO_DET PD WITH(NOLOCK) ON PS.CD_PEDIDO=PD.CD_PEDIDO AND PS.CD_PRODUTO=PD.CD_PRODUTO AND PS.LOTE = PD.LOTE AND PS.ITEM = PD.ITEM
		JOIN PEDIDO  PED WITH(NOLOCK) ON PED.CD_PEDIDO=PS.CD_PEDIDO
	WHERE
		LEFT(ps.Num_Proc, 5)='IMLYB' 
		AND CONVERT(DATE,PS.Dt_ins,103) >=GETDATE() - 31

--UNION ALL
---- spINT_Invoice quando não tem produto 
--		select 
--			'01BDPBRSAO'										[BDP_SS_ID]
--			,ic.Num_Proc										[FRWDR_REF_NBR]
--			null										       [CMRCL_INVC_PRDCT_SEQ_NBR],
--			'InvoiceC'										   [CMRCL_INVC_REF_NBR],
--			pc.Produto_Descr                                   [FULL_PRDCT_DESC],
--			pc.Produto_Descr                                   [PRDCT_DESC],
--			Case
--					When Upper(id.Tipo_unid)='KG' then ((id.Quantidade) * id.Preco_Unit) 
--					else ((id.Quantidade*Capacidade)*id.Preco_Unit) 
--			End                              					[PRDCT_LN_ITM_AMT],
--			'USD'                                               [PRDCT_LN_ITM_AMT_CURR_CD],
--			Case
--					When Upper(id.Tipo_unid)='KG' then (id.Quantidade) 
--					else (id.Quantidade*id.Capacidade) 
--			End                                                 [PRDCT_LN_ITM_QTY],
--			id.Tipo_Unid                                        [PRDCT_LN_ITM_QTY_UOM_CD],
--			id.Preco_Unit                                       [PRDCT_UNT_PRC_AMT],
--			'USD'                                               [PRDCT_UNT_PRC_AMT_CURR_CD],
				
--			'invoice_cliente'                                   [tabela]  
--	  	From invoice_cliente IC With(Nolock)
--				Join Invoice_Det ID With(Nolock) on ID.id_inv=IC.Id_inv
--				Left Join Tipo_Embalagem TE With(Nolock) on TE.cd_tp_embal=Cd_Embalagem
--				Left Join Produto_Cliente PC With(Nolock) on PC.cd_prod=cd_produto
--				left Join  TErmo_PAgamento TP With(Nolock) on cast(TP.cd_termo as varchar(30))=IC.cd_termo
--		where   cd_proc_cliente is not null
--		and CONVERT(DATE,IC.Data_Invoice,103) >=GETDATE() - 365
--        and id.Quantidade>0 


	


GO
