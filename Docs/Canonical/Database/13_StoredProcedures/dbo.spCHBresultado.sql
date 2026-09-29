SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure spCHBresultado
		@mes	int,
		@ano	int

as

select modal,sum(valor) Valor from cml.dbo.clientes_top
where nome_tp_tx in (
'Serviços de Despacho 1','Emissão de Form A 1','Emissão de Form A 2','Emissão de Form A 3',
'Emissão de Form A 4','Emissão de Form A 5','Emissão de Form A','Emissão de RE'

)
and ano=@ano and mes=@mes

group by modal


GO
