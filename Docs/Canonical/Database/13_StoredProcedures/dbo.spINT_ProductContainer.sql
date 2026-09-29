SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spINT_ProductContainer(
@Num_Proc as varchar (20)
,@Cd_Prod varchar(50)
)
AS
BEGIN
select PSC.Num_Cont EquipNo, psc.num_proc
from Pedido_Ship_Container PSC with(nolock)
Join Produto_Cliente PC with(nolock) on PC.cd_prod=PSC.cd_produto 
where PSC.Num_Proc=@Num_Proc and  PC.cd_proc_cliente=@Cd_Prod
END
GO
