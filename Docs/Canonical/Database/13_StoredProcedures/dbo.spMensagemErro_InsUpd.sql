SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



create Procedure [dbo].[spMensagemErro_InsUpd]

@Cod_Erro		integer,
@Local			varchar(3),
@Modais			varchar(30),
@Descricao		varchar(300),
@Msg_Portugues	varchar(300),
@Msg_Ingles		varchar(300),
@Msg_Espanhol	varchar(300),
@Ativo			char(1)

as
Begin Transaction

	if exists(select Cod_Erro from mensagem_erro where cod_erro = @Cod_Erro)
		Begin
			Update
				mensagem_erro
			set
				Local = @Local,
				Modais = @Modais,
				Descricao = @Descricao,
				Msg_Portugues = @Msg_Portugues,
				Msg_Ingles = @Msg_Ingles,
				Msg_Espanhol = @Msg_Espanhol,
				Ativo = @Ativo
			where
				Cod_Erro = @Cod_Erro
		end
	else
		Begin
			SET @Cod_Erro =(SELECT ISNULL(MAX(Cod_Erro),1) FROM mensagem_erro)+1
			insert into
				mensagem_erro(Cod_Erro, Local, Modais, Descricao, Msg_Portugues, Msg_Ingles,Msg_Espanhol, Ativo)
			values
				(@Cod_Erro, @Local, @Modais, @Descricao, @Msg_Portugues, @Msg_Ingles, @Msg_Espanhol, @Ativo)
		end

IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END


COMMIT TRANSACTION

GO
