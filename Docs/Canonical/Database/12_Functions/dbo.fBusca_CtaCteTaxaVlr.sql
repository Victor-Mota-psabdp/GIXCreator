SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[fBusca_CtaCteTaxaVlr](
@Processo varchar(16),
@Taxa varchar(30),
@DC char(1)
)
RETURNS Float

BEGIN
	Declare @Resultado Float

	If left(@Processo,2) = 'IM'
		Begin
			SET @Resultado=Isnull((
				select sum(vlr_org_HIM) from cta_cte_hou_imp_mar CC 
				join tipo_taxa TT on TT.cd_tp_tx=CC.cd_tp_tx
				where num_proc_HIM=@Processo and DC_HIM = @DC and Nome_tp_tx like @Taxa),0)
		End

	If left(@Processo,2) = 'IA'
		Begin
			SET @Resultado=Isnull((
				select sum(vlr_org_HIA) from cta_cte_hou_imp_aer CC 
				join tipo_taxa TT on TT.cd_tp_tx=CC.cd_tp_tx
				where num_proc_HIA=@Processo and DC_HIA = @DC and Nome_tp_tx like @Taxa),0)
		End

	If left(@Processo,2) = 'IO'
		Begin
			SET @Resultado=Isnull((
				select sum(vlr_org_HIO) from cta_cte_hou_imp_out CC 
				join tipo_taxa TT on TT.cd_tp_tx=CC.cd_tp_tx
				where num_proc_HIO=@Processo and DC_HIO = @DC and Nome_tp_tx like @Taxa),0)
		End

	If left(@Processo,2) = 'EM'
		Begin
			SET @Resultado=Isnull((
				select sum(vlr_org_HEM) from cta_cte_hou_exp_mar CC 
				join tipo_taxa TT on TT.cd_tp_tx=CC.cd_tp_tx
				where num_proc_HEM=@Processo and DC_HEM = @DC and Nome_tp_tx like @Taxa),0)
		End

	If left(@Processo,2) = 'EA'
		Begin
			SET @Resultado=Isnull((
				select sum(vlr_org_HEA) from cta_cte_hou_exp_aer CC 
				join tipo_taxa TT on TT.cd_tp_tx=CC.cd_tp_tx
				where num_proc_HEA=@Processo and DC_HEA = @DC and Nome_tp_tx like @Taxa),0)
		End

	If left(@Processo,2) = 'EO'
		Begin
			SET @Resultado=Isnull((
				select sum(vlr_org_HEO) from cta_cte_hou_exp_out CC 
				join tipo_taxa TT on TT.cd_tp_tx=CC.cd_tp_tx
				where num_proc_HEO=@Processo and DC_HEO = @DC and Nome_tp_tx like @Taxa),0)
		End

	RETURN @Resultado
END






GO
