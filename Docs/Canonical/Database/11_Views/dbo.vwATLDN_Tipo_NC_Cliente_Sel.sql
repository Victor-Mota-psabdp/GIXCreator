SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwATLDN_Tipo_NC_Cliente_Sel]
AS
	select			
		T.Cd_NC				[GNC Display Code],
		T.Descricao_nC		[GNC Display Code Description],
		T.Parte_Resp		[Responsible Party],
		T.Processo			[Process],
		T.Descricao_NC_ENG	[NC],
		T.Descricao_NC_PTG	[NC Translated],
		T.ativo				[Enabled],
		T.Historico_Padrao	[Default History],
		T.Ativo_Historico	[Enable History],
		T.cd_pes_grupo		[Group Code],
		P.Apelido			[Group Name]
		from 
		Tipo_NC_Cliente T with(nolock)
		left join Grupo G with(nolock) on G.cd_pes_grupo = T.cd_pes_grupo
		left join Pessoa P with(nolock) on P.cd_pes = G.cd_pes_grupo

GO
