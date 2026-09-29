SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spReportManagerExpV2FOB_Sel] -- [dbo].[spReportManagerFOB_Sel] 'EMCSR20091110701'
	@Num_Proc	Varchar(16),
	@Cd_Produto	Varchar(100),
	@FOB		Decimal(18,2) output

AS

Declare @Temp Table
	(
		Cd_Proc_Cliente varchar(40),
		Preco_Unt		float,
		Peso_Liquido	float,
		Uom				Varchar(5),
		Num_Proc		Varchar(16),
		Quantidade		Float
	
	)
insert @Temp
select cd_proc_cliente,Preco_Unit,sum(Peso_Liquido) Peso_Liquido,upper(Tipo_Unid) Uom,Num_Proc,sum(quantidade)*capacidade quantidade from invoice_det ID with(nolock)
Join Invoice_Cliente IC With(nolock) on IC.id_inv=ID.id_inv
Join Produto_Cliente PC with(nolock) on PC.cd_prod=ID.cd_produto
Where
	Num_PRoc=@Num_Proc and cd_proc_cliente=@Cd_Produto
group by
	cd_proc_cliente,Preco_Unit,Peso_Liquido,Tipo_Unid,Num_Proc ,capacidade

union all

Select cd_proc_cliente,vlr_item preco_unit,peso_liquido_tot peso_liquido,uom,ps.num_proc,ps.qty quantidade From Pedido_Ship PS with(nolock)
Join Pedido_Det PDD with(nolock) on PDD.cd_pedido=PS.cd_pedido and PDD.cd_produto=PS.cd_produto and PDD.lote=PS.lote and PDD.item=PS.item
Left Join Invoice_Cliente IC with(nolock) on PS.num_proc=IC.num_proc
Join Produto_Cliente PC with(nolock) on PS.cd_produto=PC.cd_prod
where IC.num_proc is null
and PS.num_proc=@num_proc and cd_proc_cliente=@Cd_Produto



Select 
		@FOB= Sum(case 
			--When upper(UOM)='KG' then Peso_Liquido*Preco_Unt
			When upper(UOM)='KG' then Quantidade*Preco_Unt --18/03/2015 - Alteração solicitada por Anderson Lima
			
			else Quantidade*Preco_Unt
		End)
	from @temp
GO
