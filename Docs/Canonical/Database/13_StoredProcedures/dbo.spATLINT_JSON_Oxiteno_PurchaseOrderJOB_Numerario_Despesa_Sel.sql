SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATLINT_JSON_Oxiteno_PurchaseOrderJOB_Numerario_Despesa_Sel]
(
	@ID_PurchaseOrderJOB	bigint,
	@ID_Numerario			bigint,
	@ID_Line				bigint,
	@Tipo					char(1)
)
as

--sp_help ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB_Numerario_Despesa

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select 		
			PO.ID_purchaseOrderJOB [Internal Code],			
			PO.ID_Numerario,
			PO.ID_Line,
			PO.nome,
			PO.valor			
		from 
			ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB JOB  with(nolock)
			join ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB_Numerario I with(nolock) on JOB.ID_purchaseOrderJOB = I.ID_purchaseOrderJOB
			join ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB_Numerario_Despesa PO with(nolock) on I.ID_purchaseOrderJOB = PO.ID_purchaseOrderJOB
				and I.ID_Numerario = PO.ID_Numerario
		where 
			PO.ID_purchaseOrderJOB = @ID_PurchaseOrderJOB
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select 		
			PO.ID_purchaseOrderJOB [Internal Code],			
			PO.ID_Numerario,
			PO.ID_Line,
			PO.nome,
			PO.valor			
		from 
			ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB JOB  with(nolock)
			join ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB_Numerario I with(nolock) on JOB.ID_purchaseOrderJOB = I.ID_purchaseOrderJOB
			join ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB_Numerario_Despesa PO with(nolock) on I.ID_purchaseOrderJOB = PO.ID_purchaseOrderJOB
				and I.ID_Numerario = PO.ID_Numerario
		where 
			PO.ID_purchaseOrderJOB = @ID_PurchaseOrderJOB and PO.ID_Numerario = @ID_Numerario
	End
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select 		
			PO.ID_purchaseOrderJOB [Internal Code],			
			PO.ID_Numerario,
			PO.ID_Line,
			PO.nome,
			PO.valor			
		from 
			ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB JOB  with(nolock)
			join ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB_Numerario I with(nolock) on JOB.ID_purchaseOrderJOB = I.ID_purchaseOrderJOB
			join ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB_Numerario_Despesa PO with(nolock) on I.ID_purchaseOrderJOB = PO.ID_purchaseOrderJOB
				and I.ID_Numerario = PO.ID_Numerario
		where 
			PO.ID_purchaseOrderJOB = @ID_PurchaseOrderJOB and PO.ID_Numerario = @ID_Numerario
	End



GO
