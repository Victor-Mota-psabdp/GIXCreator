SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select dbo.fBusca_HistoricoDescr_Completo('IMCSR20100902101')
--dbcc checktable(hist_geral)
CREATE	function [dbo].[fBusca_HistoricoDescr_Tipo_S_Completo](
	@Processo varchar(16)
)
RETURNS Varchar(500)

BEGIN
	Declare @Resultado	Varchar(500)
	Declare @Descricao	Varchar(500)
	Declare @DataFU		Datetime
	Declare @Data		Datetime

--	SET @Data=(select top 1 hsgData from hist_geral where HSGProcesso = @Processo and cd_origem = 'U' and cd_tp_ocor not in (53,56) order by HSGData desc)
--	SET @DataFU=(select top 1 hsgDataFU from hist_geral where HSGProcesso = @Processo and cd_origem = 'U' and cd_tp_ocor not in (53,56) order by HSGData desc)
--	SET @Descricao=(select top 1 HSDDescricao from hist_geral where HSGProcesso = @Processo and cd_origem = 'U' and cd_tp_ocor not in (53,56) order by HSGData desc)

	Begin
		select top 1 @Data=hsgData, @DataFU=hsgDataFU, @Descricao=HSDDescricao 
		from hist_geral with(nolock) where HSGProcesso = @Processo 
		and cd_origem = 'U' and disp_cliente='S' and cd_tp_ocor not in (53,56) order by HSGData desc
	End

	if @DataFU is not null and (@DataFU >= @Data)
		Begin
			Set @Resultado= convert(varchar(10), @Data,103) + ' Previsão: ' 
				+ convert(varchar(10),@DataFU,103) + ' - ' + @Descricao
		end
	Else
		Begin
			Set @Resultado= convert(varchar(10), @Data,103) +  ' - ' + @Descricao
		end
		
	RETURN @Resultado

END











GO
