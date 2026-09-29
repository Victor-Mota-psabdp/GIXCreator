SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Alterado di 17/05/2017 - Cadu
CREATE VIEW [dbo].[vwSolPgtoCtaCteApr]
AS
SELECT TOP (100) PERCENT 
			(CASE WHEN SP.Status_Aprovacao IS NULL AND SP.Status = 1 THEN 'Created' 
				WHEN SP.Status_Aprovacao IS NULL AND SP.Status = 0 THEN 'Canceled' 
				WHEN SP.Status_Aprovacao = 'A' AND SP.Status = 1 THEN 'Approved'
				WHEN SP.Status_Aprovacao = 'A' AND SP.Status = 0 THEN 'Canceled' 
				WHEN (SP.Status_Aprovacao = 'D' Or SP.Status_Aprovacao = 'E')
				AND SP.Status = 1 or SP.Status = 0 THEN 'Rejected' END) AS Status, 
                  
             (CASE WHEN SP.Status_Aprovacao = 'A' THEN 'X' ELSE '' END) AS Approved, 
             
             (CASE WHEN SP.Status_Aprovacao = 'D' Or  SP.Status_Aprovacao = 'E' THEN 'X' ELSE '' END) AS Reject,
              '' AS History, 
              SP.ID AS [Register Number], 
              SP.Cd_Cred_Dev AS [Code Debitor], 
              PS.Apelido AS [Name Debitor], 
              PS.Num_CPF_CNPJ AS CNPJ, 
              SP.Dt_Pgto_Rcto AS [Register Date], 
              SP.Vlr_Doc AS [Value Debit], 
              SP.Dt_Vcto AS [Due Date], 
              SP.Cd_Tp_Doc AS [Code Document], 
              TD.Nome_Tp_Doc AS [Name Document], 
              SOL.Nome_Usuario AS Solicitante, 
              GR.Nome_Usuario AS Gerente, 
              DR.Nome_Usuario AS Diretor,
              SP.Doc_Register
FROM dbo.Sol_Pgto_Cta_Cte AS SP WITH (nolock) INNER JOIN
      dbo.Usuario AS SOL ON SP.Cd_Solicitante = SOL.Cd_Usuario LEFT OUTER JOIN
      dbo.Usuario AS GR ON SP.Cd_Gerente = GR.Cd_Usuario LEFT OUTER JOIN
      dbo.Usuario AS DR ON SP.Cd_Diretor = DR.Cd_Usuario INNER JOIN
      dbo.Pessoa AS PS ON SP.Cd_Cred_Dev = PS.Cd_Pes INNER JOIN
      dbo.Tipo_Documento AS TD ON SP.Cd_Tp_Doc = TD.Cd_Tp_Doc
ORDER BY [Register Number]





--SELECT     TOP (100) PERCENT (CASE WHEN SP.Status_Aprovacao IS NULL AND SP.Status = 1 THEN 'Created' WHEN SP.Status_Aprovacao IS NULL AND 
--                      SP.Status = 0 THEN 'Canceled' WHEN SP.Status_Aprovacao = 'A' AND SP.Status = 1 THEN 'Closed' WHEN (SP.Status_Aprovacao = 'D' Or SP.Status_Aprovacao = 'E') AND SP.Status = 1 THEN 'Rejected' END) AS Status, 
--                      (CASE WHEN SP.Status_Aprovacao = 'A' THEN 'X' ELSE '' END) AS Approved, (CASE WHEN SP.Status_Aprovacao = 'D' Or  SP.Status_Aprovacao = 'E' THEN 'X' ELSE '' END) AS Reject, '' AS History, 
--                      SP.ID AS [Register Number], SP.Cd_Cred_Dev AS [Code Debitor], PS.Apelido AS [Name Debitor], PS.Num_CPF_CNPJ AS CNPJ, SP.Dt_Pgto_Rcto AS [Register Date], 
--                      SP.Vlr_Doc AS [Value Debit], SP.Dt_Vcto AS [Due Date], SP.Cd_Tp_Doc AS [Code Document], TD.Nome_Tp_Doc AS [Name Document], 
--                      SOL.Nome_Usuario AS Solicitante, GR.Nome_Usuario AS Gerente, DR.Nome_Usuario AS Diretor,
--                      SP.Doc_Register
--FROM         dbo.Sol_Pgto_Cta_Cte AS SP WITH (nolock) INNER JOIN
--                      dbo.Usuario AS SOL ON SP.Cd_Solicitante = SOL.Cd_Usuario LEFT OUTER JOIN
--                      dbo.Usuario AS GR ON SP.Cd_Gerente = GR.Cd_Usuario LEFT OUTER JOIN
--                      dbo.Usuario AS DR ON SP.Cd_Diretor = DR.Cd_Usuario INNER JOIN
--                      dbo.Pessoa AS PS ON SP.Cd_Cred_Dev = PS.Cd_Pes INNER JOIN
--                      dbo.Tipo_Documento AS TD ON SP.Cd_Tp_Doc = TD.Cd_Tp_Doc
--ORDER BY [Register Number]








GO
