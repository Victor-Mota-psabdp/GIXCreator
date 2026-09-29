SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Banco
CREATE PROCEDURE [dbo].[spATL_Banco_InsUpd]
(
	@Cd_Banco		VARCHAR(3),  
	@Nome_Banco		VARCHAR(30),
	@Cod_Banco_Rem	VARCHAR(5),
	@Cd_Cta_Ctb		VARCHAR(13),
	@Ativo			BIT,
	@Dt_Ins			DateTime,
	@Cd_Usuario		VARCHAR(10)
)
AS

BEGIN TRANSACTION

	IF EXISTS (SELECT Cd_Banco FROM Banco (NOLOCK) WHERE Cd_Banco=@Cd_Banco)
		BEGIN
			UPDATE
				Banco
			SET				
				Nome_Banco = @Nome_Banco,
				Cod_Banco_Rem = @Cod_Banco_Rem,
				Cd_Cta_Ctb = @Cd_Cta_Ctb,
				Ativo=@Ativo,
				Dt_Ins=Getdate(),
				Cd_Usuario=@Cd_Usuario
			WHERE
				Cd_Banco = @Cd_Banco
		END
	ELSE
		BEGIN
			INSERT Into Banco
				(Cd_Banco,Nome_Banco,Cod_Banco_Rem,Cd_Cta_Ctb,Ativo,Dt_Ins,Cd_Usuario)
			VALUES
				(@Cd_Banco,@Nome_Banco,@Cod_Banco_Rem,@Cd_Cta_Ctb,@Ativo,Getdate(),@Cd_Usuario)
		END
	

COMMIT TRANSACTION


GO
