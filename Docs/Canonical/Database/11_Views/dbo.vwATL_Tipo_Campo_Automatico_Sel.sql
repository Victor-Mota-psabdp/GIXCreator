SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from Tipo_Campo_Automatico
--sp_help Tipo_Campo_Automatico
CREATE VIEW [dbo].[vwATL_Tipo_Campo_Automatico_Sel]
AS
	Select 
			T.Id_Campo							[Code],
			T.Cd_Pes_Grupo						[Group Code],
			P.Apelido							[Group Name],
			T.Tipo								[Type Code],
			V.nome_Tipo							[Type Name],
			T.Descr_Campo						[Field Description],
			T.Tab_Relacionada					[Related Table],
			T.Cod_Busca							[Search Code],
			T.Campo_Exibicao					[Display Field],
			T.[View]							[View]
	--Select 
	--	P.Apelido							[Grupo],
	--	T.Descr_Campo						[Descricao do Campo],
	--	V.nome_Tipo							[Tipo],
	--	T.Tab_Relacionada					[Tabela Relacionada],
	--	T.Cod_Busca							[Codigo Busca],
	--	T.Campo_Exibicao					[Campo Exibicao]
	From 
		Tipo_Campo_Automatico T	with(nolock) 			
		join Grupo G with(nolock) on T.Cd_Pes_Grupo = G.Cd_Pes_Grupo
		join Pessoa P with(nolock)  on P.Cd_Pes =G.Cd_Pes_Grupo
		join Tipo_Variavel V with(nolock)  on V.cd_tipo = T.Tipo


GO
