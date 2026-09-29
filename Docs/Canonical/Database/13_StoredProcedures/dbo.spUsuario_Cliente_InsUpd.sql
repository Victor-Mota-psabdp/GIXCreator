SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spUsuario_Cliente_InsUpd]
	@Cd_Usuario		varchar(20),
	@Cd_Cliente		varchar(10),
	@Nome_Usuario	varchar(50),
	@Email			varchar(50),
	@Ativo			char(1),
	@Plasticos		varchar(29)
AS

Begin Transaction

	If  exists (select cd_usuario from Usuario_Cliente where Cd_Usuario=@Cd_Usuario and Cd_Cliente=@Cd_Cliente)
	Begin
		Update
			Usuario_Cliente
		Set
			Nome_Usuario = @Nome_Usuario,
			Email=@Email,
			Ativo=@Ativo,
			Plasticos=@Plasticos
		Where
			cd_usuario=@Cd_Usuario and Cd_Cliente=@Cd_Cliente
	End
	Else
		Insert
			Usuario_Cliente(
				Cd_Usuario,
				Cd_Cliente,
				Nome_Usuario,
				Email,
				Ativo,
				Plasticos
				)
		Values
			(
				@Cd_Usuario,
				@Cd_Cliente,
				@Nome_Usuario,
				@Email,
				@Ativo,
				@Plasticos
			)
	

Commit Transaction







GO
