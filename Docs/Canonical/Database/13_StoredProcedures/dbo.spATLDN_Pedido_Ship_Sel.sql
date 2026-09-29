SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Pedido_Ship  
CREATE procedure [dbo].[spATLDN_Pedido_Ship_Sel]
(
	@Cd_Pedido			int,
	@Num_Pedido			varchar(30),
	@Cd_Produto			int,
	@Cd_Proc_Cliente	VarChar(30),
	@Item				Varchar(6),
	@Lote				varchar(30),
	@Num_Proc			varchar(16),
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
V  /// Buscar o produto do cliente com tratamento no codigo_do produto, usar na
	   integração do fazcomex  

*/

if @Tipo = 'A' or @Tipo = 'B'
	Begin	
		select 
			convert(varchar(25),'Saved')	[Status],
			PS.cd_pedido					[Order Code],
			PE.Num_Pedido					[Order Number],
			PS.cd_produto					[Product Code],
			PC.cd_Proc_Cliente				[Product ID],
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
		where
			PS.Cd_Pedido = @Cd_Pedido	
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin	
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
		where
			PE.Num_Pedido = @Num_Pedido
	End
	
if @Tipo = 'N' or @Tipo = 'O'
	Begin
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
		where
			PS.Num_Proc = @Num_Proc
	End
	
if @Tipo = 'P' 
	Begin
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
		where
			PS.Num_Proc = @Num_Proc
			AND PS.Cd_Pedido = @Cd_Pedido
			--P.Num_Pedido = @Num_Pedido 			
			and PS.item = @Item
			and PC.Cd_Proc_Cliente = @Cd_Proc_Cliente
			and PS.Lote = @Lote
			--and status<>'E'
			--and Dt_Pedido is not null
	
	End
	
if @Tipo = 'Q'
	Begin
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
		where
			PS.Num_Proc = @Num_Proc
			--AND PS.Cd_Pedido = @Cd_Pedido
			AND PE.Num_Pedido = @Num_Pedido 			
			and PS.item = @Item
			and PC.Cd_Proc_Cliente = @Cd_Proc_Cliente
			and PS.Lote = @Lote
			--and status<>'E'
			--and Dt_Pedido is not null
	
	End

--solicitacao de LI -SLI/Produto
if @Tipo = 'S'
	Begin
		select 
			convert(varchar(25),'Saved')	[Status],
			PS.cd_pedido					[Order Code],
			PE.Num_Pedido					[Order Number],
			PS.cd_produto					[Product Code],
			PC.cd_Proc_Cliente				[Product ID],
			PC.Produto_Descr				[Product Description],
			Ps.Lote							[2ª Ref. (Delivery Note)],
			Ps.item							[Item],
			--Ps.Qty							[Qty],		
			Ps.Num_Proc						[JOB],
			PS.cd_usuario					[User Code],
			US.Nome_Usuario					[User Name],			
			
			PE.cd_tp_moeda					[Currency Code],
			TM.Nome_Tp_Moeda				[Currency Name],			
			PD.NCM							[NCM Code],
			NCM.Descricao_NCM				[NCM Description],
			sum(PS.Qty)						[Qty],			
			sum(PD.Peso_Bruto_TOT)			[Gross Weight],
			sum(PD.Peso_Liquido_TOT)		[Net Weight],
			max(PD.Vlr_Item)				[Unit Price]
		from Pedido_Ship PS with(nolock)
			join Pedido_Det PD with(nolock) on PS.cd_pedido=PD.Cd_Pedido and PS.cd_produto=PD.Cd_Produto and
				ps.Item = PD.Item AND PS.Lote = PD.Lote
			left join Pedido PE with(nolock) on PE.Cd_pedido = PS.cd_pedido
			left join Tipo_Moeda TM on TM.Cd_Tp_Moeda = PE.cd_tp_moeda
			left join vwClienteALLJOBs JOB  with(nolock) on PS.Num_Proc = JOB.num_proc
			left join Pessoa_LLP P with(nolock) on P.Cd_Pes = JOB.cd_cliente	
			left join Produto_Cliente PC with(nolock) on PC.cd_prod = PS.cd_produto and PC.cd_Cliente = P.Cd_Pes_Grupo		
			left join Usuario US with(nolock) on Us.Cd_Usuario = PS.cd_usuario
			Left Join NCM			With(noLock) on NCM.NCM=PD.NCM
		where
			PS.Num_Proc = @Num_Proc
		group by 
			PS.cd_pedido,PE.Num_Pedido,PS.cd_produto,PC.cd_Proc_Cliente,
			PC.Produto_Descr,Ps.Lote,Ps.item,Ps.Num_Proc,PS.cd_usuario,
			US.Nome_Usuario,			
			PE.cd_tp_moeda,TM.Nome_Tp_Moeda,PD.NCM,NCM.Descricao_NCM
	End

--estou usando p carregar o SLI/Produto
if @Tipo = 'T'
	Begin
		select 
			convert(varchar(25),'Saved')	[Status],
			PS.cd_pedido					[Order Code],
			PE.Num_Pedido					[Order Number],
			PS.cd_produto					[Product Code],
			PC.cd_Proc_Cliente				[Product ID],
			PC.Produto_Descr				[Product Description],
			Ps.Lote							[2ª Ref. (Delivery Note)],
			Ps.item							[Item],
			--Ps.Qty							[Qty],		
			Ps.Num_Proc						[JOB],
			PS.cd_usuario					[User Code],
			US.Nome_Usuario					[User Name],			
			
			PE.cd_tp_moeda					[Currency Code],
			TM.Nome_Tp_Moeda				[Currency Name],			
			PD.NCM							[NCM Code],
			NCM.Descricao_NCM				[NCM Description],
			sum(PS.Qty)						[Qty],			
			sum(PD.Peso_Bruto_TOT)			[Gross Weight],
			sum(PD.Peso_Liquido_TOT)		[Net Weight],
			max(PD.Vlr_Item)				[Unit Price]
		from Pedido_Ship PS with(nolock)
			join Pedido_Det PD with(nolock) on PS.cd_pedido=PD.Cd_Pedido and PS.cd_produto=PD.Cd_Produto and
				ps.Item = PD.Item AND PS.Lote = PD.Lote
			left join Pedido PE with(nolock) on PE.Cd_pedido = PS.cd_pedido
			left join Tipo_Moeda TM on TM.Cd_Tp_Moeda = PE.cd_tp_moeda
			left join vwClienteALLJOBs JOB  with(nolock) on PS.Num_Proc = JOB.num_proc
			left join Pessoa_LLP P with(nolock) on P.Cd_Pes = JOB.cd_cliente	
			left join Produto_Cliente PC with(nolock) on PC.cd_prod = PS.cd_produto and PC.cd_Cliente = P.Cd_Pes_Grupo		
			left join Usuario US with(nolock) on Us.Cd_Usuario = PS.cd_usuario
			Left Join NCM			With(noLock) on NCM.NCM=PD.NCM
		where
			PS.Num_Proc = @Num_Proc and PC.cd_Proc_Cliente = @Cd_Proc_Cliente		
		group by 
			PS.cd_pedido,PE.Num_Pedido,PS.cd_produto,PC.cd_Proc_Cliente,
			PC.Produto_Descr,Ps.Lote,Ps.item,Ps.Num_Proc,PS.cd_usuario,
			US.Nome_Usuario,		
			PE.cd_tp_moeda,TM.Nome_Tp_Moeda,PD.NCM,NCM.Descricao_NCM
	
	End


--estou usando p carregar na DLL Atalntis - BLL_Pedido - verificar se já tem Pedido_Ship amarrado
if @Tipo = 'U'
	Begin
		select 
			convert(varchar(25),'Saved')	[Status],
			PS.cd_pedido					[Order Code],
			PE.Num_Pedido					[Order Number],
			PS.cd_produto					[Product Code],
			PC.cd_Proc_Cliente				[Product ID],
			PC.Produto_Descr				[Product Description],
			Ps.Lote							[2ª Ref. (Delivery Note)],
			Ps.item							[Item],
			--Ps.Qty							[Qty],		
			Ps.Num_Proc						[JOB],
			PS.cd_usuario					[User Code],
			US.Nome_Usuario					[User Name],			
			
			PE.cd_tp_moeda					[Currency Code],
			TM.Nome_Tp_Moeda				[Currency Name],			
			PD.NCM							[NCM Code],
			NCM.Descricao_NCM				[NCM Description],
			sum(PS.Qty)						[Qty],			
			sum(PD.Peso_Bruto_TOT)			[Gross Weight],
			sum(PD.Peso_Liquido_TOT)		[Net Weight],
			max(PD.Vlr_Item)				[Unit Price]
		from Pedido_Ship PS with(nolock)
			join Pedido_Det PD with(nolock) on PS.cd_pedido=PD.Cd_Pedido and PS.cd_produto=PD.Cd_Produto and
				ps.Item = PD.Item AND PS.Lote = PD.Lote
			left join Pedido PE with(nolock) on PE.Cd_pedido = PS.cd_pedido
			left join Tipo_Moeda TM on TM.Cd_Tp_Moeda = PE.cd_tp_moeda
			left join vwClienteALLJOBs JOB  with(nolock) on PS.Num_Proc = JOB.num_proc
			left join Pessoa_LLP P with(nolock) on P.Cd_Pes = JOB.cd_cliente	
			left join Produto_Cliente PC with(nolock) on PC.cd_prod = PS.cd_produto and PC.cd_Cliente = P.Cd_Pes_Grupo		
			left join Usuario US with(nolock) on Us.Cd_Usuario = PS.cd_usuario
			Left Join NCM			With(noLock) on NCM.NCM=PD.NCM
		where		
			PS.Cd_Pedido = @Cd_Pedido					
			and PS.Cd_Produto = @Cd_Produto
			and PS.item = @Item
			and PS.Lote = @Lote	
			/*PS.cd_pedido = '" & lblCodigo.Caption & "' 
            and cd_proc_cliente = '" & strProduto & "' and item = '" & StrItem & "' and lote = '" & strLote & "'"*/
		group by 
			PS.cd_pedido,PE.Num_Pedido,PS.cd_produto,PC.cd_Proc_Cliente,
			PC.Produto_Descr,Ps.Lote,Ps.item,Ps.Num_Proc,PS.cd_usuario,
			US.Nome_Usuario,		
			PE.cd_tp_moeda,TM.Nome_Tp_Moeda,PD.NCM,NCM.Descricao_NCM
	
	End

-- Pegrar o produto do jeito que vem da nota fiscal do fazcomex e acrescentar zeros 
-- pegar o que ta na base e acrescentar zeros e fazer a comparação para localizar 
-- o pedidos ship 
if @Tipo = 'V' 
	Begin

	select 
			convert(varchar(25),'Saved')	[Status],
			PS.cd_pedido					[Order Code],
			PE.Num_Pedido					[Order Number],
			PS.cd_produto					[Product Code],
			PC.cd_Proc_Cliente				[Product ID],
			PC.Produto_Descr				[Product Description],
			Ps.Lote							[2ª Ref. (Delivery Note)],
			Ps.item							[Item],
			--Ps.Qty							[Qty],		
			Ps.Num_Proc						[JOB],
			PS.cd_usuario					[User Code],
			US.Nome_Usuario					[User Name],			
			
			PE.cd_tp_moeda					[Currency Code],
			TM.Nome_Tp_Moeda				[Currency Name],			
			PD.NCM							[NCM Code],
			NCM.Descricao_NCM				[NCM Description],
			sum(PS.Qty)						[Qty],			
			sum(PD.Peso_Bruto_TOT)			[Gross Weight],
			sum(PD.Peso_Liquido_TOT)		[Net Weight],
			max(PD.Vlr_Item)				[Unit Price]
		from Pedido_Ship PS with(nolock)
			join Pedido_Det PD with(nolock) on PS.cd_pedido=PD.Cd_Pedido and PS.cd_produto=PD.Cd_Produto and
				ps.Item = PD.Item AND PS.Lote = PD.Lote
			left join Pedido PE with(nolock) on PE.Cd_pedido = PS.cd_pedido
			left join Tipo_Moeda TM on TM.Cd_Tp_Moeda = PE.cd_tp_moeda
			left join vwClienteALLJOBs JOB  with(nolock) on PS.Num_Proc = JOB.num_proc
			left join Pessoa_LLP P with(nolock) on P.Cd_Pes = JOB.cd_cliente	
			left join Produto_Cliente PC with(nolock) on PC.cd_prod = PS.cd_produto 
			                                          and PC.cd_Cliente = P.Cd_Pes_Grupo		
			left join Usuario US with(nolock) on Us.Cd_Usuario = PS.cd_usuario
			Left Join NCM			With(noLock) on NCM.NCM=PD.NCM
		where
			PS.Num_Proc = @num_Proc 
			and right('000000000000000000' + PC.cd_proc_cliente,18) 
		   	=   right('000000000000000000' +  @Cd_Proc_Cliente,18)		
		group by 
			PS.cd_pedido,PE.Num_Pedido,PS.cd_produto,PC.cd_Proc_Cliente,
			PC.Produto_Descr,Ps.Lote,Ps.item,Ps.Num_Proc,PS.cd_usuario,
			US.Nome_Usuario,		
			PE.cd_tp_moeda,TM.Nome_Tp_Moeda,PD.NCM,NCM.Descricao_NCM
End 

/*ALTER procedure [dbo].[spATL_Pedido_Ship_Sel]
(
	@Cd_Pedido			varchar(30),
	@Num_Pedido			varchar(30),
	@Num_Proc			varchar(16),
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

if @Tipo = 'A' or @Tipo = 'B'
	Begin	
		select 
			convert(varchar(25),'Saved')		[Status],
			PS.cd_pedido		[Order Code],
			PE.Num_Pedido		[Order Number],
			PS.cd_produto		[Code],
			PC.cd_Proc_Cliente	[Product Code],
			PC.Produto_Descr	[Product Description],
			Ps.Num_Proc			[JOB],
			Ps.item				[Item]
			--falta os outros campos			
		from Pedido_Ship PS with(nolock)
			join Pedido_Det PD with(nolock) on PS.cd_pedido=PD.Cd_Pedido and PS.cd_produto=PD.Cd_Produto and
				ps.Item = PD.Item AND PS.Lote = PD.Lote
			left join Pedido PE with(nolock) on PE.Cd_pedido = PS.cd_pedido
			left join vwClienteALLJOBs JOB  with(nolock) on PS.Num_Proc = JOB.num_proc
			left join Pessoa_LLP P with(nolock) on P.Cd_Pes = JOB.cd_cliente	
			left join Produto_Cliente PC with(nolock) on PC.cd_prod = PS.cd_produto and PC.cd_Cliente = P.Cd_Pes_Grupo		
			left join Usuario US with(nolock) on Us.Cd_Usuario = PS.cd_usuario
		where
			PS.Cd_Pedido = @Cd_Pedido	
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin	
		select 
		convert(varchar(25),'Saved')		[Status],
			PS.cd_pedido		[Order Code],
			PE.Num_Pedido		[Order Number],
			PS.cd_produto		[Code],
			PC.cd_Proc_Cliente	[Product Code],
			PC.Produto_Descr	[Product Description],
			Ps.Num_Proc			[JOB],
			Ps.item				[Item]
			--falta os outros campos			
		from Pedido_Ship PS with(nolock)
			join Pedido_Det PD with(nolock) on PS.cd_pedido=PD.Cd_Pedido and PS.cd_produto=PD.Cd_Produto and
				ps.Item = PD.Item AND PS.Lote = PD.Lote
			left join Pedido PE with(nolock) on PE.Cd_pedido = PS.cd_pedido
			left join vwClienteALLJOBs JOB  with(nolock) on PS.Num_Proc = JOB.num_proc
			left join Pessoa_LLP P with(nolock) on P.Cd_Pes = JOB.cd_cliente	
			left join Produto_Cliente PC with(nolock) on PC.cd_prod = PS.cd_produto and PC.cd_Cliente = P.Cd_Pes_Grupo		
			left join Usuario US with(nolock) on Us.Cd_Usuario = PS.cd_usuario
		where
			PE.Num_Pedido = @Num_Pedido
	End
	
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select 
		convert(varchar(25),'Saved')		[Status],
			PS.cd_pedido		[Order Code],
			PE.Num_Pedido		[Order Number],
			PS.cd_produto		[Code],
			PC.cd_Proc_Cliente	[Product Code],
			PC.Produto_Descr	[Product Description],
			Ps.Num_Proc			[JOB],
			Ps.item				[Item]
			--falta os outros campos			
		from Pedido_Ship PS with(nolock)
			join Pedido_Det PD with(nolock) on PS.cd_pedido=PD.Cd_Pedido and PS.cd_produto=PD.Cd_Produto and
				ps.Item = PD.Item AND PS.Lote = PD.Lote
			left join Pedido PE with(nolock) on PE.Cd_pedido = PS.cd_pedido
			left join vwClienteALLJOBs JOB  with(nolock) on PS.Num_Proc = JOB.num_proc
			left join Pessoa_LLP P with(nolock) on P.Cd_Pes = JOB.cd_cliente	
			left join Produto_Cliente PC with(nolock) on PC.cd_prod = PS.cd_produto and PC.cd_Cliente = P.Cd_Pes_Grupo		
			left join Usuario US with(nolock) on Us.Cd_Usuario = PS.cd_usuario
		where
			PS.Num_Proc = @Num_Proc
	End
	
if @Tipo = 'P' 
	Begin
		select 
		convert(varchar(25),'Saved')		[Status],
			PS.cd_pedido		[Order Code],
			PE.Num_Pedido		[Order Number],
			PS.cd_produto		[Code],
			PC.cd_Proc_Cliente	[Product Code],
			PC.Produto_Descr	[Product Description],
			Ps.Num_Proc			[JOB],
			Ps.item				[Item]
			--falta os outros campos			
		from Pedido_Ship PS with(nolock)
			join Pedido_Det PD with(nolock) on PS.cd_pedido=PD.Cd_Pedido and PS.cd_produto=PD.Cd_Produto and
				ps.Item = PD.Item AND PS.Lote = PD.Lote
			left join Pedido PE with(nolock) on PE.Cd_pedido = PS.cd_pedido
			left join vwClienteALLJOBs JOB  with(nolock) on PS.Num_Proc = JOB.num_proc
			left join Pessoa_LLP P with(nolock) on P.Cd_Pes = JOB.cd_cliente	
			left join Produto_Cliente PC with(nolock) on PC.cd_prod = PS.cd_produto and PC.cd_Cliente = P.Cd_Pes_Grupo		
			left join Usuario US with(nolock) on Us.Cd_Usuario = PS.cd_usuario
		where
			PS.Num_Proc = @Num_Proc
			AND PS.Cd_Pedido = @Cd_Pedido
			--P.Num_Pedido = @Num_Pedido 			
			and PS.item = @Item
			and PC.Cd_Proc_Cliente = @Cd_Proc_Cliente
			and PS.Lote = @Lote
			--and status<>'E'
			--and Dt_Pedido is not null
	
	End
	
if @Tipo = 'Q'
	Begin
		select 
		convert(varchar(25),'Saved')		[Status],
			PS.cd_pedido		[Order Code],
			PE.Num_Pedido		[Order Number],
			PS.cd_produto		[Code],
			PC.cd_Proc_Cliente	[Product Code],
			PC.Produto_Descr	[Product Description],
			Ps.Num_Proc			[JOB],
			Ps.item				[Item]
			--falta os outros campos			
		from Pedido_Ship PS with(nolock)
			join Pedido_Det PD with(nolock) on PS.cd_pedido=PD.Cd_Pedido and PS.cd_produto=PD.Cd_Produto and
				ps.Item = PD.Item AND PS.Lote = PD.Lote
			left join Pedido PE with(nolock) on PE.Cd_pedido = PS.cd_pedido
			left join vwClienteALLJOBs JOB  with(nolock) on PS.Num_Proc = JOB.num_proc
			left join Pessoa_LLP P with(nolock) on P.Cd_Pes = JOB.cd_cliente	
			left join Produto_Cliente PC with(nolock) on PC.cd_prod = PS.cd_produto and PC.cd_Cliente = P.Cd_Pes_Grupo		
			left join Usuario US with(nolock) on Us.Cd_Usuario = PS.cd_usuario
		where
			PS.Num_Proc = @Num_Proc
			--AND PS.Cd_Pedido = @Cd_Pedido
			AND PE.Num_Pedido = @Num_Pedido 			
			and PS.item = @Item
			and PC.Cd_Proc_Cliente = @Cd_Proc_Cliente
			and PS.Lote = @Lote
			--and status<>'E'
			--and Dt_Pedido is not null
	
	End

*/

GO
