SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Integracao304_Rel]--'ALL'
(
@JOB varchar(16)
)
as
select 
	CO.Cd_Pedido [ID Order], 
	PD.Num_Pedido [Order Reference],
	PD.Num_PO [PO Number], 
	Pd.Dt_Pedido [Order Date], 
	SE.Apelido [Seller],
	BU.Apelido [Buyer],  
	CS.Apelido [Consignee],
	ORG.Nome_Pais [Country Origin],
	DST.Nome_Pais	[Country Destination],
	convert(varchar(10),PDE.Cd_Produto) + ' - ' + convert(varchar(10),PRC.Produto_Descr) [Product],
	TM.Modal [Modal],
	ISNULL(CONVERT(varchar(30), Num_Proc),'No Linked JOBs') [JOB]
	--Campo_Dados [Ruler]  
from 
	Campo_Ordem CO
	left join Pedido PD				with(nolock) on CO.cd_pedido = PD.Cd_pedido
	left join Pedido_Det PDE		with(nolock) on PD.Cd_pedido = PDE.Cd_Pedido
	left join Pedido_Ship PS		with(nolock) on PDE.Cd_Pedido = PS.cd_pedido and PS.Cd_Produto = PDE.CD_Produto and PS.Lote = PDE.Lote and PS.Item = PDE.Item
	left join Produto_Cliente PRC	with(nolock) on PDE.Cd_Produto = PRC.cd_prod
	left join Pessoa BU				with(nolock) on PD.Cd_Buyer = BU.Cd_Pes
	left join Pessoa SE				with(nolock) on PD.Cd_Seller = SE.Cd_Pes
	left join Pessoa CS				with(nolock) on PD.Cd_Consignee = CS.Cd_Pes
	left join Pais	ORG				with(nolock) on PD.Cd_Pais_Org = ORG.Cd_Pais
	left join Pais	DST				with(nolock) on PD.Cd_Pais_Dst = DST.Cd_Pais
	left join Tipo_Modal TM			with(nolock) on PD.Cd_Modal = TM.Id
where 
Id_Campo = 3
GO
