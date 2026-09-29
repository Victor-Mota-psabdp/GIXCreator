SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spCamposAdicionaisCampo_Produto_Cliente_InsUpd] --'IACAR20090300301',	'31',	'2,075'
			
	@cd_prod		INT,
	@Descr_Campo	varchar(30),
	@Campo_Dados	Varchar(500),
	@Usuario		varchar(50)

AS

BEGIN TRANSACTION

	declare @cd_usuario varchar(20)
	set @cd_usuario = (select cd_usuario from usuario where nome_usuario=@usuario)

	Declare @ID_Campo int
	Declare @Cd_Pes_Grupo varchar(10)
	set @Cd_Pes_Grupo = (select cd_grupo from pedido where cd_pedido = @cd_prod)
	set @ID_Campo = (select ID_Campo from [dbo].[Tipo_Campo_Produto_Cliente] where 
			Descr_Campo=@Descr_Campo and (Cd_Pes_Grupo=@Cd_Pes_Grupo or cd_pes_grupo='10017'))

	if exists(select Tipo from [dbo].[Tipo_Campo_Produto_Cliente] where tipo='F' and Id_Campo=@ID_Campo)
		Begin
			set @Campo_Dados = replace(@Campo_Dados,'.','')
			set @Campo_Dados = replace(@Campo_Dados,',','.')
		End

	if exists (select Campo_Dados from [dbo].[Campo_Produto_Cliente] where Id_Campo=@Id_Campo and cd_prod=@cd_prod)
		if @Campo_Dados=''
			BEGIN
				DELETE
					[dbo].[Campo_Produto_Cliente]
				WHERE
					Id_Campo=@Id_Campo and Cd_Prod=@cd_prod
			END
		Else
			BEGIN
				UPDATE
					[dbo].[Campo_Produto_Cliente]
				SET
					Campo_Dados	= @Campo_Dados, Dt_Ins = Getdate(), cd_usuario = @cd_usuario
				WHERE
					Id_Campo=@Id_Campo and cd_prod=@cd_prod
			END
	ELSE
		BEGIN
			INSERT INTO
				[dbo].[Campo_Produto_Cliente]
				(
					Cd_Prod,
					Id_Campo,	
					Campo_Dados,
					Dt_Ins,
					cd_usuario
				)
			VALUES
				(
					@cd_prod,
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
