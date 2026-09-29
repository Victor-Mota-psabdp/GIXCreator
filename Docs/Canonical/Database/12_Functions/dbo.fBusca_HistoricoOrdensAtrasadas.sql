SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[fBusca_HistoricoOrdensAtrasadas](
				@Processo varchar(16),	
				@hoje	datetime
)

RETURNS Varchar(500)

BEGIN
	Declare @Resultado	Varchar(500)
	Declare @Descricao	Varchar(500)
	Declare @DataFU		Datetime
	Declare @Data		Datetime
	
	Begin
		select top 1 @Descricao=HSDDescricao, @DataFU=hsgDataFU, @Data=hsgData from hist_geral with(nolock)
		where hsgprocesso=@processo AND DISP_CLIENTE='S' order by hsgseq desc
	End
-------------------------------------------------------------------------------------
	if @DataFU is not null and (@DataFU > @Data)
		Begin
			Set @Resultado= convert(varchar(10), @Data,103) + ' Previsão: ' + convert(varchar(10),@DataFU,103) + ' - ' + @Descricao
		end
	Else
		Begin
			Set @Resultado= convert(varchar(10), @Data,103) +  ' - ' + Rtrim(@Descricao)
		end

	RETURN @Resultado

END










GO
