SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[fBusca_CaixaMASTaxaVlr](
@Processo varchar(14),
@Taxa varchar(30),
@DC char(1)
)
RETURNS Float

BEGIN
	Declare @Resultado Float

	If left(@Processo,2) = 'IM'
		Begin
			SET @Resultado=Isnull((
				select sum(vlr_pgto_rcto_mim) from caixa_mas_imp_mar CC 
				join tipo_taxa TT on TT.cd_tp_tx=CC.cd_tp_tx
				where num_proc_MIM=@Processo and DC_MIM = @DC and Nome_tp_tx like @Taxa),0)
		End

	If left(@Processo,2) = 'IA'
		Begin
			SET @Resultado=Isnull((
				select sum(vlr_pgto_rcto_miA) from caixa_mas_imp_aer CC 
				join tipo_taxa TT on TT.cd_tp_tx=CC.cd_tp_tx
				where num_proc_MIA=@Processo and DC_MIA = @DC and Nome_tp_tx like @Taxa),0)
		End

	If left(@Processo,2) = 'IO'
		Begin
			SET @Resultado=Isnull((
				select sum(vlr_pgto_rcto_miO) from caixa_mas_imp_out CC 
				join tipo_taxa TT on TT.cd_tp_tx=CC.cd_tp_tx
				where num_proc_MIO=@Processo and DC_MIO = @DC and Nome_tp_tx like @Taxa),0)
		End

	RETURN @Resultado
END



GO
