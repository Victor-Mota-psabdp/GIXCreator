SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure spProcessoGMIDQtd_rel
as
select
	Num_Proc, GMID, sum(PS.Qty) Qtd, Peso_Bruto_TOT, Peso_Liquido_TOT
from
	pedido_ship PS
	Join Produto_Cliente		PC	on PS.Cd_Produto =PC.Cd_Prod
	Left Join De_Para_Produto	DPP	on PC.Cd_Proc_Cliente = DPP.GMID 
	Join Pedido_Det				PD 	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
where
	num_proc like '%'
Group by
	Num_Proc, GMID, Peso_Bruto_TOT, Peso_Liquido_TOT
order by
	Num_Proc


GO
