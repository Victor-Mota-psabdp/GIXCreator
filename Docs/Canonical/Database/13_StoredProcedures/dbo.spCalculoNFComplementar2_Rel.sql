SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--[spCalculoNFComplementar2_Rel] 'IMSUR20101000101'
CREATE Procedure [dbo].[spCalculoNFComplementar2_Rel]
	(@Num_Proc varchar(16))
AS
	select 
		cd_proc_cliente [Código do Produto], Produto_Descr [Descrição do Produto],dbo.fBusca_Custo_Processo_SemImpostos(num_proc)*dbo.fBuscaPorcentagem_CdProduto(num_proc,ps.cd_produto) Valor 
	from 
		pedido_ship PS
		Join Produto_Cliente PC on PC.cd_prod=ps.cd_produto
	where 
		num_proc=@Num_Proc

UNION ALL
	select 'TOTAL','',dbo.fBusca_Custo_Processo_SemImpostos(@num_proc)


GO
