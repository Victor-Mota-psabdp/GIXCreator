SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spNavio_InsUpd 994, 'ABRA', 'BR', '8020939',NULL

CREATE   procedure [dbo].[spNavio_InsUpd]

@Codigo int,
@Nome varchar(25),
@Cd_Pais   char(2),
@LLoyd varchar(8),
@NCodigo int output
AS
--Inserção e Alteração na Tabela Linguagem
--Se for enviando um parametro NULL no @Codigo o SQL vai entender que será um novo registro
--Se for enviando um valor no @Codigo o sistema vai entender que será uma alteração no registro informado

Declare @cod int

Begin Transaction 
	IF @codigo is null 
	   BEGIN	
		Set @cod=(select isnull(max(id_navio),0)+1 from navio)
		Insert 
			navio (id_navio,nome_navio,Cd_Nacionalidade,LLoyd,Cd_Pais)
		Values
			(@cod,@Nome,NULL,@LLoyd,@Cd_Pais)
			Set @NCodigo = @cod
			--Print @Cd_Retorno
	   END
	ELSE
	   BEGIN
		if exists(select id_navio from navio where id_navio=@codigo)
		Begin

			Update 
				navio
			Set 
				nome_navio=@nome,
				cd_pais=@cd_pais,
				lloyd=@lloyd
			Where
				id_navio=@codigo
				Set @NCodigo = @codigo
	   	End
--		if @@rowcount = 0 
--			Print 'Nenhum registro Incluído/Alterado'
--Print @Cd_Retorno
	END
		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

Commit Transaction 
	








GO
