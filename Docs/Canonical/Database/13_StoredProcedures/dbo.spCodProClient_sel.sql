SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spCodProClient_sel 'EA1115162', 'AKZO ITUPEVA SURFACE', 'AKZO NOBEL SUR 63612'

CREATE      Procedure [dbo].[spCodProClient_sel] 

		@Num_Pedido 	VarChar(30),
		@Shipper		VarChar(50),
		@Consignee			VarChar(50)

as
/* Alterado por Erbson - 15-08-2012: Verificar PED.dt_pedido > getdate() -360*/
/* Alterado por Erbson - 21-04-2013: Verifica Seller e Buyer */
--select 
--	cd_proc_cliente  
--from 
--	pedido PED with(nolock)
--Join Pedido_Det PD  with(nolock) on PD.cd_pedido=PED.cd_pedido 
--Join Produto_Cliente PC with(nolock) on PC.cd_prod=PD.cd_produto and PED.cd_grupo=PC.cd_cliente
--Where 
--	ped.num_pedido=@num_pedido and PED.dt_pedido > getdate() -360
--group by 
--	cd_proc_cliente
--order by
--	cd_proc_cliente
--27/07/2015 - incluido o dt_pedido nao ser vazio
	Declare @Cd_Shipper		varchar(10)
	Declare @Cd_Consignee	varchar(10)

Set @Cd_Shipper = (Select Cd_Pes from Pessoa with(nolock) where apelido = @Shipper)
Set @Cd_Consignee = (Select Cd_Pes from Pessoa  with(nolock) where apelido = @Consignee)

Select
	Cd_Proc_Cliente
from
	pedido P with(nolock)
Join Pedido_Det			PD with(nolock) on P.Cd_Pedido=PD.Cd_Pedido
Join Produto_Cliente	PC with(nolock) on PC.Cd_Prod = PD.Cd_Produto and P.Cd_Grupo = PC.Cd_Cliente
where 
	P.Num_Pedido = @Num_Pedido 
	and (P.Cd_Seller = @Cd_Shipper or P.Cd_Shipper = @Cd_Shipper)
	and (P.cd_Buyer= @Cd_Consignee or P.Cd_Consignee=@Cd_Consignee)
	and Dt_Pedido is not null
group by 
	cd_proc_cliente
order by
	cd_proc_cliente






GO
