SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Function [dbo].[fBusca_Hist_Geral_Sistema_UltimaAtualizacao]--'EMFMC201506006BR','47'
(
	@Processo varchar(16),
	@Tipo int
)
RETURNS Datetime

BEGIN
	Declare @Resultado Datetime

	SET @Resultado=(select top 1 HSGData from Hist_Geral_Sistema with(nolock) where hsgprocesso=@processo 
					and cd_tp_ocor=@tipo
					order by hsgseq desc)
	
	RETURN @Resultado

END



GO
