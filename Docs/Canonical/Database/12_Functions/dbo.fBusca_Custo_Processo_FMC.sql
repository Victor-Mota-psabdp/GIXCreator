SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  function [dbo].[fBusca_Custo_Processo_FMC](
@Processo	varchar(16),
@TipoTaxa	varchar(30)
)
RETURNS Float

BEGIN
	Declare @Resultado Float

	SET @Resultado=Isnull((
			select sum(vlr_item_custo) from custo_cliente CC 
			join tipo_taxa TT on TT.cd_tp_tx=CC.cd_tp_tx
			where num_proc=@Processo  and Nome_tp_tx like @TipoTaxa),0)
	RETURN @Resultado
END




GO
