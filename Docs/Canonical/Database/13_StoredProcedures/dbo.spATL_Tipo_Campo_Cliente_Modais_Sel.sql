SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from Tipo_Campo_Cliente_Modais_Modais
--sp_help Tipo_Campo_Cliente_Modais
CREATE procedure [dbo].[spATL_Tipo_Campo_Cliente_Modais_Sel]
(	
	@Id_Campo		Int,
	@Cd_Pes_Grupo	VarChar(10),
	@Descr_campo	VarChar(30),
	@Tipo			char(1)
)
as
		
/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codgo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos

X /// para ver se tem algum job com este campo preenchido
*/

--IF @Tipo = 'A'  or @Tipo = 'B' or @Tipo = 'A'  or @Tipo = 'B'
	--Begin
		SELECT
			T.Id_Campo							[Code],
			T.Cd_Pes_Grupo						[Group Code],			
			T.Descr_Campo						[Field Description],
			T.Tipo								[Type Code],			
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
			join Tipo_Campo_Cliente_Modais M with(nolock) on M.Id_Campo = T.Id_Campo			
		where
			T.Id_Campo = @Id_Campo


GO
