SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spATL_AcessoTela_Sel]--'aselt','002'
	@cd_Usuario varchar(50),
	@cd_tela varchar(3)
as	
	declare @cd_nivel varchar(3)
	declare @cd_area varchar(3)
	declare @Resultado varchar(3)

	Begin
		Select @cd_area = cd_area, @cd_nivel = cd_nivel  from usuario U
		where U.ck_ativo='1' and U.cd_usuario = @cd_Usuario
	End
		
	--verifica acesso por usuario
	Begin		
		select @Resultado = leitura + gravacao + exclusao from Usuario_acesso U
		where
			U.cd_tela=@cd_tela and
			U.cd_usuario = @cd_Usuario
	End
 
	If @Resultado is NULL
	--Verifica o acesso por area e nivel
	Begin
		select @Resultado = leitura + gravacao + exclusao from nivel_acesso NA
		where
			NA.cd_tela=@cd_tela and
			NA.cd_area=@cd_area and
			NA.cd_nivel=@cd_nivel
	End

	-- Se não encontrar o acesso por area e nivel verifica por area apenas
	If @Resultado is NULL
		Begin
			select @Resultado = leitura + gravacao + exclusao from dep_acesso D
			where
				D.cd_tela=@cd_tela and
				D.cd_area=@cd_area
		End

	--Se não encontrar retorna '000'
	If @Resultado is NULL
		Begin
			Set @Resultado = '000'
		End

	--Retorna o Resultado
	select @Resultado leitura_gravacao_exclusao









GO
