SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure spTipoNCCliente_Sel

AS


select 
	Cd_Pes_Grupo	[CodigoGrupo] ,
	Apelido			[NomeGrupo],
	CD_NC  			[CodigoNC],
	Descricao_NC	[DescricaoNC],
	Ativo			[AtivoNC],
	Case 
		when Ativo_Historico=1 then 'S'
		else 'N'
	End
		[HistoricoAtivo],
	Historico_Padrao [HistoricoPadrao]
		
from 
	tipo_Nc_Cliente with(nolock)
	Join Pessoa PP on pp.cd_pes=cd_pes_Grupo

	

GO
