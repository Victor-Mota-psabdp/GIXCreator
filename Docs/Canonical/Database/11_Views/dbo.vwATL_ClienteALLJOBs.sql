SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwATL_ClienteALLJOBs]
AS
select 
	num_proc,
	cd_fornecedor,
	TT.Dt_Criacao			[Register Date],
	TT.num_proc				[JOB],			
	TT.cd_cliente			[Client Code],
	CLI.Apelido				[Client Name],	
	TT.cd_fornecedor		[Provider Code],
	PRO.Apelido				[Provider Name],		
	TT.DATA					[Data],
	TT.Master				[Master],
	TT.ETA					[ETA],
	TT.ATD					[ATD],
	TT.ATA					[ATA],
	TT.Cd_local				[Origin Code],
	ORG.Nome_Local			[Origin  Name],
	TT.ID_Status			[Status Code],
	TSP.Status_Descricao	[Status Description],
	LLP.Cd_Pes_Grupo		[Group Code],
	GRU.Apelido				[Group Name]
from 
	vwClienteALLJOBS TT with(nolock)
	left join Pessoa CLI with(nolock) on CLI.Cd_Pes = TT.cd_cliente
	left join Pessoa PRO with(nolock) on PRO.Cd_Pes = TT.cd_fornecedor
	left join Localidade ORG with(nolock) on ORG.Cd_Local = TT.Cd_local
	left join Tipo_Status_Processo TSP with(nolock) on TSP.ID_Status = TT.ID_Status
	left join Pessoa_LLP LLP with(nolock) on LLP.Cd_Pes = TT.cd_cliente
	left join Pessoa GRU with(nolock) on GRU.Cd_Pes = LLP.Cd_Pes_Grupo

GO
