SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spReportManagerFOB_Sel] -- [dbo].[spReportManagerFOB_Sel] 'EMCSR20091110701'
	@Num_Proc	Varchar(16)
AS

select cd_proc_cliente,Preco_Unit,sum(Peso_Liquido) Peso_Liquido,upper(Tipo_Unid) Uom,Num_Proc,sum(quantidade)*capacidade quantidade from invoice_det ID with(nolock)
Join Invoice_Cliente IC with(nolock) on IC.id_inv=ID.id_inv
Join Produto_Cliente PC with(nolock) on PC.cd_prod=ID.cd_produto
Where
	Num_PRoc=@Num_Proc
group by
	cd_proc_cliente,Preco_Unit,Peso_Liquido,Tipo_Unid,Num_Proc ,capacidade

union all

Select cd_proc_cliente,vlr_item preco_unit,peso_liquido_tot peso_liquido,uom,ps.num_proc,ps.qty quantidade From Pedido_Ship PS with(nolock)
Join Pedido_Det PDD with(nolock) on PDD.cd_pedido=PS.cd_pedido and PDD.cd_produto=PS.cd_produto and PDD.lote=PS.lote and PDD.item=PS.item
Left Join Invoice_Cliente IC with(nolock) on PS.num_proc=IC.num_proc
Join Produto_Cliente PC with(nolock) on PS.cd_produto=PC.cd_prod
where IC.num_proc is null
and PS.num_proc=@num_proc


GO
