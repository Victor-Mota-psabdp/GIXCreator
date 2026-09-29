SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--(select * from Usuario_Cliente where Cd_Usuario='UCusso' and Cd_Cliente='P000030340')
--(select isnull((max(right(cd_usuario,4))),0)+1 
--select * from Usuario_Cliente 
--where left(cd_usuario,2)= 'UC' and len (cd_usuario)=6
--and ISNUMERIC(right(cd_usuario,4)) <> 0 
----UCusso
--select * from Usuario_Cliente where Nome_Usuario like '%cinthia%' 
--ATL_QA_260319
--select * from Pessoa where  Apelido like '%solenis%'
--select * from Usuario_Cliente where Cd_Cliente like '%P000030340%' 

CREATE procedure [dbo].[spUsuarioClienteATL_InsUpd]

	@Cd_Usuario		varchar(20),
	@Cd_Cliente		varchar(10),
	@Nome_Usuario	varchar(50),
	@Email			varchar(40),
	@Ativo			char(1)
AS

Begin Transaction

	If  exists (select cd_usuario from Usuario_Cliente where Cd_Usuario=@Cd_Usuario and Cd_Cliente=@Cd_Cliente)
	Begin
		Update
			Usuario_Cliente
		Set
			Nome_Usuario = @Nome_Usuario,
			Email=@Email,
			Ativo=@Ativo
		Where
			cd_usuario=@Cd_Usuario and Cd_Cliente=@Cd_Cliente
	End
	Else
		set @cd_usuario= (select isnull((max(right(cd_usuario,4))),0)+1 from Usuario_Cliente 
		where left(cd_usuario,2)= 'UC' and len (cd_usuario)=6	and ISNUMERIC(right(cd_usuario,4)) <> 0 )
		set @cd_usuario = 'UC'+ right(('0000'+ @cd_usuario),4)

		Insert
			Usuario_Cliente(
				Cd_Usuario,
				Cd_Cliente,
				Nome_Usuario,
				Email,
				Ativo,
				dt_ins
				)
		Values
			(
				@Cd_Usuario,
				@Cd_Cliente,
				@Nome_Usuario,
				@Email,
				@Ativo,
				getdate()
			)
	

IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END


COMMIT TRANSACTION







GO
