SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwATL_Tipo_Campo_Cliente_Sel]
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
			T.Campo_Exibicao					[Display Field],
			T.Where_Field						[Where Field],
			isnull(M.House,0)					[House],
			isnull(M.Master,0)					[Master],
			isnull(M.Export,0)					[Export],
			isnull(M.Import,0)					[Import],
			isnull(M.Air,0)						[Air],
			isnull(M.Ocean,0)					[Ocean],
			isnull(M.Other,0)					[Other]
		From 
			Tipo_Campo_Cliente T	with(nolock) 			
			join Grupo G with(nolock) on T.Cd_Pes_Grupo = G.Cd_Pes_Grupo
			join Pessoa P with(nolock)  on P.Cd_Pes =G.Cd_Pes_Grupo
			join Tipo_Variavel V with(nolock)  on V.cd_tipo = T.Tipo
			left join tipo_campo_cliente_Modais M on M.Id_campo = T.Id_Campo

GO
