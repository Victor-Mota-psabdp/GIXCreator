SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_Campo_Ordem_Del] --'IACAR20090300301',	'31',	'2,075'
			
	@Cd_Pedido			INT,
	@ID_Campo			INT
	

AS

BEGIN TRANSACTION
	if exists (select Campo_Dados from [dbo].[Campo_Ordem] where Id_Campo=@Id_Campo and Cd_Pedido=@Cd_Pedido)	
		BEGIN
			DELETE
				[dbo].[Campo_Ordem]
			WHERE
				Id_Campo=@Id_Campo and Cd_Pedido=@Cd_Pedido
		END	

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END


COMMIT TRANSACTION

GO
