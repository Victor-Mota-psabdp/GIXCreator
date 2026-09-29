SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[spATL_Agencia_Sel]
(	 
	@Cd_Agencia			VARCHAR(5),  
	@Nome_Agencia		VARCHAR(30),
	@Cd_Banco			VARCHAR(3), 
	@Tipo				CHAR(1)  
)  
AS  

IF @Tipo = 'A'  
	BEGIN  
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
	END 
	
IF @Tipo = 'B'  
	BEGIN  
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
		Where
			A.Ativo = 1
	END  

IF @Tipo = 'C'  
	BEGIN  
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
		Where
			A.Cd_Agencia = @Cd_Agencia 
	END  
IF @Tipo = 'D'  
	BEGIN  
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
		Where
			A.Cd_Agencia = @Cd_Agencia 
			and A.Ativo = 1
	END 
	
IF @Tipo = 'N'  
	BEGIN  
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
		Where
			A.Nome_Agencia = @Nome_Agencia			
		
	END 
	
IF @Tipo = 'O'  
	BEGIN  
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
		Where
			A.Cd_Banco = @Cd_Banco
	END 

IF @Tipo = 'P'   
	BEGIN  
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
		WHERE 
			A.Cd_Agencia =@Cd_Agencia and A.Cd_Banco = @Cd_Banco  
	END 

if @Tipo = 'Z'-- or @Tipo = 'O'
	Begin
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
		WHERE 
			A.Nome_Agencia = @Nome_Agencia and A.Cd_Agencia <> @Cd_Agencia 
	End

 -- Alessandra 28/02/2022 - Ticket 100-187961 - Checando se a agencia ja esta sendo usada no cadastro de conta corrente. Caso positivo, não posso deletar
 IF @Tipo = 'X'
	BEGIN 
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
			INNER JOIN Account C (NOLOCK) ON C.Cd_Bank = A.Cd_Banco	AND C.Cd_Agency = A.Cd_Agencia
		WHERE
			A.Nome_Agencia = @Nome_Agencia 
			and A.Cd_Agencia <> @Cd_Agencia	
	END


GO
