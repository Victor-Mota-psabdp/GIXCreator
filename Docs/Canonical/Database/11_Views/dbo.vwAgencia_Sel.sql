SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vwAgencia_Sel]  
AS  
	SELECT
		A.Cd_Agencia		AS [Code],
		A.Nome_Agencia		AS [Agency Name],
		A.Cd_Banco			AS [Bank Code],
		B.Nome_Banco		AS [Bank Name],
		A.Ativo				AS [Enabled],
		A.Dt_Ins			AS [Insert Date],
		A.Cd_Usuario		AS [User Code],
		US.Nome_Usuario		AS [User Name]
	FROM Agencia A (NOLOCK)  
		JOIN Banco B (NOLOCK) ON A.Cd_Banco = B.Cd_Banco
		Left Join Usuario US with(NOLOCK)  on US.Cd_Usuario = A.Cd_Usuario	
	

GO
