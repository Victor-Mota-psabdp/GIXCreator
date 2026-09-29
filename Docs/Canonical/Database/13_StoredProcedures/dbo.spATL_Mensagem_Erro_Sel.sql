SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Mensagem_Erro
CREATE PROCEDURE [dbo].[spATL_Mensagem_Erro_Sel]
(
	@Cod_Erro		Int,
	@Local			varchar(3),
	@Tipo			char(1)
)
	
as

if @Tipo = 'A' or @Tipo = 'B'
	Begin
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

	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
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
		where 
			Cod_Erro = @Cod_Erro
	End	
	
if @Tipo = 'N' or @Tipo = 'O'
	Begin
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
		where 
			Local = @Local
		
	End
	
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
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
		where 
			Local = @Local and Cod_Erro <> @Cod_Erro			
	End

if @Tipo = 'P' or @Tipo = 'Q'
	Begin
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
		where 
			Cod_Erro = @Cod_Erro and (Local = @Local or Local = 'ALL')
		
	End	

GO
