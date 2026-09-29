SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_Agencia_InsUpd]
(
	@Cd_Banco	VARCHAR(3),  
	@Cd_Agencia VARCHAR(5),  
	@Nome_Agencia	VARCHAR(30),
	@Ativo			BIT,
	@Dt_Ins			DateTime,
	@Cd_Usuario		VARCHAR(10)
)
AS  
  
BEGIN TRANSACTION
  
	if exists(SELECT Cd_Banco FROM Agencia WHERE Cd_Banco = @Cd_Banco AND Cd_Agencia = @Cd_Agencia) 
		BEGIN  
			UPDATE  
				Agencia  
			SET 
				Nome_Agencia = @Nome_Agencia ,
				Ativo=@Ativo,
				Dt_Ins=Getdate(),
				Cd_Usuario=@Cd_Usuario
			WHERE  
				Cd_Banco = @Cd_Banco AND Cd_Agencia = @Cd_Agencia                     
		END  
	ELSE  
		BEGIN   
			INSERT Into Agencia
				(Cd_Banco,Cd_Agencia,Nome_Agencia,Ativo,Dt_Ins,Cd_Usuario)
			Values  
				(@Cd_Banco,@Cd_Agencia,@Nome_Agencia,@Ativo,Getdate(),@Cd_Usuario)
		End  
  
COMMIT TRANSACTION
  
  
  

GO
