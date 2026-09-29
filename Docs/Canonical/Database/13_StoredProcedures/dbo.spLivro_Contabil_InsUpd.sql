SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spLivro_Contabil_InsUpd]
(
	@ID int output, @Ano int, @Mes int, @Data datetime, @cd_usuario varchar(20)
)
As

	declare @Numero int
	set @Numero  = (select isnull(max(numero),0) +1 from Livro_Contabil where ano = @Ano and mes = @Mes)

	If @ID is null or @ID = ''
		Begin
			Insert into Livro_Contabil (Ano, Mes, Numero, Data, Dt_Ins, cd_usuario, Ativo)
			Values (@Ano, @Mes, @Numero, @Data, getdate(), @cd_usuario, 1)
			set @ID = (select ID from Livro_Contabil where Ano=@Ano and Mes=@Mes and numero = @Numero)
		End
	Else
		Begin
			update 
				Livro_Contabil
			set 
				Data=@Data
			where
				ID = @ID
		End

GO
