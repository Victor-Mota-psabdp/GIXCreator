SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATLINT_JSON_Oxiteno_PurchaseOrderJOB_Invoice_Sel]
(
	@ID_PurchaseOrderJOB	bigint,
	@ID_Invoice				bigint,
	@Tipo					char(1)
)
as

--sp_help ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB_Invoice

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select 		
			J.ID_purchaseOrderJOB [Internal Code],			
			J.ID_Invoice,
			J.numero,
			J.data,
			J.valor,
			J.moeda,
			J.incoterm,
			J.cond_pagto
		from 
			ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB_Invoice J with(nolock)
			join ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB JOB with(nolock) on JOB.ID_purchaseOrderJOB = J.ID_purchaseOrderJOB
			
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select 		
			J.ID_purchaseOrderJOB [Internal Code],			
			J.ID_Invoice,
			J.numero,
			J.data,
			J.valor,
			J.moeda,
			J.incoterm,
			J.cond_pagto
		from 
			ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB_Invoice J with(nolock)
			join ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB JOB with(nolock) on JOB.ID_purchaseOrderJOB = J.ID_purchaseOrderJOB
		where 
			J.ID_purchaseOrderJOB = @ID_PurchaseOrderJOB
	End
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select 		
			J.ID_purchaseOrderJOB [Internal Code],			
			J.ID_Invoice,
			J.numero,
			J.data,
			J.valor,
			J.moeda,
			J.incoterm,
			J.cond_pagto
		from 
			ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB_Invoice J with(nolock)
			join ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB JOB with(nolock) on JOB.ID_purchaseOrderJOB = J.ID_purchaseOrderJOB
		where 
			J.ID_purchaseOrderJOB = @ID_PurchaseOrderJOB and J.ID_Invoice = @ID_Invoice
	End






GO
