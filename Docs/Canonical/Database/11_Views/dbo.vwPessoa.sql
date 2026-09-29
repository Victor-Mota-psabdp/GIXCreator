SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwPessoa]
AS
SELECT     PS.Cd_Pes AS Code, PS.Apelido AS [Company Name], PS.Nome_Raz_Soc AS [Complete Name], PS.Num_CPF_CNPJ AS CNPJ, PS.Num_RG_IE AS IE, 
                      TA.Nome_Tp_Ativ AS [Type Of Activity], TG.Nome_Tp_Grupo AS [Group Type], US.Nome_Usuario AS [User Name], PS.Dt_Cad AS Date, 
                      (CASE WHEN Desat_Pes = 'N' THEN CONVERT(Bit, 1) ELSE CONVERT(Bit, 0) END) AS Disable, PS.Obs_Pes AS Notes, PS.Num_Insc_Munic AS IM, 
                      PS.GLOBAL_ENTITY_ID AS [Global Entity ID]
FROM         dbo.Pessoa AS PS WITH (nolock) LEFT OUTER JOIN
                      dbo.Tipo_Atividade AS TA WITH (nolock) ON PS.Cd_Tp_Ativ = TA.Cd_Tp_Ativ LEFT OUTER JOIN
                      dbo.Tipo_Grupo AS TG WITH (nolock) ON PS.Cd_Tp_Grupo = TG.Cd_Tp_Grupo LEFT OUTER JOIN
                      dbo.Usuario AS US WITH (nolock) ON PS.Cd_Usuario = US.Cd_Usuario
WHERE     (PS.Desat_Pes = 'N')



GO
