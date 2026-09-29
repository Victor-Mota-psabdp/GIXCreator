SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATLINT_JSON_Oxiteno_PurchaseOrderJOB_Invoice_PO_Sel]
(
	@ID_PurchaseOrderJOB	bigint,
	@ID_Invoice				bigint,
	@ID_Line				bigint,
	@Tipo					char(1)
)
as

--sp_help ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB_Invoice_PO

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select 		
			PO.ID_purchaseOrderJOB [Internal Code],
			PO.ID_Invoice,
			PO.ID_Line,			
			PO.numero			
		from 
			ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB JOB  with(nolock)
			join ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB_Invoice I with(nolock) on JOB.ID_purchaseOrderJOB = I.ID_purchaseOrderJOB
			join ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB_Invoice_PO PO with(nolock) on I.ID_purchaseOrderJOB = PO.ID_purchaseOrderJOB
				and I.ID_Invoice = PO.ID_Invoice
		where
			PO.ID_purchaseOrderJOB = @ID_PurchaseOrderJOB
	
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select 		
			PO.ID_purchaseOrderJOB [Internal Code],
			PO.ID_Invoice,
			PO.ID_Line,			
			PO.numero				
		from 
			ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB JOB  with(nolock)
			join ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB_Invoice I with(nolock) on JOB.ID_purchaseOrderJOB = I.ID_purchaseOrderJOB
			join ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB_Invoice_PO PO with(nolock) on I.ID_purchaseOrderJOB = PO.ID_purchaseOrderJOB
				and I.ID_Invoice = PO.ID_Invoice
		where 
			PO.ID_purchaseOrderJOB = @ID_PurchaseOrderJOB and PO.ID_Invoice = @ID_Invoice

	End
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select 		
			PO.ID_purchaseOrderJOB [Internal Code],
			PO.ID_Invoice,
			PO.ID_Line,			
			PO.numero					
		from 
			ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB JOB  with(nolock)
			join ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB_Invoice I with(nolock) on JOB.ID_purchaseOrderJOB = I.ID_purchaseOrderJOB
			join ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB_Invoice_PO PO with(nolock) on I.ID_purchaseOrderJOB = PO.ID_purchaseOrderJOB
				and I.ID_Invoice = PO.ID_Invoice
		where 
			PO.ID_purchaseOrderJOB = @ID_PurchaseOrderJOB and PO.ID_Invoice = @ID_Invoice
	End



GO
