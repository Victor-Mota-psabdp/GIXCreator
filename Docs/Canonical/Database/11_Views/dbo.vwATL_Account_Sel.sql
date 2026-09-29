SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwATL_Account_Sel]  
AS  
SELECT     
		 [Account ID]
		,[Bank Code]
		,[Bank Name]
		,[Agency Code]
		,[Account]
		,[Billing Code]
		,[Assignor]
		,[OBS]
		,[Account Enabled]
		,[Generate Remessa Enabled]
		,[Generate Boleto Enabled]
FROM  
	(
		SELECT 
		ACC.id_Account			AS [Account ID]
		,ACC.Cd_Bank				AS [Bank Code]
		,BAN.Nome_Banco			AS [Bank Name]
		,ACC.Cd_Agency			AS [Agency Code]
		,ACC.Account				AS [Account]
		,ACC.Billing_Code			AS [Billing Code]
		,ACC.Assignor				AS [Assignor]
		,ACC.OBS 					AS [OBS]
		,CASE 
		WHEN ACC.Account_Enabled = 1 THEN 'Y'
		ELSE 'N'
		END 					AS [Account Enabled]
		,CASE 
		WHEN ACC.Generate_Remessa_Enabled = 1 THEN 'Y'
		ELSE 'N'
		END 					AS [Generate Remessa Enabled]
		,CASE 
		WHEN ACC.Generate_Boleto_Enabled = 1 THEN 'Y'
		ELSE 'N'
		END 					AS [Generate Boleto Enabled]
		FROM Account ACC (NOLOCK)
		INNER JOIN AGENCIA AGE (NOLOCK)
			ON ACC.CD_BANK = AGE.Cd_Banco
			AND ACC.CD_AGENCY = AGE.Cd_Agencia
		INNER JOIN banco BAN (NOLOCK)
			ON AGE.Cd_Banco = BAN.Cd_Banco 
	) AS ALIAS  


GO
