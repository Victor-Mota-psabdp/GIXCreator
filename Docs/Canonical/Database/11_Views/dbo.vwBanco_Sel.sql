SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwBanco_Sel]

AS  

SELECT 
	B.Cd_Banco			AS [Code],
	B.Nome_Banco		AS [Bank Name],
	B.Cod_Banco_Rem		AS [Bank Intl. Code],
	B.Cd_Cta_Ctb		AS [Current Account],
	B.Ativo				AS [Enabled],
	B.Dt_Ins			AS [Insert Date],
	B.Cd_Usuario		AS [User Code],
	US.Nome_Usuario		AS [User Name]
FROM 
	Banco B with(NOLOCK)  
	Left Join Usuario US with(NOLOCK)  on US.Cd_Usuario = B.Cd_Usuario
   
  

GO
