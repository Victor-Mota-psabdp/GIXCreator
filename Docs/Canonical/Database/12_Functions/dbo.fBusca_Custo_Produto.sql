SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  function [dbo].[fBusca_Custo_Produto](
@Processo	varchar(16),	
@Cd_Produto	int,
@TipoTaxa	varchar(50)
)
RETURNS Float

BEGIN
	Declare @Resultado Float


	If @TipoTaxa='DESPACHO'
	begin
		SET @Resultado=Isnull((select Sum(Vlr_Item_Custo) Custo from custo_cliente where Num_Proc = @Processo and Cd_Produto=@Cd_Produto and Cd_tp_tx in (select cd_tp_tx from tipo_taxa where CD_AX_Resultado ='78.2')),0)
		
	end
	else
	begin
		SET @Resultado=Isnull((select Sum(Vlr_Item_Custo) Custo from custo_cliente where Num_Proc = @Processo and Cd_Produto=@Cd_Produto and Cd_tp_tx in (select cd_tp_tx from tipo_taxa where nome_tp_tx like @TipoTaxa)),0)
	end
	RETURN @Resultado

END


GO
