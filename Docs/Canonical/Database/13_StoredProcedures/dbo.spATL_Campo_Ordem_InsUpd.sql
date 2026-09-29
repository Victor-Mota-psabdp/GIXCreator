SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from [Campo_Ordem]
--sp_help [Campo_Ordem] 

CREATE Procedure [dbo].[spATL_Campo_Ordem_InsUpd] --'IACAR20090300301',	'31',	'2,075'
			
	@Cd_Pedido			INT,
	@ID_Campo			INT,
	@Campo_Dados		Varchar(500),	
	@cd_usuario			varchar(6)

AS

BEGIN TRANSACTION

	if exists(select Tipo from [dbo].[Tipo_Campo_Ordem] where tipo='F' and Id_Campo=@ID_Campo)
		Begin
			set @Campo_Dados = replace(@Campo_Dados,'.','')
			set @Campo_Dados = replace(@Campo_Dados,',','.')
		End

	if exists (select Campo_Dados from [dbo].[Campo_Ordem] where Id_Campo=@Id_Campo and Cd_Pedido=@Cd_Pedido)
		if @Campo_Dados=''
			BEGIN
				DELETE
					[dbo].[Campo_Ordem]
				WHERE
					Id_Campo=@Id_Campo and Cd_Pedido=@Cd_Pedido
			END
		Else
			BEGIN
				UPDATE
					[dbo].[Campo_Ordem]
				SET
					Campo_Dados	= @Campo_Dados, Dt_Ins_Upd = Getdate(), cd_usuario = @cd_usuario
				WHERE
					Id_Campo=@Id_Campo and Cd_Pedido=@Cd_Pedido
			END
	ELSE
		BEGIN
			INSERT INTO
				[dbo].[Campo_Ordem]
				(
					Cd_Pedido,
					Id_Campo,	
					Campo_Dados,
					Dt_Ins_Upd,
					cd_usuario
				)
			VALUES
				(
					@Cd_Pedido,
					@Id_Campo,
					@Campo_Dados,
					getdate(),
					@cd_usuario
				)
		END

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END


COMMIT TRANSACTION

GO
