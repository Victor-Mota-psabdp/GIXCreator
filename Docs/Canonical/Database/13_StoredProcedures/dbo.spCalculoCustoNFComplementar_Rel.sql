SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spCalculoCustoNFComplementar_Rel] --'IAPOW20091000301'

		@Num_Proc	Varchar(16)

AS

select cd_tp_oper, dbo.[fBusca_TipoDocCliente]('N',num_proc,5) DI_Number , dbo.[fBusca_TipoDocCliente]('N',num_proc,3) PO_Number, cd_proc_cliente Codigo_Produto, Produto_Descr,dbo.fBusca_Custo_Processo_SemImpostos(num_proc)*dbo.fBuscaPorcentagem_CdProduto(num_proc,ps.cd_produto) Valor from pedido_ship PS
Join Produto_Cliente PC on PC.cd_prod=ps.cd_produto
Join House_Imp_Mar hou on hou.num_proc_him=ps.num_proc
where num_proc=@Num_Proc

union

select cd_tp_oper, dbo.[fBusca_TipoDocCliente]('N',num_proc,5) DI_Number , dbo.[fBusca_TipoDocCliente]('N',num_proc,3) PO_Number, cd_proc_cliente Codigo_Produto, Produto_Descr,dbo.fBusca_Custo_Processo_SemImpostos(num_proc)*dbo.fBuscaPorcentagem_CdProduto(num_proc,ps.cd_produto) Valor from pedido_ship PS
Join Produto_Cliente PC on PC.cd_prod=ps.cd_produto
Join House_Imp_aer hou on hou.num_proc_hia=ps.num_proc
where num_proc=@Num_Proc






GO
