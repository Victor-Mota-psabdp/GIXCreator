SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spATL_CalculaPercentual_Ins] 'P000000450'
CREATE procedure [dbo].[spATL_CalculaPercentual_Ins]
	
	@Cd_Grupo varchar(50)
	
as

Declare @Grupo varchar(3)
set @Grupo = (select GRupo from Grupo with(nolock) where Cd_Pes_Grupo = @Cd_Grupo)

delete Percentual_Produto_Hexion where SUBSTRING(num_proc,3,3) = @Grupo

insert Percentual_Produto_Hexion
select distinct PS.Num_Proc,PS.cd_pedido,PS.cd_produto,PS.Item,
cast(DBO.fBuscaPorcentagem_CdPedido_Transf(PS.Num_Proc,PS.ITEM,PS.cd_pedido)*dbo.fBuscaPorcentagem_Pedido_Prod(PS.num_proc,PS.cd_pedido,PS.cd_produto) as decimal(18,10)),
CP.Campo_Dados,year(PO.Data_PO_HIM)
from Pedido_Ship PS with(nolock)
left join PO_HIM PO with(nolock) on PS.Num_Proc = PO.Num_Proc_HIM and ID_DC = '5'
left  join Campo_Processo CP with(nolock) on PS.Num_Proc = CP.Num_Proc  and CP.Id_Campo = 31
--left join Percentual_Produto P with(nolock) on PS.Num_Proc = P.Num_proc and  PS.cd_pedido = P.Cd_pedido  and PS.cd_produto = P.cd_produto  and PS.Item = P.Item
where 
--num_proc_him = 'IMHEX201612016BR' and 
year(PO.Data_PO_HIM) >= year(getdate())-2 and  
SUBSTRING(PS.num_proc,3,3) = @Grupo 

union ALL

select distinct PS.Num_Proc,PS.cd_pedido,PS.cd_produto,PS.Item,
cast(DBO.fBuscaPorcentagem_CdPedido_Transf(PS.Num_Proc,PS.ITEM,PS.cd_pedido)*dbo.fBuscaPorcentagem_Pedido_Prod(PS.num_proc,PS.cd_pedido,PS.cd_produto) as decimal(18,10)),
CP.Campo_Dados,year(PO.Data_PO_HIA)
from Pedido_Ship PS with(nolock)
left join PO_HIA PO with(nolock) on PS.Num_Proc = PO.Num_Proc_HIA and ID_DC = '5'
left  join Campo_Processo CP with(nolock) on PS.Num_Proc = CP.Num_Proc  and CP.Id_Campo = 31
--left join Percentual_Produto P with(nolock) on PS.Num_Proc = P.Num_proc and  PS.cd_pedido = P.Cd_pedido  and PS.cd_produto = P.cd_produto  and PS.Item = P.Item
where 
--year(PO.Data_PO_HIA) = year(getdate()) and 
year(PO.Data_PO_HIA) >= year(getdate())-2 and 
SUBSTRING(PS.num_proc,3,3) =@GRupo 

union ALL

select distinct PS.Num_Proc,PS.cd_pedido,PS.cd_produto,PS.Item,
cast(DBO.fBuscaPorcentagem_CdPedido_Transf(PS.Num_Proc,PS.ITEM,PS.cd_pedido)*dbo.fBuscaPorcentagem_Pedido_Prod(PS.num_proc,PS.cd_pedido,PS.cd_produto) as decimal(18,10)),
CP.Campo_Dados,year(PO.Data_PO_HIO)
from Pedido_Ship PS with(nolock)
left join PO_HIO PO with(nolock) on PS.Num_Proc = PO.Num_Proc_HIO and ID_DC = '5'
left  join Campo_Processo CP with(nolock) on PS.Num_Proc = CP.Num_Proc  and CP.Id_Campo = 31
--left join Percentual_Produto P with(nolock) on PS.Num_Proc = P.Num_proc and  PS.cd_pedido = P.Cd_pedido  and PS.cd_produto = P.cd_produto  and PS.Item = P.Item
where 
--year(PO.Data_PO_HIO) = year(getdate()) and 
year(PO.Data_PO_HIO) >= year(getdate())-2 and 
SUBSTRING(PS.num_proc,3,3) =@GRupo
option(hash join)
GO
