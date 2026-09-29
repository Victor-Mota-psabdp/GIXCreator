SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Mensagem_Erro
create procedure [dbo].[spATL_Mensagem_Erro_Del]
(
	@Cod_Erro	int
)
as

	If  exists (select Cod_Erro from Mensagem_Erro where Cod_Erro=@Cod_Erro)
		Begin
			update Mensagem_Erro set Ativo = 'N' where Cod_Erro=@Cod_Erro
		End

GO
