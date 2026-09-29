SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fBusca_CaixaTaxaVlr](
@Processo varchar(16),
@Taxa varchar(30),
@DC char(1)
)
RETURNS Float

BEGIN
	Declare @Resultado Float
	
	Begin
			SET @Resultado=Isnull((
				select sum(vlr_pgto_rcto_hia) from vwCXAS CC 
				join tipo_taxa TT on TT.cd_tp_tx=CC.cd_tp_tx
				where num_proc_HIa=@Processo and DC_HIa = @DC and Nome_tp_tx like @Taxa),0)
		End

	--If left(@Processo,2) = 'IM'
	--	Begin
	--		SET @Resultado=Isnull((
	--			select sum(vlr_pgto_rcto_him) from caixa_hou_imp_mar CC 
	--			join tipo_taxa TT on TT.cd_tp_tx=CC.cd_tp_tx
	--			where num_proc_HIM=@Processo and DC_HIM = @DC and Nome_tp_tx like @Taxa),0)
	--	End

	--If left(@Processo,2) = 'IA'
	--	Begin
	--		SET @Resultado=Isnull((
	--			select sum(vlr_pgto_rcto_hiA) from caixa_hou_imp_aer CC 
	--			join tipo_taxa TT on TT.cd_tp_tx=CC.cd_tp_tx
	--			where num_proc_HIA=@Processo and DC_HIA = @DC and Nome_tp_tx like @Taxa),0)
	--	End

	--If left(@Processo,2) = 'IO'
	--	Begin
	--		SET @Resultado=Isnull((
	--			select sum(vlr_pgto_rcto_hiO) from caixa_hou_imp_out CC 
	--			join tipo_taxa TT on TT.cd_tp_tx=CC.cd_tp_tx
	--			where num_proc_HIO=@Processo and DC_HIO = @DC and Nome_tp_tx like @Taxa),0)
	--	End

	RETURN @Resultado
END






GO
