SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATLINT_JSON_Oxiteno_PurchaseOrderJOB_NotasFiscal_Item_Sel]
(
	@ID_PurchaseOrderJOB			bigint,
	@ID_NotasFiscal					bigint,
	@ID_NotasFiscal_Item			bigint,
	@Tipo							char(1)
)
as

--sp_help ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB_NotasFiscal

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select 		
			NI.ID_purchaseOrderJOB [Internal Code],			
			NI.ID_NotasFiscal,		
			NI.ID_NotasFiscal_Item,
			NI.nr_linha,
			NI.item_cod,
			NI.item_descr,
			NI.quantidade,
			NI.um,
			NI.valor_unitario,
			NI.peso_bruto,
			NI.peso_liquido
		from 
			ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB  JOB with(nolock)
			join ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB_NotasFiscal N with(nolock) on JOB.ID_purchaseOrderJOB = N.ID_purchaseOrderJOB
			join ATL_INT.dbo.JSON_Oxiteno_purchaseOrderJOB_NotasFiscal_Item NI with(nolock) on N.ID_purchaseOrderJOB = NI.ID_purchaseOrderJOB 
					and N.ID_NotasFiscal = NI.ID_NotasFiscal
		where 
			NI.ID_purchaseOrderJOB = @ID_PurchaseOrderJOB
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select 		
			NI.ID_purchaseOrderJOB [Internal Code],			
			NI.ID_NotasFiscal,		
			NI.ID_NotasFiscal_Item,
			NI.nr_linha,
			NI.item_cod,
			NI.item_descr,
			NI.quantidade,
			NI.um,
			NI.valor_unitario,
			NI.peso_bruto,
			NI.peso_liquido
			--,IPO.numero [Num_Pedido]
		from 
			ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB  JOB with(nolock)
			join ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB_NotasFiscal N with(nolock) on JOB.ID_purchaseOrderJOB = N.ID_purchaseOrderJOB
			join ATL_INT.dbo.JSON_Oxiteno_purchaseOrderJOB_NotasFiscal_Item NI with(nolock) on N.ID_purchaseOrderJOB = NI.ID_purchaseOrderJOB and N.ID_NotasFiscal = NI.ID_NotasFiscal

			--join ATL_INT.dbo.JSON_Oxiteno_purchaseOrderJOB_Invoice_PO I with(nolock) on JOB.ID_purchaseOrderJOB = I.ID_purchaseOrderJOB
			--join ATL_INT.dbo.JSON_Oxiteno_purchaseOrderJOB_Invoice_PO IPO with(nolock) on N.ID_purchaseOrderJOB = IPO.ID_purchaseOrderJOB and N.ID_NotasFiscal = IPO.ID_Invoice
			
			join Produto_Cliente PROD with (nolock) on PROD.Cd_Proc_Cliente = NI.item_cod and PROD.Cd_Cliente = 'P21128'
			--join ATLANTIS.dbo.Pedido_Ship PS with (nolock) on JOB.ref_processo = PS.Num_Proc and PROD.cd_Prod = PS.Cd_Produto 
		where 
			NI.ID_purchaseOrderJOB = @ID_PurchaseOrderJOB and NI.ID_NotasFiscal = @ID_NotasFiscal
	End
	--Begin
	--	select 		
	--		NI.ID_purchaseOrderJOB [Internal Code],			
	--		NI.ID_NotasFiscal,		
	--		NI.ID_NotasFiscal_Item,
	--		NI.nr_linha,
	--		NI.item_cod,
	--		NI.item_descr,
	--		NI.quantidade,
	--		NI.um,
	--		NI.valor_unitario,
	--		NI.peso_bruto,
	--		NI.peso_liquido
	--	from 
	--		ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB  JOB with(nolock)
	--		join ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB_NotasFiscal N with(nolock) on JOB.ID_purchaseOrderJOB = N.ID_purchaseOrderJOB
	--		join ATL_INT.dbo.JSON_Oxiteno_purchaseOrderJOB_NotasFiscal_Item NI with(nolock) on N.ID_purchaseOrderJOB = NI.ID_purchaseOrderJOB 
	--				and N.ID_NotasFiscal = NI.ID_NotasFiscal
	--	where 
	--		NI.ID_purchaseOrderJOB = @ID_PurchaseOrderJOB and NI.ID_NotasFiscal = @ID_NotasFiscal
	--End
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select 		
			NI.ID_purchaseOrderJOB [Internal Code],			
			NI.ID_NotasFiscal,		
			NI.ID_NotasFiscal_Item,
			NI.nr_linha,
			NI.item_cod,
			NI.item_descr,
			NI.quantidade,
			NI.um,
			NI.valor_unitario,
			NI.peso_bruto,
			NI.peso_liquido
		from 
			ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB  JOB with(nolock)
			join ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB_NotasFiscal N with(nolock) on JOB.ID_purchaseOrderJOB = N.ID_purchaseOrderJOB
			join ATL_INT.dbo.JSON_Oxiteno_purchaseOrderJOB_NotasFiscal_Item NI with(nolock) on N.ID_purchaseOrderJOB = NI.ID_purchaseOrderJOB 
					and N.ID_NotasFiscal = NI.ID_NotasFiscal
		where 
			NI.ID_purchaseOrderJOB = @ID_PurchaseOrderJOB and NI.ID_NotasFiscal = @ID_NotasFiscal 
			and NI.ID_NotasFiscal_Item = @ID_NotasFiscal_Item
	End

--if @Tipo = 'P'
--	Begin
--		select 		
--			NI.ID_purchaseOrderJOB [Internal Code],			
--			NI.ID_NotasFiscal,		
--			NI.ID_NotasFiscal_Item,
--			NI.nr_linha,
--			NI.item_cod,
--			NI.item_descr,
--			NI.quantidade,
--			NI.um,
--			NI.valor_unitario,
--			NI.peso_bruto,
--			NI.peso_liquido,
--			IPO.numero [Num_Pedido]
--		from 
--			ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB  JOB with(nolock)
--			join ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB_NotasFiscal N with(nolock) on JOB.ID_purchaseOrderJOB = N.ID_purchaseOrderJOB
--			join ATL_INT.dbo.JSON_Oxiteno_purchaseOrderJOB_NotasFiscal_Item NI with(nolock) on N.ID_purchaseOrderJOB = NI.ID_purchaseOrderJOB and N.ID_NotasFiscal = NI.ID_NotasFiscal

--			join ATL_INT.dbo.JSON_Oxiteno_purchaseOrderJOB_Invoice_PO I with(nolock) on JOB.ID_purchaseOrderJOB = I.ID_purchaseOrderJOB
--			join ATL_INT.dbo.JSON_Oxiteno_purchaseOrderJOB_Invoice_PO IPO with(nolock) on N.ID_purchaseOrderJOB = IPO.ID_purchaseOrderJOB and N.ID_NotasFiscal = IPO.ID_Invoice
			
--			join Produto_Cliente PROD with (nolock) on PROD.Cd_Proc_Cliente = NI.item_cod and PROD.Cd_Cliente = 'P21128'
--			--join ATLANTIS.dbo.Pedido_Ship PS with (nolock) on JOB.ref_processo = PS.Num_Proc and PROD.cd_Prod = PS.Cd_Produto 
--		where 
--			NI.ID_purchaseOrderJOB = 3 and NI.ID_NotasFiscal = 1
--	End




GO
