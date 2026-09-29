SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE procedure [dbo].[spTransPriceNFTotal]
		@num_proc	varchar(16),
		@cd_prod	varchar(50),
		@status		Char(1)



as

if @status = 'S' 
 begin

	select count(distinct(nc.id_nf)) QtyNF,sum(acrescimos) Acrescimo,sum(vlr_seguro) Seguro,sum(vlr_frete) Frete, sum(isnull(peso_liquido,quantidade)) Quantidade, sum(Vlr_Total_Item) FOB,sum(vl_base_II) Base_II,sum(vl_base_IPI) Base_IPI,sum(vl_base_PIS) Base_PIS,sum(vl_base_icms) BAse_ICMS from nota_cliente NC with(nolock)
	Join Nota_Fiscal_Cliente_Det ND with(nolock) on nD.id_nf=NC.id_nf and nD.cd_cliente=Nc.cd_cliente 
	Join Produto_Cliente PC with(nolock) on PC.cd_prod=cd_produto 
	where num_proc=@num_proc and cd_proc_cliente=@cd_prod

 end
else
	begin

	select count(distinct(nc.id_nf)) QtyNF,sum(acrescimos) Acrescimo, sum(vlr_seguro) Seguro,sum(vlr_frete) Frete,sum(isnull(peso_liquido,quantidade)) Quantidade, sum(Vlr_Total_Item) FOB,sum(vl_base_II) Base_II,sum(vl_base_IPI) Base_IPI,sum(vl_base_PIS) Base_PIS,sum(vl_base_icms) BAse_ICMS from nota_cliente NC with(nolock)
	Join Nota_Fiscal_Cliente_Det ND with(nolock) on nD.id_nf=NC.id_nf and nD.cd_cliente=Nc.cd_cliente
	Join Produto_Cliente PC with(nolock) on PC.cd_prod=cd_produto
	where num_proc=@num_proc 


	end






GO
