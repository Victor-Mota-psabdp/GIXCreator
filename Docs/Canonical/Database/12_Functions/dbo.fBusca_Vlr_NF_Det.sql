SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--29/05 Ajuste (CAEC) sum(Qtd)

CREATE   function [dbo].[fBusca_Vlr_NF_Det](
@Processo	varchar(16),
@Cd_Pedido	int,
@Cd_Produto	int,
@Campo		varchar(15)
)
RETURNS Float

BEGIN
	Declare @Resultado Float

	If @Campo='Quantidade'
	Begin
		SET @Resultado=(
				Select sum(Vlr_Total_Item) Quantidade from nota_fiscal_cliente_det NFCD with(nolock)
				join nota_cliente NC with(nolock) on Nc.Id_NF = NFCD.Id_NF and NC.cd_cliente = NFCD.cd_cliente
				where NC.num_proc = @Processo  and cd_produto = @Cd_Produto
				)
	End

	If @Campo='Vlr_FRETE'
	Begin
		SET @Resultado=(
				Select sum(Vlr_FRETE) from nota_fiscal_cliente_det NFCD with(nolock)
				join nota_cliente NC with(nolock) on Nc.Id_NF = NFCD.Id_NF and NC.cd_cliente = NFCD.cd_cliente
				where NC.num_proc = @Processo and cd_produto = @Cd_Produto
				)
	End

	If @Campo='ALIQ_II'
	Begin
		SET @Resultado=(
				Select max(ALIQ_II) from nota_fiscal_cliente_det NFCD with(nolock)
				join nota_cliente NC with(nolock) on Nc.Id_NF = NFCD.Id_NF and NC.cd_cliente = NFCD.cd_cliente
				where NC.num_proc = @Processo and cd_produto = @Cd_Produto
				)
	End

	If @Campo='VL_II'
	Begin
		SET @Resultado=(
				Select sum(VL_II) from nota_fiscal_cliente_det NFCD with(nolock)
				join nota_cliente NC with(nolock) on Nc.Id_NF = NFCD.Id_NF and NC.cd_cliente = NFCD.cd_cliente
				where NC.num_proc = @Processo and cd_produto = @Cd_Produto
				)
	End

	If @Campo='ALIQ_IPI'
	Begin
		SET @Resultado=(
				Select max(ALIQ_IPI) from nota_fiscal_cliente_det NFCD with(nolock)
				join nota_cliente NC with(nolock) on Nc.Id_NF = NFCD.Id_NF and NC.cd_cliente = NFCD.cd_cliente
				where NC.num_proc = @Processo and cd_produto = @Cd_Produto
				)
	End

	If @Campo='VL_BASE_IPI'
	Begin
		SET @Resultado=(
				Select sum(VL_BASE_IPI) from nota_fiscal_cliente_det NFCD with(nolock)
				join nota_cliente NC with(nolock) on Nc.Id_NF = NFCD.Id_NF and NC.cd_cliente = NFCD.cd_cliente
				where NC.num_proc = @Processo and cd_produto = @Cd_Produto
				group by ALIQ_IPI
				)
	End

	If @Campo='VL_IPI'
	Begin
		SET @Resultado=(
				Select sum(VL_IPI) from nota_fiscal_cliente_det NFCD with(nolock)
				join nota_cliente NC with(nolock) on Nc.Id_NF = NFCD.Id_NF and NC.cd_cliente = NFCD.cd_cliente
				where NC.num_proc = @Processo and cd_produto = @Cd_Produto
				)
	End


	If @Campo='Capatazias'
	Begin
		SET @Resultado=(
				Select sum(acrescimos) from nota_fiscal_cliente_det NFCD with(nolock)
				join nota_cliente NC with(nolock) on Nc.Id_NF = NFCD.Id_NF and NC.cd_cliente = NFCD.cd_cliente
				where NC.num_proc = @Processo  and cd_produto = @Cd_Produto
				)
	End

	If @Campo='Peso_Liquido'
	Begin
		SET @Resultado=(
				Select sum(Peso_Liquido) from nota_fiscal_cliente_det NFCD with(nolock)
				join nota_cliente NC with(nolock) on Nc.Id_NF = NFCD.Id_NF and NC.cd_cliente = NFCD.cd_cliente
				where NC.num_proc = @Processo  and cd_produto = @Cd_Produto
				)
	End

	If @Campo='Seguro'
	Begin
		SET @Resultado=(
				Select sum(vlr_Seguro) from nota_fiscal_cliente_det NFCD with(nolock)
				join nota_cliente NC with(nolock) on Nc.Id_NF = NFCD.Id_NF and NC.cd_cliente = NFCD.cd_cliente
				where NC.num_proc = @Processo  and cd_produto = @Cd_Produto
				)
	End

	If @Campo='CIF'
	Begin
		SET @Resultado=(
				Select sum(CIF) from nota_fiscal_cliente_det NFCD with(nolock)
				join nota_cliente NC with(nolock) on Nc.Id_NF = NFCD.Id_NF and NC.cd_cliente = NFCD.cd_cliente
				where NC.num_proc = @Processo  and cd_produto = @Cd_Produto
				)
	End

	If @Campo='FOB'
	Begin
		SET @Resultado=(
				Select sum(CIF - vlr_frete - vlr_seguro - isnull(acrescimos,0)) from nota_fiscal_cliente_det NFCD with(nolock)
				join nota_cliente NC with(nolock) on Nc.Id_NF = NFCD.Id_NF and NC.cd_cliente = NFCD.cd_cliente
				where NC.num_proc = @Processo  and cd_produto = @Cd_Produto
				)
	End


	RETURN isnull(@Resultado,0) * dbo.fBuscaPorcentagem_Pedido_Prod(@Processo,@Cd_Pedido,@Cd_Produto)

END









GO
