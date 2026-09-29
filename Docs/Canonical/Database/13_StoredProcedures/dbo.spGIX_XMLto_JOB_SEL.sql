SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spGIX_XMLto_JOB_SEL]

as

Select 	
	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],	
	Request.ID_Req
from ATL_INT.dbo.GIX_Request_Header Request
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type = 'ImportForwarderRefNbr'
	join vwALL_JOBs V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number

	--join GIX_Header_References PurchaseOrderNumber on PurchaseOrderNumber.ID_Req = Request.ID_Req 
	--	and PurchaseOrderNumber.Ref_Type = 'PurchaseOrderNumber'

	--join GIX_Header_Parties Shipper on Shipper.ID_Req = Request.ID_Req and Shipper.Parties_Type = 'Shipper'
	--join ATL_QA_1006.dbo.Pessoa SH on SH.Nome_raz_Soc = Shipper.Party_Name
	--join GIX_Header_Parties Consignee on Consignee.ID_Req = Request.ID_Req and Consignee.Parties_Type = 'Consignee'
	--join ATL_QA_1006.dbo.Pessoa CO on CO.Nome_raz_Soc = Shipper.Party_Name
	
	--join GIX_Header_References OrderNumber on OrderNumber.ID_Req = Request.ID_Req and OrderNumber.Ref_Type = 'OrderNumber'
	--join GIX_Header_Commercial_Invoice Commercial_Invoice on OrderNumber.ID_Req = Request.ID_Req and OrderNumber.Ref_Number= Commercial_Invoice.Invoice_Number
		
	
	
	--join GIX_Header_References EntryNumber on EntryNumber.ID_Req = Request.ID_Req and EntryNumber.Ref_Type = 'EntryNumber'
	
	
	--join GIX_Header_Notes Notes on Notes.ID_Req = Request.ID_Req and Notes.Note_Type = 'EDI'
	
	--join GIX_Header_Commercial_Invoice Commercial_Invoice on Request.ID_Req = Request.ID_Req
	
	--join GIX_Header_Transportation Secondary on Secondary.ID_Req = Request.ID_Req and Secondary.LEGTYPE = 'Secondary'
	--join GIX_Header_Transportation_Origin Origin on Origin.ID_Req = Secondary.ID_Req and Origin.ID_Trans = Secondary.ID_Trans
	--join ATL_QA_1006.dbo.Localidade ORG on ORG.Nome_Local = Origin.Origin_Name 
	
	--join GIX_Header_Transportation_Destination Destination on Destination.ID_Req = Secondary.ID_Req and Destination.ID_Trans = Secondary.ID_Trans
	--join ATL_QA_1006.dbo.Localidade DST on DST.Nome_Local = Destination.DestinationName 	
		
	--join GIX_Header_Transportation [Primary] on [Primary].ID_Req = Request.ID_Req and [Primary].LEGTYPE = 'Primary'
	--join GIX_Header_Transportation_ReferenceType ReferenceType on ReferenceType.ID_Req = [Primary].ID_Req and ReferenceType.ID_Trans = [Primary].ID_Trans
	--join GIX_Header_Transportation_Carrier Carrier on Carrier.ID_Req = [Primary].ID_Req and Carrier.ID_Trans = [Primary].ID_Trans
	
	--join GIX_Header_Licence Licence on Licence.ID_Req = Request.ID_Req	
	
	--join GIX_Header_Status DTCI on DTCI.ID_Req = Request.ID_Req and DTCI.StatusDescription = 'DTCI'
	--join GIX_Header_Status DTEMBARQUE on DTEMBARQUE.ID_Req = Request.ID_Req and DTEMBARQUE.StatusDescription = 'DTEMBARQUE'
	--join GIX_Header_Status DTPAGAMENTO_DE_ICMS on DTPAGAMENTO_DE_ICMS.ID_Req = Request.ID_Req and DTPAGAMENTO_DE_ICMS.StatusDescription = 'DTPAGAMENTO DE ICMS'
	--join GIX_Header_Status DTPAGAMENTO_AFRMM on DTPAGAMENTO_AFRMM.ID_Req = Request.ID_Req and DTPAGAMENTO_AFRMM.StatusDescription = 'DTPAGAMENTO_AFRMM'
	--join GIX_Header_Status DTREGISTRO on DTREGISTRO.ID_Req = Request.ID_Req and DTREGISTRO.StatusDescription = 'DTREGISTRO'
	
	--join GIX_Header_Amount ExchangeRateAmt on ExchangeRateAmt.ID_Req = Request.ID_Req and ExchangeRateAmt.AmountType  = 'ExchangeRateAmt'
	--join GIX_Header_Amount ChargeableWeight on ChargeableWeight.ID_Req = Request.ID_Req and ChargeableWeight.AmountType  = 'ChargeableWeight'
	--join GIX_Header_Amount OtherFeeAmount on OtherFeeAmount.ID_Req = Request.ID_Req and OtherFeeAmount.AmountType  = 'OtherFeeAmount'
	--join GIX_Header_Amount OtherTaxAmount on OtherTaxAmount.ID_Req = Request.ID_Req and OtherTaxAmount.AmountType  = 'OtherTaxAmount'
	--join GIX_Header_Amount BDPBillingInvoicePrepaidAmount on BDPBillingInvoicePrepaidAmount.ID_Req = Request.ID_Req and BDPBillingInvoicePrepaidAmount.AmountType  = 'BDPBillingInvoicePrepaidAmount'
	
	--left join Atlantis.dbo.Pedido P with (nolock) on P.Num_Pedido = OrderNumber.Ref_Number and Cd_Grupo = 'P21128'
	--left join ATL_QA_1006.dbo.Pedido P with (nolock) on P.Num_Pedido = PurchaseOrderNumber.Ref_Number and Cd_Grupo = 'P21128'
where
	--isnull(P.Status,'O') = 'O'
	--and 
	DT_INS_JOB is null
	and SystemCode = '1'
	and isnull(v.ID_Status,0) not in ('9','5')
	--and Request.ID_Req = 36
--Group by
--	P.Cd_pedido,PurchaseOrderNumber.Ref_Number,SH.Apelido,CO.Apelido,
--	Org.Pais_Local,DST.Pais_Local,Request.ID_Req,Consignee.Party_Name
order by
	2

GO
