SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spTipo_NF_Doc_Register_InsUpd] 

	@cd_site		char(1),
	@cd_servico		int,
	@Item_lei		varchar(50),
	@CNAE		varchar(50),
	@Descricao		varchar	(500),
	@cd_usuario		varchar(6),
	@Desativar		char(1)

AS

BEGIN TRANSACTION

BEGIN
	IF NOT EXISTS(SELECT cd_servico FROM Tipo_NF_Doc_Register WHERE cd_servico=@cd_servico)
		BEGIN
		  INSERT INTO
			Tipo_NF_Doc_Register
				(
					cd_servico,item_lei,Descricao,cd_usuario,dt_ins,cd_site,Desativada,CNAE
				)
			VALUES
				(
					@cd_servico,@Item_lei,@Descricao,@cd_usuario,getdate(),@cd_site,@Desativar,@CNAE
		)
		END
	ELSE
		BEGIN
		   UPDATE
			Tipo_NF_Doc_Register
				set					
					Item_lei=@Item_lei,
					Descricao=@Descricao,
					cd_usuario = @cd_usuario,
					dt_ins = getdate(),
					cd_site = @cd_site,
					Desativada = @Desativar,
					cnae = @CNAE
			WHERE
				cd_servico=@cd_servico
		   END
if @@error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -2
	END

END			

COMMIT TRANSACTION







GO
