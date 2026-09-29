SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spPedidoShipProc_Container_Sel'IMUPL201610050BR'
CREATE Procedure [dbo].[spPedidoShipProc_Container_Sel]
	@Processo VarChar(16)
as	

SELECT 
	P.Num_pedido, PC.Cd_Proc_Cliente, PC.Produto_Descr, PS.Qty, PS.Item, PS.Lote,
	PSC.Num_Cont, 
	--PSC.FreeTime,
	PSC.GA_Ship_Actual_Date,PSC.GA_Ship_Estimated_Date
FROM 
	Pedido_Ship_Container PSC  With(nolock)
	join Pedido_Ship PS  With(nolock) on PS.Cd_pedido = PSC.Cd_Pedido and PS.cd_produto=PSC.cd_produto and PS.Item = PSC.Item and PS.Lote = PSC.Lote and PS.Num_Proc=PSC.Num_Proc
	Join Pedido P With(nolock) on P.Cd_pedido = PS.Cd_Pedido
	Join Produto_Cliente PC With(nolock) on PC.cd_prod=PS.cd_produto	
where 
	PSC.Num_Proc=@Processo






GO
