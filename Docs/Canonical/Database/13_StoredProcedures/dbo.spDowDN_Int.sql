SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spDowDN_Int]

as

/*
STORED MOSTRA PEDIDOS QUE NECESSITAM SER AJUSTADOS (QUANTIDADE, PREÇO E PESO)
*/


select 
	pd.cd_pedido,num_pedido,max(num_proc) Job 
from 
	TMP_AjusteDN_Pedido AJ
	Left Join Pedido PD on PD.num_pedido=num_pedido_inv
	Join Pedido_Ship PS on PS.cd_pedido=PD.cd_pedido
where 
	DN_R='N' or DN_R is null and left(num_proc,1)='I'
group by 
	pd.cd_pedido,num_pedido 
having 
	count(distinct(num_proc)) = 1

GO
