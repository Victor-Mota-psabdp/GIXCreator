SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[spTipoShipContainer_Sel]
(
	@Processo varchar(16),
	@GMID varchar(30)
)
as

select GA_Ship_Actual_Date, GA_Ship_Estimated_Date from Pedido_Ship_Container PSC
join Pedido PED on PED.cd_pedido=PSC.cd_pedido
Join Produto_Cliente PC on PC.cd_prod=cd_produto
where Num_Proc = @Processo and cd_proc_cliente = @GMID
GO
