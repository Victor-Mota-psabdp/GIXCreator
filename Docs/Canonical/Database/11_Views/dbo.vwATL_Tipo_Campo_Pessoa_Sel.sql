SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vwATL_Tipo_Campo_Pessoa_Sel]
AS
	Select		
			T.Id_Campo							[Code],	
			T.Cd_Pes_Grupo						[Group Code],
			P.Apelido							[Group Name],
			T.Descr_Campo						[Field Description],
			T.Tipo								[Type Code],
			V.Nome_Tipo							[Type Name],
			T.Tab_Relacionada					[Related Table],
			T.Cod_Busca							[Search Code],
			T.Campo_Exibicao					[Display Field]
		From 
			Tipo_Campo_Pessoa T	with(nolock) 			
			join Grupo G with(nolock) on T.Cd_Pes_Grupo = G.Cd_Pes_Grupo
			join Pessoa P with(nolock)  on P.Cd_Pes =G.Cd_Pes_Grupo
			join Tipo_Variavel V with(nolock)  on V.cd_tipo = T.Tipo

GO
