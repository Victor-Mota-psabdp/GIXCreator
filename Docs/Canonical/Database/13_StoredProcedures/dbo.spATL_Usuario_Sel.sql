SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_Usuario_Sel '','Silvano Lopes Pereira','B'

CREATE procedure [dbo].[spATL_Usuario_Sel](
@CdUsuario varchar(6),
@NomeUsuario varchar(30),
@Tipo char(1)
)
as

if @Tipo = 'A'
	Begin
		if @CdUsuario is not null and @CdUsuario <>''
			begin
				select Cd_Usuario, Nome_Usuario,Email from usuario
				where Cd_Usuario = @CdUsuario  and Ck_Ativo = 1
			End
		else
			begin
				select Cd_Usuario, Nome_Usuario,Email from usuario
				where Nome_Usuario = @NomeUsuario and Ck_Ativo = 1
			End
	End
else if @Tipo = 'B'
	if @CdUsuario is not null and @CdUsuario <>''
		begin
			select Cd_Usuario, Nome_Usuario,Email from usuario
			where Cd_Usuario = @CdUsuario
		End
	else
		begin
			select Cd_Usuario, Nome_Usuario,Email from usuario
			where Nome_Usuario = @NomeUsuario
		End

GO
