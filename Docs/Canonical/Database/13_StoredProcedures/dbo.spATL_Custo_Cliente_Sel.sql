SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Custo_Cliente  
CREATE procedure [dbo].[spATL_Custo_Cliente_Sel]
(
	@Num_Proc			Varchar(16),
	@Num_Pedido			varchar(30),
	@Cd_Pedido			int,
	@Cd_Produto			int,
	@Cd_tp_tx			varchar(3),
	@Tipo				char(1)
)
as


if @Tipo = 'A' or @Tipo = 'B'
	Begin	
		select 
			convert(varchar(25),'Saved')	[Status],
			CC.Num_Proc						[JOB],
			CC.cd_pedido					[Order Code],
			PE.Num_Pedido					[Order Number],
			CC.cd_produto					[Product Code],
			PC.cd_Proc_Cliente				[Product ID],
			PC.Produto_Descr				[Product Description],
			CC.Cd_Tp_Tx						[Charge Code],
			TT.Nome_Tp_Tx					[Charge Name],	
			CC.Vlr_Item_Custo				[Value],
			CC.Num_NF_Custo					[NF],
			CC.Prestacao					[Invoicing]			
		from Custo_Cliente CC with(nolock)
			left join Pedido PE with(nolock) on PE.Cd_pedido = CC.cd_pedido
			left join vwClienteALLJOBs JOB  with(nolock) on CC.Num_Proc = JOB.num_proc		
			left join Produto_Cliente PC with(nolock) on PC.cd_prod = CC.cd_produto and PC.cd_Cliente = PE.Cd_Grupo		
			left Join Tipo_Taxa	TT on TT.Cd_Tp_Tx=CC.Cd_Tp_Tx
		where
			CC.Cd_Pedido = @Cd_Pedido
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin	
		select 
			convert(varchar(25),'Saved')	[Status],
			CC.Num_Proc						[JOB],
			CC.cd_pedido					[Order Code],
			PE.Num_Pedido					[Order Number],
			CC.cd_produto					[Product Code],
			PC.cd_Proc_Cliente				[Product ID],
			PC.Produto_Descr				[Product Description],
			CC.Cd_Tp_Tx						[Charge Code],
			TT.Nome_Tp_Tx					[Charge Name],	
			CC.Vlr_Item_Custo				[Value],
			CC.Num_NF_Custo					[NF],
			CC.Prestacao					[Invoicing]			
		from Custo_Cliente CC with(nolock)
			left join Pedido PE with(nolock) on PE.Cd_pedido = CC.cd_pedido
			left join vwClienteALLJOBs JOB  with(nolock) on CC.Num_Proc = JOB.num_proc		
			left join Produto_Cliente PC with(nolock) on PC.cd_prod = CC.cd_produto and PC.cd_Cliente = PE.Cd_Grupo		
			left Join Tipo_Taxa	TT on TT.Cd_Tp_Tx=CC.Cd_Tp_Tx
		where
			PE.Num_Pedido = @Num_Pedido
	End
	
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select 
			convert(varchar(25),'Saved')	[Status],
			CC.Num_Proc						[JOB],
			CC.cd_pedido					[Order Code],
			PE.Num_Pedido					[Order Number],
			CC.cd_produto					[Product Code],
			PC.cd_Proc_Cliente				[Product ID],
			PC.Produto_Descr				[Product Description],
			CC.Cd_Tp_Tx						[Charge Code],
			TT.Nome_Tp_Tx					[Charge Name],	
			CC.Vlr_Item_Custo				[Value],
			CC.Num_NF_Custo					[NF],
			CC.Prestacao					[Invoicing]			
		from Custo_Cliente CC with(nolock)
			left join Pedido PE with(nolock) on PE.Cd_pedido = CC.cd_pedido
			left join vwClienteALLJOBs JOB  with(nolock) on CC.Num_Proc = JOB.num_proc		
			left join Produto_Cliente PC with(nolock) on PC.cd_prod = CC.cd_produto and PC.cd_Cliente = PE.Cd_Grupo		
			left Join Tipo_Taxa	TT on TT.Cd_Tp_Tx=CC.Cd_Tp_Tx
		where
			CC.Num_Proc = @Num_Proc
	End


if @Tipo = 'P' 
	Begin
		select 
			convert(varchar(25),'Saved')	[Status],
			CC.Num_Proc						[JOB],
			CC.cd_pedido					[Order Code],
			PE.Num_Pedido					[Order Number],
			CC.cd_produto					[Product Code],
			PC.cd_Proc_Cliente				[Product ID],
			PC.Produto_Descr				[Product Description],
			CC.Cd_Tp_Tx						[Charge Code],
			TT.Nome_Tp_Tx					[Charge Name],	
			CC.Vlr_Item_Custo				[Value],
			CC.Num_NF_Custo					[NF],
			CC.Prestacao					[Invoicing]			
		from Custo_Cliente CC with(nolock)
			left join Pedido PE with(nolock) on PE.Cd_pedido = CC.cd_pedido
			left join vwClienteALLJOBs JOB  with(nolock) on CC.Num_Proc = JOB.num_proc		
			left join Produto_Cliente PC with(nolock) on PC.cd_prod = CC.cd_produto and PC.cd_Cliente = PE.Cd_Grupo		
			left Join Tipo_Taxa	TT on TT.Cd_Tp_Tx=CC.Cd_Tp_Tx
		where
			CC.Num_Proc = @Num_Proc
			AND CC.Cd_Pedido = @Cd_Pedido
			AND CC.Cd_Produto = @Cd_Produto
			AND CC.Cd_tp_tx = @Cd_tp_tx
	End

if @Tipo = 'Q' 
	Begin
		select 
			convert(varchar(25),'Saved')	[Status],
			CC.Num_Proc						[JOB],
			CC.cd_pedido					[Order Code],
			PE.Num_Pedido					[Order Number],
			CC.cd_produto					[Product Code],
			PC.cd_Proc_Cliente				[Product ID],
			PC.Produto_Descr				[Product Description],
			CC.Cd_Tp_Tx						[Charge Code],
			TT.Nome_Tp_Tx					[Charge Name],	
			CC.Vlr_Item_Custo				[Value],
			CC.Num_NF_Custo					[NF],
			CC.Prestacao					[Invoicing]			
		from Custo_Cliente CC with(nolock)
			left join Pedido PE with(nolock) on PE.Cd_pedido = CC.cd_pedido
			left join vwClienteALLJOBs JOB  with(nolock) on CC.Num_Proc = JOB.num_proc		
			left join Produto_Cliente PC with(nolock) on PC.cd_prod = CC.cd_produto and PC.cd_Cliente = PE.Cd_Grupo		
			left Join Tipo_Taxa	TT on TT.Cd_Tp_Tx=CC.Cd_Tp_Tx
		where
			CC.Num_Proc = @Num_Proc
			AND PE.Num_Pedido = @Num_Pedido
			AND CC.Cd_Produto = @Cd_Produto
			AND CC.Cd_tp_tx = @Cd_tp_tx
	End



GO
