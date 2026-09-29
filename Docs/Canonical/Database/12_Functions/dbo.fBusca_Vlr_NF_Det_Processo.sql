SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   function [dbo].[fBusca_Vlr_NF_Det_Processo](
@Processo	varchar(16),	
@Campo		varchar(15)
)
RETURNS Float

BEGIN
	Declare @Resultado Float

	If @Campo='Quantidade'
	Begin
		SET @Resultado=(
				Select sum(Quantidade) Quantidade from nota_fiscal_cliente_det NFCD with(nolock)
				join nota_cliente NC with(nolock) on Nc.Id_NF = NFCD.Id_NF  and NC.cd_cliente = NFCD.cd_cliente
				where NC.num_proc = @Processo 				)
--		RETURN @Resultado
	End

	If @Campo='Vlr_FRETE'
	Begin
		SET @Resultado=(
				Select top 1 Vlr_FRETE from nota_fiscal_cliente_det NFCD with(nolock)
				join nota_cliente NC with(nolock) on Nc.Id_NF = NFCD.Id_NF and NC.cd_cliente = NFCD.cd_cliente
				where NC.num_proc = @Processo
				)
--		RETURN @Resultado
	End

	If @Campo='ALIQ_II'
	Begin
		SET @Resultado=(
				Select top 1 ALIQ_II from nota_fiscal_cliente_det NFCD with(nolock)
				join nota_cliente NC with(nolock) on Nc.Id_NF = NFCD.Id_NF and NC.cd_cliente = NFCD.cd_cliente
				where NC.num_proc = @Processo
				)
		RETURN @Resultado
	End

	If @Campo='VL_II'
	Begin
		SET @Resultado=(
				Select top 1 VL_II from nota_fiscal_cliente_det NFCD with(nolock)
				join nota_cliente NC with(nolock) on Nc.Id_NF = NFCD.Id_NF and NC.cd_cliente = NFCD.cd_cliente
				where NC.num_proc = @Processo
				)
--		RETURN @Resultado
	End

	If @Campo='ALIQ_IPI'
	Begin
		SET @Resultado=(
				Select top 1 ALIQ_IPI from nota_fiscal_cliente_det NFCD with(nolock)
				join nota_cliente NC with(nolock) on Nc.Id_NF = NFCD.Id_NF and NC.cd_cliente = NFCD.cd_cliente
				where NC.num_proc = @Processo
				)
--		RETURN @Resultado
	End

	If @Campo='VL_BASE_IPI'
	Begin
		SET @Resultado=(
				Select top 1 VL_BASE_IPI from nota_fiscal_cliente_det NFCD with(nolock)
				join nota_cliente NC with(nolock) on Nc.Id_NF = NFCD.Id_NF and NC.cd_cliente = NFCD.cd_cliente
				where NC.num_proc = @Processo
				)
		
	End
	If @Campo='VL_IPI'
	Begin
		SET @Resultado=(
				Select top 1 VL_IPI from nota_fiscal_cliente_det NFCD with(nolock)
				join nota_cliente NC with(nolock) on Nc.Id_NF = NFCD.Id_NF and NC.cd_cliente = NFCD.cd_cliente
				where NC.num_proc = @Processo
				)
		
	End
	If @Campo='FOB'
	Begin
		SET @Resultado=(
				Select top 1 FOB from nota_fiscal_cliente_det NFCD with(nolock)
				join nota_cliente NC with(nolock) on Nc.Id_NF = NFCD.Id_NF and NC.cd_cliente = NFCD.cd_cliente
				where NC.num_proc = @Processo
				)
	End

	If @Campo='ICMS'
	Begin
		SET @Resultado=(
				Select sum(VL_icms) from nota_fiscal_cliente_det NFCD with(nolock)
				join nota_cliente NC with(nolock) on Nc.Id_NF = NFCD.Id_NF and NC.cd_cliente = NFCD.cd_cliente
				where NC.num_proc = @Processo
				)
		
	End

	If @Campo='IPI_SOMA'
	Begin
		SET @Resultado=(
				Select sum(VL_ipi) from nota_fiscal_cliente_det NFCD with(nolock)
				join nota_cliente NC with(nolock) on Nc.Id_NF = NFCD.Id_NF and NC.cd_cliente = NFCD.cd_cliente
				where NC.num_proc = @Processo
				)
		
	End
	
	RETURN @Resultado

END





GO
