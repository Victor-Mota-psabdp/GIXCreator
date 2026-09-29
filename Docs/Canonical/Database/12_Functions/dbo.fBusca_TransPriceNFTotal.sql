SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  function [dbo].[fBusca_TransPriceNFTotal](

@Processo	varchar(16),	
@cd_prod	varchar(50),
@campo		varchar(50)

)
RETURNS Float

BEGIN
	Declare @Resultado Float
	Declare @saldo int

	set @saldo = (select count(distinct cd_produto) Saldo from nota_fiscal_cliente_Det NDD with(nolock)
				 Join Produto_cliente PC with(nolock) on PC.cd_prod=NDD.cd_produto  
				 Join NotA_Cliente NC with(nolock) on nc.id_nf=NDD.id_nf and nc.cd_cliente=Ndd.cd_cliente where num_proc= @Processo)

	if @saldo = 1
		BEGIN
			If @Campo='Quantidade'
			Begin
				SET @Resultado=(
						Select sum(isnull(peso_liquido,quantidade)) Quantidade from nota_cliente NC with(nolock)
								Join Nota_Fiscal_Cliente_Det ND with(nolock) on nD.id_nf=NC.id_nf and nD.cd_cliente=Nc.cd_cliente
								Join Produto_Cliente PC with(nolock) on PC.cd_prod=cd_produto
						where num_proc=@Processo)
			End

			If @Campo='FOB-Frete' --FOB-Seguro-Acrescimo-Frete
			Begin
				SET @Resultado=(
						Select sum(isnull(Vlr_Total_Item,0)) - sum(isnull(vlr_frete,0)) - sum(isnull(vlr_seguro,0)) - sum(isnull(acrescimos,0))  from nota_cliente NC with(nolock)
								Join Nota_Fiscal_Cliente_Det ND with(nolock) on nD.id_nf=NC.id_nf and nD.cd_cliente=Nc.cd_cliente
								Join Produto_Cliente PC with(nolock) on PC.cd_prod=cd_produto
						where num_proc=@Processo)
			End		

			If @Campo='FOB' --FOB-Seguro-Acrescimo
			Begin
				SET @Resultado=(
						Select sum(isnull(Vlr_Total_Item,0)) - sum(isnull(vlr_seguro,0)) - sum(isnull(acrescimos,0))  from nota_cliente NC with(nolock)
								Join Nota_Fiscal_Cliente_Det ND with(nolock) on nD.id_nf=NC.id_nf and nD.cd_cliente=Nc.cd_cliente
								Join Produto_Cliente PC with(nolock) on PC.cd_prod=cd_produto
						where num_proc=@Processo)
			End	

			If @Campo='Base_ICMS'
			Begin
				SET @Resultado=(
						Select sum(isnull(vl_base_icms,0)) Base_ICMS  from nota_cliente NC with(nolock)
								Join Nota_Fiscal_Cliente_Det ND with(nolock) on nD.id_nf=NC.id_nf and nD.cd_cliente=Nc.cd_cliente
								Join Produto_Cliente PC with(nolock) on PC.cd_prod=cd_produto
						where num_proc=@Processo)
			End	

			If @Campo='qtyNF'
			Begin
				SET @Resultado=(
						Select count(distinct(nc.id_nf)) QtyNF from nota_cliente NC with(nolock)
								Join Nota_Fiscal_Cliente_Det ND with(nolock) on nD.id_nf=NC.id_nf and nD.cd_cliente=Nc.cd_cliente
								Join Produto_Cliente PC with(nolock) on PC.cd_prod=cd_produto
						where num_proc=@Processo)
			End
			
			If @Campo='Base_II'
			Begin
				SET @Resultado=(
						Select sum(isnull(vl_base_II,0)) Base_II from nota_cliente NC with(nolock)
								Join Nota_Fiscal_Cliente_Det ND with(nolock) on nD.id_nf=NC.id_nf and nD.cd_cliente=Nc.cd_cliente
								Join Produto_Cliente PC with(nolock) on PC.cd_prod=cd_produto
						where num_proc=@Processo)
			End

			If @Campo='Base_IPI'
			Begin
				SET @Resultado=(
						Select sum(isnull(vl_base_IPI,0)) Base_IPI from nota_cliente NC with(nolock)
								Join Nota_Fiscal_Cliente_Det ND with(nolock) on nD.id_nf=NC.id_nf and nD.cd_cliente=Nc.cd_cliente
								Join Produto_Cliente PC with(nolock) on PC.cd_prod=cd_produto
						where num_proc=@Processo)
			End
		
			If @Campo='Base_PIS'
			Begin
				SET @Resultado=(
						Select sum(isnull(vl_base_PIS,0)) Base_PIS from nota_cliente NC with(nolock)
								Join Nota_Fiscal_Cliente_Det ND with(nolock) on nD.id_nf=NC.id_nf and nD.cd_cliente=Nc.cd_cliente
								Join Produto_Cliente PC with(nolock) on PC.cd_prod=cd_produto
						where num_proc=@Processo)
			End

			If @Campo='Frete'
			Begin
				SET @Resultado=(
						Select sum(isnull(vlr_frete,0)) Frete from nota_cliente NC with(nolock)
								Join Nota_Fiscal_Cliente_Det ND with(nolock) on nD.id_nf=NC.id_nf and nD.cd_cliente=Nc.cd_cliente
								Join Produto_Cliente PC with(nolock) on PC.cd_prod=cd_produto
						where num_proc=@Processo)
			End

			If @Campo='Seguro'
			Begin
				SET @Resultado=(
						Select sum(isnull(vlr_seguro,0)) Seguro from nota_cliente NC with(nolock)
								Join Nota_Fiscal_Cliente_Det ND with(nolock) on nD.id_nf=NC.id_nf and nD.cd_cliente=Nc.cd_cliente
								Join Produto_Cliente PC with(nolock) on PC.cd_prod=cd_produto
						where num_proc=@Processo)
			End

			If @Campo='Acrescimo'
			Begin
				SET @Resultado=(
						Select sum(isnull(acrescimos,0)) Acrescimo from nota_cliente NC with(nolock)
								Join Nota_Fiscal_Cliente_Det ND with(nolock) on nD.id_nf=NC.id_nf and nD.cd_cliente=Nc.cd_cliente
								Join Produto_Cliente PC with(nolock) on PC.cd_prod=cd_produto
						where num_proc=@Processo)
			End		
			
		END
	ELSE
		BEGIN
			If @Campo='Quantidade'
			Begin
				SET @Resultado=(
						Select sum(isnull(peso_liquido,quantidade)) Quantidade from nota_cliente NC with(nolock)
								Join Nota_Fiscal_Cliente_Det ND with(nolock) on nD.id_nf=NC.id_nf and nD.cd_cliente=Nc.cd_cliente
								Join Produto_Cliente PC with(nolock) on PC.cd_prod=cd_produto
						where num_proc=@Processo and cd_proc_cliente=@cd_prod)
			End
			
			If @Campo='FOB-Frete' --FOB-Seguro-Acrescimo-Frete
			Begin
				SET @Resultado=(
						Select sum(isnull(Vlr_Total_Item,0)) - sum(isnull(vlr_frete,0)) - sum(isnull(vlr_seguro,0)) - sum(isnull(acrescimos,0))  from nota_cliente NC with(nolock)
								Join Nota_Fiscal_Cliente_Det ND with(nolock) on nD.id_nf=NC.id_nf and nD.cd_cliente=Nc.cd_cliente
								Join Produto_Cliente PC with(nolock) on PC.cd_prod=cd_produto
						where num_proc=@Processo and cd_proc_cliente=@cd_prod)
			End		

			If @Campo='FOB' --FOB-Seguro-Acrescimo
			Begin
				SET @Resultado=(
						Select sum(isnull(Vlr_Total_Item,0)) - sum(isnull(vlr_seguro,0)) - sum(isnull(acrescimos,0))  from nota_cliente NC with(nolock)
								Join Nota_Fiscal_Cliente_Det ND with(nolock) on nD.id_nf=NC.id_nf and nD.cd_cliente=Nc.cd_cliente
								Join Produto_Cliente PC with(nolock) on PC.cd_prod=cd_produto
						where num_proc=@Processo and cd_proc_cliente=@cd_prod)
			End	

			If @Campo='Base_ICMS'
			Begin
				SET @Resultado=(
						Select sum(isnull(vl_base_icms,0)) Base_ICMS  from nota_cliente NC with(nolock)
								Join Nota_Fiscal_Cliente_Det ND with(nolock) on nD.id_nf=NC.id_nf and nD.cd_cliente=Nc.cd_cliente
								Join Produto_Cliente PC with(nolock) on PC.cd_prod=cd_produto
						where num_proc=@Processo and cd_proc_cliente=@cd_prod)
			End

--			If @Campo='FOB'
--			Begin
--				SET @Resultado=(
--						Select sum(isnull(Vlr_Total_Item,0)) FOB from nota_cliente NC
--								Join Nota_Fiscal_Cliente_Det ND on nD.id_nf=NC.id_nf and nD.cd_cliente=Nc.cd_cliente
--								Join Produto_Cliente PC on PC.cd_prod=cd_produto
--						where num_proc=@Processo and cd_proc_cliente=@cd_prod)
--			End			
			
			If @Campo='Base_II'
			Begin
				SET @Resultado=(
						Select sum(isnull(vl_base_II,0)) Base_II from nota_cliente NC with(nolock)
								Join Nota_Fiscal_Cliente_Det ND with(nolock) on nD.id_nf=NC.id_nf and nD.cd_cliente=Nc.cd_cliente
								Join Produto_Cliente PC with(nolock) on PC.cd_prod=cd_produto
						where num_proc=@Processo and cd_proc_cliente=@cd_prod)
			End

			If @Campo='Base_IPI'
			Begin
				SET @Resultado=(
						Select sum(isnull(vl_base_IPI,0)) Base_IPI from nota_cliente NC with(nolock)
								Join Nota_Fiscal_Cliente_Det ND with(nolock) on nD.id_nf=NC.id_nf and nD.cd_cliente=Nc.cd_cliente
								Join Produto_Cliente PC with(nolock) on PC.cd_prod=cd_produto
						where num_proc=@Processo and cd_proc_cliente=@cd_prod)
			End
			
			If @Campo='Base_PIS'
			Begin
				SET @Resultado=(
						Select sum(isnull(vl_base_PIS,0)) Base_PIS from nota_cliente NC with(nolock)
								Join Nota_Fiscal_Cliente_Det ND with(nolock) on nD.id_nf=NC.id_nf and nD.cd_cliente=Nc.cd_cliente
								Join Produto_Cliente PC with(nolock) on PC.cd_prod=cd_produto
						where num_proc=@Processo and cd_proc_cliente=@cd_prod)
			End

			If @Campo='Frete'
			Begin
				SET @Resultado=(
						Select sum(isnull(vlr_frete,0)) Frete from nota_cliente NC with(nolock)
								Join Nota_Fiscal_Cliente_Det ND with(nolock) on nD.id_nf=NC.id_nf and nD.cd_cliente=Nc.cd_cliente
								Join Produto_Cliente PC with(nolock) on PC.cd_prod=cd_produto
						where num_proc=@Processo and cd_proc_cliente=@cd_prod)
			End

			If @Campo='Seguro'
			Begin
				SET @Resultado=(
						Select sum(isnull(vlr_seguro,0)) Seguro from nota_cliente NC with(nolock)
								Join Nota_Fiscal_Cliente_Det ND with(nolock) on nD.id_nf=NC.id_nf and nD.cd_cliente=Nc.cd_cliente
								Join Produto_Cliente PC with(nolock) on PC.cd_prod=cd_produto
						where num_proc=@Processo and cd_proc_cliente=@cd_prod)
			End

			If @Campo='Acrescimo'
			Begin
				SET @Resultado=(
						Select sum(isnull(acrescimos,0)) Acrescimo from nota_cliente NC with(nolock)
								Join Nota_Fiscal_Cliente_Det ND with(nolock) on nD.id_nf=NC.id_nf and nD.cd_cliente=Nc.cd_cliente
								Join Produto_Cliente PC with(nolock) on PC.cd_prod=cd_produto
						where num_proc=@Processo and cd_proc_cliente=@cd_prod)
			End
			
			If @Campo='qtyNF'
			Begin
				SET @Resultado=(
						Select count(distinct(nc.id_nf)) QtyNF from nota_cliente NC with(nolock)
								Join Nota_Fiscal_Cliente_Det ND with(nolock) on nD.id_nf=NC.id_nf and nD.cd_cliente=Nc.cd_cliente
								Join Produto_Cliente PC with(nolock) on PC.cd_prod=cd_produto
						where num_proc=@Processo and cd_proc_cliente=@cd_prod )
			End
		END
	RETURN @Resultado

END





GO
