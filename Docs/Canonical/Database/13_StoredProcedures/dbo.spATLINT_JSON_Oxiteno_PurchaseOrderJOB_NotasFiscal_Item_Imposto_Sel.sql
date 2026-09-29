SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATLINT_JSON_Oxiteno_PurchaseOrderJOB_NotasFiscal_Item_Imposto_Sel]
(
	@ID_PurchaseOrderJOB			bigint,
	@ID_NotasFiscal					bigint,
	@ID_NotasFiscal_Item			bigint,
	@ID_NotasFiscal_Item_Imposto	bigint,
	@Tipo							char(1)
)
as

--sp_help ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB_NotasFiscal

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select 		
			NII.ID_purchaseOrderJOB [Internal Code],			
			NII.ID_NotasFiscal,		
			NII.ID_NotasFiscal_Item,
			NII.ID_NotasFiscal_Item_Imposto,
			NII.tipo,
			NII.base_calculo,
			NII.aliquota,
			NII.valor
		from 
			ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB  JOB with(nolock)
			join ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB_NotasFiscal N with(nolock) on JOB.ID_purchaseOrderJOB = N.ID_purchaseOrderJOB
			join ATL_INT.dbo.JSON_Oxiteno_purchaseOrderJOB_NotasFiscal_Item NI with(nolock) on N.ID_purchaseOrderJOB = NI.ID_purchaseOrderJOB 
					and N.ID_NotasFiscal = NI.ID_NotasFiscal
			join ATL_INT.dbo.JSON_Oxiteno_purchaseOrderJOB_NotasFiscal_Item_Imposto NII with(nolock) on NII.ID_purchaseOrderJOB = NI.ID_purchaseOrderJOB 
					and NII.ID_NotasFiscal = NI.ID_NotasFiscal and NII.ID_NotasFiscal_Item = NI.ID_NotasFiscal_Item
		where 
			NII.ID_purchaseOrderJOB = @ID_PurchaseOrderJOB and NII.ID_NotasFiscal = @ID_NotasFiscal
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select 		
			NII.ID_purchaseOrderJOB [Internal Code],			
			NII.ID_NotasFiscal,		
			NII.ID_NotasFiscal_Item,
			NII.ID_NotasFiscal_Item_Imposto,
			NII.tipo,
			NII.base_calculo,
			NII.aliquota,
			NII.valor
		from 
			ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB  JOB with(nolock)
			join ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB_NotasFiscal N with(nolock) on JOB.ID_purchaseOrderJOB = N.ID_purchaseOrderJOB
			join ATL_INT.dbo.JSON_Oxiteno_purchaseOrderJOB_NotasFiscal_Item NI with(nolock) on N.ID_purchaseOrderJOB = NI.ID_purchaseOrderJOB 
					and N.ID_NotasFiscal = NI.ID_NotasFiscal
			join ATL_INT.dbo.JSON_Oxiteno_purchaseOrderJOB_NotasFiscal_Item_Imposto NII with(nolock) on NII.ID_purchaseOrderJOB = NI.ID_purchaseOrderJOB 
					and NII.ID_NotasFiscal = NI.ID_NotasFiscal and NII.ID_NotasFiscal_Item = NI.ID_NotasFiscal_Item
		where 
			NII.ID_purchaseOrderJOB = @ID_PurchaseOrderJOB and NII.ID_NotasFiscal = @ID_NotasFiscal and NII.ID_NotasFiscal_Item = @ID_NotasFiscal_Item
	End
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select 		
			NII.ID_purchaseOrderJOB [Internal Code],			
			NII.ID_NotasFiscal,		
			NII.ID_NotasFiscal_Item,
			NII.ID_NotasFiscal_Item_Imposto,
			NII.tipo,
			NII.base_calculo,
			NII.aliquota,
			NII.valor
		from 
			ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB  JOB with(nolock)
			join ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB_NotasFiscal N with(nolock) on JOB.ID_purchaseOrderJOB = N.ID_purchaseOrderJOB
			join ATL_INT.dbo.JSON_Oxiteno_purchaseOrderJOB_NotasFiscal_Item NI with(nolock) on N.ID_purchaseOrderJOB = NI.ID_purchaseOrderJOB 
					and N.ID_NotasFiscal = NI.ID_NotasFiscal
			join ATL_INT.dbo.JSON_Oxiteno_purchaseOrderJOB_NotasFiscal_Item_Imposto NII with(nolock) on NII.ID_purchaseOrderJOB = NI.ID_purchaseOrderJOB 
					and NII.ID_NotasFiscal = NI.ID_NotasFiscal and NII.ID_NotasFiscal_Item = NI.ID_NotasFiscal_Item
		where 
				NII.ID_purchaseOrderJOB = @ID_PurchaseOrderJOB and NII.ID_NotasFiscal = @ID_NotasFiscal and NII.ID_NotasFiscal_Item = @ID_NotasFiscal_Item
				and NII.ID_NotasFiscal_Item_Imposto = @ID_NotasFiscal_Item_Imposto
	End






GO
