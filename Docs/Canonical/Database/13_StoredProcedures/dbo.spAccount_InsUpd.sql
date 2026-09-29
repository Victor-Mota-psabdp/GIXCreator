SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spAccount_InsUpd]
(
	@id_Account					INT,
	@Cd_Bank					VARCHAR(3),
	@Cd_Agency					VARCHAR(8),
	@Account					VARCHAR(30),
	@Billing_Code				VARCHAR(15),
	@Assignor					VARCHAR(15),
	@OBS						VARCHAR(250),
	@Account_Enabled			BIT,
	@Generate_Remessa_Enabled	BIT,
	@Generate_Boleto_Enabled	BIT,
	@Cd_User					VARCHAR(10)
)
AS  
  
BEGIN TRANSACTION
  
	IF EXISTS (	SELECT id_Account FROM Account WHERE id_Account = @id_Account)  
		BEGIN  
			UPDATE  
				Account   
			SET  
				Cd_Bank	= @Cd_Bank,
				Cd_Agency= @Cd_Agency,
				Account= @Account,
				Billing_Code= @Billing_Code,
				Assignor= @Assignor,
				OBS	= @OBS,
				Account_Enabled	= @Account_Enabled,
				Generate_Remessa_Enabled= @Generate_Remessa_Enabled,
				Generate_Boleto_Enabled= @Generate_Boleto_Enabled,
				dt_alt= GETDATE(),
				Cd_User=@Cd_User
			WHERE  
				id_Account = @id_Account

		END
	ELSE  
		BEGIN   
			INSERT Account
			(  
				Cd_Bank,Cd_Agency,Account,Billing_Code,Assignor,OBS,Account_Enabled,
				Generate_Remessa_Enabled,Generate_Boleto_Enabled,Cd_User,dt_ins

			)  
			VALUES  
			(  
				@Cd_Bank,@Cd_Agency,@Account,@Billing_Code,@Assignor,@OBS,@Account_Enabled,
				@Generate_Remessa_Enabled,@Generate_Boleto_Enabled,@Cd_User,GETDATE()
			)  
		END  
  
COMMIT TRANSACTION


GO
