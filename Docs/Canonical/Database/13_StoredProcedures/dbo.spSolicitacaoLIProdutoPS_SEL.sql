SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spSolicitacaoLIProdutoPS_SEL] --'IMCSR201508035BR','00104675'
		@Num_Proc	Varchar(16),
		@CodProd VarChar(30)

AS

--sp_help produto_cliente
--Stored responsavel por buscar os itens do pedido_ship para sugerir na tela de controle de L.I.
--Anderson 27-02-2010

select 
	cd_proc_cliente CodProd,Produto_Descr,Isnull(PDD.ncm,'') NCM,
	Isnull(Descricao_NCM,'')[Descricao_NCM],sum(ps.qty) Quantidade,sum(peso_bruto_tot) Peso_Bruto,
	sum(peso_liquido_tot) Peso_Liquido,TM.Nome_tp_moeda,max(vlr_item) Preco_Unit, Ps.Num_Proc 
from 
	pedido_ship PS			With(noLock) 
	Join Produto_Cliente PC With(noLock) on PC.cd_prod=ps.cd_produto
	Join Pedido_Det PDD		With(noLock) on PDD.cd_pedido=PS.cd_pedido and ps.cd_produto=pdd.cd_produto and ps.lote=pdd.lote and pdd.item=ps.item
	Join Pedido PD			With(noLock) on PD.cd_pedido=PS.cd_pedido
	Left Join NCM			With(noLock) on NCM.NCM=PDD.NCM
	Left Join Tipo_Moeda TM With(noLock) on  PD.Cd_Tp_Moeda = TM.Cd_Tp_Moeda
Where 
	ps.num_proc =@num_proc and (cd_Proc_Cliente = @CodProd or @CodProd= '')
group by 
	cd_proc_cliente ,Produto_Descr,PDD.ncm ,Nome_tp_moeda,Descricao_NCM,PS.Num_Proc
	

GO
