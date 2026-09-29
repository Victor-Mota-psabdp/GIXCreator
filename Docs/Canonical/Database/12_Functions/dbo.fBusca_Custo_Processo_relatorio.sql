SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  function [dbo].[fBusca_Custo_Processo_relatorio](  
@Processo varchar(16),  
@TipoTaxa varchar(30),
@TipoTaxa2 varchar(30),
@TipoTaxa3 varchar(30)
)  
RETURNS float



BEGIN  
	Declare @Resultado float  

	SET @TipoTaxa = '%' + @TipoTaxa + '%'
	SET @TipoTaxa2 = '%' + @TipoTaxa2 + '%'

	IF ISNULL(@TipoTaxa3,'') = ''
		SET @TipoTaxa3 = 'XXXXXXXXXXXXXXXXXXXXXXXXX'
	ELSE
		SET @TipoTaxa3 = '%' + @TipoTaxa3 + '%'
	
	
  
	SET @Resultado=	isnull((  
					select sum(Isnull(vlr_item_custo,0))
					from tmp_relatorio_Custo_Processo_TAXAS CC (nolock)  
					INNER join tipo_taxa TT (nolock) 
						on TT.cd_tp_tx=CC.cd_tp_tx  
					where num_proc=@Processo 
					and TT.Nome_tp_tx like @TipoTaxa
					and TT.Nome_tp_tx like @TipoTaxa2
					And TT.Nome_tp_tx NOT like @TipoTaxa3
					),0)

	SET @Resultado =@Resultado


	RETURN @Resultado  
END  
GO
