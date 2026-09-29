SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Log_CustoCliente  
CREATE procedure [dbo].[spLog_CustoCliente_Sel]
(
	@Num_Proc			Varchar(16),
	@Cd_Pedido			int,
	@Cd_Produto			int,
	@Cd_tp_tx			varchar(3),
	@Tipo				char(1)
)
as


if @Tipo = 'A' or @Tipo = 'B'
	Begin	
		select 
			CC.ID_Log				[Log ID],
			CC.Data_CC				[Log Date],
			CC.Tp_Oper_CC				[Log Type Code],
			ALT.Nome_Tp_Log_Oper	[Log Type Name],

			convert(varchar(25),'Saved')	[Status],
			CC.Num_Proc_CC						[JOB],
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
		from Log_CustoCliente CC with(nolock)
			left join Pedido PE with(nolock) on PE.Cd_pedido = CC.cd_pedido
			left join vwClienteALLJOBs JOB  with(nolock) on CC.Num_Proc_CC = JOB.num_proc		
			left join Produto_Cliente PC with(nolock) on PC.cd_prod = CC.cd_produto and PC.cd_Cliente = PE.Cd_Grupo		
			left Join Tipo_Taxa	TT with(nolock) on TT.Cd_Tp_Tx=CC.Cd_Tp_Tx
			left join Tipo_Log_Oper	Alt	with(nolock) on Alt.Cd_tp_Log_Oper	= CC.Tp_Oper_CC
		where
			CC.Cd_Pedido = @Cd_Pedido
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin	
			select 
			CC.ID_Log				[Log ID],
			CC.Data_CC				[Log Date],
			CC.Tp_Oper_CC				[Log Type Code],
			ALT.Nome_Tp_Log_Oper	[Log Type Name],

			convert(varchar(25),'Saved')	[Status],
			CC.Num_Proc_CC						[JOB],
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
		from Log_CustoCliente CC with(nolock)
			left join Pedido PE with(nolock) on PE.Cd_pedido = CC.cd_pedido
			left join vwClienteALLJOBs JOB  with(nolock) on CC.Num_Proc_CC = JOB.num_proc		
			left join Produto_Cliente PC with(nolock) on PC.cd_prod = CC.cd_produto and PC.cd_Cliente = PE.Cd_Grupo		
			left Join Tipo_Taxa	TT with(nolock) on TT.Cd_Tp_Tx=CC.Cd_Tp_Tx
			left join Tipo_Log_Oper	Alt	with(nolock) on Alt.Cd_tp_Log_Oper	= CC.Tp_Oper_CC
		where
			CC.Cd_Pedido = @Cd_Pedido
	End
	
if @Tipo = 'N' or @Tipo = 'O'
	Begin
			select 
			CC.ID_Log				[Log ID],
			CC.Data_CC				[Log Date],
			CC.Tp_Oper_CC				[Log Type Code],
			ALT.Nome_Tp_Log_Oper	[Log Type Name],

			convert(varchar(25),'Saved')	[Status],
			CC.Num_Proc_CC						[JOB],
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
		from Log_CustoCliente CC with(nolock)
			left join Pedido PE with(nolock) on PE.Cd_pedido = CC.cd_pedido
			left join vwClienteALLJOBs JOB  with(nolock) on CC.Num_Proc_CC = JOB.num_proc		
			left join Produto_Cliente PC with(nolock) on PC.cd_prod = CC.cd_produto and PC.cd_Cliente = PE.Cd_Grupo		
			left Join Tipo_Taxa	TT with(nolock) on TT.Cd_Tp_Tx=CC.Cd_Tp_Tx
			left join Tipo_Log_Oper	Alt	with(nolock) on Alt.Cd_tp_Log_Oper	= CC.Tp_Oper_CC
		where
			CC.Cd_Pedido = @Cd_Pedido
	End



GO
