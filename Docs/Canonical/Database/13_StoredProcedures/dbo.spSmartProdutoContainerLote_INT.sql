SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spSmartProdutoContainerLote_INT]
(
		@Num_Proc			Varchar(16),
		@Cd_Proc_Cliente	Varchar(50),
		@Lote				Varchar(30)
)

as

select 
	replace(num_cont_em,'-','') num_cont_em,
	--num_cont_em,
	Num_Lacre_EM,
	nome_tp_Cont Container,
	cd_smart,cd_cc_ofc,
	cd_proc_cliente, 
	produto_descr,
	[dbo].[fBusca_TipoDocCliente]('N',@Num_PRoc,4) RE 
from pedido_ship_container PS with(nolock)
Join Produto_Cliente PC with(nolock) on PC.cd_prod=cd_produto
Join Container_hou_exp_mar CH with(nolock) on CH.num_proc_hem=ps.num_proc
Join Container_mas_exp_mar CM with(nolock) on CM.num_proc_mem=CH.num_proc_mem and CM.item_cont_em=CH.item_Cont_EM and replace(num_cont_em,'-','')=replace(num_cont,'-','') 
Join Tipo_Container TP with(nolock) on TP.cd_tp_Cont=CM.cd_tp_cont
Where
	cd_proc_cliente=@cd_proc_cliente and Num_Proc=@Num_Proc
	and PS.Lote = @Lote





GO
