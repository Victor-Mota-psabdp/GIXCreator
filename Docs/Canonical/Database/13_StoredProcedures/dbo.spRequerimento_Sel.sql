SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--
--select * from Pedido_det
--where cd_pedido = '650'
--select * from Pedido_Ship
--where num_proc = 'IMCSR20080112701'

CREATE Procedure [dbo].[spRequerimento_Sel] --'%'

	@Requerimento varchar(50)

as

if @Requerimento <> '%' 
	select 
		Num_proc,
		Num_Pedido,
		PD.cd_pedido, 
		PD.cd_Produto, 
		sum(PD.QTY) QTY_Pedido, 
		UoM, 
		sum(PS.QTY) QTY_Ship ,
		Requerimento
	from 
		Pedido P
	Left Outer Join Pedido_Det PD on P.cd_pedido = PD.cd_pedido
	Left Outer Join Pedido_Ship PS on PS.cd_pedido = PD.cd_pedido and PS.cd_produto = PD.cd_produto and PS.Item = PD.Item and PS.Lote = PD.Lote
	where 
		Requerimento = @Requerimento
	group by 
		Num_proc, Num_Pedido,PD.cd_pedido, PD.cd_Produto,PD.QTY, PS.QTY, UoM, Requerimento

else

	select 
		Num_proc,
		Num_Pedido,
		PD.cd_pedido, 
		PD.cd_Produto, 
		sum(PD.QTY) QTY_Pedido, 
		UoM, 
		sum(PS.QTY) QTY_Ship, 
		Requerimento
	from 
		Pedido P
	Left Outer Join Pedido_Det PD on P.cd_pedido = PD.cd_pedido
	Left Outer Join Pedido_Ship PS on PS.cd_pedido = PD.cd_pedido and PS.cd_produto = PD.cd_produto and PS.Item = PD.Item and PS.Lote = PD.Lote
	where 
		Requerimento is NULL 
	group by 
		Num_proc, Num_Pedido,PD.cd_pedido, PD.cd_Produto,PD.QTY, PS.QTY, UoM, Requerimento


GO
