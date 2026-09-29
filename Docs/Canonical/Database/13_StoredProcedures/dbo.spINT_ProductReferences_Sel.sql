SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--18/06/2024 - Cadu included Distinct
CREATE PROCEDURE [dbo].[spINT_ProductReferences_Sel] 
(
	@num_proc	varchar(16),
	@cd_Proc_Cliente varchar(30) 
)
as

--PONumber
--PurchaseOrderNumber
	select 	Distinct
		'PONumber' ProductReferencesType,
		PED.Num_PO ProductReferences		
	from pedido_ship PS			WITH(nolock)
	Join Produto_Cliente PC		WITH(nolock) on PC.cd_prod=cd_produto
	Join Pedido  PED			WITH(nolock) on PED.cd_pedido=PS.cd_pedido
	WHERE
		NUM_PROC=@num_proc 
		and PC.cd_Proc_Cliente = @cd_Proc_Cliente

	union ALL

	select 	Distinct
		'PurchaseOrderNumber' ProductReferencesType,
		PED.Num_Pedido ProductReferences		
	from pedido_ship PS			WITH(nolock)
	Join Produto_Cliente PC		WITH(nolock) on PC.cd_prod=cd_produto
	Join Pedido  PED			WITH(nolock) on PED.cd_pedido=PS.cd_pedido
	WHERE
		NUM_PROC=@num_proc 
		and PC.cd_Proc_Cliente = @cd_Proc_Cliente

	union ALL

	select 	Distinct
		'OrderNumber' ProductReferencesType,
		PED.Num_Pedido ProductReferences		
	from pedido_ship PS			WITH(nolock)
	Join Produto_Cliente PC		WITH(nolock) on PC.cd_prod=cd_produto
	Join Pedido  PED			WITH(nolock) on PED.cd_pedido=PS.cd_pedido
	WHERE
		NUM_PROC=@num_proc 
		and PC.cd_Proc_Cliente = @cd_Proc_Cliente

	
	
GO
