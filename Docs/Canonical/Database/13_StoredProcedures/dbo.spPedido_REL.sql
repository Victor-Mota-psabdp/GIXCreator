SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE   Procedure [dbo].[spPedido_REL] 
		@DataInicial Datetime,
		@dataFinal	DAtetime
as

select PP.Nome_RAz_Soc Seller, PE.Nome_Raz_Soc, Org.Nome_Pais Origem, DSt.Nome_Pais Destino,* from pedido PD with(nolock)
Join Pessoa PP with(nolock) on PP.cd_pes=cd_seller
Join Pessoa PE with(nolock) on PE.cd_pes=cd_buyer
Join Pais Org with(nolock) on Org.cd_pais=cd_pais_org
Join Pais Dst with(nolock) on Dst.cd_pais=cd_pais_dst
Join Pedido_det DET with(nolock) on PD.cd_pedido=DET.cd_pedido
Join Produto_cliente CP with(nolock) on CP.cd_prod=cd_produto
Join Pessoa_LLP PP_LLP with(nolock) on PP_LLP.cd_pes=cd_seller
Join Pessoa_LLP PE_LLP with(nolock) on PE_LLP.cd_pes=cd_buyer
Join DE_Para_Produto DP with(nolock) on GMID=cd_proc_cliente
Join Pedido_Referencia PR with(nolock) on PR.codigo=Payment and id_descr='Payments'
Where DL_Chegada between @DataInicial and @DataFinal






GO
