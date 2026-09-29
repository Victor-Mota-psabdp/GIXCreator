SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE	procedure [dbo].[spCamposAdicionaisPessoa_InsUpd] --'IACAR20090300301',	'31',	'2,075'
			
	@Cd_Pes			VarChar(16),
	@Descr_Campo	varchar(30),
	@Campo_Dados	Varchar(500),
	@Usuario		varchar(50)

AS

BEGIN TRANSACTION

	declare @cd_usuario varchar(20)
	set @cd_usuario = (select cd_usuario from usuario where nome_usuario=@usuario)

	Declare @ID_Campo int
	set @ID_Campo = (select ID_Campo from Tipo_Campo_Pessoa where Descr_Campo=@Descr_Campo and (Cd_Pes_Grupo=@Cd_Pes or cd_pes_grupo='10017'))

	if exists(select Tipo from tipo_campo_pessoa where tipo='F' and Id_Campo=@ID_Campo)
		Begin
			set @Campo_Dados = replace(@Campo_Dados,'.','')
			set @Campo_Dados = replace(@Campo_Dados,',','.')
		End

	if exists (select Campo_Dados from Campo_Pessoa where Id_Campo=@Id_Campo and Cd_Pes=@Cd_Pes)
		if @Campo_Dados=''
			BEGIN
				DELETE
					Campo_Pessoa
				WHERE
					Id_Campo=@Id_Campo and Cd_Pes=@Cd_Pes
			END
		Else
			BEGIN
				UPDATE
					Campo_Pessoa
				SET
					Campo_Dados	= @Campo_Dados, Dt_Ins = Getdate(), cd_usuario = @cd_usuario
				WHERE
					Id_Campo=@Id_Campo and Cd_Pes=@Cd_Pes
			END
	ELSE
		BEGIN
			INSERT INTO
				Campo_Pessoa
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
