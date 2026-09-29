SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spATL_Campo_Produto_Cliente_Del] --'IACAR20090300301',	'31',	'2,075'
(		
	@cd_prod			INT,
	@ID_Campo			INT,
	@Campo_Dados		Varchar(500),	
	@cd_usuario			varchar(6)
)

AS

BEGIN TRANSACTION

	if exists (select Campo_Dados from [dbo].[Campo_Produto_Cliente] where Id_Campo=@Id_Campo and cd_prod=@cd_prod)	
		BEGIN
			DELETE
				[dbo].[Campo_Produto_Cliente]
			WHERE
				Id_Campo=@Id_Campo and Cd_Prod=@cd_prod
		END
		

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END


COMMIT TRANSACTION

GO
