SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE procedure [dbo].[spBuscaNFCusto] 

as

select cd_proc_cliente,Num_Pedido,Num_Proc,VL_II Valor_II,VL_IPI Valor_IPI,VL_IMPOSTO_PIS Valor_PIS,VL_IMPOSTO_COFINS Valor_Cofins,VL_ICMS Valor_ICMS from nota_cliente NC with(nolock)  
Join nota_fiscal_cliente_det NCD with(nolock) ON NCD.ID_NF=NC.ID_NF and NC.Cd_Cliente=NCD.Cd_Cliente 
Join Pedido PD with(nolock) on NCD.cd_pedido=PD.cd_pedido
Join Produto_Cliente PC with(nolock) on PC.cd_prod=NCD.cd_produto
 where custo='N'



GO
