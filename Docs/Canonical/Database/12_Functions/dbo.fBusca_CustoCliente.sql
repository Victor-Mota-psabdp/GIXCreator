SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select [dbo].[fBusca_CustoCliente]('IMCSR20100660701','AFRMM - CHB')

CREATE function [dbo].[fBusca_CustoCliente]--'IMCSR20100660701','AFRMM'
(
@Processo	varchar(16),
@TipoTaxa	varchar(30)
)
RETURNS Float

BEGIN
	Declare @Resultado Float

	SET @Resultado=Isnull((
			select sum(vlr_item_custo) from custo_cliente CP 
			join tipo_taxa TT on TT.cd_tp_tx=CP.cd_tp_tx
			where num_proc=@Processo and Nome_tp_tx like @TipoTaxa),0)
	RETURN @Resultado
END




GO
