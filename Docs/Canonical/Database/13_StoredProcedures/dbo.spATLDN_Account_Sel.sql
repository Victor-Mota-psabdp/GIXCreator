SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spATLDN_Account_Sel]
(  
	@id_Account			INT, 
	@cd_bank			CHAR(3),  
	@Cd_Agency			CHAR(5),
	@Tipo				CHAR(1)  
)  
AS 

IF @Tipo = 'A' OR @Tipo = 'B'  
	BEGIN  
		SELECT 
			ACC.id_Account				AS [Account ID],
			ACC.cd_bank					AS [Bank Code],
			BAN.Nome_Banco				AS [Bank Name],
			ACC.Cd_Agency				AS [Agency Code],
			AGE.Nome_Agencia			AS [Agency Name],
			ACC.Account					AS [Account],
			ACC.Billing_Code			AS [Billing Code],
			ACC.Assignor				AS [Assignor],
			ACC.Obs 					AS [OBS],
			ACC.Account_Enabled 			AS [Enabled],
			ACC.Generate_Remessa_Enabled AS [Generate Remessa Enabled],
			ACC.Generate_Boleto_Enabled AS [Generate Boleto Enabled],
			ACC.Cd_User					as [User Code],
			US.Nome_Usuario				as [User Name]
		FROM Account ACC (NOLOCK)
			JOIN AGENCIA AGE (NOLOCK)	ON ACC.CD_BANK = AGE.Cd_Banco AND ACC.CD_AGENCY = AGE.Cd_Agencia
			JOIN banco BAN (NOLOCK)	ON AGE.Cd_Banco = BAN.Cd_Banco
			left join Usuario US (NOLOCK)	ON US.cd_usuario = ACC.Cd_User
	END  
  
IF @Tipo = 'C' OR @Tipo = 'D'  
	BEGIN 
		SELECT 
			ACC.id_Account				AS [Account ID],
			ACC.cd_bank				AS [Bank Code],
			BAN.Nome_Banco				AS [Bank Name],
			ACC.Cd_Agency				AS [Agency Code],
			AGE.Nome_Agencia			AS [Agency Name],
			ACC.Account				AS [Account],
			ACC.Billing_Code			AS [Billing Code],
			ACC.Assignor				AS [Assignor],
			ACC.Obs 					AS [OBS],
			ACC.Account_Enabled 			AS [Enabled],
			ACC.Generate_Remessa_Enabled AS [Generate Remessa Enabled],
			ACC.Generate_Boleto_Enabled AS [Generate Boleto Enabled],
			ACC.Cd_User					as [User Code],
			US.Nome_Usuario				as [User Name]
		FROM Account ACC (NOLOCK)
			JOIN AGENCIA AGE (NOLOCK)	ON ACC.CD_BANK = AGE.Cd_Banco AND ACC.CD_AGENCY = AGE.Cd_Agencia
			JOIN banco BAN (NOLOCK)	ON AGE.Cd_Banco = BAN.Cd_Banco
			left join Usuario US (NOLOCK)	ON US.cd_usuario = ACC.Cd_User
		WHERE 
			ACC.id_Account =@id_Account    
	END  

IF @Tipo = 'N'  
	BEGIN  
		SELECT 
			ACC.id_Account				AS [Account ID],
			ACC.cd_bank				AS [Bank Code],
			BAN.Nome_Banco				AS [Bank Name],
			ACC.Cd_Agency				AS [Agency Code],
			AGE.Nome_Agencia			AS [Agency Name],
			ACC.Account				AS [Account],
			ACC.Billing_Code			AS [Billing Code],
			ACC.Assignor				AS [Assignor],
			ACC.Obs 					AS [OBS],
			ACC.Account_Enabled 			AS [Enabled],
			ACC.Generate_Remessa_Enabled AS [Generate Remessa Enabled],
			ACC.Generate_Boleto_Enabled AS [Generate Boleto Enabled],
			ACC.Cd_User					as [User Code],
			US.Nome_Usuario				as [User Name]
		FROM Account ACC (NOLOCK)
			JOIN AGENCIA AGE (NOLOCK)	ON ACC.CD_BANK = AGE.Cd_Banco AND ACC.CD_AGENCY = AGE.Cd_Agencia
			JOIN banco BAN (NOLOCK)	ON AGE.Cd_Banco = BAN.Cd_Banco
			left join Usuario US (NOLOCK)	ON US.cd_usuario = ACC.Cd_User
		WHERE 
			ACC.cd_bank = @cd_bank 
	END
	
IF @Tipo = 'O'  
	BEGIN  
		SELECT 
			ACC.id_Account				AS [Account ID],
			ACC.cd_bank				AS [Bank Code],
			BAN.Nome_Banco				AS [Bank Name],
			ACC.Cd_Agency				AS [Agency Code],
			AGE.Nome_Agencia			AS [Agency Name],
			ACC.Account				AS [Account],
			ACC.Billing_Code			AS [Billing Code],
			ACC.Assignor				AS [Assignor],
			ACC.Obs 					AS [OBS],
			ACC.Account_Enabled 			AS [Enabled],
			ACC.Generate_Remessa_Enabled AS [Generate Remessa Enabled],
			ACC.Generate_Boleto_Enabled AS [Generate Boleto Enabled],
			ACC.Cd_User					as [User Code],
			US.Nome_Usuario				as [User Name]
		FROM Account ACC (NOLOCK)
			JOIN AGENCIA AGE (NOLOCK)	ON ACC.CD_BANK = AGE.Cd_Banco AND ACC.CD_AGENCY = AGE.Cd_Agencia
			JOIN banco BAN (NOLOCK)	ON AGE.Cd_Banco = BAN.Cd_Banco
			left join Usuario US (NOLOCK)	ON US.cd_usuario = ACC.Cd_User
		WHERE 
			ACC.cd_bank	= @cd_bank and ACC.Cd_Agency= @Cd_Agency
	END  

  

GO
