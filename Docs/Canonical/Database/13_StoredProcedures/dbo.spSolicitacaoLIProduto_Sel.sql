SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spSolicitacaoLIProduto_Sel]
		@Num_Solicitacao Varchar(13)

AS

Select 
	cd_proc_cliente CodProd,Produto_Descr,NCM,Descricao_NCM,Qty Quantidade,
	Peso_Bruto,Peso_Liquido,Nome_Tp_moeda,Preco_Unit

from solicitacao_li_produto SLP
	Join Produto_Cliente PC With(noLock) on PC.cd_prod=SLP.cd_produto
	Left Join NCM With(noLock) on SLP.id_ncm=NCM.id_ncm
	Left Join Tipo_Moeda TM With(noLock) on  SLP.Cd_Tp_Moeda = TM.Cd_Tp_Moeda
Where
	Num_Solicitacao=@Num_Solicitacao
GO
