SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[DW_CMRCL_INVC]
as



	Select
		HOU.Num_Proc_HEM																		FRWDR_REF_NBR
		,FORMAT([dbo].[fBusca_DATA_PO_Modal](HOU.Num_Proc_HEM,1), 'dd/MM/yy')					CMRCL_INVC_DT
		,isnull(dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc_HEM,2),'0000000000')					CMRCL_INVC_REF_NBR -- <Request><Header><CommercialInvoice><InvoiceNumber></InvoiceNumber></CommercialInvoice></Header></Request>
		,isnull(dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc_HEM,2),'0000000000')					CMRCL_INVC_REF_NBR_CONCAT
		,ROW_NUMBER() OVER(PARTITION BY HOU.Num_Proc_HEM ORDER BY HOU.Num_Proc_HEM ASC)			CMRCL_INVC_SEQ_ID 
		,(CASE WHEN [dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HEM) > 0 
				THEN
					[dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HEM)				
				ELSE 
					LLP.Vlr_Invoice - isnull(HOU.vlr_frete_tot_hem,0) END)						CMRCL_INVC_TTL_AMT -- <Request><Header><CommercialInvoice><InvoiceAmount></InvoiceAmount></CommercialInvoice></Header></Request>
		,HOU.CD_TP_MOEDA																		CMRCL_INVC_TTL_AMT_CURR_CD -- <Request><Header><CommercialInvoice><CurrencyCode></CurrencyCode></CommercialInvoice></Header></Request>
		,HOU.Cd_Tp_Oper																			FINAL_SALE_TERM_CD -- <Request><Header><CommercialInvoice><FinalTermsofSaleDesc></FinalTermsofSaleDesc></CommercialInvoice></Header></Request>
		,HOU.Cd_Tp_Oper																			FINAL_SALE_TERM_DESC -- <Request><Header><CommercialInvoice><FinalTermsofSaleDesc></FinalTermsofSaleDesc></CommercialInvoice></Header></Request>
		,(CASE WHEN [dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HEM) > 0 
				THEN 
					(Case when [dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HEM) < isnull(HOU.vlr_frete_tot_hem,0) 
						THEN 
							[dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HEM)
						ELSE
							[dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HEM) - isnull(HOU.vlr_frete_tot_hem,0)
					END)
				ELSE 
					LLP.Vlr_Invoice - isnull(HOU.vlr_frete_tot_hem,0) END)							FOB_AMT -- <Request><Header><CommercialInvoice><FOBAmount></FOBAmount></CommercialInvoice></Header></Request>
		,HOU.CD_TP_MOEDA																		FOB_AMT_CURR_CD -- <Request><Header><CommercialInvoice><FOBCurrency></FOBCurrency></CommercialInvoice></Header></Request>
		,UPPER([dbo].[fDW_PYMNT_TERM_CD](HOU.Num_Proc_HEM,'Code'))								PYMNT_TERM_CD -- <Request><Header><CommercialInvoice><TermsofPaymentCode></TermsofPaymentCode></CommercialInvoice></Header></Request>
		,UPPER([dbo].[fDW_PYMNT_TERM_CD](HOU.Num_Proc_HEM,'Desc'))								PYMNT_TERM_DESC -- NOT SEND <Request><Header><CommercialInvoice><TermsofPaymentDescription></TermsofPaymentDescription></CommercialInvoice></Header></Request>
		,HOU.CD_TP_MOEDA																		SALE_TERM_AMT_CURR_CD -- <Request><Header><CommercialInvoice><CurrencyCode></CurrencyCode></CommercialInvoice></Header></Request>
		,HOU.Cd_Tp_Oper																			SALE_TERM_CD -- <Request><Header><CommercialInvoice><TermsofSaleCode></TermsofSaleCode></CommercialInvoice></Header></Request>
		,HOU.Cd_Tp_Oper																			SALE_TERM_DESC -- <Request><Header><CommercialInvoice><TermsofSaleDesc></TermsofSaleDesc></CommercialInvoice></Header></Request>
		,'01BDPBRSAO' 																			[BDP_SS_ID]
	FROM House_Exp_Mar		HOU WITH(NOLOCK)
		JOIN LLP_EXP_MAR	LLP	WITH (NOLOCK) ON LLP.NUM_PROC_LEM =	HOU.Num_Proc_HEM
	Where
		--HOU.Num_Proc_HEM = 'IMSOL202407018BR'
		convert(datetime,HOU.Dt_Emis_HEM,105) > getdate() -31


UNION ALL

	Select
		HOU.Num_Proc_HEA																		FRWDR_REF_NBR
		,FORMAT([dbo].[fBusca_DATA_PO_Modal](HOU.Num_Proc_HEA,1), 'dd/MM/yy')					CMRCL_INVC_DT
		,isnull(dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc_HEA,2),'0000000000')					CMRCL_INVC_REF_NBR -- <Request><Header><CommercialInvoice><InvoiceNumber></InvoiceNumber></CommercialInvoice></Header></Request>
		,isnull(dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc_HEA,2),'0000000000')					CMRCL_INVC_REF_NBR_CONCAT
		,ROW_NUMBER() OVER(PARTITION BY HOU.Num_Proc_HEA ORDER BY HOU.Num_Proc_HEA ASC)			CMRCL_INVC_SEQ_ID 
		,(CASE WHEN [dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HEA) > 0 
				THEN
					[dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HEA)				
				ELSE 
					LLP.Vlr_Invoice - isnull(HOU.vlr_frete_tot_hea,0) END)						CMRCL_INVC_TTL_AMT -- <Request><Header><CommercialInvoice><InvoiceAmount></InvoiceAmount></CommercialInvoice></Header></Request>
		,HOU.CD_TP_MOEDA																		CMRCL_INVC_TTL_AMT_CURR_CD -- <Request><Header><CommercialInvoice><CurrencyCode></CurrencyCode></CommercialInvoice></Header></Request>
		,HOU.Cd_Tp_Oper																			FINAL_SALE_TERM_CD -- <Request><Header><CommercialInvoice><FinalTermsofSaleDesc></FinalTermsofSaleDesc></CommercialInvoice></Header></Request>
		,HOU.Cd_Tp_Oper																			FINAL_SALE_TERM_DESC -- <Request><Header><CommercialInvoice><FinalTermsofSaleDesc></FinalTermsofSaleDesc></CommercialInvoice></Header></Request>
		,(CASE WHEN [dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HEA) > 0 
				THEN 
					(Case when [dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HEA) < isnull(HOU.vlr_frete_tot_hea,0) 
						THEN 
							[dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HEA)
						ELSE
							[dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HEA) - isnull(HOU.vlr_frete_tot_hea,0)
					END)
				ELSE 
					LLP.Vlr_Invoice - isnull(HOU.vlr_frete_tot_hea,0) END)							FOB_AMT -- <Request><Header><CommercialInvoice><FOBAmount></FOBAmount></CommercialInvoice></Header></Request>
		,HOU.CD_TP_MOEDA																		FOB_AMT_CURR_CD -- <Request><Header><CommercialInvoice><FOBCurrency></FOBCurrency></CommercialInvoice></Header></Request>
		,UPPER([dbo].[fDW_PYMNT_TERM_CD](HOU.Num_Proc_HEA,'Code'))								PYMNT_TERM_CD -- <Request><Header><CommercialInvoice><TermsofPaymentCode></TermsofPaymentCode></CommercialInvoice></Header></Request>
		,UPPER([dbo].[fDW_PYMNT_TERM_CD](HOU.Num_Proc_HEA,'Desc'))								PYMNT_TERM_DESC -- NOT SEND <Request><Header><CommercialInvoice><TermsofPaymentDescription></TermsofPaymentDescription></CommercialInvoice></Header></Request>
		,HOU.CD_TP_MOEDA																		SALE_TERM_AMT_CURR_CD -- <Request><Header><CommercialInvoice><CurrencyCode></CurrencyCode></CommercialInvoice></Header></Request>
		,HOU.Cd_Tp_Oper																			SALE_TERM_CD -- <Request><Header><CommercialInvoice><TermsofSaleCode></TermsofSaleCode></CommercialInvoice></Header></Request>
		,HOU.Cd_Tp_Oper																			SALE_TERM_DESC -- <Request><Header><CommercialInvoice><TermsofSaleDesc></TermsofSaleDesc></CommercialInvoice></Header></Request>
		,'01BDPBRSAO' 																			[BDP_SS_ID]
	FROM House_EXp_Aer		HOU WITH(NOLOCK)
		JOIN LLP_EXP_Aer	LLP	WITH (NOLOCK) ON LLP.NUM_PROC_LEA =	HOU.Num_Proc_HEA
	Where
		--HOU.Num_Proc_HEA = 'IMSOL202407018BR'
		convert(datetime,HOU.Dt_Emis_HEA,105) > getdate() -31

UNION ALL

	Select
		HOU.Num_Proc_HEO																		FRWDR_REF_NBR
		,FORMAT([dbo].[fBusca_DATA_PO_Modal](HOU.Num_Proc_HEO,1), 'dd/MM/yy')		CMRCL_INVC_DT
		,isnull(dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc_HEO,2),'0000000000')					CMRCL_INVC_REF_NBR -- <Request><Header><CommercialInvoice><InvoiceNumber></InvoiceNumber></CommercialInvoice></Header></Request>
		,isnull(dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc_HEO,2),'0000000000')					CMRCL_INVC_REF_NBR_CONCAT
		,ROW_NUMBER() OVER(PARTITION BY HOU.Num_Proc_HEO ORDER BY HOU.Num_Proc_HEO ASC)			CMRCL_INVC_SEQ_ID 
		,(CASE WHEN [dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HEO) > 0 
				THEN
					[dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HEO)				
				ELSE 
					LLP.Vlr_Invoice - isnull(HOU.vlr_frete_efet_HEO,0) END)						CMRCL_INVC_TTL_AMT -- <Request><Header><CommercialInvoice><InvoiceAmount></InvoiceAmount></CommercialInvoice></Header></Request>
		,HOU.CD_TP_MOEDA																		CMRCL_INVC_TTL_AMT_CURR_CD -- <Request><Header><CommercialInvoice><CurrencyCode></CurrencyCode></CommercialInvoice></Header></Request>
		,HOU.Cd_Tp_Oper																			FINAL_SALE_TERM_CD -- <Request><Header><CommercialInvoice><FinalTermsofSaleDesc></FinalTermsofSaleDesc></CommercialInvoice></Header></Request>
		,HOU.Cd_Tp_Oper																			FINAL_SALE_TERM_DESC -- <Request><Header><CommercialInvoice><FinalTermsofSaleDesc></FinalTermsofSaleDesc></CommercialInvoice></Header></Request>
		,(CASE WHEN [dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HEO) > 0 
				THEN 
					(Case when [dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HEO) < isnull(HOU.vlr_frete_efet_HEO,0) 
						THEN 
							[dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HEO)
						ELSE
							[dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HEO) - isnull(HOU.vlr_frete_efet_HEO,0)
					END)
				ELSE 
					LLP.Vlr_Invoice - isnull(HOU.vlr_frete_efet_HEO,0) END)							FOB_AMT -- <Request><Header><CommercialInvoice><FOBAmount></FOBAmount></CommercialInvoice></Header></Request>
		,HOU.CD_TP_MOEDA																		FOB_AMT_CURR_CD -- <Request><Header><CommercialInvoice><FOBCurrency></FOBCurrency></CommercialInvoice></Header></Request>
		,UPPER([dbo].[fDW_PYMNT_TERM_CD](HOU.Num_Proc_HEO,'Code'))								PYMNT_TERM_CD -- <Request><Header><CommercialInvoice><TermsofPaymentCode></TermsofPaymentCode></CommercialInvoice></Header></Request>
		,UPPER([dbo].[fDW_PYMNT_TERM_CD](HOU.Num_Proc_HEO,'Desc'))								PYMNT_TERM_DESC -- NOT SEND <Request><Header><CommercialInvoice><TermsofPaymentDescription></TermsofPaymentDescription></CommercialInvoice></Header></Request>
		,HOU.CD_TP_MOEDA																		SALE_TERM_AMT_CURR_CD -- <Request><Header><CommercialInvoice><CurrencyCode></CurrencyCode></CommercialInvoice></Header></Request>
		,HOU.Cd_Tp_Oper																			SALE_TERM_CD -- <Request><Header><CommercialInvoice><TermsofSaleCode></TermsofSaleCode></CommercialInvoice></Header></Request>
		,HOU.Cd_Tp_Oper																			SALE_TERM_DESC -- <Request><Header><CommercialInvoice><TermsofSaleDesc></TermsofSaleDesc></CommercialInvoice></Header></Request>
		,'01BDPBRSAO' 																			[BDP_SS_ID]
	FROM House_EXp_Out		HOU WITH(NOLOCK)
		JOIN LLP_EXP_Out	LLP	WITH (NOLOCK) ON LLP.NUM_PROC_LEO =	HOU.Num_Proc_HEO
	Where
		--HOU.Num_Proc_HIA = 'IMSOL202407018BR'
		convert(datetime,HOU.Dt_Emis_HEO,105) > getdate() -31

UNION ALL

	Select
		HOU.Num_Proc_HIM																		FRWDR_REF_NBR
		,FORMAT([dbo].[fBusca_DATA_PO_Modal](HOU.Num_Proc_HIM,1), 'dd/MM/yy')		CMRCL_INVC_DT
		,isnull(dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc_HIM,2),'0000000000')					CMRCL_INVC_REF_NBR -- <Request><Header><CommercialInvoice><InvoiceNumber></InvoiceNumber></CommercialInvoice></Header></Request>
		,isnull(dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc_HIM,2),'0000000000')					CMRCL_INVC_REF_NBR_CONCAT
		,ROW_NUMBER() OVER(PARTITION BY HOU.Num_Proc_HIM ORDER BY HOU.Num_Proc_HIM ASC)			CMRCL_INVC_SEQ_ID 
		,(CASE WHEN [dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HIM) > 0 
				THEN
					[dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HIM)				
				ELSE 
					LLP.Vlr_Invoice - isnull(HOU.Vlr_Frete_Efet_HIM,0) END)						CMRCL_INVC_TTL_AMT -- <Request><Header><CommercialInvoice><InvoiceAmount></InvoiceAmount></CommercialInvoice></Header></Request>
		,HOU.CD_TP_MOEDA																		CMRCL_INVC_TTL_AMT_CURR_CD -- <Request><Header><CommercialInvoice><CurrencyCode></CurrencyCode></CommercialInvoice></Header></Request>
		,HOU.Cd_Tp_Oper																			FINAL_SALE_TERM_CD -- <Request><Header><CommercialInvoice><FinalTermsofSaleDesc></FinalTermsofSaleDesc></CommercialInvoice></Header></Request>
		,HOU.Cd_Tp_Oper																			FINAL_SALE_TERM_DESC -- <Request><Header><CommercialInvoice><FinalTermsofSaleDesc></FinalTermsofSaleDesc></CommercialInvoice></Header></Request>
		,(CASE WHEN [dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HIM) > 0 
				THEN 
					(Case when [dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HIM) < isnull(HOU.Vlr_Frete_Efet_HIM,0) 
						THEN 
							[dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HIM)
						ELSE
							[dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HIM) - isnull(HOU.Vlr_Frete_Efet_HIM,0)
					END)
				ELSE 
					LLP.Vlr_Invoice - isnull(HOU.Vlr_Frete_Efet_HIM,0) END)							FOB_AMT -- <Request><Header><CommercialInvoice><FOBAmount></FOBAmount></CommercialInvoice></Header></Request>
		,HOU.CD_TP_MOEDA																		FOB_AMT_CURR_CD -- <Request><Header><CommercialInvoice><FOBCurrency></FOBCurrency></CommercialInvoice></Header></Request>
		,UPPER([dbo].[fDW_PYMNT_TERM_CD](HOU.Num_Proc_HIM,'Code'))								PYMNT_TERM_CD -- <Request><Header><CommercialInvoice><TermsofPaymentCode></TermsofPaymentCode></CommercialInvoice></Header></Request>
		,UPPER([dbo].[fDW_PYMNT_TERM_CD](HOU.Num_Proc_HIM,'Desc'))								PYMNT_TERM_DESC -- NOT SEND <Request><Header><CommercialInvoice><TermsofPaymentDescription></TermsofPaymentDescription></CommercialInvoice></Header></Request>
		,HOU.CD_TP_MOEDA																		SALE_TERM_AMT_CURR_CD -- <Request><Header><CommercialInvoice><CurrencyCode></CurrencyCode></CommercialInvoice></Header></Request>
		,HOU.Cd_Tp_Oper																			SALE_TERM_CD -- <Request><Header><CommercialInvoice><TermsofSaleCode></TermsofSaleCode></CommercialInvoice></Header></Request>
		,HOU.Cd_Tp_Oper																			SALE_TERM_DESC -- <Request><Header><CommercialInvoice><TermsofSaleDesc></TermsofSaleDesc></CommercialInvoice></Header></Request>
		,'01BDPBRSAO' 																			[BDP_SS_ID]
	FROM House_Imp_Mar		HOU WITH(NOLOCK)
		JOIN LLP_IMP_MAR	LLP	WITH (NOLOCK) ON LLP.NUM_PROC_LIM =	HOU.Num_Proc_HIM
	Where
		--HOU.Num_Proc_HIM = 'IMSOL202407018BR'
		convert(datetime,HOU.Dt_Emis_HIM,105) > getdate() -31


UNION ALL

	Select
		HOU.Num_Proc_HIA																		FRWDR_REF_NBR
		,FORMAT([dbo].[fBusca_DATA_PO_Modal](HOU.Num_Proc_HIA,1), 'dd/MM/yy')		CMRCL_INVC_DT
		,isnull(dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc_HIA,2),'0000000000')					CMRCL_INVC_REF_NBR -- <Request><Header><CommercialInvoice><InvoiceNumber></InvoiceNumber></CommercialInvoice></Header></Request>
		,isnull(dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc_HIA,2),'0000000000')					CMRCL_INVC_REF_NBR_CONCAT
		,ROW_NUMBER() OVER(PARTITION BY HOU.Num_Proc_HIA ORDER BY HOU.Num_Proc_HIA ASC)			CMRCL_INVC_SEQ_ID 
		,(CASE WHEN [dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HIA) > 0 
				THEN
					[dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HIA)				
				ELSE 
					LLP.Vlr_Invoice - isnull(HOU.vlr_frete_efet_hia,0) END)						CMRCL_INVC_TTL_AMT -- <Request><Header><CommercialInvoice><InvoiceAmount></InvoiceAmount></CommercialInvoice></Header></Request>
		,HOU.CD_TP_MOEDA																		CMRCL_INVC_TTL_AMT_CURR_CD -- <Request><Header><CommercialInvoice><CurrencyCode></CurrencyCode></CommercialInvoice></Header></Request>
		,HOU.Cd_Tp_Oper																			FINAL_SALE_TERM_CD -- <Request><Header><CommercialInvoice><FinalTermsofSaleDesc></FinalTermsofSaleDesc></CommercialInvoice></Header></Request>
		,HOU.Cd_Tp_Oper																			FINAL_SALE_TERM_DESC -- <Request><Header><CommercialInvoice><FinalTermsofSaleDesc></FinalTermsofSaleDesc></CommercialInvoice></Header></Request>
		,(CASE WHEN [dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HIA) > 0 
				THEN 
					(Case when [dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HIA) < isnull(HOU.vlr_frete_efet_hia,0) 
						THEN 
							[dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HIA)
						ELSE
							[dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HIA) - isnull(HOU.vlr_frete_efet_hia,0)
					END)
				ELSE 
					LLP.Vlr_Invoice - isnull(HOU.vlr_frete_efet_hia,0) END)							FOB_AMT -- <Request><Header><CommercialInvoice><FOBAmount></FOBAmount></CommercialInvoice></Header></Request>
		,HOU.CD_TP_MOEDA																		FOB_AMT_CURR_CD -- <Request><Header><CommercialInvoice><FOBCurrency></FOBCurrency></CommercialInvoice></Header></Request>
		,UPPER([dbo].[fDW_PYMNT_TERM_CD](HOU.Num_Proc_HIA,'Code'))								PYMNT_TERM_CD -- <Request><Header><CommercialInvoice><TermsofPaymentCode></TermsofPaymentCode></CommercialInvoice></Header></Request>
		,UPPER([dbo].[fDW_PYMNT_TERM_CD](HOU.Num_Proc_HIA,'Desc'))								PYMNT_TERM_DESC -- NOT SEND <Request><Header><CommercialInvoice><TermsofPaymentDescription></TermsofPaymentDescription></CommercialInvoice></Header></Request>
		,HOU.CD_TP_MOEDA																		SALE_TERM_AMT_CURR_CD -- <Request><Header><CommercialInvoice><CurrencyCode></CurrencyCode></CommercialInvoice></Header></Request>
		,HOU.Cd_Tp_Oper																			SALE_TERM_CD -- <Request><Header><CommercialInvoice><TermsofSaleCode></TermsofSaleCode></CommercialInvoice></Header></Request>
		,HOU.Cd_Tp_Oper																			SALE_TERM_DESC -- <Request><Header><CommercialInvoice><TermsofSaleDesc></TermsofSaleDesc></CommercialInvoice></Header></Request>
		,'01BDPBRSAO' 																			[BDP_SS_ID]
	FROM House_Imp_Aer		HOU WITH(NOLOCK)
		JOIN LLP_IMP_Aer	LLP	WITH (NOLOCK) ON LLP.NUM_PROC_LIA =	HOU.Num_Proc_HIA
	Where
		--HOU.Num_Proc_HIA = 'IMSOL202407018BR'
		convert(datetime,HOU.Dt_Emis_HIA,105) > getdate() -31

UNION ALL

Select
		HOU.Num_Proc_HIO																		FRWDR_REF_NBR
		,FORMAT([dbo].[fBusca_DATA_PO_Modal](HOU.Num_Proc_HIO,1), 'dd/MM/yy')		CMRCL_INVC_DT
		,isnull(dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc_HIO,2),'0000000000')					CMRCL_INVC_REF_NBR -- <Request><Header><CommercialInvoice><InvoiceNumber></InvoiceNumber></CommercialInvoice></Header></Request>
		,isnull(dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc_HIO,2),'0000000000')					CMRCL_INVC_REF_NBR_CONCAT
		,ROW_NUMBER() OVER(PARTITION BY HOU.Num_Proc_HIO ORDER BY HOU.Num_Proc_HIO ASC)			CMRCL_INVC_SEQ_ID 
		,(CASE WHEN [dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HIO) > 0 
				THEN
					[dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HIO)				
				ELSE 
					LLP.Vlr_Invoice - isnull(HOU.vlr_frete_efet_hio,0) END)						CMRCL_INVC_TTL_AMT -- <Request><Header><CommercialInvoice><InvoiceAmount></InvoiceAmount></CommercialInvoice></Header></Request>
		,HOU.CD_TP_MOEDA																		CMRCL_INVC_TTL_AMT_CURR_CD -- <Request><Header><CommercialInvoice><CurrencyCode></CurrencyCode></CommercialInvoice></Header></Request>
		,HOU.Cd_Tp_Oper																			FINAL_SALE_TERM_CD -- <Request><Header><CommercialInvoice><FinalTermsofSaleDesc></FinalTermsofSaleDesc></CommercialInvoice></Header></Request>
		,HOU.Cd_Tp_Oper																			FINAL_SALE_TERM_DESC -- <Request><Header><CommercialInvoice><FinalTermsofSaleDesc></FinalTermsofSaleDesc></CommercialInvoice></Header></Request>
		,(CASE WHEN [dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HIO) > 0 
				THEN 
					(Case when [dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HIO) < isnull(HOU.vlr_frete_efet_hio,0) 
						THEN 
							[dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HIO)
						ELSE
							[dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HIO) - isnull(HOU.vlr_frete_efet_hio,0)
					END)
				ELSE 
					LLP.Vlr_Invoice - isnull(HOU.vlr_frete_efet_hio,0) END)							FOB_AMT -- <Request><Header><CommercialInvoice><FOBAmount></FOBAmount></CommercialInvoice></Header></Request>
		,HOU.CD_TP_MOEDA																		FOB_AMT_CURR_CD -- <Request><Header><CommercialInvoice><FOBCurrency></FOBCurrency></CommercialInvoice></Header></Request>
		,UPPER([dbo].[fDW_PYMNT_TERM_CD](HOU.Num_Proc_HIO,'Code'))								PYMNT_TERM_CD -- <Request><Header><CommercialInvoice><TermsofPaymentCode></TermsofPaymentCode></CommercialInvoice></Header></Request>
		,UPPER([dbo].[fDW_PYMNT_TERM_CD](HOU.Num_Proc_HIO,'Desc'))								PYMNT_TERM_DESC -- NOT SEND <Request><Header><CommercialInvoice><TermsofPaymentDescription></TermsofPaymentDescription></CommercialInvoice></Header></Request>
		,HOU.CD_TP_MOEDA																		SALE_TERM_AMT_CURR_CD -- <Request><Header><CommercialInvoice><CurrencyCode></CurrencyCode></CommercialInvoice></Header></Request>
		,HOU.Cd_Tp_Oper																			SALE_TERM_CD -- <Request><Header><CommercialInvoice><TermsofSaleCode></TermsofSaleCode></CommercialInvoice></Header></Request>
		,HOU.Cd_Tp_Oper																			SALE_TERM_DESC -- <Request><Header><CommercialInvoice><TermsofSaleDesc></TermsofSaleDesc></CommercialInvoice></Header></Request>
		,'01BDPBRSAO' 																			[BDP_SS_ID]
	FROM House_Imp_Out		HOU WITH(NOLOCK)
		JOIN LLP_IMP_Out	LLP	WITH (NOLOCK) ON LLP.NUM_PROC_LIO =	HOU.Num_Proc_HIO
	Where
		--HOU.Num_Proc_HIA = 'IMSOL202407018BR'
		convert(datetime,HOU.Dt_Emis_HIO,105) > getdate() -31


GO
