SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwATL_Bank_Sel]  
AS  
SELECT     
	[Bank Code]
	,[Bank Name]
	,[Bank Intl. Code]
FROM         
	(SELECT Cd_Banco AS [Bank Code]
	,Nome_Banco AS [Bank Name]  
	,Cod_Banco_Rem AS [Bank Intl. Code] 
	FROM  dbo.Banco (NOLOCK)) AS ALIAS  
               
                         
  
  
  
  
  
  
  
GO
