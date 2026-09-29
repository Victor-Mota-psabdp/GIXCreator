SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spATL_Banco_Sel] 
(  
	@Cd_Banco		VARCHAR(3),  
	@Nome_Banco		VARCHAR(30),
	@Tipo			CHAR(1)  
)  
AS 

IF @Tipo = 'A'  
	BEGIN  
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
	END  
IF @Tipo = 'B'  
	BEGIN  
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
		Where
			Ativo = 1
	END  


IF @Tipo = 'C'  
	BEGIN  
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
		WHERE 
			B.Cd_Banco = @Cd_Banco  
	END  
IF @Tipo = 'D'  
	BEGIN  
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
		WHERE 
			B.Cd_Banco = @Cd_Banco 
			and Ativo = 1
	END 
	
IF @Tipo = 'N'  
	BEGIN  
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
		WHERE 
			B.Nome_Banco = @Nome_Banco   
	END  
IF @Tipo = 'O'  
	BEGIN  
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
		WHERE 
			B.Nome_Banco = @Nome_Banco 
			and Ativo = 1
	END 

if @Tipo = 'Z'-- or @Tipo = 'O'
	Begin
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
		WHERE 
			B.Nome_Banco = @Nome_Banco and B.Cd_Banco <> @Cd_Banco 
	End
GO
