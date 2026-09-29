SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_NF_Doc_Register
CREATE procedure [dbo].[spATL_Tipo_NF_Doc_Register_InsUpd]
(
	@Cd_Site		char(1),
	@Cd_Servico		Int,
	@Item_lei		varchar(50),
	@CNAE			varchar(25),
	@Descricao		varchar	(500),
	@cd_usuario		varchar(6),
	@Desativada		char(1)
)
as
	
	
	Begin Transaction

	IF NOT EXISTS(SELECT cd_servico FROM Tipo_NF_Doc_Register WHERE cd_servico=@cd_servico)
		BEGIN
		  INSERT INTO
			Tipo_NF_Doc_Register
				(
					cd_servico,item_lei,Descricao,cd_usuario,dt_ins,cd_site,Desativada,CNAE
				)
			VALUES
				(
					@cd_servico,@Item_lei,@Descricao,@cd_usuario,getdate(),@cd_site,@Desativada,@CNAE
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
				--dt_ins = getdate(),
				cd_site = @cd_site,
				Desativada = @Desativada,
				cnae = @CNAE
			WHERE
				cd_servico=@cd_servico
		   END
			

	IF @@Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END

Commit Transaction

GO
