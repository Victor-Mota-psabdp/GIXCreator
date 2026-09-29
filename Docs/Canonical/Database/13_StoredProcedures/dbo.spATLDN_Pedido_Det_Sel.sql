SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Pedido_Det
CREATE procedure[dbo].[spATLDN_Pedido_Det_Sel]--190,'D'
(
	@Cd_Pedido			VARCHAR(25),
	--@Num_Pedido 		VarChar(30),
	@Cd_Shipper			varchar(10),
	@Cd_Consignee		varchar(10),
	@Item				VarChar(6),
	@Lote				VarChar(30),
	@Cd_Proc_Cliente	VarChar(30),
	@Tipo				char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
*/

if @Tipo = 'A'  or @Tipo = 'B' 
	Begin	
		select 
			convert(varchar(25),'Saved')	[Status],
			PD.cd_pedido					[Order Code],
			PE.Num_Pedido					[Order Number],
			PD.cd_produto					[Code],
			PC.cd_Proc_Cliente				[Product Code],
			PC.Produto_Descr				[Product Description],
			PD.Lote							[2ª Ref. (Delivery Note)],
			PD.Item							[Item], 
			PD.Qty							[Qty],
			
			PE.Cd_Shipper					[Shipper Code],
			Shipper.Apelido					[Shipper Name],		
			
			PE.Cd_Consignee					[Consignee Code],
			Consignee.Apelido				[Consignee Name],			
			Ps.Num_Proc						[JOB],
			PE.Cd_Grupo						[Group Code],
			Grupo.Apelido					[Group]
	
		from Pedido_Det	PD with(nolock)			
			left join Pedido	PE with(nolock) on PE.Cd_pedido = PD.cd_pedido
			left join Pessoa	Shipper	with(nolock)on Shipper.Cd_Pes = PE.Cd_Shipper
			left join Pessoa	Consignee with(nolock)on Consignee.Cd_Pes = PE.Cd_Consignee	
			left join Pessoa	Grupo with(nolock)on Grupo.Cd_Pes = PE.cd_grupo	
			left join Pedido_Ship PS with(nolock) on PS.cd_pedido=PD.Cd_Pedido and PS.cd_produto=PD.Cd_Produto and
				ps.Item = PD.Item AND PS.Lote = PD.Lote		
			left join vwClienteALLJOBs JOB  with(nolock) on PS.Num_Proc = JOB.num_proc
			left join Pessoa_LLP P with(nolock) on P.Cd_Pes = JOB.cd_cliente	
			left join Produto_Cliente PC with(nolock) on PC.cd_prod = PD.cd_produto and PC.cd_Cliente = PE.cd_grupo		
			left join Usuario US with(nolock) on Us.Cd_Usuario = PS.cd_usuario
		where
			PD.Cd_Pedido = @Cd_Pedido
			--P.Num_Pedido = @Num_Pedido 
			and (PE.Cd_Seller = @Cd_Shipper or PE.Cd_Shipper=@Cd_Shipper) 
			and (PE.cd_Buyer = @Cd_Consignee or PE.Cd_Consignee=@Cd_Consignee)
			and PD.Item = @Item
			and PC.Cd_Proc_Cliente = @Cd_Proc_Cliente
			and PD.Lote = @Lote
			and PE.Status<>'E'
			and PE.Dt_Pedido is not null
			
	End

if @Tipo = 'C'  or @Tipo = 'D'
	Begin
		select 
			convert(varchar(25),'Saved')	[Status],
			PD.cd_pedido					[Order Code],
			PE.Num_Pedido					[Order Number],
			PD.cd_produto					[Code],
			PC.cd_Proc_Cliente				[Product Code],
			PC.Produto_Descr				[Product Description],
			PD.Lote							[2ª Ref. (Delivery Note)],
			PD.Item							[Item], 
			PD.Qty							[Qty],
			
			PE.Cd_Shipper					[Shipper Code],
			Shipper.Apelido					[Shipper Name],		
			
			PE.Cd_Consignee					[Consignee Code],
			Consignee.Apelido				[Consignee Name],			
			Ps.Num_Proc						[JOB],
			PE.Cd_Grupo						[Group Code],
			Grupo.Apelido					[Group]
	
		from Pedido_Det	PD with(nolock)			
			left join Pedido	PE with(nolock) on PE.Cd_pedido = PD.cd_pedido
			left join Pessoa	Shipper	with(nolock)on Shipper.Cd_Pes = PE.Cd_Shipper
			left join Pessoa	Consignee with(nolock)on Consignee.Cd_Pes = PE.Cd_Consignee	
			left join Pessoa	Grupo with(nolock)on Grupo.Cd_Pes = PE.cd_grupo	
			left join Pedido_Ship PS with(nolock) on PS.cd_pedido=PD.Cd_Pedido and PS.cd_produto=PD.Cd_Produto and
				ps.Item = PD.Item AND PS.Lote = PD.Lote		
			left join vwClienteALLJOBs JOB  with(nolock) on PS.Num_Proc = JOB.num_proc
			left join Pessoa_LLP P with(nolock) on P.Cd_Pes = JOB.cd_cliente	
			left join Produto_Cliente PC with(nolock) on PC.cd_prod = PD.cd_produto and PC.cd_Cliente = PE.cd_grupo		
			left join Usuario US with(nolock) on Us.Cd_Usuario = PS.cd_usuario
		where
			PD.Cd_Pedido = @Cd_Pedido
			--P.Num_Pedido = @Num_Pedido 
			and (PE.Cd_Seller = @Cd_Shipper or PE.Cd_Shipper=@Cd_Shipper) 
			and (PE.cd_Buyer = @Cd_Consignee or PE.Cd_Consignee=@Cd_Consignee)
			and PD.Item = @Item
			and PC.Cd_Proc_Cliente = @Cd_Proc_Cliente
			and PD.Lote = @Lote
			and PE.Status<>'E'
			and PE.Dt_Pedido is not null
	End
	

	

	
GO
