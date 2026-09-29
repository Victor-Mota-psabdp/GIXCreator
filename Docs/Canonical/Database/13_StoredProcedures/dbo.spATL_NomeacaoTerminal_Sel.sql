SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_NomeacaoTerminal_Sel 'IMLYB201806004BR','EU'
CREATE procedure [dbo].[spATL_NomeacaoTerminal_Sel]
(
@Num_Proc varchar(16),
@Cd_Usuario varchar(6)
)
as
Select 
	TM.Nome_Terminal [Terminal],
	HOU.Vessel [Navio],
	HOU.Viagem [Viagem],
	PD.Num_Pedido [PO#],
	PS165.Apelido [Inspetoria],
	HOU.Num_Proc [JOB],
	PC.Produto_Descr [Product],
	HOU.ETA [ETA],
	P.Nome_Raz_Soc [Consignatario],
	cast(SUM(PS.Qty) as decimal(18,3)) [Quantidade],
	CP164.Campo_Dados [Tanques]
from vwHouse_Imp HOU with(nolock)
left join Terminal TM with(nolock) on HOU.cd_terminal = TM.Cd_Terminal
join Pedido_Ship PS with(nolock) on HOU.Num_Proc = PS.Num_Proc
join Produto_Cliente PC with(nolock) on PS.cd_produto = PC.cd_prod  
Join Pedido PD with(nolock) on PS.cd_pedido = PD.cd_pedido
left join Pessoa P with(nolock) on Hou.Cd_Consig = P.Cd_Pes
left join Campo_Processo CP164 with(nolock) on HOU.Num_Proc = CP164.Num_Proc and CP164.Id_Campo = 164
left join Campo_Processo CP165 with(nolock) on HOU.Num_Proc = CP165.Num_Proc and CP165.Id_Campo = 165
left join Pessoa PS165 with(nolock) on CP165.Campo_Dados = PS165.Cd_Pes
where HOU.Num_Proc = @Num_Proc
group by 	TM.Nome_Terminal,
	HOU.Vessel,
	HOU.Viagem,
	PD.Num_Pedido,
	PS165.Apelido,
	HOU.Num_Proc,
	PC.Produto_Descr,
	HOU.ETA,
	P.Nome_Raz_Soc,
	CP164.Campo_Dados
	
--select * from Pedido_Ship where Num_Proc = 'IMLYB201701001BR'
--select * from Produto_Cliente where cd_proc_cliente = 'VAM'
GO
