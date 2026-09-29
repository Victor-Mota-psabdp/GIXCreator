SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  function [dbo].[fBusca_Custo_Processo_SemImpostos](
@Processo	varchar(16)
)
RETURNS Float

BEGIN
	Declare @Resultado Float

	SET @Resultado=Isnull((
	
			select sum(vlr_item_custo) from custo_cliente CC 
		
			where num_proc=@Processo and (Prestacao='S' or Prestacao is null) and 
			
			Cd_tp_Tx not in (select cd_tp_Tx from tipo_Taxa_custo_akzo)

				)
			,0)
	RETURN @Resultado
END



GO
