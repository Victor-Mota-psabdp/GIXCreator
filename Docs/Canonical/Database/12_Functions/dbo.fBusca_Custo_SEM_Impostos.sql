SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  function [dbo].[fBusca_Custo_SEM_Impostos](
	@Processo	varchar(16),	
	@Cd_Pedido	int,
	@Cd_Produto	int,
	@TipoTaxa	varchar(50)
)
RETURNS Float

BEGIN
	Declare @Resultado Float

	SET @Resultado=Isnull((
		select Sum(Vlr_Item_Custo) Custo from custo_cliente 
		where 
			Num_Proc = @Processo and Cd_Pedido= @Cd_Pedido and Cd_Produto=@Cd_Produto and Prestacao = 'S'
			and Cd_tp_tx in (select cd_tp_tx from tipo_taxa where nome_tp_tx like @TipoTaxa)
			and cd_tp_tx NOT in (select cd_tp_tx from tipo_taxa where nome_tp_tx like '%Imp%Imp%' or nome_tp_tx like '%IPI%' or nome_tp_tx like 'PIS%' or nome_tp_tx like 'Cofins%' or nome_tp_tx like 'SISCOMEX%' or nome_tp_tx like 'Seguro%')
		),0)
	RETURN @Resultado

END


GO
