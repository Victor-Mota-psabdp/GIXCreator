SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwPessoaSimplesSemGrupos_Sel]
AS
SELECT     ID, [Company Name (Short Name)], CNPJ, [Complete Name]
FROM         (SELECT     P.Cd_Pes AS ID, P.Apelido AS [Company Name (Short Name)], P.Num_CPF_CNPJ AS CNPJ,
				P. Nome_Raz_Soc AS [Complete Name]
           FROM          dbo.Pessoa P
           left join Grupo G on P.Cd_Pes = G.Cd_Pes_Grupo
           WHERE      
			(Desat_Pes = 'N' and G.Grupo is null)) AS Alias



GO
