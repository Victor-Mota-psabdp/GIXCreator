SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Mensagem_Erro
CREATE VIEW [dbo].[vwATL_Mensagem_Erro_Sel]
AS
	SELECT
		Cod_Erro		[Code],
		Local			[Local],
		Modais			[Modais],
		Descricao		[Description],
		Msg_Portugues	[PT Message],
		Msg_Ingles		[EN Message],
		Msg_Espanhol	[ES Message],
		Ativo			[Enabled],
		dt_criacao		[Insert Date]
	FROM 
		Mensagem_Erro A with(nolock)


GO
