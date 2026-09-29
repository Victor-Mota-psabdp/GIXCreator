SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spAlertaPadrao_InsUpd]
(
	@ID int,
	@Nome_Alerta varchar(50),
	@Conteudo varchar(max),
	@cd_usuario varchar(10)
)
AS
BEGIN TRANSACTION

	IF exists(select ID from alerta_padrao where ID=@ID)
		Begin
			UPDATE
				Alerta_Padrao
			SET
				Nome_Alerta = @Nome_Alerta,
				Conteudo = @Conteudo,
				dt_ins = getdate()
			WHERE
				ID = @ID
		End
	ELSE
		Begin
			insert into Alerta_Padrao (nome_alerta, conteudo, cd_usuario, dt_ins, ativo)
			values (@Nome_Alerta, @Conteudo, @cd_usuario, getdate(),'1')
		End


IF @@Error <> 0
	Begin
		ROLLBACK TRANSACTION
		RETURN -1
	End

COMMIT TRANSACTION

GO
