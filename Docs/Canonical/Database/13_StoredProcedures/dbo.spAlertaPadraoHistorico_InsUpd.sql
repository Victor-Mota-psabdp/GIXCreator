SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[spAlertaPadraoHistorico_InsUpd]
(
	@ID int,
	@JOB varchar(16),
	@Emails varchar(500),
	@Conteudo varchar(max),
	@DocAnexos varchar(150),
	@cd_usuario varchar(10)
)
AS

BEGIN TRANSACTION

	insert into 
		Alerta_Padrao_Historico
		(
			ID,
			JOB,
			Emails,
			Conteudo,
			DocAnexos,
			cd_usuario,
			dt_ins,
			dt_envio
		)
	values
		(
			@ID,
			@JOB,
			@Emails,
			@Conteudo,
			@DocAnexos,
			@cd_usuario,
			getdate(),
			NULL
		)

IF @@Error <> 0
	Begin
		ROLLBACK TRANSACTION
		RETURN -1
	End

COMMIT TRANSACTION

GO
