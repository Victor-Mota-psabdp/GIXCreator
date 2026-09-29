SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE function [dbo].[fBusca_HistoricoDescr](
				@Processo varchar(16),	
				@Tipo	int,
				@hoje	datetime
)

RETURNS Varchar(700)

BEGIN
	Declare @Resultado	Varchar(500)
	Declare @Descricao	Varchar(500)
	Declare @DataFU		Datetime
	Declare @Data		Datetime

	if @tipo=0
		begin
			select top 1 @Descricao=HSDDescricao, @DataFU=hsgDataFU, @Data=hsgData from Hist_Geral_UltimoHistorico with(nolock)
			where hsgprocesso=@Processo and disp_cliente='S' and cd_tp_ocor <> '117'
			if @Descricao is null
				Begin
					select top 1 @Descricao=HSDDescricao, @DataFU=hsgDataFU, @Data=hsgData from hist_geral  with(nolock)
					where hsgprocesso=@Processo and disp_cliente='S'  and cd_tp_ocor <> '117' order by hsgseq desc
				End
		end
	Else
		if (@tipo=67) or (@tipo=89) or (@tipo=90) or (@Tipo=95)or (@Tipo=117)
			begin
				select top 1 @Descricao=HSDDescricao, @DataFU=hsgDataFU, @Data=hsgData from hist_geral  with(nolock)
				where hsgprocesso=@Processo and cd_tp_ocor=@tipo order by hsgseq desc
			end
		Else
			Begin
				select top 1 @Descricao=HSDDescricao, @DataFU=hsgDataFU, @Data=hsgData from hist_geral with(nolock)
				where hsgprocesso=@processo and cd_tp_ocor=@tipo AND DISP_CLIENTE='S' order by hsgseq desc
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
