SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE	function [dbo].[fBusca_Historico_DataFU]
(
	@Processo varchar(16),	
	@Tipo	int
)
RETURNS Datetime

BEGIN
	Declare @Resultado Datetime

	SET @Resultado=(select top 1 HSGDataFU from hist_geral with(nolock) where hsgprocesso=@processo and cd_tp_ocor=@tipo and Disp_Cliente='S'
	order by hsgseq desc)
	
	RETURN @Resultado

END



GO
