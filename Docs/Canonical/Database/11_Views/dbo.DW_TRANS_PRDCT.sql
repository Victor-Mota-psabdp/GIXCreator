SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
CREATE VIEW [dbo].[DW_TRANS_PRDCT]
AS

SELECT
	PS.NUM_PROC											FRWDR_REF_NBR
	,PS.Qty												BILLD_QTY_AMT
	,PD.UOM												BILLD_QTY_UNT
	,isnull(replace(num_cont_em,'-','')	,'0000000000')	CNTNR_NBR 
	,PED.Cd_Pais_Org									CNTRY_OF_ORGN_CD 
	,[dbo].[fDW_DEST_INL_CARR_NM](PS.Num_Proc)			DEST_INL_CARR_NM 
	,NULL												DOW_BUS_CD
	,NULL												DOW_BUS_GRP
	,NULL												DOW_BUS_GRP_CD
	,NULL												DOW_BUS_NM
	,NULL												DOW_PERF_CNTR_CD
	,NULL												DOW_PERF_CNTR_NM
	,NULL												DOW_VAL_CTR
	,NULL												ECCN_NBR
	,NULL												GMID_CD
	,NULL												GMID_SHORT_TXT
	,NULL												GOODS_AVLBL_SHP_ACT_DT
	,NULL												GOODS_AVLBL_SHP_ACT_DTM
	,NULL												GOODS_AVLBL_SHP_EST_DT
	,NULL												GOODS_AVLBL_SHP_EST_DTM
	,(Case When PD.peso_uom = 'LM' then
			(CASE WHEN Isnull(PD.peso_bruto_Tot,0) = 0 and PD.peso_item is null then  1 * PD.Qty  * (1000 / 2205)
				ELSE 
				(CASE WHEN Isnull(PD.peso_bruto_Tot,0) = 0 and PD.peso_item is not null then PD.peso_item * PD.Qty  * (1000 / 2205)
				ELSE PD.peso_bruto_Tot * (1000 / 2205)
				END)
			END)	
		When PD.peso_uom = 'LB' then
				(CASE WHEN Isnull(PD.peso_bruto_Tot,0) = 0 and PD.peso_item is null then  1 * PD.Qty / 2205
					ELSE 
					(CASE WHEN Isnull(PD.peso_bruto_Tot,0) = 0 and PD.peso_item is not null then PD.peso_item * PD.Qty / 2205
					ELSE PD.peso_bruto_Tot / 2205
					END)
				END)		
		ELSE		
			(CASE WHEN Isnull(PD.peso_bruto_Tot,0) = 0 and PD.peso_item is null then  1 * PD.Qty 
					ELSE 
					(CASE WHEN Isnull(PD.peso_bruto_Tot,0) = 0 and PD.peso_item is not null then PD.peso_item * PD.Qty 
						ELSE PD.peso_bruto_Tot
					END)
				END)
	END)																[GROSS_PRDCT_KILO_QTY]	

	,(Case When PD.peso_uom = 'LM' then
			(CASE WHEN Isnull(PD.peso_bruto_Tot,0) = 0 and PD.peso_item is null then  1 * PD.Qty  * (1000 / 2205)
				ELSE 
				(CASE WHEN Isnull(PD.peso_bruto_Tot,0) = 0 and PD.peso_item is not null then PD.peso_item * PD.Qty  * (1000 / 2205)
				ELSE PD.peso_bruto_Tot * (1000 / 2205)
				END)
			END)	
		When PD.peso_uom = 'LB' then
				(CASE WHEN Isnull(PD.peso_bruto_Tot,0) = 0 and PD.peso_item is null then  1 * PD.Qty / 2205
					ELSE 
					(CASE WHEN Isnull(PD.peso_bruto_Tot,0) = 0 and PD.peso_item is not null then PD.peso_item * PD.Qty / 2205
					ELSE PD.peso_bruto_Tot / 2205
					END)
				END)		
		ELSE		
			(CASE WHEN Isnull(PD.peso_bruto_Tot,0) = 0 and PD.peso_item is null then  1 * PD.Qty 	* 2.2046
					ELSE 
					(CASE WHEN Isnull(PD.peso_bruto_Tot,0) = 0 and PD.peso_item is not null then PD.peso_item * PD.Qty  	* 2.2046
						ELSE PD.peso_bruto_Tot 	* 2.2046
					END)
				END)
	END)														GROSS_PRDCT_POUND_QTY
	,PP.classCode												HAZMAT_CL_CD
	,PP.hazmat_phone											HAZMAT_CNTCT_NM
	,PP.hazMat_description										HAZMAT_DESC
	,PP.flashpoint												HAZMAT_FLASH_POINT_CD
	,leFT(PP.meAsureCode,1)										HAZMAT_FLASH_POINT_QTY
	,(CAse when PP.classCode is not null then 'Y' else 'N' END)	HAZMAT_IND
	,PP.packingCode												HAZMAT_PCKNG_GROUP_CD
	,PP.unCode													HAZMAT_UN_NBR
		,PP.hazMat_Name_Material								HZRDS_CHEM_NM
	,NULL														IMP_LIC_PERMIT_ISS_DT
	,NULL														L7501_DUTY_PER_PROD_AMT
	,(Case When PD.peso_uom = 'LM' then
			(CASE WHEN Isnull(PD.peso_liquido_Tot,0) = 0 and PD.peso_item is null then  1 * PD.Qty  * (1000 / 2205)
				ELSE 
				(CASE WHEN Isnull(PD.peso_liquido_Tot,0) = 0 and PD.peso_item is not null then PD.peso_item * PD.Qty  * (1000 / 2205)
				ELSE PD.peso_liquido_Tot * (1000 / 2205)
				END)
			END)	
		When PD.peso_uom = 'LB' then
				(CASE WHEN Isnull(PD.peso_liquido_Tot,0) = 0 and PD.peso_item is null then  1 * PD.Qty / 2205
					ELSE 
					(CASE WHEN Isnull(PD.peso_liquido_Tot,0) = 0 and PD.peso_item is not null then PD.peso_item * PD.Qty / 2205
					ELSE PD.peso_liquido_Tot / 2205
					END)
				END)		
		ELSE		
			(CASE WHEN Isnull(PD.peso_liquido_Tot,0) = 0 and PD.peso_item is null then  1 * PD.Qty 
					ELSE 
					(CASE WHEN Isnull(PD.peso_liquido_Tot,0) = 0 and PD.peso_item is not null then PD.peso_item * PD.Qty 
						ELSE PD.peso_liquido_Tot
					END)
				END)
	END)														NET_PRDCT_KILO_QTY
		,(Case When PD.peso_uom = 'LM' then
			(CASE WHEN Isnull(PD.peso_liquido_Tot,0) = 0 and PD.peso_item is null then  1 * PD.Qty  * (1000 / 2205)
				ELSE 
				(CASE WHEN Isnull(PD.peso_liquido_Tot,0) = 0 and PD.peso_item is not null then PD.peso_item * PD.Qty  * (1000 / 2205)
				ELSE PD.peso_liquido_Tot * (1000 / 2205)
				END)
			END)	
		When PD.peso_uom = 'LB' then
				(CASE WHEN Isnull(PD.peso_liquido_Tot,0) = 0 and PD.peso_item is null then  1 * PD.Qty / 2205
					ELSE 
					(CASE WHEN Isnull(PD.peso_liquido_Tot,0) = 0 and PD.peso_item is not null then PD.peso_item * PD.Qty / 2205
					ELSE PD.peso_liquido_Tot / 2205
					END)
				END)		
		ELSE		
			(CASE WHEN Isnull(PD.peso_liquido_Tot,0) = 0 and PD.peso_item is null then  1 * PD.Qty * 2.2046
					ELSE 
					(CASE WHEN Isnull(PD.peso_liquido_Tot,0) = 0 and PD.peso_item is not null then PD.peso_item * PD.Qty * 2.2046
						ELSE PD.peso_liquido_Tot * 2.2046
					END)
				END)
	END)														NET_PRDCT_POUND_QTY
	, [dbo].[fDW_OGA](PS.Num_Proc,'OGA')						OGA_CD
	, [dbo].[fDW_OGA](PS.Num_Proc,'OGA')						OGA_DESC
	, [dbo].[fDW_OGA](PS.Num_Proc,'Data_Release_OGA')			OGA_RLS_DT
	, [dbo].[fDW_OGA](PS.Num_Proc,'Data_Submit_OGA')			OGA_SBMT_DT
	,'D'														ORGN_DOM_FRGN_CD
	,FORMAT(TP10.Dt_Conclusao, 'dd/MM/yy')						ORGN_OF_GOODS_DPRTR_ACT_DT
	,FORMAT(TP10.Dt_Previsao, 'dd/MM/yy')						ORGN_OF_GOODS_DPRTR_EST_DT
	,isnull(TIPO.cd_dst,PD.UOM)									PCKG_CD
	,replace(ltrim(rtrim(Produto_descr )),char(160),'')			PRDCT_BRND_NM
	,HOU.Vol_Tot												PRDCT_CBM_QTY
	,replace(PC.cd_proc_cliente,'&','')							PRDCT_CD
	,NULL														PRDCT_CFT_QTY
	,PD.NCM														PRDCT_CL_NBR
	,NULL														PRDCT_CLASS_FEE_AMT
	,ROW_NUMBER() OVER(PARTITION BY PS.Num_PROC ORDER BY PS.Item ASC) PRDCT_LINE_ITEM_NBR
	,(Case When PD.Vlr_Item > 10000 then PD.Vlr_Item/100000 * PD.Qty
		else PD.Vlr_Item	* PD.Qty End)						PRDCT_LN_AMT
	,PED.cd_tp_moeda											PRDCT_LN_CURR_CD
	,PS.Qty														PRDCT_PCKG_CT
	,isnull(Tipo.Descr_org,PD.UOM)								PRDCT_PCKG_DESC
	,NULL														PRDCT_PLLT_SKID_CT
	,PED.Num_PO													PRDCT_PO_NBR
	,NCM.NCM													PRDCT_TRFF_CL_CD
	,left([dbo].[FRemoveAcentuacao](NCM.Descricao_NCM),256) 	PRDCT_TRFF_DESC
	,(Case When PD.Vlr_Item > 10000 then PD.Vlr_Item/100000 
		else PD.Vlr_Item	End)								PRICE_AMT
	,NULL														PRICE_AMT_UNT
	,PD.Vlr_Item * PD.Qty 										REPRT_VAL_AMT
	,DPP.Value_center_code										SBU
	,PS.Qty														SED_1_QTY
	,isnull(TIPO.cd_dst,PD.UOM)									SED_1_QTY_UOM_CD
	,PS.Qty														SED_2_QTY
	,isnull(TIPO.cd_dst,PD.UOM)									SED_2_QTY_UOM_CD
	,NULL														VAL_CTR_CD
FROM PEDIDO_SHIP					PS WITH(NOLOCK)	
	JOIN PEDIDO_DET					PD WITH(NOLOCK)		ON PS.CD_PRODUTO=PD.CD_PRODUTO AND PS.CD_PEDIDO=PD.CD_PEDIDO
	JOIN PEDIDO						PED WITH(NOLOCK)	ON PED.CD_PEDIDO=PS.CD_PEDIDO
	JOIN PRODUTO_CLIENTE			PC WITH(NOLOCK)		ON PC.CD_PROD=PS.CD_PRODUTO and PC.cd_Cliente = PED.Cd_Grupo
	LEFT JOIN Produto_Perigoso		PP WITH(NOLOCK)		ON PC.CD_PROD=PP.cd_prod and PP.Uncode <> 'NH'
	LEFT JOIN de_para_produto		DPP WITH(NOLOCK)	ON DPP.gmid=PC.cd_proc_cliente
	LEFT JOIN DE_PARA				TIPO WITH(NOLOCK)	ON TIPO.CD_ORG=UOM AND TIPO.CD_TIPO=3
	LEFT JOIN TERMO_PAGAMENTO		TP WITH(NOLOCK)		ON CAST(TP.CD_TERMO AS VARCHAR(30))=PAYMENT
	LEFT JOIN TIPO_EMBALAGEM		TE WITH(NOLOCK)		ON TE.CD_TP_EMBAL=PD.CD_TP_EMBAL
	--LEFT JOIN PEDIDO_SHIP_CONTAINER PSC WITH(NOLOCK) ON PS.CD_PRODUTO=PSC.CD_PRODUTO AND PS.CD_PEDIDO=PSC.CD_PEDIDO AND PS.LOTE =PSC.LOTE  
	LEFT JOIN CONTAINER_HOU_EXP_MAR CH WITH(NOLOCK) ON CH.NUM_PROC_HEM=PS.NUM_PROC
	LEFT JOIN CONTAINER_MAS_EXP_MAR CM WITH(NOLOCK) ON CM.NUM_PROC_MEM=CH.NUM_PROC_MEM AND CM.ITEM_CONT_EM=CH.ITEM_CONT_EM --AND REPLACE(CM.NUM_CONT_EM,'-','')=REPLACE(PSC.NUM_CONT,'-','') 
	--LEFT JOIN TIPO_CONTAINER		TPC WITH(NOLOCK) ON TPC.CD_TP_CONT=CM.CD_TP_CONT
	LEFT JOIN TAREFAS_PROCESSOS		TP10	WITH (NOLOCK) ON TP10.NUM_PROC	=	PS.NUM_PROC AND TP10.ID_TASK = 10
	LEFT JOIN vwHouse_Exp			HOU		WITH(NOLOCK) ON HOU.NUM_PROC=PS.NUM_PROC

	LEFT JOIN PROC_NCM				PNCM	with(nolock)ON PNCM.NUM_PROC=PS.NUM_PROC
	LEFT Join						NCM		with(nolock) on NCM.id_NCM=PNCM.id_ncm
WHERE
	PS.NUM_PROC = 'EMOXT202408164BR'
	--PS.DT_INS > Getdate() -31

UNION 

SELECT 
	PS.NUM_PROC												FRWDR_REF_NBR
	,PS.Qty													BILLD_QTY_AMT
	,PD.UOM													BILLD_QTY_UNT
	,isnull(replace(CM.Num_Cont_IM,'-',''),'0000000000')	CNTNR_NBR --spSmartProdutoContainerLote_INT
	,PED.Cd_Pais_Org										CNTRY_OF_ORGN_CD
	,[dbo].[fDW_DEST_INL_CARR_NM](PS.Num_Proc)				DEST_INL_CARR_NM
	,NULL													DOW_BUS_CD
	,NULL													DOW_BUS_GRP
	,NULL													DOW_BUS_GRP_CD
	,NULL													DOW_BUS_NM
	,NULL													DOW_PERF_CNTR_CD
	,NULL													DOW_PERF_CNTR_NM
	,NULL													DOW_VAL_CTR
	,NULL													ECCN_NBR
	,NULL													GMID_CD
	,NULL													GMID_SHORT_TXT
	,NULL													GOODS_AVLBL_SHP_ACT_DT
	,NULL													GOODS_AVLBL_SHP_ACT_DTM
	,NULL													GOODS_AVLBL_SHP_EST_DT
	,NULL													GOODS_AVLBL_SHP_EST_DTM
	, 
	(Case When PD.peso_uom = 'LM' then
			(CASE WHEN Isnull(PD.peso_bruto_Tot,0) = 0 and PD.peso_item is null then  1 * PD.Qty  * (1000 / 2205)
				ELSE 
				(CASE WHEN Isnull(PD.peso_bruto_Tot,0) = 0 and PD.peso_item is not null then PD.peso_item * PD.Qty  * (1000 / 2205)
				ELSE PD.peso_bruto_Tot * (1000 / 2205)
				END)
			END)	
		When PD.peso_uom = 'LB' then
				(CASE WHEN Isnull(PD.peso_bruto_Tot,0) = 0 and PD.peso_item is null then  1 * PD.Qty / 2205
					ELSE 
					(CASE WHEN Isnull(PD.peso_bruto_Tot,0) = 0 and PD.peso_item is not null then PD.peso_item * PD.Qty / 2205
					ELSE PD.peso_bruto_Tot / 2205
					END)
				END)		
		ELSE		
			(CASE WHEN Isnull(PD.peso_bruto_Tot,0) = 0 and PD.peso_item is null then  1 * PD.Qty 
					ELSE 
					(CASE WHEN Isnull(PD.peso_bruto_Tot,0) = 0 and PD.peso_item is not null then PD.peso_item * PD.Qty 
						ELSE PD.peso_bruto_Tot
					END)
				END)
	END)														GROSS_PRDCT_KILO_QTY	
	,(Case When PD.peso_uom = 'LM' then
			(CASE WHEN Isnull(PD.peso_bruto_Tot,0) = 0 and PD.peso_item is null then  1 * PD.Qty  * (1000 / 2205)
				ELSE 
				(CASE WHEN Isnull(PD.peso_bruto_Tot,0) = 0 and PD.peso_item is not null then PD.peso_item * PD.Qty  * (1000 / 2205)
				ELSE PD.peso_bruto_Tot * (1000 / 2205)
				END)
			END)	
		When PD.peso_uom = 'LB' then
				(CASE WHEN Isnull(PD.peso_bruto_Tot,0) = 0 and PD.peso_item is null then  1 * PD.Qty / 2205
					ELSE 
					(CASE WHEN Isnull(PD.peso_bruto_Tot,0) = 0 and PD.peso_item is not null then PD.peso_item * PD.Qty / 2205
					ELSE PD.peso_bruto_Tot / 2205
					END)
				END)		
		ELSE		
			(CASE WHEN Isnull(PD.peso_bruto_Tot,0) = 0 and PD.peso_item is null then  1 * PD.Qty 	* 2.2046
					ELSE 
					(CASE WHEN Isnull(PD.peso_bruto_Tot,0) = 0 and PD.peso_item is not null then PD.peso_item * PD.Qty  	* 2.2046
						ELSE PD.peso_bruto_Tot 	* 2.2046
					END)
				END)
	END)														GROSS_PRDCT_POUND_QTY
	,PP.classCode												HAZMAT_CL_CD
	,PP.hazmat_phone											HAZMAT_CNTCT_NM
	,PP.hazMat_description										HAZMAT_DESC
	,PP.flashpoint												HAZMAT_FLASH_POINT_CD
	,leFT(PP.meAsureCode,1)										HAZMAT_FLASH_POINT_QTY
	,(CAse when PP.classCode is not null then 'Y' else 'N' END)	HAZMAT_IND
	,PP.packingCode												HAZMAT_PCKNG_GROUP_CD
	,PP.unCode													HAZMAT_UN_NBR
	,PP.hazMat_Name_Material									HZRDS_CHEM_NM
	,NULL														IMP_LIC_PERMIT_ISS_DT
	,NULL														L7501_DUTY_PER_PROD_AMT
	,(Case When PD.peso_uom = 'LM' then
			(CASE WHEN Isnull(PD.peso_liquido_Tot,0) = 0 and PD.peso_item is null then  1 * PD.Qty  * (1000 / 2205)
				ELSE 
				(CASE WHEN Isnull(PD.peso_liquido_Tot,0) = 0 and PD.peso_item is not null then PD.peso_item * PD.Qty  * (1000 / 2205)
				ELSE PD.peso_liquido_Tot * (1000 / 2205)
				END)
			END)	
		When PD.peso_uom = 'LB' then
				(CASE WHEN Isnull(PD.peso_liquido_Tot,0) = 0 and PD.peso_item is null then  1 * PD.Qty / 2205
					ELSE 
					(CASE WHEN Isnull(PD.peso_liquido_Tot,0) = 0 and PD.peso_item is not null then PD.peso_item * PD.Qty / 2205
					ELSE PD.peso_liquido_Tot / 2205
					END)
				END)		
		ELSE		
			(CASE WHEN Isnull(PD.peso_liquido_Tot,0) = 0 and PD.peso_item is null then  1 * PD.Qty 
					ELSE 
					(CASE WHEN Isnull(PD.peso_liquido_Tot,0) = 0 and PD.peso_item is not null then PD.peso_item * PD.Qty 
						ELSE PD.peso_liquido_Tot
					END)
				END)
	END)														NET_PRDCT_KILO_QTY--


	,(Case When PD.peso_uom = 'LM' then
			(CASE WHEN Isnull(PD.peso_liquido_Tot,0) = 0 and PD.peso_item is null then  1 * PD.Qty  * (1000 / 2205)
				ELSE 
				(CASE WHEN Isnull(PD.peso_liquido_Tot,0) = 0 and PD.peso_item is not null then PD.peso_item * PD.Qty  * (1000 / 2205)
				ELSE PD.peso_liquido_Tot * (1000 / 2205)
				END)
			END)	
		When PD.peso_uom = 'LB' then
				(CASE WHEN Isnull(PD.peso_liquido_Tot,0) = 0 and PD.peso_item is null then  1 * PD.Qty / 2205
					ELSE 
					(CASE WHEN Isnull(PD.peso_liquido_Tot,0) = 0 and PD.peso_item is not null then PD.peso_item * PD.Qty / 2205
					ELSE PD.peso_liquido_Tot / 2205
					END)
				END)		
		ELSE		
			(CASE WHEN Isnull(PD.peso_liquido_Tot,0) = 0 and PD.peso_item is null then  1 * PD.Qty * 2.2046
					ELSE 
					(CASE WHEN Isnull(PD.peso_liquido_Tot,0) = 0 and PD.peso_item is not null then PD.peso_item * PD.Qty * 2.2046
						ELSE PD.peso_liquido_Tot * 2.2046
					END)
				END)
	END)														NET_PRDCT_POUND_QTY
	,[dbo].[fDW_OGA](PS.Num_Proc,'OGA')							OGA_CD
	,[dbo].[fDW_OGA](PS.Num_Proc,'OGA')							OGA_DESC
	,[dbo].[fDW_OGA](PS.Num_Proc,'Data_Release_OGA')			OGA_RLS_DT
	,[dbo].[fDW_OGA](PS.Num_Proc,'Data_Submit_OGA')				OGA_SBMT_DT
	,'D'														ORGN_DOM_FRGN_CD
	,FORMAT(TP10.Dt_Conclusao, 'dd/MM/yy')						ORGN_OF_GOODS_DPRTR_ACT_DT
	,FORMAT(TP10.Dt_Previsao, 'dd/MM/yy')						ORGN_OF_GOODS_DPRTR_EST_DT
	,isnull(TIPO.cd_dst,PD.UOM)									PCKG_CD
	,replace(ltrim(rtrim(PC.Produto_descr )),char(160),'')		PRDCT_BRND_NM
	,HOU.Vol_Tot												PRDCT_CBM_QTY
	,replace(PC.cd_proc_cliente,'&','')							PRDCT_CD
	,NULL														PRDCT_CFT_QTY
	--,NULL														PRDCT_CL_NBR
	,PD.NCM														PRDCT_CL_NBR--NCM do JOB
	,NULL														PRDCT_CLASS_FEE_AMT
	,ROW_NUMBER() OVER(PARTITION BY PS.Num_PROC ORDER BY PS.Item ASC) PRDCT_LINE_ITEM_NBR
	,(Case When PD.Vlr_Item > 10000 then PD.Vlr_Item/100000 * PD.Qty
		else PD.Vlr_Item * PD.Qty End)							PRDCT_LN_AMT
	,PED.cd_tp_moeda											PRDCT_LN_CURR_CD
	,PS.Qty														PRDCT_PCKG_CT
	,isnull(Tipo.Descr_org,PD.UOM)								PRDCT_PCKG_DESC
	,NULL														PRDCT_PLLT_SKID_CT
	,PED.Num_PO													PRDCT_PO_NBR
	,NCM.NCM													PRDCT_TRFF_CL_CD
	,left([dbo].[FRemoveAcentuacao](NCM.Descricao_NCM),256) 	PRDCT_TRFF_DESC
	,(Case When PD.Vlr_Item > 10000 then PD.Vlr_Item/100000 
		else PD.Vlr_Item	End)								PRICE_AMT
	,NULL														PRICE_AMT_UNT
	,PD.Vlr_Item * PD.Qty 										REPRT_VAL_AMT
	,DPP.Value_center_code										SBU
	,PS.Qty														SED_1_QTY
	,isnull(TIPO.cd_dst,PD.UOM)									SED_1_QTY_UOM_CD
	,PS.Qty														SED_2_QTY
	,isnull(TIPO.cd_dst,PD.UOM)									SED_2_QTY_UOM_CD
	,NULL														VAL_CTR_CD	
FROM PEDIDO_SHIP PS WITH(NOLOCK)	
	JOIN PEDIDO_DET					PD WITH(NOLOCK)		ON PS.CD_PRODUTO=PD.CD_PRODUTO AND PS.CD_PEDIDO=PD.CD_PEDIDO
	JOIN PEDIDO						PED WITH(NOLOCK)	ON PED.CD_PEDIDO=PS.CD_PEDIDO
	JOIN PRODUTO_CLIENTE			PC WITH(NOLOCK)		ON PC.CD_PROD=PS.CD_PRODUTO and PC.cd_Cliente = PED.Cd_Grupo
	LEFT JOIN Produto_Perigoso		PP WITH(NOLOCK)		ON PC.CD_PROD=PP.cd_prod and PP.Uncode <> 'NH'
	LEFT JOIN de_para_produto		DPP WITH(NOLOCK)	ON DPP.gmid=PC.cd_proc_cliente
	LEFT JOIN DE_PARA				TIPO WITH(NOLOCK)	ON TIPO.CD_ORG=UOM AND TIPO.CD_TIPO=3
	LEFT JOIN TERMO_PAGAMENTO		TP WITH(NOLOCK)		ON CAST(TP.CD_TERMO AS VARCHAR(30))=PAYMENT
	LEFT JOIN TIPO_EMBALAGEM		TE	WITH(NOLOCK)	ON TE.CD_TP_EMBAL=PD.CD_TP_EMBAL

	--LEFT JOIN PEDIDO_SHIP_CONTAINER PSC WITH(NOLOCK)	ON PS.CD_PRODUTO=PSC.CD_PRODUTO AND PS.CD_PEDIDO=PSC.CD_PEDIDO AND PS.LOTE =PSC.LOTE  
	LEFT JOIN CONTAINER_HOU_IMP_MAR CH WITH(NOLOCK)		ON CH.NUM_PROC_HIM=PS.NUM_PROC
	LEFT JOIN CONTAINER_MAS_IMP_MAR CM WITH(NOLOCK)		ON CM.NUM_PROC_MIM=CH.NUM_PROC_MIM AND CM.ITEM_CONT_IM=CH.ITEM_CONT_IM --AND REPLACE(CM.NUM_CONT_IM,'-','')=REPLACE(PS.NUM_CONT,'-','') 
	--LEFT JOIN TIPO_CONTAINER		TPC WITH(NOLOCK)	ON TPC.CD_TP_CONT=CM.CD_TP_CONT

	LEFT JOIN TAREFAS_PROCESSOS		TP10	WITH (NOLOCK) ON TP10.NUM_PROC	=	PS.NUM_PROC AND TP10.ID_TASK = 10
	LEFT JOIN vwHouse_Imp			HOU		WITH(NOLOCK) ON HOU.NUM_PROC=PS.NUM_PROC
	LEFT JOIN PROC_NCM				PNCM	with(nolock)ON PNCM.NUM_PROC=PS.NUM_PROC
	LEFT Join						NCM		with(nolock) on NCM.id_NCM=PNCM.id_ncm
WHERE
	PS.NUM_PROC in ('IMLVS202408028BR','IMCTV202408041BR')
	--PS.DT_INS > Getdate() -31

GO
