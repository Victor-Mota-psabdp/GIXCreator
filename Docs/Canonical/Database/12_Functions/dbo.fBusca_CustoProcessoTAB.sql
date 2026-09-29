SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[fBusca_CustoProcessoTAB](
@Processo	varchar(16),
@TipoTaxa	varchar(30)
)
RETURNS Float

BEGIN
	Declare @Resultado Float

	SET @Resultado=Isnull((
			select sum(valor) from custo_processo CP with (nolock) 
			join tipo_taxa TT with (nolock) on TT.cd_tp_tx=CP.cd_tp_tx
			where num_proc=@Processo and Nome_tp_tx like @TipoTaxa),0)
	RETURN @Resultado
END




GO
