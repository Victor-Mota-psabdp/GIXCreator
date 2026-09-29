SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE spAlpenaDowOrdensEmAberto

AS

SELECT PD.cd_pedido FROM PEDIDO PD
Join Pedido_det PDD on PD.cd_pedido=PDD.cd_pedido
Left Join Pedido_Ship PS on PS.cd_pedido=PDD.cd_pedido and PS.cd_produto=PDD.cd_Produto
Join Produto_Cliente PC on PC.cd_prod=PDD.cd_produto
Where ps.num_proc is null and cd_grupo='1'
and cd_proc_Cliente in (select cd_produto_cliente from projeto_dowalpena)

GO
