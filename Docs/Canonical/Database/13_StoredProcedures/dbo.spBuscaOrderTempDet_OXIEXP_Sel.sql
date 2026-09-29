SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spBuscaOrderTempDet_OXIEXP_Sel 166721
--select * from Produto_Cliente where cd_Cliente = 'P21128' and Produto_Descr = 'SECBUTANOL'
--select * from pedido where num_pedido = '1169533'
--select * from pedido_det where Cd_Pedido = '329861'
--Codigo cliente - Descricao
--83297 SECBUTANOL
--82115 SECBUTANOL
--select * from Produto_Cliente  where cd_prod = '166098'
--update Produto_Cliente set Produto_Descr = 'SECBUTANOL (83297)'  where cd_prod = '166098'

--sp_help select * from Pedido_det
--select * from Pedido_Temp
--spBuscaOrderTempDet_OXIEXP_Sel 2
--spBuscaOrderTempDet_OXIEXP_Sel '169710'
CREATE procedure [dbo].[spBuscaOrderTempDet_OXIEXP_Sel] (
	@Cd_PedidoTemp int
	
)
as
Declare @Item varchar(50)
Declare @Num_Pedido varchar(50)
Declare @Cd_Prod int
Declare @Produto_Descr varchar(500)

set @Num_Pedido = (select Top 1 Num_pedido from Pedido_Temp where Cd_pedido = @Cd_PedidoTemp)
print @Num_Pedido
set @Produto_Descr = (select Top 1 PC.Produto_Descr Produto from Pedido_Temp PT
						join Produto_Cliente PC on PT.Cd_Proc_cliente = PC.cd_Proc_Cliente
						where Cd_pedido = @Cd_PedidoTemp and cd_Cliente = 'P21128')
print @Produto_Descr
set @Cd_Prod = (select Top 1 cd_prod from Produto_Cliente where cd_Cliente = 'P21128' and Produto_Descr = @Produto_Descr)
print @Cd_Prod
--set @Item = isnull((select PD.Item from Pedido_det PD
--				left join Pedido P on P.Cd_pedido = PD.Cd_Pedido
--				where P.Num_Pedido = @Num_Pedido and P.Cd_Grupo = 'P21128' and PD.Cd_Produto = @Cd_Prod),1)
--print @Item
--if @Item is NULL
--cadu pra sempre ser 1
	set @Item = '1'
		
print @Item
Select 
	@Cd_PedidoTemp Cd_Pedido,
	@Produto_Descr Nome_Produto ,
	'1' Lote,
	@Item Item,
	NULL Requerimento,
	'TON'UOM,
	Qty,
	Vlr_Item,
	Vlr_Total_Item,
	NULL UOM_PRC,
	NULL Peso_UOM,
	NULL Peso_Item,
	NULL Peso_Bruto_TOT,
	Peso_Liquido_TOT,
	NULL Peso_Invoice,
	NULL SAP_Company,
	NULL [Contract],
	NULL [NATOP],
	NULL Finalidade,
	NULL PO_GRP,
	NULL In_Progress,
	NULL Requision,
	NULL NCM,
	NULL UPC,
	NULL Qtde
from
	Pedido_Temp
where 
	Cd_Pedido = @cd_PedidoTemp
	



GO
