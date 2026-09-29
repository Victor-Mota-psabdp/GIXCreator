SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Pedido_Det_Perigoso
CREATE procedure [dbo].[spATL_Pedido_Det_Perigoso_Sel]
(
	@Cd_Pedido			int,
	@Cd_Produto			int,
	@Lote				varchar(30),
	@Item				varchar(4),
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

if @Tipo = 'A' or @Tipo = 'B'
	Begin	
		select
			'Saved'								[Status],
			Pedido_Det.Cd_Pedido				[Order Code],
			Pedido_Det.Cd_Produto				[Product Code],
			Produto_Cliente.cd_Proc_Cliente		[Client Product Code],
			Produto_Cliente.Produto_Descr		[Client Product Description],
			Pedido_Det.Lote						[2ª Ref. (Delivery Note)],
			Pedido_Det.Item						[Item], 
			Pedido.Cd_Grupo						[Group Code],
			Grupo.Apelido						[Group Name],
			Pedido_Det_Perigoso.HAZMAT_CD				[HAZMAT_CD],   
			Pedido_Det_Perigoso.HAZMAT_CLASS_CD			[HAZMAT_CLASS_CD],   
			Pedido_Det_Perigoso.HAZMAT_DESC				[HAZMAT_DESC],   
			Pedido_Det_Perigoso.HAZMAT_CONTACT			[HAZMAT_CONTACT],   
			Pedido_Det_Perigoso.HAZMAT_PAGE				[HAZMAT_PAGE],   
			Pedido_Det_Perigoso.HAZMAT_FPOINT				[HAZMAT_FPOINT],   
			Pedido_Det_Perigoso.HAZMAT_FPOINT_CD			[HAZMAT_FPOINT_CD],   
			Pedido_Det_Perigoso.HAZMAT_PULL_DESC_FRM_BDP	[HAZMAT_PULL_DESC_FRM_BDP],   
			Pedido_Det_Perigoso.HAZMAT_ORG_DESC				[HAZMAT_ORG_DESC],   
			Pedido_Det_Perigoso.HAZMAT_DESC_QUAL			[HAZMAT_DESC_QUAL]	
		from Pedido_Det					Pedido_Det with(nolock) 
			join Pedido					Pedido	with(nolock) on Pedido.Cd_pedido = Pedido_Det.Cd_pedido
			JOIN Pedido_Det_Perigoso	Pedido_Det_Perigoso with(nolock)  on Pedido_Det_Perigoso.Cd_pedido = Pedido_Det.Cd_pedido
				and Pedido_Det_Perigoso.cd_produto = Pedido_Det.cd_produto and Pedido_Det_Perigoso.Item = Pedido_Det.Item
				and Pedido_Det_Perigoso.Lote = Pedido_Det.Lote
			join Produto_Cliente		Produto_Cliente with(nolock)  on Produto_Cliente.cd_prod = Pedido_Det.Cd_Produto and Produto_Cliente.cd_Cliente =Pedido.Cd_Grupo 			
			left join Pessoa			Grupo	with(nolock) on Grupo.Cd_Pes = Pedido.Cd_Grupo
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin	
		select
			'Saved'								[Status],
			Pedido_Det.Cd_Pedido				[Order Code],
			Pedido_Det.Cd_Produto				[Product Code],
			Produto_Cliente.cd_Proc_Cliente		[Client Product Code],
			Produto_Cliente.Produto_Descr		[Client Product Description],
			Pedido_Det.Lote						[2ª Ref. (Delivery Note)],
			Pedido_Det.Item						[Item], 
			Pedido.Cd_Grupo						[Group Code],
			Grupo.Apelido						[Group Name],
			Pedido_Det_Perigoso.HAZMAT_CD				[HAZMAT_CD],   
			Pedido_Det_Perigoso.HAZMAT_CLASS_CD			[HAZMAT_CLASS_CD],   
			Pedido_Det_Perigoso.HAZMAT_DESC				[HAZMAT_DESC],   
			Pedido_Det_Perigoso.HAZMAT_CONTACT			[HAZMAT_CONTACT],   
			Pedido_Det_Perigoso.HAZMAT_PAGE				[HAZMAT_PAGE],   
			Pedido_Det_Perigoso.HAZMAT_FPOINT				[HAZMAT_FPOINT],   
			Pedido_Det_Perigoso.HAZMAT_FPOINT_CD			[HAZMAT_FPOINT_CD],   
			Pedido_Det_Perigoso.HAZMAT_PULL_DESC_FRM_BDP	[HAZMAT_PULL_DESC_FRM_BDP],   
			Pedido_Det_Perigoso.HAZMAT_ORG_DESC				[HAZMAT_ORG_DESC],   
			Pedido_Det_Perigoso.HAZMAT_DESC_QUAL			[HAZMAT_DESC_QUAL]	
		from Pedido_Det					Pedido_Det with(nolock) 
			join Pedido					Pedido	with(nolock) on Pedido.Cd_pedido = Pedido_Det.Cd_pedido
			JOIN Pedido_Det_Perigoso	Pedido_Det_Perigoso with(nolock)  on Pedido_Det_Perigoso.Cd_pedido = Pedido_Det.Cd_pedido
				and Pedido_Det_Perigoso.cd_produto = Pedido_Det.cd_produto and Pedido_Det_Perigoso.Item = Pedido_Det.Item
				and Pedido_Det_Perigoso.Lote = Pedido_Det.Lote
			join Produto_Cliente		Produto_Cliente with(nolock)  on Produto_Cliente.cd_prod = Pedido_Det.Cd_Produto and Produto_Cliente.cd_Cliente =Pedido.Cd_Grupo 			
			left join Pessoa			Grupo	with(nolock) on Grupo.Cd_Pes = Pedido.Cd_Grupo
		where
			Pedido_Det.Cd_Pedido = @Cd_Pedido and 
			Pedido_Det.Cd_Produto = @Cd_Produto and 
			Pedido_Det.Lote = @Lote and 
			Pedido_Det.Item = @Item

	End
	
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select
			'Saved'								[Status],
			Pedido_Det.Cd_Pedido				[Order Code],
			Pedido_Det.Cd_Produto				[Product Code],
			Produto_Cliente.cd_Proc_Cliente		[Client Product Code],
			Produto_Cliente.Produto_Descr		[Client Product Description],
			Pedido_Det.Lote						[2ª Ref. (Delivery Note)],
			Pedido_Det.Item						[Item], 
			Pedido.Cd_Grupo						[Group Code],
			Grupo.Apelido						[Group Name],
			Pedido_Det_Perigoso.HAZMAT_CD				[HAZMAT_CD],   
			Pedido_Det_Perigoso.HAZMAT_CLASS_CD			[HAZMAT_CLASS_CD],   
			Pedido_Det_Perigoso.HAZMAT_DESC				[HAZMAT_DESC],   
			Pedido_Det_Perigoso.HAZMAT_CONTACT			[HAZMAT_CONTACT],   
			Pedido_Det_Perigoso.HAZMAT_PAGE				[HAZMAT_PAGE],   
			Pedido_Det_Perigoso.HAZMAT_FPOINT				[HAZMAT_FPOINT],   
			Pedido_Det_Perigoso.HAZMAT_FPOINT_CD			[HAZMAT_FPOINT_CD],   
			Pedido_Det_Perigoso.HAZMAT_PULL_DESC_FRM_BDP	[HAZMAT_PULL_DESC_FRM_BDP],   
			Pedido_Det_Perigoso.HAZMAT_ORG_DESC				[HAZMAT_ORG_DESC],   
			Pedido_Det_Perigoso.HAZMAT_DESC_QUAL			[HAZMAT_DESC_QUAL]	
		from Pedido_Det					Pedido_Det with(nolock) 
			join Pedido					Pedido	with(nolock) on Pedido.Cd_pedido = Pedido_Det.Cd_pedido
			JOIN Pedido_Det_Perigoso	Pedido_Det_Perigoso with(nolock)  on Pedido_Det_Perigoso.Cd_pedido = Pedido_Det.Cd_pedido
				and Pedido_Det_Perigoso.cd_produto = Pedido_Det.cd_produto and Pedido_Det_Perigoso.Item = Pedido_Det.Item
				and Pedido_Det_Perigoso.Lote = Pedido_Det.Lote
			join Produto_Cliente		Produto_Cliente with(nolock)  on Produto_Cliente.cd_prod = Pedido_Det.Cd_Produto and Produto_Cliente.cd_Cliente =Pedido.Cd_Grupo 			
			left join Pessoa			Grupo	with(nolock) on Grupo.Cd_Pes = Pedido.Cd_Grupo
		where
			Pedido_Det.Cd_Pedido = @Cd_Pedido and 
			Pedido_Det.Cd_Produto = @Cd_Produto and 
			Pedido_Det.Lote = @Lote and 
			Pedido_Det.Item = @Item
	End

GO
