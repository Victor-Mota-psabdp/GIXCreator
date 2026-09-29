SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE        function [dbo].[fBusca_Historico](
				@Processo varchar(16),	
				@Tipo	int,
				@hoje datetime

)
RETURNS Datetime

BEGIN
		Declare @Resultado Datetime
	if @tipo=54
		BEGIN
			SET @Resultado=(select top 1 HSGDataFU from hist_geral with(nolock) where hsgprocesso=@processo and cd_tp_ocor=@tipo and dbo.Dias_Uteis(hsgdata,0) >= convert(datetime,dbo.strhoje(@hoje),105)
			order by hsgseq desc)
		END
	ELSE
		BEGIN
			SET @Resultado=(select top 1 HSGDataFU from hist_geral with(nolock) where hsgprocesso=@processo and cd_tp_ocor=@tipo 
			order by hsgseq desc)
		END
		RETURN @Resultado

END



















GO
