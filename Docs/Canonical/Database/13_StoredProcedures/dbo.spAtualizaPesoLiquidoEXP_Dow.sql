SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spAtualizaPesoLiquidoEXP_Dow]
as


Begin
	insert Exchange
	select null, INV.num_proc, getdate(), 0, null, null, null, null
	from invoice_cliente INV
	join pedido_ship PS on PS.num_proc = INV.num_proc and substring(PS.num_proc,3,3) in ('ROB','CSR','STB')
	join invoice_det DET on DET.id_inv = INV.id_inv and DET.cd_pedido = PS.cd_pedido and DET.cd_produto =PS.cd_produto and convert(int,DET.item) = convert(int,PS.item)
	join pedido_det PD on PD.cd_pedido = PS.cd_pedido and PD.cd_produto =PS.cd_produto and PD.item = PS.item
	where
		substring(INV.num_proc,3,3) in ('ROB','CSR','STB')
		and substring(INV.num_proc,1,1) ='E'
		and data_invoice > '2010-01-01'
		and (DET.peso_liquido <> PD.peso_liquido_tot OR PD.peso_bruto_tot <> DET.peso_bruto)
End


Begin
--	select INV.num_proc, PS.cd_pedido, PS.item itemPS, DET.item itemINV, PS.cd_produto, DET.peso_liquido, PD.peso_liquido_tot 
	update PD set PD.peso_liquido_tot = DET.peso_liquido, PD.peso_bruto_tot = DET.peso_bruto
	from invoice_cliente INV
	join pedido_ship PS on PS.num_proc = INV.num_proc and substring(PS.num_proc,3,3) in ('ROB','CSR','STB')
	join invoice_det DET on DET.id_inv = INV.id_inv and DET.cd_pedido = PS.cd_pedido and DET.cd_produto =PS.cd_produto and convert(int,DET.item) = convert(int,PS.item)
	join pedido_det PD on PD.cd_pedido = PS.cd_pedido and PD.cd_produto =PS.cd_produto and PD.item = PS.item
	where
		substring(INV.num_proc,3,3) in ('ROB','CSR','STB')
		and substring(INV.num_proc,1,1) ='E'
		and data_invoice > '2010-01-01'
		and (DET.peso_liquido <> PD.peso_liquido_tot OR PD.peso_bruto_tot <> DET.peso_bruto)
End



GO
