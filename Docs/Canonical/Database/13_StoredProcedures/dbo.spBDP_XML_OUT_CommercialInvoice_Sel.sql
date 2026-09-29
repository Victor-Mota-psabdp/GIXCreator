SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spBDP_XML_OUT_INT_PEDIDO] 'EMSLA201901003BR'
CREATE PROCEDURE [dbo].[spBDP_XML_OUT_CommercialInvoice_Sel] 
(
	@num_proc	varchar(16)
)
as

	select  
		LLP.cd_tp_oper			[TermsofSaleCode],
		LLP.Vlr_Invoice			[InvoiceAmount],
		LLP.Cd_Moeda_Invoice	[CurrencyCode]
	from 
		vwBDP_XML_OUT_ClienteALLJOBS LLP With(Nolock)		
	WHERE
		LLP.Num_Proc=@NUM_PROC


GO
