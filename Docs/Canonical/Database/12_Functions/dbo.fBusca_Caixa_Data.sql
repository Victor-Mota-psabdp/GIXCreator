SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[fBusca_Caixa_Data](
@Processo	varchar(16),
@TipoTaxa	varchar(30),
@DC			char(1)
)
RETURNS datetime

AS

BEGIN
	Declare @Resultado datetime
				SET @Resultado =(
							select top 1
								convert(datetime,Dt_Pgto_Rcto_HIA, 103)
							from 
								vwCXAS CX
								join tipo_taxa TT on TT.cd_tp_tx=CX.cd_tp_tx
							where 
								nome_tp_tx like @TipoTaxa
								and Num_proc_hia = @Processo
								and DC_hia=@DC
							order by
								convert(datetime,Dt_Pgto_Rcto_HIA, 103) desc)

	--if left(@Processo,2)='IM'
	--	Begin
	--		SET @Resultado =(
	--						select top 1
	--							convert(datetime,Dt_Pgto_Rcto_HIM, 103)
	--						from 
	--							caixa_hou_imp_mar CX
	--							join tipo_taxa TT on TT.cd_tp_tx=CX.cd_tp_tx
	--						where 
	--							nome_tp_tx like @TipoTaxa
	--							and Num_proc_him = @Processo
	--							and DC_HIM=@DC
	--						order by
	--							convert(datetime,Dt_Pgto_Rcto_HIM, 103) desc)
	--	end
	
	--if left (@Processo,2) = 'IA'
	--	Begin
	--		SET @Resultado =(
	--						select top 1
	--							convert(datetime,Dt_Pgto_Rcto_HIA, 103)
	--						from 
	--							caixa_hou_imp_aer CX
	--							join tipo_taxa TT on TT.cd_tp_tx=CX.cd_tp_tx
	--						where 
	--							nome_tp_tx like @TipoTaxa
	--							and Num_proc_hia = @Processo
	--							and DC_HIA=@DC
	--						order by
	--							convert(datetime,Dt_Pgto_Rcto_HIA, 103) desc)
	--	end

	--if left (@Processo,2) = 'IO'
	--	Begin
	--		SET @Resultado =(
	--						select top 1
	--							convert(datetime,Dt_Pgto_Rcto_HIO, 103)
	--						from 
	--							caixa_hou_imp_out CX
	--							join tipo_taxa TT on TT.cd_tp_tx=CX.cd_tp_tx
	--						where 
	--							nome_tp_tx like @TipoTaxa
	--							and Num_proc_hio = @Processo
	--							and DC_HIO=@DC
	--						order by
	--							convert(datetime,Dt_Pgto_Rcto_HIO, 103) desc)
	--	end

	RETURN @Resultado
END


GO
