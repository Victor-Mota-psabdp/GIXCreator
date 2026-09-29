SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE Procedure [dbo].[spRateioConsulidadaBuscaPerc_Sel] 

		@Num_Proc	Varchar(14)

AS


DEclare  @Table Table (

		Cd_Produto_Temp int,
		Qty_Temp	float
		
	)


if left(@num_proc,2)='IA'
	Begin
		SET NOCOUNT ON;

		Insert @Table
		select cd_produto,sum(ps.qty) Qty   from house_imp_aer Hou
		Join Pedido_Ship PS on PS.num_proc=hou.num_proc_hia	
		Join Pedido PD on PD.cd_pedido=PS.cd_pedido
		where num_proc_mia=@num_proc
		Group by cd_produto

		SET NOCOUNT OFf;

		select cd_proc_cliente,produto_descr,num_proc,cd_produto,sum(ps.qty)/sum(qty_temp) Perc,sum(ps.qty) QTD  from house_imp_aer Hou
		Join Pedido_Ship PS on PS.num_proc=hou.num_proc_hia	
		Join Pedido PD on PD.cd_pedido=PS.cd_pedido
		Join @Table TT on TT.cd_produto_temp=cd_produto 
		Join Produto_Cliente PC on PC.cd_prod=cd_produto
		where num_proc_mia=@num_proc
		Group by num_proc,cd_produto,produto_descr,cd_proc_cliente
		order by num_proc	
End

if left(@num_proc,2)='IM'
	Begin
		SET NOCOUNT ON;

		Insert @Table
		select cd_produto,sum(ps.qty) Qty   from house_imp_mar Hou
		Join Pedido_Ship PS on PS.num_proc=hou.num_proc_him	
		Join Pedido PD on PD.cd_pedido=PS.cd_pedido
		where num_proc_mim=@Num_Proc
		Group by cd_produto

		SET NOCOUNT OFF;

		select cd_proc_cliente,produto_descr,num_proc,cd_produto,sum(ps.qty)/sum(qty_temp) Perc,sum(ps.qty) QTD  from house_imp_mar Hou
		Join Pedido_Ship PS on PS.num_proc=hou.num_proc_him	
		Join Pedido PD on PD.cd_pedido=PS.cd_pedido
		Join @Table TT on TT.cd_produto_temp=cd_produto 
		Join Produto_Cliente PC on PC.cd_prod=cd_produto
		where num_proc_mim=@num_proc
		Group by num_proc,cd_produto,produto_descr,cd_proc_cliente
		order by num_proc


	End







GO
