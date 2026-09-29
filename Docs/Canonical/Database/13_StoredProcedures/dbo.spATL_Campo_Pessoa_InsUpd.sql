SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_Campo_Pessoa_InsUpd] --'IACAR20090300301',	'31',	'2,075'
			
	@Cd_Pes			varchar(10),
	@ID_Campo			INT,
	@Campo_Dados		Varchar(500),	
	@cd_usuario			varchar(6)

AS

BEGIN TRANSACTION

	if exists(select Tipo from [dbo].[Tipo_Campo_Pessoa] where tipo='I' and Id_Campo=@ID_Campo)
		Begin
			set @Campo_Dados = replace(@Campo_Dados,'.','')
			set @Campo_Dados = replace(@Campo_Dados,',','.')
		End

	if exists (select Campo_Dados from [dbo].[Campo_Pessoa] where Id_Campo=@Id_Campo and Cd_Pes=@Cd_Pes)
		if @Campo_Dados=''
			BEGIN
				DELETE
					[dbo].[Campo_Pessoa]
				WHERE
					Id_Campo=@Id_Campo and Cd_Pes=@Cd_Pes
			END
		Else
			BEGIN
				UPDATE
					[dbo].[Campo_Pessoa]
				SET
					Campo_Dados	= @Campo_Dados, Dt_Ins = Getdate(), cd_usuario = @cd_usuario
				WHERE
					Id_Campo=@Id_Campo and Cd_Pes=@Cd_Pes
			END
	ELSE
		BEGIN
			INSERT INTO
				[dbo].[Campo_Pessoa]
				(
					Cd_Pes,
					Id_Campo,	
					Campo_Dados,
					Dt_Ins,
					cd_usuario
				)
			VALUES
				(
					@Cd_Pes,
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
