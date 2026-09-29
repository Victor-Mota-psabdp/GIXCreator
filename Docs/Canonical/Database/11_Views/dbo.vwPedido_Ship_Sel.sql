SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Pedido_Ship
CREATE VIEW [dbo].[vwPedido_Ship_Sel]
AS

select 
	convert(varchar(25),'Saved')	[Status],
	PS.cd_pedido					[Order Code],
	PE.Num_Pedido					[Order Number],
	PS.cd_produto					[Code],
	PC.cd_Proc_Cliente				[Product Code],
	PC.Produto_Descr				[Product Description],
	Ps.Lote							[2ª Ref. (Delivery Note)],
	Ps.item							[Item],
	Ps.Qty							[Qty],			
	Ps.Num_Proc						[JOB],
	PS.cd_usuario					[User Code],
	US.Nome_Usuario					[User Name]
from Pedido_Ship PS with(nolock)
	join Pedido_Det PD with(nolock) on PS.cd_pedido=PD.Cd_Pedido and PS.cd_produto=PD.Cd_Produto and
		ps.Item = PD.Item AND PS.Lote = PD.Lote
	left join Pedido PE with(nolock) on PE.Cd_pedido = PS.cd_pedido
	left join vwClienteALLJOBs JOB  with(nolock) on PS.Num_Proc = JOB.num_proc
	left join Pessoa_LLP P with(nolock) on P.Cd_Pes = JOB.cd_cliente	
	left join Produto_Cliente PC with(nolock) on PC.cd_prod = PS.cd_produto and PC.cd_Cliente = P.Cd_Pes_Grupo		
	left join Usuario US with(nolock) on Us.Cd_Usuario = PS.cd_usuario


--select 
--	PS.cd_pedido		[Order Code],
--	PE.Num_Pedido		[Order Number],
--	PS.cd_produto		[Code],
--	PC.cd_Proc_Cliente	[Product Code],
--	PC.Produto_Descr	[Product Description],
--	Ps.Num_Proc			[JOB]
--	--falta os outros campos			
--from Pedido_Ship PS with(nolock)
--	join Pedido_Det PD with(nolock) on PS.cd_pedido=PD.Cd_Pedido and PS.cd_produto=PD.Cd_Produto and
--		ps.Item = PD.Item AND PS.Lote = PD.Lote
--	left join Pedido PE with(nolock) on PE.Cd_pedido = PS.cd_pedido
--	left join vwClienteALLJOBs JOB  with(nolock) on PS.Num_Proc = JOB.num_proc
--	left join Pessoa_LLP P with(nolock) on P.Cd_Pes = JOB.cd_cliente	
--	left join Produto_Cliente PC with(nolock) on PC.cd_prod = PS.cd_produto and PC.cd_Cliente = P.Cd_Pes_Grupo		
--	left join Usuario US with(nolock) on Us.Cd_Usuario = PS.cd_usuario



GO
